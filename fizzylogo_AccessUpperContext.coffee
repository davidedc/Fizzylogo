class FLAccessUpperContextClass extends FLPrimitiveClasses
  createNew: (tokenString) ->
    toBeReturned = super FLAccessUpperContext
    toBeReturned.value = tokenString

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext) ->
      console.log "evaling FLAccessUpperContextClass object"
      theContext.isTransparent = true
      return [theContext]

    return toBeReturned

FLAccessUpperContext = new FLAccessUpperContextClass()
