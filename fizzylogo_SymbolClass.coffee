class  FLSymbolClass extends  FLAnonymousClass
  createNew: (value) ->
    toBeReturned = new  FLPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.flClass = FLSymbol

    toBeReturned.print = ->
      return @value

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLSymbol = new  FLSymbolClass() # this is a class, an anonymous class


