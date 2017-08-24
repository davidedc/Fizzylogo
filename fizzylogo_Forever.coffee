class FLForeverClass extends FLClasses
  createNew: ->
    toBeReturned = super FLForever
    toBeReturned.value = null


    toBeReturned.flToString = ->
      return "Forever_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLForever = new FLForeverClass()
