class FLForClass extends FLClasses
  createNew: ->
    toBeReturned = super FLFor

    toBeReturned.print = ->
      return "For_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLFor = new FLForClass()
