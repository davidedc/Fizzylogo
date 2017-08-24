class FLNotClass extends FLClasses
  createNew: ->
    toBeReturned = super FLNot

    toBeReturned.flToString = ->
      return "Not_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLNot = new FLNotClass()
