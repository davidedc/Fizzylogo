class FLListClass extends FLClasses


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

  # unused at the moment
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

    toBeReturned.definitionContext = null

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

    toBeReturned.mutablePush = (theItemToPush) ->
      @value.jsArrayPush theItemToPush
      @cursorEnd++
      @

    toBeReturned.elementAt = (theElementNumber) ->
      if @value[@cursorStart + theElementNumber]?
        @value[@cursorStart + theElementNumber]
      else
        FLNil.createNew()


    toBeReturned.elementAtSetMutable = (theElementNumber, theValue) ->
      if @isMessage or @cursorStart != 0
        throw "elementAtSetMutable: you can't set an element of a message"
      @value[theElementNumber] = theValue
      @cursorEnd = @value.length - 1
      return @

    # creates a string for a matcher signature, such that
    # when these strings are ordered alphabetically, the
    # matchers are ordered from more specific to more
    # generic.
    #
    # This is done like so:
    #  a token generates an 'a'
    #  a non-evaluating param generates 'b'
    #  evaluating param generates 'c'
    #  empty slot generates 'd'
    #  the string is then padded with 'd' up to 10 places
    #
    # in this way, anything starting with a token will come
    # first, and longer token matches will prevail.
    # the empty signature will always go last, and more empty
    # slots will generate more 'd', so shorter signatures will
    # tend to be last.

    toBeReturned.sortOrderString = ->
      sortOrderString = ""
      for i in [0...@length()]
        element = @elementAt(i)
        if element.flClass == FLToken
          sortOrderString += "a"
        if element.flClass == FLList
          if element.isEvaluatingParam()
            sortOrderString += "c"
          else
            sortOrderString += "b"
      paddingLength = 10 - sortOrderString.length
      sortOrderString += new Array(paddingLength).join('d')

    toBeReturned.giveDefinitionContextToElements = (context) ->
      for i in [0...@length()]
        if listEvaluationsDebug
          log "toBeReturned.giveDefinitionContextToElements"
        
        if (@elementAt i).flClass == FLList
          (@elementAt i).giveDefinitionContextToElements context
        else
          (@elementAt i).definitionContext = context


    toBeReturned.flToString = ->
      #log "@value:" + @value
      #log "list print: length: " + @length()
      if @length() <= 0
        return "empty message"
      toBePrinted = "("
      for i in [0...@length()]
        #log "@value element " + i + " : " + @value[i]
        #log "@value element " + i + " content: " + @value[i].value
        toBePrinted += " " + @elementAt(i).flToStringForList()
      toBePrinted += " )"
      return toBePrinted

    

    toBeReturned.evalFirstListElementAndTurnRestIntoMessage = (theContext) ->
      firstElement = @firstElement()
      if listEvaluationsDebug
        log "           " + indentation() + "evaling element " + firstElement.value
      # yield from
      theContext.returned = firstElement.eval theContext, @

      restOfMessage = @restOfMessage()
      return [theContext, restOfMessage]

    toBeReturned.findReceiver = (theContext) ->
      # yield from
      [returnedContext, restOfMessage] = @evalFirstListElementAndTurnRestIntoMessage theContext

      receiver = returnedContext.returned

      if listEvaluationsDebug
        log "evaluation " + indentation() + "remaining part of list to be sent as message is: " + restOfMessage.flToString()
      return [returnedContext, restOfMessage, receiver]

    # this eval requires that the whole list is consumed
    toBeReturned.eval = (theContext) ->

      # yield from
      [returnedContext, returnedMessage] = @partialEvalAsMessage theContext

      if listEvaluationsDebug
        log "list eval - returned message: " + returnedMessage.flToString()
        log "list eval - returned context: " + returnedContext?.flToString?()
        log "list eval - returnedcontext.returned: " + returnedContext.returned?.flToString?()
        log "list eval - returnedcontext.unparsedMessage: " + returnedContext.unparsedMessage?.flToString?()

      if !returnedMessage.isEmpty()
        if listEvaluationsDebug
          log "list couldn't be fully evaluated: " + @flToString() + " unexecutable: " + returnedMessage.flToString()
        theContext.throwing = true
        return FLException.createNew "message was not understood: " + returnedMessage.flToString()

      return returnedContext.returned

    # this eval doesn't require that the whole list is consumed,
    # it just consumes what it can
    toBeReturned.partialEvalAsMessage = (theContext, priority, associativity, theReceiver, theSignature) ->
      # a list without any messages just evaluates itself, which
      # consists of the following:
      #  a) separate all the statements (parts separated by ";")
      #  b) for each statement, evaluate its first element as the receiver
      #  c) send to the receiver the remaining part of the statement, as the message

      if listEvaluationsDebug
        log "evaluation " + indentation() + "list received empty message, evaluating content of list"
        log "evaluation " + indentation() + "  i.e. " + @flToString()

      # todo this doesn't seem to be needed
      @toList()

      statements = @separateStatements()

      for eachStatement in statements
        if listEvaluationsDebug
          log "evaluation " + indentation() + "evaluating single statement"
          log "evaluation " + indentation() + "  i.e. " + eachStatement.flToString()

        returnedContext = theContext
        restOfMessage = eachStatement

        # yield from
        [returnedContext, restOfMessage, receiver] = restOfMessage.findReceiver returnedContext
        if listEvaluationsDebug
          log "found next receiver and now message is: " + restOfMessage.flToString()
          #dir receiver
          log "3 returnedContext.throwing: " + returnedContext.throwing

        # works as follows: now that we found the first receiver,
        # we send it the rest of the original message hence getting a
        # new receiver, whom we send again the rest of the message
        # and so and and so forth. We keep using the same context, so we
        # accrete the state changes to the same context i.e. the one we
        # are running the method body in.

        # we'll exit this loop in a number of ways:
        #  - no more messages to consume
        #  - exceptions being thrown or done/return objects
        #  - the message is not understood
        loop

          # where we detect an exception being thrown
          if theContext.throwing or returnedContext.throwing
            if listEvaluationsDebug
              log "throw escape"

            # the return is a special type of exception that
            # we can catch before doing the next "method call"
            # so we catch it here. We have to go up a level
            # while the context is transparent, because "proper"
            # method calls are done in a non-transparent context
            if listEvaluationsDebug
              log "context at depth " + theContext.depth()+ " with self: " + theContext.self.flToString?() + " is transparent: "  + theContext.isTransparent
            if receiver.flClass == FLReturn and !theContext.isTransparent
              if listEvaluationsDebug
                log "got a return!"
              theContext.throwing = false
              theContext.returned = receiver.value
            else
              if listEvaluationsDebug
                log " throwing the receiver up " + receiver.flToString()
              theContext.throwing = true
              theContext.returned = receiver

            return [theContext, FLList.emptyMessage()]

          if listEvaluationsDebug
            log "evaluation " + indentation() + "receiver: " + receiver?.flToString?()
            log "evaluation " + indentation() + "message: " + restOfMessage.flToString()

          # now actually send the message to the receiver. Note that
          # only part of the message might be consumed, in which case
          # we'll have to find the result from what we can consume and then
          # send the remaining part to such result. This is why
          # we have to keep iterating until the whole message is consumed

          if (receiver.flClass == FLNumber or receiver.flClass == FLString or receiver.flClass == FLBoolean) and restOfMessage.isEmpty()
            returnedContext = theContext
            returnedMessage = restOfMessage
            returnedContext.returned = receiver
            if listEvaluationsDebug
              log "skipping empty evaluation because basic type "
          else
            # yield from
            [returnedContext, returnedMessage] = receiver.findSignatureBindParamsAndMakeCall restOfMessage, theContext, priority, associativity, theReceiver, theSignature

          if !returnedContext?
            returnedContext = theContext
            returnedContext.returned = receiver
            if listEvaluationsDebug
              log "restOfMessage: " + restOfMessage.flToString()
              log "receiver: " + receiver.flToString()
            returnedContext.unparsedMessage = returnedMessage

            # if the object was sent the empty message and it wasn't
            # understood, and there is nothing after the object,
            # then we move on to the next statement rather than
            # quitting altogether
            if returnedMessage.isEmpty()
              break

            return [returnedContext, returnedMessage]

          receiver = returnedContext.returned
          restOfMessage = returnedMessage

          if listEvaluationsDebug
            log "evaluation " + indentation() + "list evaluation returned: " + receiver?.flToString?()
            log "theContext.throwing: " + theContext.throwing
            log "returnedContext.throwing: " + returnedContext.throwing
            log "restOfMessage: " + restOfMessage

          if restOfMessage.isEmpty() and
            # field or array access is just like a token access, and
            # hence should still let the content
            # just looked up to "run" further on. That's because
            # it's as if we looked up a token, so it should behave
            # the same.
            !returnedContext.justDidAFieldOrArrayAccess? and
            !(theContext.throwing or returnedContext.throwing) and
            # "remaining" thrown exceptions cause us to keep going with the
            # current statement, which causes an exception to be thrown.
            !(receiver?.flClass == FLException and receiver?.thrown) and
            # any "remaining" ifFallThrough also need to keep being evaluated
            # as they'll evaluate themselves to nil
            !(receiver?.flClass == FLIfFallThrough)
              if listEvaluationsDebug
                log "breaking and moving on to next statement"
              break




        if listEvaluationsDebug
          log "evaluation " + indentation() + "list: nothing more to evaluate"
        theContext.returned = receiver


      if listEvaluationsDebug
        log "evaluation " + indentation() + "list: theContext.returned: " + theContext.returned
      #dir theContext.returned
      #flContexts.pop()
      return [theContext, restOfMessage]

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

    toBeReturned.startsWithCompoundAssignmentOperator =  ->
      if @length() >= 2
        if (@elementAt 1).flClass == FLToken
          # test for things like "+=", "*=" etc.
          if /([+\-^*/%_]+=)/g.test (@elementAt 1).value
            if listEvaluationsDebug
              log "startsWithCompoundAssignmentOperator: yes"
            return true
      if listEvaluationsDebug
        log "startsWithCompoundAssignmentOperator: no"
      return false

    toBeReturned.startsWithIncrementOrDecrementOperator =  ->
      if @length() >= 2
        if (@elementAt 1).flClass == FLToken
          if (@elementAt 1).value == "++" or (@elementAt 1).value == "--"
            if listEvaluationsDebug
              log "startsWithIncrementOrDecrementOperator: yes"
            return true
      if listEvaluationsDebug
        log "startsWithIncrementOrDecrementOperator: no"
      return false

    toBeReturned.secondElementIsEqual =  ->
      if @length() >= 2
        if (@elementAt 1).flClass == FLToken
          if (@elementAt 1).value == "="
            return true
      return false

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
      copy.definitionContext = @definitionContext
      return copy

    toBeReturned.shallowCopy = ->
      copy = @copy()
      copy.value = @value.slice()
      return copy

    toBeReturned.isEvaluatingParam =  ->
      @length() == 1

    toBeReturned.getParamToken = ->
      if @isEvaluatingParam()
        return @elementAt(0)
      else
        return @elementAt(1)

    toBeReturned.separateStatements = ->
      #log "evaluation " + indentation() + "separating statements   start: " + @flToString()
      arrayOfStatements = []
      lastStatementEnd = @cursorStart - 1
      for i in [@cursorStart..@cursorEnd]
        #log "evaluation " + indentation() + "separating statements   examining element " + @value[i].flToString()
        if (@value[i].isStatementSeparator?()) or (i == @cursorEnd)
          statementToBeAdded = @copy().toList()
          statementToBeAdded.cursorStart = lastStatementEnd + 1
          statementToBeAdded.cursorEnd = i - 1
          if i == @cursorEnd and !@value[@cursorEnd].isStatementSeparator?()
            #log " last char: " + @value[@cursorEnd].flToString()
            statementToBeAdded.cursorEnd++
          lastStatementEnd = i
          if !statementToBeAdded.isEmpty() and !statementToBeAdded.firstElement().isStatementSeparator?()
            #log " adding: " + statementToBeAdded.flToString()
            arrayOfStatements.jsArrayPush statementToBeAdded
          #log "evaluation " + indentation() + "separating statements isolated new statement " + statementToBeAdded.flToString()


      return arrayOfStatements



    return toBeReturned

    
FLList = new FLListClass()
