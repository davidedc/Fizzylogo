class FLNotClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLNot


    toBeReturned.print = ->
      return "Not_object"

    toBeReturned.printForList = toBeReturned.print

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLNot = new FLNotClass() # this is a class, an anonymous class
FLNot.flClass = FLNot

# --------------------------------------------------------------------------------

class FLDoneClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLDone
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
FLDone.flClass = FLDone

# --------------------------------------------------------------------------------

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
