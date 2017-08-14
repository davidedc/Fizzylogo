class FLAtomClass extends FLPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = super FLAtom
    toBeReturned.value = theAtomName

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext, remainingMessage) ->

      # shortcut: instead of using "@a←5" or "@a eval1"
      # one can now just use "a=5" and "a eval"
      if remainingMessage? and remainingMessage.flClass == FLList
        console.log "remainingMessage: " + remainingMessage.print()
        console.log "secondElementIsEqual: " + remainingMessage.secondElementIsEqual()
        if remainingMessage.secondElementIsEqual()
          theContext.returned = @
          return [theContext]

      # first always look up if there is a value for anything
      # if there is, that wins all the times, so you could
      # have an exotic value for "false", or "2" that is completely
      # different from what it would naturally be.
      existingLookedUpValue = theContext.lookUpAtomValuePlace @
      if existingLookedUpValue?
        theContext.returned = theContext.lookUpAtomValue @, existingLookedUpValue
      else if /^\d+$/.test @value
        theContext.returned = FLNumber.createNew @value

      console.log "evaluation " + indentation() + "atom " + theAtomName + " contents: " + theContext.returned?.value

      # if we are here it means that we can't find any
      # meaning for this atom,
      # which is something that we are going to report.
      # We might even try to send a message to it, in which
      # case we'll report that too.
      rWorkspace.lastUndefinedArom = @

      return [theContext]


    return toBeReturned

FLAtom = new FLAtomClass()
