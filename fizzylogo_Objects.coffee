
class  FLObjects
  flClass: null # the class it belongs to
  instanceVariablesDict: null # a JS dictionary

  constructor: ->
    #console.log " instanceVariablesDict initiated "
    @instanceVariablesDict = {}

  findMessageAndBindParams: (theContext, methodInvocationToBeChecked) ->
        console.log "evaluation " + indentation() + "  !!! looking up method invocation " + methodInvocationToBeChecked.print() + " with signatures!" + " PC: " + theContext.programCounter
        console.log "evaluation " + indentation() + "  !!! looking up method invocation, is method empty? " + methodInvocationToBeChecked.isEmpty() + " PC: " + theContext.programCounter

        # as we check the matches of the invocation with the
        # signature, we might need to roll back the program
        # counter, which is what keeps tab of how much of the
        # message (in the context) we consume.
        # so let's remember the original value here
        originalProgramCounter = theContext.programCounter

        countSignaturePosition = -1
        console.log "evaluation " + indentation() + "  I am: " + @value
        console.log "evaluation " + indentation() + "  matching - my class patterns: "

        for eachClassPattern in @flClass.msgPatterns
          console.log "evaluation " + indentation() + eachClassPattern.print()


        for eachSignature in @flClass.msgPatterns
          #console.log "evaluation " + indentation() + "  matching - checking if this signature matches: " + eachSignature.print() + " PC: " + theContext.programCounter
          method = methodInvocationToBeChecked
          countSignaturePosition++

          # as we might have failed a match of a signature, we need to restore
          # the program counter so we keep the correct tab of how much
          # of the message (in the context) we consume.
          theContext.programCounter = originalProgramCounter

          #console.log "evaluation " + indentation() + "  matching - checking if signature matches this invocation " + method.print() + " PC: " + theContext.programCounter

          soFarEverythingMatched = true
          originalMethodStart = method.cursorStart
          until eachSignature.isEmpty() or method.isEmpty()

            console.log "evaluation " + indentation() + "  matching: - next signature piece: " + eachSignature.print() + " is atom: " + " with: " + method.print() + " PC: " + theContext.programCounter

            [eachElementOfSignature, eachSignature] = eachSignature.nextElement()

            
            # the element of a signature can only be of two kinds:
            # an atom or an RList containing one parameter (with
            # prepended "@" in case the parameter doesn't require
            # evaluation)
            if eachElementOfSignature.flClass == RAtom or eachElementOfSignature.flClass == RSymbol
              # if the signature contains an atom, the message
              # must contain the same atom, otherwise we don't
              # have a match.

              [eachElementOfInvocation, method] = method.nextElement()

              if eachElementOfInvocation.flClass == RAtom or eachElementOfInvocation.flClass == RSymbol

                #console.log "evaluation " + indentation() + "  matching atoms: - next signature piece: " + eachElementOfSignature.print() + " is atom: " + (eachElementOfSignature.flClass == RAtom) + " with: " + eachElementOfInvocation.print() + " PC: " + theContext.programCounter

                # ok at least the message contains an atom, but
                # now we have to check that they spell the same
                if eachElementOfSignature.value == eachElementOfInvocation.value
                  console.log "evaluation " + indentation() + "  matching - atom matched: " + eachElementOfSignature.print() + " PC: " + theContext.programCounter
                  # OK good match of atomsr,
                  # check the next token in the signature
                  continue
                else
                  # no match between the atoms, check next signature
                  soFarEverythingMatched = false
                  break
              else
                # the signature sais "atom" but the message contains
                # something else: no match, check the next
                # signature
                #console.log "evaluation " + indentation() + "  matching - no match: " + eachElementOfSignature.print() + " vs. " + eachElementOfInvocation.print() + " PC: " + theContext.programCounter
                # this signature doesn't match check the next one
                soFarEverythingMatched = false
                break
            else
              # the signature has a param. we have to check if
              # it requires an evaluation or not
              console.log "evaluation " + indentation() + "  matching - getting the atom inside the parameter: " + eachElementOfSignature.print() + " PC: " + theContext.programCounter
              paramAtom = eachElementOfSignature.getParamAtom()
              #console.dir paramAtom
              console.log "evaluation " + indentation() + "  matching - atom inside the parameter: " + paramAtom.print() + " PC: " + theContext.programCounter
              if eachElementOfSignature.isEvaluatingParam()
                console.log "evaluation " + indentation() + "  matching - need to evaluate next msg element from invocation: " + method.print() + " and bind to: " + paramAtom.print() + " PC: " + theContext.programCounter
                # if the first element is a list,
                # then the list is evaluated on
                # its own, without considering what comes after it.
                # I.e. a list doesn't chain with further tokens, it's
                # used as a parameter as is
                # If the first element is not a list, then we
                # run the evaluation as long as it takes us,
                # until things "chain" with messages they
                # understand.
                if method.firstElement().flClass == RList
                  [valueToBeBound, method] = method.evalFirstMessageElement theContext
                else
                  [valueToBeBound, method] = method.flEval theContext
              else
                console.log "evaluation " + indentation() + "  matching - need to get next msg element from invocation: " + method.print() + " and bind to: " + paramAtom.print() + " PC: " + theContext.programCounter
                [valueToBeBound, method] = method.nextElement()
              
              console.log "evaluation " + indentation() + "  matching - adding paramater " + paramAtom.print() + " to tempVariables into this class: "
              #console.dir theContext.self.flClass
              # TODO we should insert without repetition
              if !theContext.self.flClass.tempVariables?
                theContext.self.flClass.tempVariables = []
              theContext.self.flClass.tempVariables.push paramAtom
              theContext.tempVariablesDict[ValidID.fromString paramAtom.value] = valueToBeBound
              # ok we matched a paramenter, now let's keep matching further
              # parts of the signature
              continue

          # ok a the signature has matched completely
          if eachSignature.isEmpty() and soFarEverythingMatched

            # now, the correct PC that we need to report is
            # the original plus what we consumed from matching the
            # signature.
            console.log "evaluation " + indentation() + "  matching - consumed from matching this sig: " + (method.cursorStart - originalMethodStart)
            console.log "evaluation " + indentation() + "             method: " + method.print() + " cursor start: " + method.cursorStart  + " original method start: " + originalMethodStart

            console.log "originalProgramCounter + method.cursorStart - originalMethodStart: " + originalProgramCounter + " " + method.cursorStart  + " " + originalMethodStart
            console.log "theContext.programCounter BEFORE: " + theContext.programCounter
            theContext.programCounter = originalProgramCounter + method.cursorStart - originalMethodStart
            console.log "theContext.programCounter AFTER: " + theContext.programCounter

            #console.log "countSignaturePosition: " + countSignaturePosition
            return countSignaturePosition

        # we are still here trying to match but
        # there are no signatures left, time to quit.
        # fix the program counter first! Put it back
        # to what it was because we matched nothing from
        # the message we were sent.
        console.log "evaluation " + indentation() + "  matching - no match found" + " PC: " + theContext.programCounter
        theContext.programCounter = originalProgramCounter
        return null

  # this could be native or non-native
  messageSend: (methodBody, theContext, newSelf = @) ->
    # note that this doesn't change the program counter,
    # because we don't care here what we consume from the body
    # execution, from the caller perspective it only matters
    # what we consume from the invocation, which we accounted
    # for just above.
    # i.e. we just consume
    # while we matched the correct method, which we account for
    # when we do the matching, not here after the matching happened.
    
    if methodBody.flClass == RList
      console.log "evaluation " + indentation() + "  matching - method body: " + methodBody.print()
      # non-native method, i.e. further fizzylogo code
      # creates a context and evals the message in it
      # the rest of the message is not used because all of the list should
      # be run, no remains from the message body should overspill
      # into the calling context. 

      newContext = new  FLContext theContext, newSelf, methodBody
      flContexts.push newContext
      [ignored1, ignore2, contextToBeReturned] = methodBody.flEval newContext
      flContexts.pop()
      return contextToBeReturned

    else
      console.log "evaluation " + indentation() + "  matching - NATIVE method body: " + methodBody
      # native method, i.e. coffeescript/javascript code
      theContext.returned = methodBody.call newSelf, theContext
      #flContexts.pop()
    return theContext


  # Note that only part of the message might be consumed
  # also note that we are creating a new context, but
  # "self" remains the same since we are still in the
  # same "method call" and the same "object". I.e. this
  # is not a method call, this is progressing within
  # an existing call
  progressWithMessage: (message, theContext) ->
    newContext = new  FLContext theContext, theContext.self, message
    flContexts.push newContext
    toBeReturned = @evalMessage newContext
    console.log "evaluation " + indentation() + "  progressWithMessage - evalMessage returned: " + toBeReturned
    #console.dir toBeReturned
    flContexts.pop()
    theContext.programCounter += newContext.programCounter
    message = message.advanceMessageBy newContext.programCounter
    console.log "evaluation " + indentation() + "  progressWithMessage - returned: " + toBeReturned
    #console.dir toBeReturned
    return [toBeReturned, message]

  lookupAndSendFoundMessage: (theContext, countSignaturePosition) ->
    console.log "evaluation " + indentation() + "  matching - found a matching signature: " + @flClass.msgPatterns[countSignaturePosition].print() + " , PC: " + theContext.programCounter
    # we have a matching signature!
    methodBody = @flClass.methodBodies[countSignaturePosition]
    console.log "evaluation " + indentation() + "  matching - method body: " + methodBody


    # this could be a native or non-native message send
    theContext = @messageSend methodBody, theContext
    console.log "evaluation " + indentation() + "  returned from message send: " + theContext
    #console.dir theContext

    return theContext

  # You eval things just by sending them the empty message.
  # Note that if you invoke this on a list, the whole list is evaluated.
  flEval: (theContext) ->
    console.log "           " + indentation() + "evaling: " + @print()
    message = @
    [newContext, unusedRestOfMessage] = @progressWithMessage RList.emptyMessage(), theContext
    if @flClass == RList
      message = @advanceMessageBy newContext.programCounter
    return [newContext.returned, message, newContext]


class  FLPrimitiveObjects extends  FLObjects
