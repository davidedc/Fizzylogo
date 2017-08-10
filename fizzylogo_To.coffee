class FLToClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLTo
    toBeReturned.value = null


    toBeReturned.print = ->
      return "To_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLTo = new FLToClass() # this is a class, an anonymous class
