class FLExceptionPrimitiveClass extends FLPrimitiveClasses
  createNew: (value) ->
    toBeReturned = super FLException
    toBeReturned.value = value

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLException = new FLExceptionPrimitiveClass()
