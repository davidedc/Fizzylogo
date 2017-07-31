class  FLBooleanPrimitiveClass extends  FLPrimitiveClasses
  createNew: (value) ->
    toBeReturned = new  FLPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.flClass = FLBoolean


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
        #console.dir returned
        console.log "evaluation " + indentation() + "after evalMessage in boolean message is: " + message.print()

        console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

        if returned.returned?
          # "findMessageAndBindParams" has already done the job of
          # making the call and fixing theContext's PC and
          # updating the return value, we are done here
          if returned.returned.value?
            console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + returned.returned.value
          return returned

        console.log "evaluation " + indentation() + "evalMessage in boolean matched: " + @flClass.methodBodies[anyMatch]
        console.log "evaluation " + indentation() + "boolean keeping evaluation because it got null result"
        console.log "evaluation " + indentation() + "...continuing, message is: " + message.print() + " and PC: " + returned.programCounter
        theContext.returned = @
        flContexts.pop()

        if theContext.returned?.value?
          console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + theContext.returned.value

        return theContext

        #remainingMessage = message.advanceMessageBy returned.programCounter

      console.log "evaluation " + indentation() + "boolean: no matches on any methods "
      
      # TODO needs refactoring, highly exceptional!

      if !message.isEmpty()
        console.log "evaluation " + indentation() + "boolean sent this piece of code to run: " + message.print()
        #console.log "evaluation " + indentation() + "with self being: " + theContext.self.print()

        # note how, even if we send a message, self remains the
        # current one, not the boolean!
        theContext2 = @messageSend message, theContext, theContext.self
        theContext.programCounter += theContext2.programCounter
        theContext.returned = theContext2.returned

        console.log "evaluation " + indentation() + "  returned from message send: " + theContext
        #console.dir theContext
        flContexts.pop()

        if theContext.returned?.value?
          console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + theContext.returned.value

        return theContext

      theContext.returned = @
      flContexts.pop()

      if theContext.returned?.value?
        console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + theContext.returned.value

      return theContext

    return toBeReturned
    

FLBoolean = new  FLBooleanPrimitiveClass()

