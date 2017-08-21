class FLDoneClass extends FLClasses
  createNew: ->
    toBeReturned = super FLDone
    toBeReturned.value = null

    toBeReturned.print = ->
      return "Done_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLDone = new FLDoneClass()
