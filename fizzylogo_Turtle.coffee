class FLTurtleClass extends FLClasses

  createNew: ->
    toBeReturned = super FLTurtle

    toBeReturned.penDown = true
    toBeReturned.direction = 0
    toBeReturned.x = 0
    toBeReturned.y = 0

    return toBeReturned

FLTurtle = new FLTurtleClass()
