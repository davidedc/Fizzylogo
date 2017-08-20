# See IfThen class for explanation.

class FLIfFallThroughClass extends FLClasses
  createNew: ->
    toBeReturned = super FLIfFallThrough
    toBeReturned.value = null


    toBeReturned.print = ->
      return "IfFallThrough_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLIfFallThrough = new FLIfFallThroughClass()
