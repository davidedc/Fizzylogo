class FLPauseClass extends FLClasses
  createNew: ->
    toBeReturned = super FLPause
    toBeReturned.value = null


    return toBeReturned

FLPause = new FLPauseClass()
