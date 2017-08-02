class FLBooleanPrimitiveClass extends FLPrimitiveClasses
  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.flClass = FLBoolean


    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging boolean " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      returnedContext = @findMessageAndBindParams theContext, message

      if returnedContext?
        console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

        if returnedContext.returned?
          # "findMessageAndBindParams" has already done the job of
          # making the call and fixing theContext's PC and
          # updating the return value, we are done here
          return returnedContext

        #console.log "evaluation " + indentation() + "evalMessage in boolean matched: " + @flClass.methodBodies[anyMatch]
        console.log "evaluation " + indentation() + "boolean keeping evaluation because it got null result"
        console.log "evaluation " + indentation() + "...continuing, message is: " + message.print() + " and PC: " + returnedContext.programCounter

        theContext.returned = @
        flContexts.pop()
        return theContext


      console.log "evaluation " + indentation() + "boolean: no matches on any methods or returned null"
      
      # TODO needs refactoring, highly exceptional!

      if !message.isEmpty()
        console.log "evaluation " + indentation() + "boolean sent this piece of code to run: " + message.print()
        #console.log "evaluation " + indentation() + "with self being: " + theContext.self.print()

        # note how, even if we send a message, self remains the
        # current one, not the boolean!
        returnedContext = @messageSend message, theContext, theContext.self
        theContext.programCounter += returnedContext.programCounter
        theContext.returned = returnedContext.returned

        console.log "evaluation " + indentation() + "  returned from message send: " + theContext
        #console.dir theContext
        flContexts.pop()

        if theContext.returned?.value?
          console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + theContext.returned.value

        return returnedContext

      theContext.returned = @
      flContexts.pop()

      if theContext.returned?.value?
        console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + theContext.returned.value

      return theContext

    return toBeReturned
    

FLBoolean = new FLBooleanPrimitiveClass()

