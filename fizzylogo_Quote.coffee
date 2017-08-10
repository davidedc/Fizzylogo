class FLQuoteClass extends FLAnonymousClass

  createNew: ->
    toBeReturned = super FLQuote

    toBeReturned.print = ->
      return "Quote_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLQuote = new FLQuoteClass() # this is a class, an anonymous class
