class FLForeverClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLForever
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Done_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext) ->
      console.log "evaling Done object"
      @beingThrown = true
      theContext.returned = @
      return [theContext]

    return toBeReturned

FLForever = new FLForeverClass() # this is a class, an anonymous class
