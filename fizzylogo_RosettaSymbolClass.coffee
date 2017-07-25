class RosettaSymbolClass extends RosettaAnonymousClass
  createNew: (value) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.rosettaClass = RSymbol

    toBeReturned.print = ->
      return @value

    return toBeReturned

RSymbol = new RosettaSymbolClass() # this is a class, an anonymous class


