class FLBooleanClass extends FLClasses
  createNew: (value) ->
    toBeReturned = super FLBoolean
    toBeReturned.value = value

    toBeReturned.flToString = ->
      return @value

    return toBeReturned
    

FLBoolean = new FLBooleanClass()
