
class FLObjects
  flClass: null # the class it belongs to
  instanceVariablesDict: null # a JS dictionary

  constructor: (@flClass) ->
    @instanceVariablesDict = {}
    @instanceVariablesDict[ValidIDfromString "class"] = @flClass

  isClass: ->
    @name?

  # this is needed because you want, say, "6" to find its
  # methods in its class Number, but you want Number to
  # find its methods in Number, not in Class. That's
  # a problem in the case of user classes, when you do
  #
  #   myClass = Class new; myObject = myClass new
  #
  # you really want the "new" of myClass to be found in
  # myClass, not in Class.
  methodsHolder: ->
    if @isClass()
      return @
    else
      return @flClass

  flToString: ->
    if @isClass()
      if @name == ""
        return "[anonymous class (an object of class Class)]"
      else
        return "[class \"" + @name + "\" (an object of class Class)]"
    else if @flClass.name != ""
      return "[object of class \"" + @flClass.name + "\"]"
    else
      return "[object of anonymous class]"

  flToStringForList: ->
    @flToString()

  eval: (theContext) ->
    #yield
    return @

  # Note that only part of the message might be consumed
  # "self" remains the same since we are still in the
  # same "method call" and the same "object". I.e. this
  # is not a method call (although it might lead to one),
  # this is progressing within an existing call
  findSignatureBindParamsAndMakeCall: (methodInvocationToBeChecked, theContext, previousPriority, previousAssociativity, previousReceiver, previousSignature) ->
    if objectFindSignatureMakeCallDebug
      log "object findSignature+makeCall: looking up method invocation " + methodInvocationToBeChecked.flToString() + " with signatures!"
      log "object findSignature+makeCall: looking up method invocation, is method empty? " + methodInvocationToBeChecked.isEmpty()
      log "object findSignature+makeCall: I am: " + @value


    # fake context push so that we can make
    # the context stack handling easier
    # the for loop
    # TODO check that this is not left hanging
    #flContexts.jsArrayPush null

    classContainingMethods = @methodsHolder()

    #log "evaluation - message patterns: -------------> "
    #for eachClassPattern in classContainingMethods.msgPatterns
    #  log "evaluation - message patterns: " + indentation() + eachClassPattern.flToString()
    #log "evaluation - message patterns: <------------- "

    for eachSignatureIndex in [0...classContainingMethods.msgPatterns.length]
      eachSignature = classContainingMethods.msgPatterns[eachSignatureIndex]
      eachPriority = classContainingMethods.priorities[eachSignatureIndex]
      eachAssociativity = classContainingMethods.associativities[eachSignatureIndex]

      goodMatchSoFar = true

      #if eachSignature.flToString() == "( + ( operandum ) )"
      #  log "obtained eachPriority: " + eachPriority
      if objectFindSignatureMakeCallDebug
        log "object findSignature+makeCall: signature: " + eachSignature.flToString()
        log "object findSignature+makeCall: previousPriority, eachPriority: " + previousPriority + " , " + eachPriority
        log "object findSignature+makeCall: previousAssociativity, eachAssociativity: " + previousAssociativity + " , " + eachAssociativity
      if previousPriority? and eachPriority?
        if previousPriority < eachPriority
          if objectFindSignatureMakeCallDebug
            log "breaking matching due to priority going up: previousPriority, eachPriority: " + previousPriority + " , " + eachPriority
          goodMatchSoFar = false
        # IF there is a case of same-priority, then we need to check
        # whether we are in a case of right-to-left associativity
        # such as in the case of "not not tue" and "- - 2"
        # in which case we don't want to break, we want to continue
        else if previousPriority == eachPriority
          if objectFindSignatureMakeCallDebug
            log "object findSignature+makeCall: eachAssociativity != ASSOCIATIVITY_RIGHT_TO_LEFT: " + (eachAssociativity != ASSOCIATIVITY_RIGHT_TO_LEFT)
            log "object findSignature+makeCall: previousReceiver.flClass != @flClass: " + (previousReceiver.flClass != @flClass)
            log "object findSignature+makeCall: eachSignature.flToString() != previousSignature.flToString(): " + (eachSignature.flToString() != previousSignature.flToString())
            log "object findSignature+makeCall: eachSignature.flToString(), previousSignature.flToString(): " + eachSignature.flToString() + " , "  + previousSignature.flToString()
          if eachAssociativity != ASSOCIATIVITY_RIGHT_TO_LEFT or
           previousReceiver.flClass != @flClass or
           # turns out that it's useful to lump together many operators
           # that start with the same token when we consider their
           # right-associativity, depending on just the first token.
           # For example, "^" and "^ -" should be lumped together, and same for
           # all assignment methods all starting with "="
           # (although we get right-associativity for "=" by just leaving its
           # precedence to null for the time being)
           eachSignature.firstElement().flToString() != previousSignature.firstElement().flToString()
            goodMatchSoFar = false


      #log "evaluation " + indentation() + "  matching - checking if this signature matches: " + eachSignature.flToString()
      methodInvocation = methodInvocationToBeChecked

      # remove the previous context because it was a
      # botched attempt to match a signature
      #flContexts.pop()
      #log "evaluation " + indentation() + "  ////////////////////////////////////// CREATING NEW CONTEXT WITH NEW SELF " + @

      # this is the ONLY place where we change self!
      newContext = new FLContext theContext, @
      #flContexts.jsArrayPush newContext
      #log "evaluation " + indentation() + "  matching - checking if signature matches this invocation " + methodInvocation.flToString()
      #log "evaluation " + indentation() + "  matching - checking if signature matches this invocation " + methodInvocation.flToString()

      originalMethodInvocationStart = methodInvocation.cursorStart


      if goodMatchSoFar
        until eachSignature.isEmpty() or methodInvocation.isEmpty()

          if objectFindSignatureMakeCallDebug
            log "evaluation " + indentation() + "  matching: - next signature piece: " + eachSignature.flToString() + " is token: " + " with: " + methodInvocation.flToString()

          [eachElementOfSignature, eachSignature] = eachSignature.nextElement()

          
          # the element of a signature can only be of two kinds:
          # a token or an FLList containing one parameter (with
          # prepended "@" in case the parameter doesn't require
          # evaluation)

          if eachElementOfSignature.flClass != FLList and eachElementOfSignature.flClass != FLToken
            theContext.throwing = true
            # TODO this error should really be a stock error referanceable
            # from the workspace because someone might want to catch it.
            theContext.returned = FLException.createNew "signature of a method should only contain tokens or lists. Found instead: " + eachElementOfSignature.flToString() + " . Perhaps some variable in the signature has been closed?"
            return [theContext, methodInvocationToBeChecked]

          if eachElementOfSignature.flClass == FLToken
            # if the signature contains a token, the message
            # must contain the same token, otherwise we don't
            # have a match.

            [eachElementOfInvocation, methodInvocation] = methodInvocation.nextElement()


            #log "evaluation " + indentation() + "  matching tokens: - next signature piece: " + eachElementOfSignature.flToString() + " is token: " + (eachElementOfSignature.flClass == FLToken) + " with: " + eachElementOfInvocation.flToString()

            # ok at least the message contains a token, but
            # now we have to check that they spell the same
            if objectFindSignatureMakeCallDebug
              log "******* evaluation " + indentation() +
                "  matching tokens: - next signature piece: " +
                eachElementOfSignature.flToString() +
                " is token: " + (eachElementOfSignature.flClass == FLToken) +
                " with: " + eachElementOfInvocation.flToString()
            if eachElementOfSignature.value == eachElementOfInvocation.value
              if objectFindSignatureMakeCallDebug
                log "evaluation " + indentation() + "  matching - token matched: " + eachElementOfSignature.flToString()
              # OK good match of tokens,
              # check the next token in the signature
              continue
            else
              # no match between the tokens, check next signature
              goodMatchSoFar = false
              break

          else
            # the signature has a param. we have to check if
            # it requires an evaluation or not
            if objectFindSignatureMakeCallDebug
              log "evaluation " + indentation() + "  matching - getting the token inside the parameter: " + eachElementOfSignature.flToString()
            paramToken = eachElementOfSignature.getParamToken()
            #dir paramToken
            if objectFindSignatureMakeCallDebug
              log "evaluation " + indentation() + "  matching - token inside the parameter: " + paramToken.flToString()
            if eachElementOfSignature.isEvaluatingParam()
              if objectFindSignatureMakeCallDebug
                log "evaluation " + indentation() + "  matching - need to evaluate next msg element from invocation: " + methodInvocation.flToString() + " and bind to: " + paramToken.flToString()

              # note how we need to evaluate the params in a context that has the
              # same SELF as the calling one, not the new one that
              # we are creating with the new SELF of the callee, otherwise, say,
              # passing self, self would always bind
              # to the receiver, which we don't want
              # like in "7 * self" we don't want to bind self to 7

              # yield from
              [returnedContext, methodInvocation] = methodInvocation.partialEvalAsMessage theContext, eachPriority, eachAssociativity, @, classContainingMethods.msgPatterns[eachSignatureIndex]

              valueToBeBound = returnedContext.returned

            else
              # don't need to evaluate the parameter
              if objectFindSignatureMakeCallDebug
                log "evaluation " + indentation() + "  matching - need to get next msg element from invocation: " + methodInvocation.flToString() + " and bind to: " + paramToken.flToString()
              [valueToBeBound, methodInvocation] = methodInvocation.nextElement()

            if objectFindSignatureMakeCallDebug
              log "evaluation " + indentation() + "  matching - adding paramater " + paramToken.flToString() + " to tempVariables dictionary in current frame"
            newContext.tempVariablesDict[ValidIDfromString paramToken.value] = valueToBeBound

            # ok we matched a paramenter, now let's keep matching further
            # parts of the signature
            continue

      # ok we took a signature, and now here it either matched or it didn't,
      # as indicated by the goodMatchSoFar flag

      if eachSignature.isEmpty() and goodMatchSoFar

        # now, the correct PC that we need to report is
        # the original plus what we consumed from matching the
        # signature.
        if objectFindSignatureMakeCallDebug
          log "evaluation " + indentation() + "  matching - consumed from matching this sig: " + (methodInvocation.cursorStart - originalMethodInvocationStart)
          log "evaluation " + indentation() + "             methodInvocation: " + methodInvocation.flToString() + " cursor start: " + methodInvocation.cursorStart  + " original methodInvocation start: " + originalMethodInvocationStart
          log "methodInvocation.cursorStart - originalMethodInvocationStart: " + " " + methodInvocation.cursorStart  + " " + originalMethodInvocationStart
          log "theContext method invocation after: " + methodInvocation.flToString()

        theContext.unparsedMessage = null
        # yield from
        contextToBeReturned = @methodCall (classContainingMethods.methodBodies[eachSignatureIndex]), newContext, methodInvocationToBeChecked.definitionContext

        return [contextToBeReturned,methodInvocation]


    # we are still here trying to match but
    # there are no signatures left, time to give up.
    if objectFindSignatureMakeCallDebug
      log "evaluation " + indentation() + "  matching - no match found"
    return [null, methodInvocationToBeChecked]


  # this could be native, in which case it's a JS call,
  # or non-native, in which case it will result into
  # evaluation of the message that makes up the body.
  methodCall: (methodBody, theContext, definitionContext) ->
    #yield
    # note that this doesn't consume from the calling
    # context, because from the caller perspective it only matters
    # what we consume from the invocation, which we accounted
    # for already in the process of finding the signature and
    # binding the parameters.
    # i.e. we just consume
    # while we matched the correct method, which we account for
    # when we do the matching, not here after the matching happened.
    #
    # However we do affect the PC of the callee context.
    
    if methodBody.flClass == FLList
      if objectFindSignatureMakeCallDebug
        log "evaluation " + indentation() + "  matching - method body: " + methodBody.flToString()
      # non-native method, i.e. further fizzylogo code
      # creates a context and evals the message in it
      # the rest of the message is not used because all of the list should
      # be run, no remains from the message body should overspill
      # into the calling context.
      # yield from
      theContext.returned = methodBody.eval theContext, methodBody

    else
      if objectFindSignatureMakeCallDebug
        log "evaluation " + indentation() + "  matching - NATIVE method body: " + methodBody

      # native method, i.e. coffeescript/javascript code
      # note that in the yielding version, these must all
      # be generator functions
      # yield from
      theContext.returned = methodBody.call @, theContext, definitionContext

    contextToBeReturned = theContext
    return contextToBeReturned


