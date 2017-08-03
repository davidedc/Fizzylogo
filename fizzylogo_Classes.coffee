
class FLClasses extends FLObjects
  name: null #a FLString
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  classVariables: null # a FLList
  instanceVariables: null # a FLList
  tempVariables: null # a FLList

  classVariablesDict: null # a JS dictionary

  constructor: ->
    super
    @classVariablesDict = {}
    @msgPatterns = []
    @methodBodies = []


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class FLPrimitiveClasses extends FLClasses


# the root of everything. An object of class
# "Class" (or, more in detail, of FLClassPrimitiveClass)
class FLClassPrimitiveClass extends FLPrimitiveClasses

  createNew: ->
    toBeReturned = new FLPrimitiveClasses()
    toBeReturned.flClass = FLClass
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    return toBeReturned
    

FLClass = new FLClassPrimitiveClass()


class FLAnonymousClass extends FLPrimitiveClasses

