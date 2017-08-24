class FLReturnClass extends FLClasses
  createNew: ->
    toBeReturned = super FLReturn
    toBeReturned.value = null

    toBeReturned.flToString = ->
      return "Return_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    toBeReturned.flToString = ->
      return "Done_object"

    return toBeReturned

FLReturn = new FLReturnClass()
