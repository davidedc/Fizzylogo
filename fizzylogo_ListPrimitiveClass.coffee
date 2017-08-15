class FLListPrimitiveClass extends FLPrimitiveClasses


  # A note about messages, which are special lists.
  # ...a fizzylogo message is just an FLList which is meant to
  # be used as a message only, which means that:
  #    - its elements don't change
  #    - because the underlying elements don't change, it can be
  #      copied quickly (keeping reference to old values)  
  #    - it can be split ( "." splits statements)
  #    - we can "consume" one or more elements
  #    - we don't need messages to be fizzylogo objects,
  #      they are part of the runtime and invisible to
  #      the user.
  #    - a message is never sent a message, because
  #      a message is not a fizzylogo object
  #
  # So we try to make some of these operations more efficient
  # for messages, since all operations don't modify the elements
  # we can do splits and we can consume things just by moving
  # around a start index and an end index of an unchanging
  # array of elements.
  #
  # Basically we can navigate/consume the program without
  # copying around the elements.
  #
  # The alternative would be to use no indexes and just
  # do shallow copies at any change. That would be fine for performance
  # but there is just something about the constant shallow copying
  # during interpretation that looks like it's a quadratic
  # operation, so we say no to that.

  emptyMessage: ->
    newMessage = FLList.createNew().toMessage()
    return newMessage

  emptyList: ->
    newMessage = FLList.createNew()
    return newMessage

  createNew: ->
    toBeReturned = super FLList
    toBeReturned.value = []

    # these are only used for messages, which
    # are special kinds of lists
    toBeReturned.cursorStart = 0
    toBeReturned.cursorEnd = -1

    # nothing much to do, but it makes it more
    # clear in the code to show "how"
    # one is using the message/list
    toBeReturned.toList = ->
      @isMessage = false
      @

    # nothing much to do, but it makes it more
    # clear in the code to show "how"
    # one is using the message/list
    toBeReturned.toMessage = ->
      @isMessage = true
      @

    toBeReturned.flListImmutablePush = (theItemToPush) ->
      copy = @shallowCopy()
      copy.value.jsArrayPush theItemToPush
      copy.cursorEnd++
      copy

    toBeReturned.elementAt = (theElementNumber) ->
      @value[@cursorStart + theElementNumber]

    toBeReturned.elementAtSetMutable = (theElementNumber, theValue) ->
      if @isMessage or @cursorStart != 0
        throw "elementAtSetMutable: you can't set an element of a message"
      @value[theElementNumber] = theValue
      return @

    # TODO this can be done much cheaper
    toBeReturned.evaluatedElementsList = (context) ->
      newList = FLList.createNew()
      for i in [0...@length()]
        console.log "toBeReturned.evaluatedElementsList evaluating " + (@elementAt i).print()
        
        if (@elementAt i).flClass == FLList
          evalled = (@elementAt i).evaluatedElementsList context
        else
          evalled = ((@elementAt i).eval context, @, true)[0].returned

        newList = newList.flListImmutablePush evalled

      return newList

    toBeReturned.print = ->
      #console.log "@value:" + @value
      #console.log "list print: length: " + @length()
      if @length() <= 0
        return "empty message"
      toBePrinted = "("
      for i in [0...@length()]
        #console.log "@value element " + i + " : " + @value[i]
        #console.log "@value element " + i + " content: " + @value[i].value
        toBePrinted += " " + @elementAt(i).printForList()
      toBePrinted += " )"
      return toBePrinted

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.evalFirstListElementAndTurnRestIntoMessage = (theContext) ->
      firstElement = @firstElement()
      console.log "           " + indentation() + "evaling element " + firstElement.value
      theContext.returned = (firstElement.eval theContext, @)[0].returned
      restOfMessage = @restOfMessage()
      return [theContext, restOfMessage]

    toBeReturned.findReceiver = (theContext) ->
      [returnedContext, restOfMessage] = @evalFirstListElementAndTurnRestIntoMessage theContext
      receiver = returnedContext.returned

      console.log "evaluation " + indentation() + "remaining part of list to be sent as message is: " + restOfMessage.print()

      # here is the case of the "statement with one command" e.g.
      #    1 print. singleCommand . 2 print
      # in this case, "singleCommand" could be just an atom that
      # points to an object. Typical case is the "done" atom
      # ponting to a Done object.
      # So, in these cases you want "done" atom to look up the
      # done object AND THEN you want to eval the object (as if
      # it got the empty message). So here we do that check and
      # do the further evaluation.
      if receiver? and restOfMessage.isEmpty() and receiver.flClass != FLAtom and receiver.flClass != FLList
        console.log "evaluation " + indentation() +  " contents can be evalued further"
        receiver = (receiver.eval returnedContext, receiver)[0].returned

      return [returnedContext, restOfMessage, receiver]

    toBeReturned.eval = (theContext) ->
      # a list without any messages just evaluates itself, which
      # consists of the following:
      #  a) separate all the statements (parts separated by ";")
      #  b) for each statement, evaluate its first element as the receiver
      #  c) send to the receiver the remaining part of the statement, as the message

      console.log "evaluation " + indentation() + "list received empty message, evaluating content of list"
      console.log "evaluation " + indentation() + "  i.e. " + @print()

      @toList()

      # quick case: ((list)) just evals to (list)
      # so: the amount of parentheses _is_ relevant.
      # this is needed in the indented syntax for when you pass a list
      # see for...each definition and examples.
      if @isWrappedList()
        theContext.returned = @unwrapList()
        return [theContext, FLList.emptyMessage()]


      statements = @separateStatements()

      for eachStatement in statements

        console.log "evaluation " + indentation() + "evaluating single statement"
        console.log "evaluation " + indentation() + "  i.e. " + eachStatement.print()

        returnedContext = theContext
        restOfMessage = eachStatement
        findAnotherReceiver = true

        # works as follows: we find a receiver, we send it the rest
        # of the original message hence getting a new receiver,
        # whom we send again the rest of the message
        # and so and and so forth. We keep using the same context, so we
        # accrete the state changes to the same context i.e. the one we
        # are running the method body in.

        # we'll exit this loop in a number of ways:
        #  - no more message to consume
        #  - exceptions being thrown or done object
        #  - the message is not understood
        while true

          # this happens for example in the "if" statement
          # (actually called ⇒ ). If the true branch is executed,
          # then everything that comes afterwards must be
          # skipped.
          if returnedContext.exhaustPreviousContextMessage == true
            restOfMessage.exhaust()

          if returnedContext.findAnotherReceiver and !returnedContext.throwing and !restOfMessage.isEmpty()
            returnedContext.findAnotherReceiver = false
            returnedContext = returnedContext.previousContext
            findAnotherReceiver = true
            console.log "finding next receiver from:  " + restOfMessage.print()

          if findAnotherReceiver
            findAnotherReceiver = false
            [returnedContext, restOfMessage, receiver] = restOfMessage.findReceiver returnedContext
            console.log "found next receiver and now message is: " + restOfMessage.print()
            console.dir receiver
            console.log "3 returnedContext.throwing: " + returnedContext.throwing

          # where we detect an exception being thrown
          if returnedContext.throwing
            console.log "throw escape"
            theContext.returned = receiver
            restOfMessage.exhaust()
            theContext.throwing = true
            return [theContext, restOfMessage]

          if !receiver?
            theContext.returned = null
            theContext.unparsedMessage = restOfMessage
            return [theContext, restOfMessage]

          if restOfMessage.isEmpty()
            break

          console.log "evaluation " + indentation() + "receiver: " + receiver?.value
          console.log "evaluation " + indentation() + "message: " + restOfMessage.print()

          # now actually send the message to the receiver. Note that
          # only part of the message might be consumed, in which case
          # we'll have to find the result from what we can consume and then
          # sent the remaining part to such reult. This is why
          # we have to keep iterating until the whole message is consumed
          
          [returnedContext, returnedMessage] = receiver.findSignatureBindParamsAndMakeCall restOfMessage, theContext

          if !returnedContext?
            returnedContext = theContext
            returnedContext.returned = receiver
            returnedContext.unparsedMessage = returnedMessage
            return [returnedContext, returnedMessage]


          console.log "2 theContext.throwing: " + theContext.throwing
          console.log "4 returnedContext.throwing: " + returnedContext.throwing


          receiver = returnedContext.returned
          restOfMessage = returnedMessage

          console.log "evaluation " + indentation() + "list evaluation returned: " + receiver?.value




        console.log "evaluation " + indentation() + "list: nothing more to evaluate"
        theContext.returned = receiver


      console.log "evaluation " + indentation() + "list: theContext.returned: " + theContext.returned
      #console.dir theContext.returned
      flContexts.pop()
      return [theContext, restOfMessage]

    toBeReturned.exhaust = ->
      @cursorStart = @cursorEnd + 1
      return @

    toBeReturned.length = ->
      return @cursorEnd - @cursorStart + 1

    toBeReturned.restOfMessage = ->
      copy = @copy()
      copy.cursorStart++
      return copy

    toBeReturned.firstElement =  ->
      if @cursorStart > @cursorEnd
        throw "no first element, array is empty"
      return @elementAt 0

    toBeReturned.secondElementIsEqual =  ->
      if @length() >= 2
        if (@elementAt 1).flClass == FLAtom
          if (@elementAt 1).value == "="
            return true
      return false

    toBeReturned.isMatchAllSignature =  ->
      if @length() == 1
        if (@elementAt 0).flClass == FLAtom
          if (@elementAt 0).value == "$$MATCHALL$$"
            return true
      return false

    toBeReturned.isWrappedList =  ->
      if @length() == 1 and @elementAt(0).flClass == FLList
        return true
      return false

    toBeReturned.unwrapList =  ->
      if @isWrappedList()
        return @elementAt 0
      return @

    # returns the first element and returns
    # a copy of the rest of the message
    toBeReturned.nextElement = ->
      [@firstElement(), @restOfMessage()]

    toBeReturned.advanceMessageBy = (numberOfElements) ->
      
      #if numberOfElements > @length()
      #  return FLList.emptyMessage()

      copy = @copy()
      copy.cursorStart += numberOfElements
      return copy

    toBeReturned.isEmpty = ->
      return @length() <= 0

    toBeReturned.copy = ->
      copy = FLList.createNew()
      copy.value = @value
      copy.cursorStart = @cursorStart
      copy.cursorEnd = @cursorEnd
      copy.isMessage = @isMessage
      return copy

    toBeReturned.shallowCopy = ->
      copy = @copy()
      copy.value = @value.slice()
      return copy

    toBeReturned.isEvaluatingParam =  ->
      @length() == 1

    toBeReturned.getParamAtom = ->
      if @isEvaluatingParam()
        return @elementAt(0)
      else
        return @elementAt(1)

    toBeReturned.separateStatements = ->
      console.log "evaluation " + indentation() + "separating statements   start: " + @print()
      arrayOfStatements = []
      lastStatementEnd = @cursorStart - 1
      for i in [@cursorStart..@cursorEnd]
        console.log "evaluation " + indentation() + "separating statements   examining element " + @value[i].print()
        if (@value[i] == RStatementSeparatorSymbol) or (i == @cursorEnd)
          statementToBeAdded = @copy().toList()
          statementToBeAdded.cursorStart = lastStatementEnd + 1
          statementToBeAdded.cursorEnd = i - 1
          if i == @cursorEnd and @value[@cursorEnd] != RStatementSeparatorSymbol
            console.log " last char: " + @value[@cursorEnd].print()
            statementToBeAdded.cursorEnd++
          lastStatementEnd = i
          if !statementToBeAdded.isEmpty() and statementToBeAdded.firstElement() != RStatementSeparatorSymbol
            console.log " adding: " + statementToBeAdded.print()
            arrayOfStatements.jsArrayPush statementToBeAdded
          console.log "evaluation " + indentation() + "separating statements isolated new statement " + statementToBeAdded.print()


      return arrayOfStatements



    return toBeReturned

    
FLList = new FLListPrimitiveClass()
