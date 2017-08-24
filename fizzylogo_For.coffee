class FLForClass extends FLClasses
  createNew: ->
    toBeReturned = super FLFor

    toBeReturned.flToString = ->
      return "For_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLFor = new FLForClass()
