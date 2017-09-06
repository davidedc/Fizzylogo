class FLNilClass extends FLClasses

  createNew: ->
    toBeReturned = super FLNil

    toBeReturned.flToString = ->
      return "nil"

    return toBeReturned
    

FLNil = new FLNilClass()
