class FLBooleanClass extends FLClasses
  createNew: (value) ->
    toBeReturned = super FLBoolean
    toBeReturned.value = value

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned
    

FLBoolean = new FLBooleanClass()
