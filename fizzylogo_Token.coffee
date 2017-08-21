class FLTokenClass extends FLClasses
  createNew: (tokenString) ->
    toBeReturned = super FLToken
    toBeReturned.value = tokenString

    toBeReturned.print = ->
      return @value

    toBeReturned.isStatementSeparator = ->
      return @value == ";"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext, remainingMessage, ignoreUnassigned) ->

      # shortcut: instead of using "@a←5"
      # one can now just use "a=5"
      if remainingMessage? and remainingMessage.flClass == FLList
        console.log "remainingMessage: " + remainingMessage.print()
        console.log "secondElementIsEqual: " + remainingMessage.secondElementIsEqual()
        if remainingMessage.startsWithIncrementOrDecrementOperator() or remainingMessage.startsWithCompoundAssignmentOperator() or remainingMessage.secondElementIsEqual()
          theContext.returned = @
          return [theContext]

      # first always look up if there is a value for anything
      # if there is, that wins all the times, so you could
      # have an exotic value for "false", or "2" that is completely
      # different from what it would naturally be.
      console.log "evaluation " + indentation() + "looking up temp token: " + @value
      existingLookedUpValuePlace = theContext.whichDictionaryContainsToken @
      if existingLookedUpValuePlace?
        console.log "evaluation " + indentation() + "found temp token: " + @value
        theContext.returned = theContext.lookUpTokenValue @, existingLookedUpValuePlace
        return [theContext]
      else if /^\d+$/.test @value
        theContext.returned = FLNumber.createNew @value
        return [theContext]

      if ignoreUnassigned
        console.log "evaluation " + indentation() + "not found temp token: " + @value + " and ignoring "
        theContext.returned = @
        return [theContext]

      console.log "evaluation " + indentation() + "token " + @value + " contents: " + theContext.returned?.value
      console.log "evaluation " + indentation() + "not found temp token: " + @value

      # if we are here it means that we can't find any
      # meaning for this token,
      # which is something that we are going to report.
      # We might even try to send a message to it, in which
      # case we'll report that too.
      theContext.returned = FLNil.createNew()
      rWorkspace.lastUndefinedArom = @

      return [theContext]


    return toBeReturned

FLToken = new FLTokenClass()
