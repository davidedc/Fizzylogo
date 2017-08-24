class FLThrowClass extends FLClasses
  createNew: ->
    toBeReturned = super FLThrow

    toBeReturned.flToString = ->
      return "Throw_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLThrow = new FLThrowClass()
