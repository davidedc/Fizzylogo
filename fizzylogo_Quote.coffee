class FLQuoteClass extends FLAnonymousClass

  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLQuote

    toBeReturned.print = ->
      return "Quote_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLQuote = new FLQuoteClass() # this is a class, an anonymous class

