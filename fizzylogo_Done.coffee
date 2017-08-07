class FLDoneClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = FLDone
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Done_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLDone = new FLDoneClass() # this is a class, an anonymous class
