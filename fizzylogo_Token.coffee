class FLTokenClass extends FLClasses
  createNew: (tokenString) ->
    toBeReturned = super FLToken
    toBeReturned.value = tokenString

    toBeReturned.flToString = ->
      if /\$STRING_TOKEN_([\$a-zA-Z0-9_]+)/g.test @value
        toPrint = "TOKEN:" + injectStrings @value
      else
        toPrint = @value
      return toPrint

    toBeReturned.isStatementSeparator = ->
      return @value == ";"

    toBeReturned.flToStringForList = toBeReturned.flToString

    toBeReturned.eval = (theContext, remainingMessage, ignoreUnassigned) ->

      #yield
      # shortcut: instead of using "@a←5"
      # one can now just use "a=5"
      if remainingMessage? and remainingMessage.flClass == FLList
        console.log "remainingMessage: " + remainingMessage.flToString()
        console.log "secondElementIsEqual: " + remainingMessage.secondElementIsEqual()
        if remainingMessage.startsWithIncrementOrDecrementOperator() or remainingMessage.startsWithCompoundAssignmentOperator() or remainingMessage.secondElementIsEqual()
          return @

      # first always look up if there is a value for anything
      # if there is, that wins all the times, so you could
      # have an exotic value for "false", or "2" that is completely
      # different from what it would naturally be.
      console.log "evaluation " + indentation() + "looking up temp token: " + @value
      existingLookedUpValuePlace = theContext.whichDictionaryContainsToken @
      if existingLookedUpValuePlace?
        console.log "evaluation " + indentation() + "found temp token: " + @value
        return theContext.lookUpTokenValue @, existingLookedUpValuePlace
      # you could match the leading "+" or "-", however this would
      # be uneven with the general case of handling leading + and - 
      #else if /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/.test @value
      else if /^[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/.test @value
        return FLNumber.createNew @value
      else if /\$STRING_TOKEN_([\$a-zA-Z0-9_]+)/g.test @value
        return FLString.createNew injectStrings @value
      else if /^true$/.test @value
        return FLBoolean.createNew true
      else if /^false$/.test @value
        return FLBoolean.createNew false

      if ignoreUnassigned
        console.log "evaluation " + indentation() + "not found temp token: " + @value + " and ignoring "
        return @

      console.log "evaluation " + indentation() + "token " + @value + " contents: " + theContext.returned?.value
      console.log "evaluation " + indentation() + "not found temp token: " + @value

      # if we are here it means that we can't find any
      # meaning for this token,
      # which is something that we are going to report.
      # We might even try to send a message to it, in which
      # case we'll report that too.
      rWorkspace.lastUndefinedArom = @
      return FLNil.createNew()


    return toBeReturned

FLToken = new FLTokenClass()
