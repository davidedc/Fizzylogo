class RosettaWorkspaceClass extends RosettaAnonymousClass
  createNew: ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.rosettaClass = RWorkspace

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging workspace with " + message.print()

      # now we are using the message as a list because we have to evaluate it.
      # to evaluate it, we treat it as a list and we send it the empty message
      # note that "self" will remain the current one, since anything that
      # is in here will still refer to "self" as the current self in the
      # overall message.
      [theValue, unusedRestOfMessage] = message.rosettaEval theContext
      theContext.returned = theValue

      console.log "evaluation " + indentation() + "end of workspace evaluation"

    return toBeReturned



RWorkspace = new RosettaWorkspaceClass() # this is a class
