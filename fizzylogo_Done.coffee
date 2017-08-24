class FLDoneClass extends FLClasses
  createNew: ->
    toBeReturned = super FLDone
    toBeReturned.value = null

    toBeReturned.flToString = ->
      return "Done_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    toBeReturned.flToString = ->
      return "Done_object"

    return toBeReturned

FLDone = new FLDoneClass()
