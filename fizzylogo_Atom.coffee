class FLAtomClass extends FLPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = theAtomName
    toBeReturned.flClass = FLAtom

    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging atom " + theAtomName + " with " + message.print()

      if message.isEmpty()

        # first always look up if there is a value for anything
        # if there is, that wins all the times, so you could
        # have an exotic value for "false", or "2" that is completely
        # different from what it would naturally be.
        existingLookedUpValue = theContext.lookUpAtomValuePlace @
        if existingLookedUpValue?
          theContext.returned = theContext.lookUpAtomValue @, existingLookedUpValue
        else if /^\d+$/.test @value
          theContext.returned = FLNumber.createNew @value

        console.log "evaluation " + indentation() + "atom " + theAtomName + " contents: " + theContext.returned.value

      else
        returnedContext = @findMessageAndBindParams theContext, message
        console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

        if returnedContext?
          # "findMessageAndBindParams" has already done the job of
          # making the call and fixing theContext's PC and
          # updating the return value, we are done here
          return returnedContext

        theContext.returned = @

      return theContext


    return toBeReturned

FLAtom = new FLAtomClass()

