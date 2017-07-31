class  FLNotClass extends  FLAnonymousClass
  createNew: ->
    toBeReturned = new  FLPrimitiveObjects()
    toBeReturned.flClass = FLNot


    toBeReturned.print = ->
      return "Not_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging Not_object with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter
      anyMatch = @findMessageAndBindParams theContext, message
      if anyMatch?
        returned = @lookupAndSendFoundMessage theContext, anyMatch
        console.log "evaluation " + indentation() + "returned from message send: " + returned
        #console.dir returned
      console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if returned?
        # "findMessageAndBindParams" has already done the job of
        # making the call and fixing theContext's PC and
        # updating the return value, we are done here
        return returned


      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to Not_object should be empty? " + message.print()
      theContext.returned = @
      flContexts.pop()

    return toBeReturned

FLNot = new  FLNotClass() # this is a class, an anonymous class

# --------------------------------------------------------------------------------

class  FLDoneClass extends  FLAnonymousClass
  createNew: ->
    toBeReturned = new  FLPrimitiveObjects()
    toBeReturned.flClass = FLDone
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Done_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging Done_object with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter
      anyMatch = @findMessageAndBindParams theContext, message
      if anyMatch?
        returned = @lookupAndSendFoundMessage theContext, anyMatch
        console.log "evaluation " + indentation() + "returned from message send: " + returned
        #console.dir returned
      console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if returned?
        # "findMessageAndBindParams" has already done the job of
        # making the call and fixing theContext's PC and
        # updating the return value, we are done here
        return returned


      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to Done_object should be empty? " + message.print()
        return theContext


      theContext.returned = @
      flContexts.pop()
      return theContext

    return toBeReturned

FLDone = new  FLDoneClass() # this is a class, an anonymous class

