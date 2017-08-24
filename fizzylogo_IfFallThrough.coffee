# See IfThen class for explanation.

class FLIfFallThroughClass extends FLClasses
  createNew: ->
    toBeReturned = super FLIfFallThrough
    toBeReturned.value = null


    toBeReturned.flToString = ->
      return "IfFallThrough_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLIfFallThrough = new FLIfFallThroughClass()
