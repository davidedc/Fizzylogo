class FLBooleanPrimitiveClass extends FLPrimitiveClasses
  createNew: (value) ->
    toBeReturned = super FLBoolean
    toBeReturned.value = value


    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLBoolean = new FLBooleanPrimitiveClass()
