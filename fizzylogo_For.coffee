class FLForClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLFor


    toBeReturned.print = ->
      return "For_object"

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLFor = new FLForClass() # this is a class, an anonymous class
FLFor.flClass = FLFor
