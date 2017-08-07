class FLAtomClass extends FLPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = super FLAtom
    toBeReturned.value = theAtomName

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging atom " + theAtomName + " with " + message.print()


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

      return theContext


    return toBeReturned

FLAtom = new FLAtomClass()
