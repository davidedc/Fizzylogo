# there is nothing special what all symbols do,
# so we just have them to be part of the anonymous class
# Literals are things that don't have value, just
# some sort of role.

RLiteralSymbol = FLSymbol.createNew "@"
# the signature is: @ (@x), so this consumes only one token
# example: @x returns the Atom X
RLiteralSymbol.evalMessage = (theContext) ->
    message = theContext.message
    console.log "evaluation " + indentation() + "messaging literal symbol with " + message.print()

    if message.isEmpty()
      theContext.returned = @
    else
      returnedContext = @findMessageAndBindParams theContext, message
      console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

      if returnedContext?
        if returnedContext.returned?
          # "findMessageAndBindParams" has already done the job of
          # making the call and fixing theContext's PC and
          # updating the return value, we are done here
          return returnedContext

      theContext.returned = @

    console.log "evaluation " + indentation() + "literal symbol evaluation returned " + theContext
    #console.dir theContext

    flContexts.pop()


RStatementSeparatorSymbol = FLSymbol.createNew "."
