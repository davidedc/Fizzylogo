class FLExceptionClass extends FLClasses
  createNew: (value) ->
    toBeReturned = super FLException
    toBeReturned.value = value

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned
    

FLException = new FLExceptionClass()
