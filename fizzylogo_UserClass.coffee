
class FLNonPrimitiveClass extends FLClasses
  createNew: ->
    toBeReturned = new FLClasses()
    toBeReturned.value = "some_custom_class_of_user"

    toBeReturned.flClass = toBeReturned

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

    toBeReturned.createNew = ->
      objectTBR = new FLPrimitiveObjects()
      objectTBR.value = "object_from_a_user_class"
      objectTBR.flClass = toBeReturned

      return objectTBR


    return toBeReturned

FLUserClass = new FLNonPrimitiveClass()
FLUserClass.flClass = FLUserClass

