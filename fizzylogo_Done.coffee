class FLDoneClass extends FLClasses
  createNew: ->
    toBeReturned = super FLDone
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Done_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.eval = (theContext) ->
      console.log "evaling Done object"
      theContext.throwing = true
      theContext.returned = @
      return [theContext]

    return toBeReturned

FLDone = new FLDoneClass()
