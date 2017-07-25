# there is nothing special what all symbols do,
# so we just have them to be part of the anonymous class
# Literals are things that don't have value, just
# some sort of role.

RLiteralSymbol = RSymbol.createNew "@"
# the signature is: @ (@x), so this consumes only one token
# example: @x returns the Atom X
RLiteralSymbol.evalMessage = (theContext) ->
    message = theContext.message
    console.log "evaluation " + indentation() + "messaging literal symbol with " + message.print()

    if message.isEmpty()
      theContext.returned = @
    else
      theContext.returned = message.firstElement()
      message = message.skipNextMessageElement theContext

    console.log "evaluation " + indentation() + "literal symbol evaluation returning " + theContext.returned.value

    rosettaContexts.pop()


RNewSymbol = RSymbol.createNew "new"
RAssignmentSymbol = RSymbol.createNew "<-"
RStatementSeparatorSymbol = RSymbol.createNew "."



