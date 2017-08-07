class FLStringPrimitiveClass extends FLPrimitiveClasses

  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = value + ""
    toBeReturned.flClass = FLString

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = ->
      return '"' + @value + '"'

    return toBeReturned
    

FLString = new FLStringPrimitiveClass()
FLString.flClass = FLString
