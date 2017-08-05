class FLNilPrimitiveClass extends FLPrimitiveClasses

  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = "nil"
    toBeReturned.flClass = FLNil

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLNil = new FLNilPrimitiveClass()
FLNil.flClass = FLNil
