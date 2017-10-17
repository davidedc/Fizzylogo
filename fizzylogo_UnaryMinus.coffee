class FLUnaryMinusClass extends FLClasses
  createNew: ->
    toBeReturned = super FLUnaryMinus
    toBeReturned.value = "-"
    return toBeReturned

FLUnaryMinus = new FLUnaryMinusClass()
