class FLQuoteClass extends FLClasses

  createNew: ->
    toBeReturned = super FLQuote

    toBeReturned.print = ->
      return "Quote_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLQuote = new FLQuoteClass()
