class FLTryClass extends FLClasses
  createNew: ->
    toBeReturned = super FLTry

    toBeReturned.flToString = ->
      return "Try_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLTry = new FLTryClass()
