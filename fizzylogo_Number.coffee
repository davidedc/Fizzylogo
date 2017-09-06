class FLNumberClass extends FLClasses

  createNew: (value) ->
    toBeReturned = super FLNumber
    toBeReturned.value = parseFloat(value + "")

    toBeReturned.flToString = ->
      return @value

    return toBeReturned
    

FLNumber = new FLNumberClass()
