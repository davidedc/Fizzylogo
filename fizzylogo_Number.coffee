class FLNumberPrimitiveClass extends FLPrimitiveClasses

  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = parseFloat(value + "")
    toBeReturned.flClass = FLNumber

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLNumber = new FLNumberPrimitiveClass()
FLNumber.flClass = FLNumber
