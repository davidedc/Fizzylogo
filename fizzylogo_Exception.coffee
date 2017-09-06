class FLExceptionClass extends FLClasses
  # value is the error message as a string
  createNew: (value) ->
    toBeReturned = super FLException
    toBeReturned.value = value

    toBeReturned.flToString = ->
      return @value    

    return toBeReturned
    

FLException = new FLExceptionClass()
