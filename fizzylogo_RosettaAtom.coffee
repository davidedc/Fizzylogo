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

      else if message.firstElement().value == "<-"
        console.log "evaluation " + indentation() + "assignment to atom " + theAtomName

        # skip the <- symbol
        message = message.skipNextMessageElement theContext

        # now evaluate the rest of the list
        # now we are using the message as a list because we have to evaluate it.
        # to evaluate it, we treat it as a list and we send it the empty message
        [theValue, unusedRestOfMessage] = message.rosettaEval theContext
        theContext.returned = theValue

        console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + theValue.value

        dictToPutAtomIn = theContext.lookUpAtomValuePlace @
        dictToPutAtomIn[theAtomName] = theValue

        console.log "evaluation " + indentation() + "stored value in dictionary"



    return toBeReturned

RAtom = new RosettaAtomClass() # ...



