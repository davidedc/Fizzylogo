class FLTryClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLTry

    toBeReturned.print = ->
      return "Try_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLTry = new FLTryClass() # this is a class, an anonymous class
