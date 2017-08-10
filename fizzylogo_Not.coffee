class FLNotClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLNot

    toBeReturned.print = ->
      return "Not_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLNot = new FLNotClass() # this is a class, an anonymous class
