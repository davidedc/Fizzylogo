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


    # check if temp variable is visible in either the running context or the
    # definition context.
    # if not, create it as a temp variable in the current running context
    toBeReturned.whichDictionaryContainsToken = (theContext, definitionContext) ->
      if tokensDebug
        log "evaluation " + indentation() + "finding location of token: " + @value
      existingLookedUpValuePlace = theContext.whichDictionaryContainsToken @

      if existingLookedUpValuePlace?
        if tokensDebug
          log "evaluation " + indentation() + "found token " + @value + " in running context"
        return existingLookedUpValuePlace
      else
          log "evaluation " + indentation() + " not found token " + @value + " in running context, ...trying in definitionContext"
        existingLookedUpValuePlace = definitionContext?.whichDictionaryContainsToken @
        if existingLookedUpValuePlace?
          if tokensDebug
            log "evaluation " + indentation() + "found token " + @value + " in definition context"
          return existingLookedUpValuePlace

      if tokensDebug
        log "evaluation " + indentation() + "not found token " + @value + " anywhere"
        log "evaluation " + indentation() + "creating temp token: " + @value + " at depth: " + theContext.firstNonTransparentContext().depth() + " with self: " + theContext.firstNonTransparentContext().self.flToString()

      # no such variable, hence we create it as temp, but
      # we can't create them in this very call context, that would
      # be useless, we place it in the context of the _previous_ context
      # note that this means that any construct that creates a new context
      # will seal the temp variables in it. For example "for" loops. This
      # is like the block scoping of C or Java. If you want function scoping, it
      # could be achieved for example by marking in a special way contexts
      # that have been created because of method calls and climbing back
      # to the last one of those...

      return theContext.firstNonTransparentContext().tempVariablesDict

    toBeReturned.assignValue = (theContext, definitionContext, valueToAssign) ->
      dictToPutValueIn = @whichDictionaryContainsToken theContext, definitionContext
      dictToPutValueIn[ValidIDfromString @value] = valueToAssign

      if tokensDebug
        log "evaluation " + indentation() + "stored value in dictionary"


    toBeReturned.lookupValue = (theContext, definitionContext) ->
      if tokensDebug
        log "evaluation " + indentation() + "looking up value of token: " + @value
      existingLookedUpValuePlace = @whichDictionaryContainsToken theContext, definitionContext

      if contextDebug
        #log "evaluation " + indentation() + "lookup: " + @value + " found dictionary and it contains:"
        #dir existingLookedUpValuePlace
        log "evaluation " + indentation() + "lookup: " + @value + " also known as " + (ValidIDfromString @value)
        log "evaluation " + indentation() + "lookup: value looked up: "
        #dir existingLookedUpValuePlace[ValidIDfromString @value]

      return existingLookedUpValuePlace[ValidIDfromString @value]
    

    toBeReturned.eval = (theContext, remainingMessage, fromListElementsEvaluation) ->

      #yield
      # shortcut: instead of using "@a←5"
      # one can now just use "a=5"
      if remainingMessage? and remainingMessage.flClass == FLList
        if tokensDebug
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
      lookupValue = @lookupValue theContext, remainingMessage.definitionContext
      if lookupValue? then return lookupValue

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

      if tokensDebug
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
