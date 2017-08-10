class FLTryClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLTry

    toBeReturned.print = ->
      return "Try_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLTry = new FLTryClass() # this is a class, an anonymous class
