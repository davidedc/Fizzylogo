class FLIfThenElseClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLIfThenElse
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

FLIfThenElse = new FLIfThenElseClass() # this is a class, an anonymous class
