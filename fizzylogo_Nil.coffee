class FLNilClass extends FLClasses

  createNew: ->
    toBeReturned = super FLNil
    toBeReturned.value = "nil"

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLNil = new FLNilClass()
