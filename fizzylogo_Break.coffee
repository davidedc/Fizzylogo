class FLBreakClass extends FLClasses
  createNew: ->
    toBeReturned = super FLBreak
    toBeReturned.value = null

    toBeReturned.flToString = ->
      return "Done_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    toBeReturned.flToString = ->
      return "Break_object"

    return toBeReturned

FLBreak = new FLBreakClass()
