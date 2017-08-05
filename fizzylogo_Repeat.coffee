class FLRepeatClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLRepeat


    toBeReturned.print = ->
      return "Repeat_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLRepeat = new FLRepeatClass() # this is a class, an anonymous class
FLRepeat.flClass = FLRepeat
