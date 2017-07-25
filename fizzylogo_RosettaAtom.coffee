class RosettaAtomClass extends RosettaPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = theAtomName
    toBeReturned.rosettaClass = RAtom

    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging atom " + theAtomName + " with " + message.print()

      if message.isEmpty()
        theContext.returned = theContext.lookUpAtomValue @
        console.log "evaluation " + indentation() + "atom " + theAtomName + " contents: " + theContext.returned.value

      else
        anyMatch = @findMessageAndBindParams theContext, message
        if anyMatch?
          returned = @lookupAndSendFoundMessage theContext, anyMatch
        console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

        if returned?
          # "findMessageAndBindParams" has already done the job of
          # making the call and fixing theContext's PC and
          # updating the return value, we are done here
          return

        theContext.returned = @




    return toBeReturned

RAtom = new RosettaAtomClass()





