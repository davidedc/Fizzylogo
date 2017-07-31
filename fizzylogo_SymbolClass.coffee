class  FLSymbolClass extends  FLAnonymousClass
  createNew: (value) ->
    toBeReturned = new  FLPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.flClass = RSymbol

    toBeReturned.print = ->
      return @value

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

RSymbol = new  FLSymbolClass() # this is a class, an anonymous class


