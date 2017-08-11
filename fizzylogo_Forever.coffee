class FLForeverClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLForever
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Forever_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLForever = new FLForeverClass() # this is a class, an anonymous class
