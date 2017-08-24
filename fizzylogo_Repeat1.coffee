class FLRepeat1Class extends FLClasses
  createNew: ->
    toBeReturned = super FLRepeat1

    toBeReturned.flToString = ->
      return "Repeat1_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLRepeat1 = new FLRepeat1Class()
