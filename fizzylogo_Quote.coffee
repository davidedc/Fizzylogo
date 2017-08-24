class FLQuoteClass extends FLClasses

  createNew: ->
    toBeReturned = super FLQuote

    toBeReturned.flToString = ->
      return "Quote_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLQuote = new FLQuoteClass()
