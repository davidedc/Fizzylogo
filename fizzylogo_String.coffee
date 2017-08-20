class FLStringClass extends FLClasses

  createNew: (value) ->
    toBeReturned = super FLString
    toBeReturned.value = value + ""

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = ->
      return '"' + @value + '"'

    return toBeReturned
    

FLString = new FLStringClass()
