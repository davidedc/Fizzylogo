class FLThrowClass extends FLClasses
  createNew: ->
    toBeReturned = super FLThrow

    toBeReturned.print = ->
      return "Throw_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLThrow = new FLThrowClass()
