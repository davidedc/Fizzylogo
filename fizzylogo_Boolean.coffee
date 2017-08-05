class FLBooleanPrimitiveClass extends FLPrimitiveClasses
  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.flClass = FLBoolean


    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLBoolean = new FLBooleanPrimitiveClass()
FLBoolean.flClass = FLBoolean
