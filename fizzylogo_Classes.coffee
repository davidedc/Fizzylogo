
class FLClasses extends FLObjects
  name: null #a FLString
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  classVariables: null # a FLList
  instanceVariables: null # a FLList
  tempVariables: null # a FLList

  classVariablesDict: null # a JS dictionary

  constructor: ->
    super @
    @classVariablesDict = {}
    @msgPatterns = []
    @methodBodies = []


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class FLPrimitiveClasses extends FLClasses
  createNew: (theClass) ->
    return new FLPrimitiveObjects theClass

class FLNonPrimitiveClasses extends FLClasses
  createNew: ->
    return new FLNonPrimitiveObjects()


# the root of everything. An object of class
# "Class" (or, more in detail, of FLClassPrimitiveClass)
class FLClassPrimitiveClass extends FLPrimitiveClasses

  # this is invoked only once at start, to
  # create the object Class, which allows you
  # to create new classes. This is not
  # invoked when the user creates a new class, for
  # that FLUserClass.createNew() is used.
  createNew: ->
    toBeReturned = super FLClass
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    return toBeReturned
    

FLClass = new FLClassPrimitiveClass FLClass

class FLAnonymousClass extends FLPrimitiveClasses

