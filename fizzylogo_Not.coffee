class FLNotClass extends FLClasses
  createNew: ->
    toBeReturned = super FLNot

    toBeReturned.print = ->
      return "Not_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLNot = new FLNotClass()
