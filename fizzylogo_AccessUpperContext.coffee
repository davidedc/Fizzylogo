class FLAccessUpperContextClass extends FLPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = super FLAccessUpperContext
    toBeReturned.value = theAtomName

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext) ->
      console.log "evaling FLAccessUpperContextClass object"
      theContext.isTransparent = true
      return [theContext]

    return toBeReturned

FLAccessUpperContext = new FLAccessUpperContextClass()
