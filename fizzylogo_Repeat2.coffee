class FLRepeat2Class extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLRepeat2

    toBeReturned.print = ->
      return "Repeat2_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLRepeat2 = new FLRepeat2Class() # this is a class, an anonymous class
