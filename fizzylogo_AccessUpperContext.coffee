class FLAccessUpperContextClass extends FLClasses
  createNew: (tokenString) ->
    toBeReturned = super FLAccessUpperContext
    toBeReturned.value = tokenString

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLAccessUpperContext = new FLAccessUpperContextClass()
