class FLStringClass extends FLClasses

  createNew: (value) ->
    toBeReturned = super FLString
    toBeReturned.value = value + ""

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = ->
      return '"' + @value + '"'

    return toBeReturned
    

FLString = new FLStringClass()
