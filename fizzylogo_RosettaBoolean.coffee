class RosettaBooleanPrimitiveClass extends RosettaPrimitiveClasses
  createNew: (value) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.rosettaClass = RBoolean


    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging boolean " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter
      anyMatch = @findMessageAndBindParams theContext, message
      if anyMatch?
        returned = @lookupAndSendFoundMessage theContext, anyMatch
        console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + returned
        console.log "evaluation " + indentation() + "evalMessage lookupAndSendFoundMessage boolean done"
        console.log "evaluation " + indentation() + "evalMessage in boolean returned value is: " + returned.returned
        console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + returned
        console.dir returned
        console.log "evaluation " + indentation() + "after evalMessage in boolean message is: " + message.print()

        console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

        if returned.returned?
          # "findMessageAndBindParams" has already done the job of
          # making the call and fixing theContext's PC and
          # updating the return value, we are done here
          return returned

        console.log "evaluation " + indentation() + "evalMessage in boolean matched: " + @rosettaClass.methodBodies[anyMatch]
        console.log "evaluation " + indentation() + "boolean keeping evaluation because it got null result"
        console.log "evaluation " + indentation() + "...continuing, message is: " + message.print() + " and PC: " + returned.programCounter
        theContext.returned = @
        rosettaContexts.pop()
        return theContext

        #remainingMessage = message.advanceMessageBy returned.programCounter

      console.log "evaluation " + indentation() + "boolean: no matches on any methods "
      
      # TODO needs refactoring, highly exceptional!

      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to boolean should be empty? " + message.print()

        theContext2 = @messageSend message, theContext
        theContext.programCounter += theContext2.programCounter
        theContext.returned = theContext2.returned

        console.log "evaluation " + indentation() + "  returned from message send: " + theContext
        console.dir theContext
        rosettaContexts.pop()
        return theContext

      theContext.returned = @
      rosettaContexts.pop()
      return theContext

    return toBeReturned
    

RBoolean = new RosettaBooleanPrimitiveClass()

