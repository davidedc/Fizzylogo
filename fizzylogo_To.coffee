class FLToClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLTo
    toBeReturned.value = null


    toBeReturned.print = ->
      return "To_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLTo = new FLToClass() # this is a class, an anonymous class
FLTo.flClass = FLTo
