class FLInClass extends FLClasses
  createNew: ->
    toBeReturned = super FLIn
    toBeReturned.value = "in"
    return toBeReturned

FLIn = new FLInClass()
