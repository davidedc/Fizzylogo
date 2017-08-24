class FLToClass extends FLClasses
  createNew: ->
    toBeReturned = super FLTo
    toBeReturned.value = null


    toBeReturned.flToString = ->
      return "To_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLTo = new FLToClass()
