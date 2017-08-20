class FLForeverClass extends FLClasses
  createNew: ->
    toBeReturned = super FLForever
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Forever_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLForever = new FLForeverClass()
