class FLQuoteClass extends FLAnonymousClass

  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLQuote

    toBeReturned.print = ->
      return "Quote_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLQuote = new FLQuoteClass() # this is a class, an anonymous class
FLQuote.flClass = FLQuote
