class FLDoneClass extends FLClasses
  createNew: ->
    toBeReturned = super FLDone
    toBeReturned.value = null

    


    return toBeReturned

FLDone = new FLDoneClass()
