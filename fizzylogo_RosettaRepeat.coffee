class RosettaRepeatClass extends RosettaAnonymousClass
  createNew: ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.rosettaClass = RRepeat


    toBeReturned.print = ->
      return "Repeat_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging Repeat_object with " + message.print()

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
        console.log "evaluation " + indentation() + "repeat is returning: " + returned
        console.dir returned
        return returned

      theContext.returned = @
      rosettaContexts.pop()

    return toBeReturned

RRepeat = new RosettaRepeatClass() # this is a class, an anonymous class

