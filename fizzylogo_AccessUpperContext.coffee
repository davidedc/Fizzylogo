class FLAccessUpperContextClass extends FLClasses
  createNew: (tokenString) ->
    toBeReturned = super FLAccessUpperContext
    toBeReturned.value = tokenString

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLAccessUpperContext = new FLAccessUpperContextClass()
