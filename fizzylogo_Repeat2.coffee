class FLRepeat2Class extends FLClasses
  createNew: ->
    toBeReturned = super FLRepeat2

    toBeReturned.flToString = ->
      return "Repeat2_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLRepeat2 = new FLRepeat2Class()
