class FLClasses extends FLObjects
  name: null #a FLString
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  classVariables: null # a FLList
  instanceVariables: null # a FLList
  tempVariables: null # a FLList

  classVariablesDict: null # a JS dictionary

  addMethod: (signature, methodBody) ->
    for i in [0...@msgPatterns.length]
      eachSignature = @msgPatterns[i]
      console.dir eachSignature
      if eachSignature.print() == signature.print()
        @msgPatterns[i] = signature
        @methodBodies[i] = methodBody
        return

    @msgPatterns.jsArrayPush signature
    @methodBodies.jsArrayPush methodBody

  constructor: ->
    super @

    @msgPatterns = []
    @methodBodies = []

    # the temp variables contents
    # are in the context, not here in the class
    # similarly, the instance variables contents
    # are in the object, not here in the class
    @classVariablesDict = {}
    allClasses.push @


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class FLPrimitiveClasses extends FLClasses
  createNew: (theClass) ->
    return new FLPrimitiveObjects theClass

class FLNonPrimitiveClasses extends FLClasses
  createNew: ->
    return new FLNonPrimitiveObjects()


# class "Class". We'll create exactyly one object for
# this class, which is going to be also called "Class".
# such object will allow users to create their classes.
class FLClassPrimitiveClass extends FLPrimitiveClasses

  # this is invoked only once at start, to
  # create the object Class, which allows users
  # to create new classes. This is *not*
  # invoked when the user creates a new class, for
  # that "new FLUserDefinedClass()" is used.
  createNew: ->
    toBeReturned = super FLClass
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    return toBeReturned
    

FLClass = new FLClassPrimitiveClass FLClass

class FLAnonymousClass extends FLPrimitiveClasses

