class FLNotClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLNot

    toBeReturned.print = ->
      return "Not_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLNot = new FLNotClass() # this is a class, an anonymous class
