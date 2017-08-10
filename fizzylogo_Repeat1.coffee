class FLRepeat1Class extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLRepeat1

    toBeReturned.print = ->
      return "Repeat1_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLRepeat1 = new FLRepeat1Class() # this is a class, an anonymous class
