class FLListPrimitiveClass extends FLPrimitiveClasses


  # A note about messages, which are special lists.
  # ...a fizzylogo message is just an FLList which is meant to
  # be used as a message only, which means that:
  #    - its elements don't change
  #    - it can be split ( "." splits statements)
  #    - we can "consume" one or more elements
  #    - we don't need messages to be fizzylogo objects,
  #      they are part of the runtime and invisible to
  #      the user.
  #    - a message is never sent a message, because
  #      a message is not a fizzylogo object
  # so we try to make some of these operations more efficient
  # for messages, since all operations don't modify the elements
  # we can do splits and we can consume things just by moving
  # around a start index and an end index of an unchanging
  # array of elements.
  # The alternative would be to use no indexes and just
  # do shallow copies around. That would be fine for performance
  # but there is just something about the constant shallow copying
  # during interpretation that looks like it's a quadratic
  # operation, so we say no to that.

  emptyMessage: ->
    newMessage = FLList.createNew()
    newMessage.isFromMessage = true
    return newMessage

  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = []
    toBeReturned.flClass = FLList


    # these are only used for messages, which
    # are special kinds of lists
    toBeReturned.cursorStart = 0
    toBeReturned.cursorEnd = -1
    toBeReturned.isFromMessage = false

    # nothing much to do, but it makes it more
    # clear in the code to show "how"
    # one is using the message/list
    toBeReturned.toList = ->
      @

    # nothing much to do, but it makes it more
    # clear in the code to show "how"
    # one is using the message/list
    toBeReturned.toMessage = ->
      @isFromMessage = true
      @

    toBeReturned.push = (theItemToPush) ->
      if @isFromMessage
        throw "FLList deriving from a message should never be modified"
      @value.push theItemToPush
      @cursorEnd++

    toBeReturned.elementAt = (theElementNumber) ->
      @value[@cursorStart + theElementNumber]

    toBeReturned.print = ->
      #console.log "@value:" + @value
      #console.log "list print: length: " + @length()
      if @length() <= 0
        return "empty message"
      toBePrinted = "( "
      for i in [0...@length()]
        #console.log "@value element " + i + " : " + @value[i]
        #console.log "@value element " + i + " content: " + @value[i].value
        toBePrinted += " " + @elementAt(i).print()
      toBePrinted += " )"
      return toBePrinted

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging list with " + message.print()

      if message.isEmpty()
        # a list without any messages just evaluates itself, which
        # consists of the following:
        #  a) separate all the statements (parts separated by ".")
        #  b) for each statement, evaluate its first element as the receiver
        #  c) send to the receiver the remaining part of the statement, as the message

        console.log "evaluation " + indentation() + "list received empty message, evaluating content of list"
        console.log "evaluation " + indentation() + "  i.e. " + @print()

        @isFromMessage = true

        statements = @separateStatements()

        for eachStatement in statements

          list = eachStatement.toList()

          console.log "evaluation " + indentation() + "evaluating single statement"
          console.log "evaluation " + indentation() + "  i.e. " + list.print()

          [receiver, restOfMessage] = list.evalFirstMessageElement theContext

          console.log "evaluation " + indentation() + "remaining part of list to be sent as message is: " + restOfMessage.print()

          # now that we have the receiver, we send it the rest of the original message
          # hence getting a new receiver, whom we send again the rest of the message
          # and so and and so forth. We keep using the same context, so we
          # accrete the state changes to the same context i.e. the one we
          # are running the method body in.
          until restOfMessage.isEmpty()

            console.log "evaluation " + indentation() + "receiver: " + receiver.value
            console.log "evaluation " + indentation() + "message: " + restOfMessage.print()

            # now actually send the message to the receiver. Note that
            # only part of the message might be consumed, this is why
            # we have to keep iterating until the whole message is consumed
            [newContext, restOfMessage] = receiver.progressWithMessage restOfMessage, theContext
            receiver = newContext.returned

            flContexts.pop()
            console.log "evaluation " + indentation() + "list evaluation returned: " + receiver?.value
            #console.dir receiver



          console.log "evaluation " + indentation() + "list: nothing more to evaluate"
          theContext.returned = receiver

      else
        returnedContext = @findSignatureBindParamsAndMakeCall theContext, message
        console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

        if returnedContext?
          if returnedContext.returned?
            # "findSignatureBindParamsAndMakeCall" has already done the job of
            # making the call and fixing theContext's PC and
            # updating the return value, we are done here
            return returnedContext

        theContext.returned = @

      console.log "evaluation " + indentation() + "list: theContext.returned: " + theContext.returned
      #console.dir theContext.returned
      flContexts.pop()
      return theContext



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

    toBeReturned.evalFirstMessageElement = (theContext) ->
      firstElement = @firstElement()
      console.log "           " + indentation() + "evaling element " + firstElement.value
      [evaledFirstElement, unused] = firstElement.flEval theContext
      restOfMessage = @skipNextMessageElement theContext
      return [evaledFirstElement, restOfMessage]

    toBeReturned.skipNextMessageElement = (theContext) ->
      theContext.programCounter++
      return @restOfMessage()

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
      copy.isFromMessage = @isFromMessage
      return copy

    toBeReturned.isEvaluatingParam =  ->
      @length() == 1

    toBeReturned.getParamAtom = ->
      if @isEvaluatingParam()
        return @elementAt(0)
      else
        return @elementAt(1)

    toBeReturned.separateStatements = ->
      console.log "evaluation " + indentation() + "separating statements   start "
      arrayOfStatements = []
      lastStatementEnd = @cursorStart - 1
      for i in [@cursorStart..@cursorEnd]
        console.log "evaluation " + indentation() + "separating statements   examining element " + @value[i].print()
        if (@value[i] == RStatementSeparatorSymbol) or (i == @cursorEnd)
          statementToBeAdded = @copy()
          statementToBeAdded.cursorStart = lastStatementEnd + 1
          statementToBeAdded.cursorEnd = i - 1
          if (i == @cursorEnd) then statementToBeAdded.cursorEnd++
          lastStatementEnd = i
          arrayOfStatements.push statementToBeAdded
          console.log "evaluation " + indentation() + "separating statements isolated new statement " + statementToBeAdded.print()


      return arrayOfStatements



    return toBeReturned

    
FLList = new FLListPrimitiveClass()


