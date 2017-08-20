class FLToClass extends FLClasses
  createNew: ->
    toBeReturned = super FLTo
    toBeReturned.value = null


    toBeReturned.print = ->
      return "To_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLTo = new FLToClass()
