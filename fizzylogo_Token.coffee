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


    toBeReturned.lookup = (theContext, definitionContext) ->
      log "evaluation " + indentation() + "looking up temp token: " + @value
      existingLookedUpValuePlace = theContext.whichDictionaryContainsToken @

      if existingLookedUpValuePlace?
        log "evaluation " + indentation() + "found temp token in running context: " + @value
        return theContext.lookUpTokenValue @, existingLookedUpValuePlace
      else
        existingLookedUpValuePlace = definitionContext?.whichDictionaryContainsToken @
        if existingLookedUpValuePlace?
          log "evaluation " + indentation() + "found temp token in definition context: " + @value
          return definitionContext.lookUpTokenValue @, existingLookedUpValuePlace
      return null
    

    toBeReturned.eval = (theContext, remainingMessage, fromListElementsEvaluation) ->

      #yield
      # shortcut: instead of using "@a←5"
      # one can now just use "a=5"
      if remainingMessage? and remainingMessage.flClass == FLList
        log "remainingMessage: " + remainingMessage.flToString()
        log "secondElementIsEqual: " + remainingMessage.secondElementIsEqual()
        if !fromListElementsEvaluation and
          (
            remainingMessage.startsWithIncrementOrDecrementOperator() or
            remainingMessage.startsWithCompoundAssignmentOperator() or
            remainingMessage.secondElementIsEqual()
          )
            return @

      # first always look up if there is a value for anything
      # if there is, that wins all the times, so you could
      # have an exotic value for "false", or "2" that is completely
      # different from what it would naturally be.
      lookup = @lookup theContext, remainingMessage.definitionContext
      if lookup? then return lookup

      # you could match the leading "+" or "-", however this would
      # be uneven with the general case of handling leading + and - 
      #else if /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/.test @value
      else if /^[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/.test @value
        return FLNumber.createNew @value
      else if /\$STRING_TOKEN_([\$a-zA-Z0-9_]+)/g.test @value
        #log "token eval returning string: " + injectStrings @value 
        return FLString.createNew injectStrings @value
      else if /^true$/.test @value
        return FLBoolean.createNew true
      else if /^false$/.test @value
        return FLBoolean.createNew false

      log "evaluation " + indentation() + "token " + @value + " contents: " + theContext.returned?.value
      log "evaluation " + indentation() + "not found temp token: " + @value

      # if we are here it means that we can't find any
      # meaning for this token,
      # which is something that we are going to report.
      # We might even try to send a message to it, in which
      # case we'll report that too.
      # rWorkspace.lastUndefinedAtom = @

      #log "token eval returning nil"
      return FLNil.createNew()


    return toBeReturned

FLToken = new FLTokenClass()
