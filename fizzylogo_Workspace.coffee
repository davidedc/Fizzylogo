class FLWorkspaceClass extends FLClasses
  createNew: ->
    toBeReturned = super FLWorkspace
    toBeReturned.value = "the workspace object"

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLWorkspace = new FLWorkspaceClass() # this is a class
