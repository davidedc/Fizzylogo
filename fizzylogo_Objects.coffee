
class FLObjects
  flClass: null # the class it belongs to
  instanceVariablesDict: null # a JS dictionary

  constructor: (@flClass) ->
    #console.log " instanceVariablesDict initiated "
    @instanceVariablesDict = {}

  eval: (theContext) ->
    theContext.returned = @
    return [theContext]

  # Note that only part of the message might be consumed
  # "self" remains the same since we are still in the
  # same "method call" and the same "object". I.e. this
  # is not a method call (although it might lead to one),
  # this is progressing within an existing call
  findSignatureBindParamsAndMakeCall: (methodInvocationToBeChecked, theContext) ->
    console.log "evaluation " + indentation() + "  !!! looking up method invocation " + methodInvocationToBeChecked.print() + " with signatures!"
    console.log "evaluation " + indentation() + "  !!! looking up method invocation, is method empty? " + methodInvocationToBeChecked.isEmpty()

    console.log "evaluation " + indentation() + "  I am: " + @value
    console.log "evaluation " + indentation() + "  matching - my class patterns: "

    for eachClassPattern in @flClass.msgPatterns
      console.log "evaluation " + indentation() + eachClassPattern.print()

    # fake context push so that we can make
    # the context stack handling easier
    # the for loop
    # TODO check that this is not left hanging
    flContexts.jsArrayPush null

    for eachSignatureIndex in [0...@flClass.msgPatterns.length]
      eachSignature = @flClass.msgPatterns[eachSignatureIndex]

      #console.log "evaluation " + indentation() + "  matching - checking if this signature matches: " + eachSignature.print()
      methodInvocation = methodInvocationToBeChecked

      # remove the previous context because it was a
      # botched attempt to match a signature
      flContexts.pop()
      console.log "evaluation " + indentation() + "  ////////////////////////////////////// CREATING NEW CONTEXT WITH NEW SELF " + @

      # this is the ONLY place where we change self!
      newContext = new FLContext theContext, @
      flContexts.jsArrayPush newContext
      #console.log "evaluation " + indentation() + "  matching - checking if signature matches this invocation " + methodInvocation.print()
      #console.log "evaluation " + indentation() + "  matching - checking if signature matches this invocation " + methodInvocation.print()

      soFarEverythingMatched = true
      originalMethodInvocationStart = methodInvocation.cursorStart

      # simple way to get "match all" signature
      # to work.
      if eachSignature.isMatchAllSignature()
        eachSignature = FLList.emptyMessage()            
        newContext.usingFallBackMatcher = true

      until eachSignature.isEmpty() or methodInvocation.isEmpty()

        console.log "evaluation " + indentation() + "  matching: - next signature piece: " + eachSignature.print() + " is token: " + " with: " + methodInvocation.print()

        [eachElementOfSignature, eachSignature] = eachSignature.nextElement()

        
        # the element of a signature can only be of two kinds:
        # a token or an FLList containing one parameter (with
        # prepended "@" in case the parameter doesn't require
        # evaluation)
        if eachElementOfSignature.flClass == FLToken or eachElementOfSignature.flClass == FLSymbol
          # if the signature contains a token, the message
          # must contain the same token, otherwise we don't
          # have a match.

          [eachElementOfInvocation, methodInvocation] = methodInvocation.nextElement()

          if eachElementOfInvocation.flClass == FLToken or eachElementOfInvocation.flClass == FLSymbol

            #console.log "evaluation " + indentation() + "  matching tokens: - next signature piece: " + eachElementOfSignature.print() + " is token: " + (eachElementOfSignature.flClass == FLToken) + " with: " + eachElementOfInvocation.print()

            # ok at least the message contains a token, but
            # now we have to check that they spell the same
            if eachElementOfSignature.value == eachElementOfInvocation.value
              console.log "evaluation " + indentation() + "  matching - token matched: " + eachElementOfSignature.print()
              # OK good match of tokens,
              # check the next token in the signature
              continue
            else
              # no match between the tokens, check next signature
              soFarEverythingMatched = false
              break
          else
            # the signature says "token" but the message contains
            # something else: no match, check the next
            # signature
            #console.log "evaluation " + indentation() + "  matching - no match: " + eachElementOfSignature.print() + " vs. " + eachElementOfInvocation.print()
            # this signature doesn't match check the next one
            soFarEverythingMatched = false
            break
        else
          # the signature has a param. we have to check if
          # it requires an evaluation or not
          console.log "evaluation " + indentation() + "  matching - getting the token inside the parameter: " + eachElementOfSignature.print()
          paramToken = eachElementOfSignature.getParamToken()
          #console.dir paramToken
          console.log "evaluation " + indentation() + "  matching - token inside the parameter: " + paramToken.print()
          if eachElementOfSignature.isEvaluatingParam()
            console.log "evaluation " + indentation() + "  matching - need to evaluate next msg element from invocation: " + methodInvocation.print() + " and bind to: " + paramToken.print()
            # if the first element is a list,
            # then the list is evaluated on
            # its own, without considering what comes after it.
            # I.e. a list doesn't chain with further tokens, it's
            # used as a parameter as is
            # If the first element is not a list, then we
            # run the evaluation as long as it takes us,
            # as far as things "chain" with messages they
            # understand.

            # note how we need to evaluate the params in a context that has the
            # same SELF as the calling one, not the new one that
            # we are creating with the new SELF of the callee, otherwise, say,
            # passing self, self would always bind
            # to the receiver, which we don't want
            # like in "7 * self" we don't want to bind self to 7

            if methodInvocation.firstElement().flClass == FLList
              console.log "evaluation " + indentation() + "  matching - what to evaluate is a list right away "
              [returnedContext, methodInvocation] = methodInvocation.evalFirstListElementAndTurnRestIntoMessage theContext
              valueToBeBound = returnedContext.returned                
            else
              [returnedContext, methodInvocation] = methodInvocation.eval theContext, methodInvocation
              valueToBeBound = returnedContext.returned                

          else
            # don't need to evaluate the parameter
            console.log "evaluation " + indentation() + "  matching - need to get next msg element from invocation: " + methodInvocation.print() + " and bind to: " + paramToken.print()
            [valueToBeBound, methodInvocation] = methodInvocation.nextElement()

          
          console.log "evaluation " + indentation() + "  matching - adding paramater " + paramToken.print() + " to tempVariables dictionary in current frame"
          newContext.tempVariablesDict[ValidIDfromString paramToken.value] = valueToBeBound

          # ok we matched a paramenter, now let's keep matching further
          # parts of the signature
          continue

      # ok a signature has matched completely
      if eachSignature.isEmpty() and soFarEverythingMatched

        # now, the correct PC that we need to report is
        # the original plus what we consumed from matching the
        # signature.
        console.log "evaluation " + indentation() + "  matching - consumed from matching this sig: " + (methodInvocation.cursorStart - originalMethodInvocationStart)
        console.log "evaluation " + indentation() + "             methodInvocation: " + methodInvocation.print() + " cursor start: " + methodInvocation.cursorStart  + " original methodInvocation start: " + originalMethodInvocationStart

        console.log "methodInvocation.cursorStart - originalMethodInvocationStart: " + " " + methodInvocation.cursorStart  + " " + originalMethodInvocationStart
        theContext.unparsedMessage = null
        console.log "theContext method invocation after: " + methodInvocation.print()

        contextToBeReturned = @methodCall (@flClass.methodBodies[eachSignatureIndex]), newContext

        return [contextToBeReturned,methodInvocation]


    # we are still here trying to match but
    # there are no signatures left, time to quit.
    console.log "evaluation " + indentation() + "  matching - no match found"
    return [null, methodInvocationToBeChecked]


  # this could be native, in which case it's a JS call,
  # or non-native, in which case it will result into
  # evaluation of the message that makes up the body.
  methodCall: (methodBody, theContext, newSelf = @) ->
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
      console.log "evaluation " + indentation() + "  matching - method body: " + methodBody.print()
      console.log "evaluation " + indentation() + "  method body mandates receiver? " + methodBody.mandatesNewReceiver()
      # non-native method, i.e. further fizzylogo code
      # creates a context and evals the message in it
      # the rest of the message is not used because all of the list should
      # be run, no remains from the message body should overspill
      # into the calling context. 
      [contextToBeReturned] = methodBody.eval theContext, methodBody
      contextToBeReturned.findAnotherReceiver = methodBody.mandatesNewReceiver()
      console.log "evaluation " + indentation() + "  method body mandates receiver2 ? " + methodBody.mandatesNewReceiver()
    else
      console.log "evaluation " + indentation() + "  matching - NATIVE method body: " + methodBody
      # native method, i.e. coffeescript/javascript code
      theContext.returned = methodBody.call newSelf, theContext
      contextToBeReturned = theContext

    return contextToBeReturned


