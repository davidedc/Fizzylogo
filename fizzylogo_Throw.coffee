class FLThrowClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLThrow

    toBeReturned.print = ->
      return "Throw_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLThrow = new FLThrowClass() # this is a class, an anonymous class
