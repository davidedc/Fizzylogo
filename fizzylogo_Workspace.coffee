class FLWorkspaceClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLWorkspace
    toBeReturned.value = "the workspace object"

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLWorkspace = new FLWorkspaceClass() # this is a class
