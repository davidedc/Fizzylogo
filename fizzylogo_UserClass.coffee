class FLNonPrimitiveClass extends FLClasses
  
  # this gets invoked when user does Class new
  # that's going to create an object that represents a new
  # user-defined Class.
  createNew: ->
    toBeReturned = new FLNonPrimitiveClasses()
    toBeReturned.value = "some_custom_class_of_user"

    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []

    toBeReturned.instanceVariables = FLList.emptyList()
    toBeReturned.classVariables = FLList.emptyList()
    toBeReturned.tempVariables = FLList.emptyList()

    # the temp variables contents
    # are in the context, not here in the class
    # similarly, the instance variables contents
    # are in the object, not here in the class
    toBeReturned.classVariablesDict = {}

    # this is going to give to the new user-defined class
    # the capacity to create objects.
    toBeReturned.createNew = ->
      objectTBR = new FLNonPrimitiveObjects toBeReturned
      objectTBR.value = "object_from_a_user_class"

      return objectTBR


    return toBeReturned

FLUserClass = new FLNonPrimitiveClass()

