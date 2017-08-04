class FLWorkspaceClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLWorkspace

    toBeReturned.eval = (theContext) ->
      message = theContext.message
      messageLength = message.length()
      console.log "evaluation " + indentation() + "messaging workspace with " + message.print()

      # now we are using the message as a list because we have to evaluate it.
      # to evaluate it, we treat it as a list and we send it the empty message
      # note that "self" will remain the current one, since anything that
      # is in here will still refer to "self" as the current self in the
      # overall message.
      
      returnedContext = message.eval theContext
      toBeReturned = returnedContext.returned
      theContext.returned = toBeReturned

      console.log "evaluation " + indentation() + "end of workspace evaluation"

      if returnedContext.unparsedMessage
        console.log "evaluation " + indentation() + "something was not understood: " + returnedContext.unparsedMessage.print()
        environmentErrors += "! something was not understood: " + returnedContext.unparsedMessage.print()


    return toBeReturned

FLWorkspace = new FLWorkspaceClass() # this is a class
FLWorkspace.flClass = FLWorkspace
