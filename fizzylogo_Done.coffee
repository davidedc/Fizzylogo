class FLDoneClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLDone
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

FLDone = new FLDoneClass() # this is a class, an anonymous class
