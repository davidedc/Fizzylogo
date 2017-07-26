class RosettaNumberPrimitiveClass extends RosettaPrimitiveClasses

  createNew: (value) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = parseFloat(value)
    toBeReturned.rosettaClass = RNumber

    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging number " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter
      anyMatch = @findMessageAndBindParams theContext, message
      if anyMatch?
        returned = @lookupAndSendFoundMessage theContext, anyMatch
      console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if returned?
        # "findMessageAndBindParams" has already done the job of
        # making the call and fixing theContext's PC and
        # updating the return value, we are done here
        return returned


      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()
      theContext.returned = @
      rosettaContexts.pop()

    return toBeReturned
    

RNumber = new RosettaNumberPrimitiveClass()

