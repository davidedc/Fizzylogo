class FLRepeat2Class extends FLClasses
  createNew: ->
    toBeReturned = super FLRepeat2

    toBeReturned.print = ->
      return "Repeat2_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLRepeat2 = new FLRepeat2Class()
