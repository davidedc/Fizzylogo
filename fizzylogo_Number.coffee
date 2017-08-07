class FLNumberPrimitiveClass extends FLPrimitiveClasses

  createNew: (value) ->
    toBeReturned = super FLNumber
    toBeReturned.value = parseFloat(value + "")

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLNumber = new FLNumberPrimitiveClass()
