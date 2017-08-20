class FLTryClass extends FLClasses
  createNew: ->
    toBeReturned = super FLTry

    toBeReturned.print = ->
      return "Try_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLTry = new FLTryClass()
