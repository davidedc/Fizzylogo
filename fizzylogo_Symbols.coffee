class FLQuoteClass extends FLAnonymousClass

  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLQuote
    toBeReturned.value = "@"

    toBeReturned.print = ->
      return "Not_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLQuote = new FLQuoteClass() # this is a class, an anonymous class

