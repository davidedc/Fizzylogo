class FLInClass extends FLClasses
  createNew: ->
    toBeReturned = super FLIn

    toBeReturned.print = ->
      return "In_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLIn = new FLInClass()
