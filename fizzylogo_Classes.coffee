class FLClasses extends FLObjects
  name: null #a FLString
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  createNew: (theClass) ->
    return new FLObjects theClass

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
    allClasses.push @


# class "Class". We'll create exactyly one object for
# this class, which is going to be also called "Class".
# such object will allow users to create their classes.
class FLClassClass extends FLClasses

  # this is invoked only once at start, to
  # create the object Class, which allows users
  # to create new classes. This is *not*
  # invoked when the user creates a new class, for
  # that "new FLUserDefinedClass()" is used.
  createNew: ->
    toBeReturned = super FLClass
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    return toBeReturned
    

FLClass = new FLClassClass FLClass

