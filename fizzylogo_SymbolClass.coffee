# symbols don't have a value and fon't get sent any messages,
# they are just special markers.
# we just have them to be part of the anonymous class.

class FLSymbolClass extends FLAnonymousClass
  createNew: (value) ->
    toBeReturned = super FLSymbol
    toBeReturned.value = value

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLSymbol = new FLSymbolClass() # this is a class, an anonymous class

RStatementSeparatorSymbol = FLSymbol.createNew "."
