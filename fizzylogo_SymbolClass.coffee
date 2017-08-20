# symbols don't have a value and fon't get sent any messages,
# they are just special markers.

class FLSymbolClass extends FLClasses
  createNew: (value) ->
    toBeReturned = super FLSymbol
    toBeReturned.value = value

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLSymbol = new FLSymbolClass()

RStatementSeparatorSymbol = FLSymbol.createNew ";"
