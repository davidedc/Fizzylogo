class FLNotClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.flClass = FLNot


    toBeReturned.print = ->
      return "Not_object"

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

    toBeReturned.isEvaluatingParam = ->
      return false

    toBeReturned.getParamAtom = ->
      return @

    return toBeReturned

FLDone = new FLDoneClass() # this is a class, an anonymous class
FLDone.flClass = FLDone
