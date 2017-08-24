class FLNumberClass extends FLClasses

  createNew: (value) ->
    toBeReturned = super FLNumber
    toBeReturned.value = parseFloat(value + "")

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned
    

FLNumber = new FLNumberClass()
