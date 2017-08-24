class FLNilClass extends FLClasses

  createNew: ->
    toBeReturned = super FLNil
    toBeReturned.value = "nil"

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned
    

FLNil = new FLNilClass()
