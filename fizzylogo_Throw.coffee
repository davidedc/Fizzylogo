class FLThrowClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLThrow

    toBeReturned.print = ->
      return "Throw_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLThrow = new FLThrowClass() # this is a class, an anonymous class
