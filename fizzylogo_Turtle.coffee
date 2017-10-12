class FLTurtleClass extends FLClasses

  createNew: ->
    toBeReturned = super FLTurtle

    toBeReturned.penDown = true
    toBeReturned.direction = 0
    toBeReturned.x = 0
    toBeReturned.y = 0

    toBeReturned.sendHome = ->
      if canvasOutputElement?
      	@x = canvasOutputElement.width/2
      	@y = canvasOutputElement.height/2
      @direction = 0


    return toBeReturned

FLTurtle = new FLTurtleClass()
