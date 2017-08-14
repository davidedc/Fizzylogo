class FLInClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLIn

    toBeReturned.print = ->
      return "In_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLIn = new FLInClass() # this is a class, an anonymous class
