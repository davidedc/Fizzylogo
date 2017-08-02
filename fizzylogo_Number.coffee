class FLNumberPrimitiveClass extends FLPrimitiveClasses

  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = parseFloat(value + "")
    toBeReturned.flClass = FLNumber

    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging number " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if message.isEmpty()
        theContext.returned = @

      else

        returnedContext = @findMessageAndBindParams theContext, message
        console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

        if returnedContext?
          if returnedContext.returned?
            # "findMessageAndBindParams" has already done the job of
            # making the call and fixing theContext's PC and
            # updating the return value, we are done here
            return returnedContext

        theContext.returned = @

      #if !message.isEmpty()
      #  console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()

      #flContexts.pop()

      return theContext

    return toBeReturned
    

FLNumber = new FLNumberPrimitiveClass()

