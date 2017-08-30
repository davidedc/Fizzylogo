class FLBreakClass extends FLClasses
  createNew: ->
    toBeReturned = super FLBreak
    toBeReturned.value = null

    toBeReturned.flToString = ->
      return "Break_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLBreak = new FLBreakClass()
