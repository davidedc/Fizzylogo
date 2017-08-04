
class FLNonPrimitiveClass extends FLClasses
  createNew: ->
    toBeReturned = new FLClasses()
    toBeReturned.value = "some_custom_class_of_user"

    toBeReturned.flClass = toBeReturned
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    toBeReturned.createNew = ->
      objectTBR = new FLPrimitiveObjects()
      objectTBR.value = "object_from_a_user_class"
      objectTBR.flClass = toBeReturned

      return objectTBR


    return toBeReturned

FLUserClass = new FLNonPrimitiveClass()
FLUserClass.flClass = FLUserClass

