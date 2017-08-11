# See IfThen class for explanation.

class FLIfFallThroughClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLIfFallThrough
    toBeReturned.value = null


    toBeReturned.print = ->
      return "IfFallThrough_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLIfFallThrough = new FLIfFallThroughClass() # this is a class, an anonymous class
