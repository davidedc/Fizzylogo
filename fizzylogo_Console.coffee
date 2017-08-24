class FLConsoleClass extends FLClasses

  createNew: ->
    toBeReturned = super FLConsole
    toBeReturned.value = "Console"

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned
    

FLConsole = new FLConsoleClass()
