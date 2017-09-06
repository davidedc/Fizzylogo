class FLReturnClass extends FLClasses
  createNew: ->
    toBeReturned = super FLReturn
    toBeReturned.value = null

    return toBeReturned

FLReturn = new FLReturnClass()
