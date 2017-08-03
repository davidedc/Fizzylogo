class FLQuoteClass extends FLAnonymousClass

  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLQuote

    toBeReturned.print = ->
      return "Quote_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging Quote_object with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if message.isEmpty()
        theContext.returned = @

      else

        returnedContext = @findSignatureBindParamsAndMakeCall theContext, message
        console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

        if returnedContext?
          if returnedContext.returned?
            # "findSignatureBindParamsAndMakeCall" has already done the job of
            # making the call and fixing theContext's PC and
            # updating the return value, we are done here
            return returnedContext

        theContext.returned = @


      #if !message.isEmpty()
      #  console.log "evaluation " + indentation() + "this message to Quote_object should be empty? " + message.print()
      #flContexts.pop()
      return theContext

    return toBeReturned

FLQuote = new FLQuoteClass() # this is a class, an anonymous class

