class FLConsoleClass extends FLClasses

  createNew: ->
    toBeReturned = super FLConsole
    toBeReturned.value = "Console"

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
    

FLConsole = new FLConsoleClass()
