class FLInClass extends FLClasses
  createNew: ->
    toBeReturned = super FLIn

    toBeReturned.flToString = ->
      return "In_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLIn = new FLInClass()
