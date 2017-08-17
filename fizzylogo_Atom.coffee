class FLAtomClass extends FLPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = super FLAtom
    toBeReturned.value = theAtomName

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext, remainingMessage, ignoreUnassigned) ->

      # shortcut: instead of using "@a←5"
      # one can now just use "a=5"
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
      console.log "evaluation " + indentation() + "looking up temp atom: " + @value
      existingLookedUpValue = theContext.lookUpAtomValuePlace @
      if existingLookedUpValue?
        console.log "evaluation " + indentation() + "found temp atom: " + @value
        theContext.returned = theContext.lookUpAtomValue @, existingLookedUpValue
        return [theContext]
      else if /^\d+$/.test @value
        theContext.returned = FLNumber.createNew @value
        return [theContext]

      if ignoreUnassigned
        console.log "evaluation " + indentation() + "not found temp atom: " + @value + " and ignoring "
        theContext.returned = @
        return [theContext]

      console.log "evaluation " + indentation() + "atom " + theAtomName + " contents: " + theContext.returned?.value
      console.log "evaluation " + indentation() + "not found temp atom: " + @value

      # if we are here it means that we can't find any
      # meaning for this atom,
      # which is something that we are going to report.
      # We might even try to send a message to it, in which
      # case we'll report that too.
      theContext.returned = FLNil.createNew()
      rWorkspace.lastUndefinedArom = @

      return [theContext]


    return toBeReturned

FLAtom = new FLAtomClass()
