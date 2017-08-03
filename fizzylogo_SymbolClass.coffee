# symbols don't have a value and fon't get sent any messages,
# they are just special markers.
# we just have them to be part of the anonymous class.

class FLSymbolClass extends FLAnonymousClass
  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLSymbol

    toBeReturned.print = ->
      return @value

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLSymbol = new FLSymbolClass() # this is a class, an anonymous class
RStatementSeparatorSymbol = FLSymbol.createNew "."


