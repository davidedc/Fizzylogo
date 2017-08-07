class FLNilPrimitiveClass extends FLPrimitiveClasses

  createNew: ->
    toBeReturned = super FLNil
    toBeReturned.value = "nil"

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLNil = new FLNilPrimitiveClass()
