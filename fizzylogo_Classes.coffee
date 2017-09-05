class FLClasses extends FLObjects
  name: null #a FLString
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  createNew: (theClass) ->
    return new FLObjects theClass

  addMethod: (signature, methodBody) ->
    #console.log "adding method to class: " + @name
    #console.log "adding method: " + signature.flToString()
    #console.log "sort order: " + signature.sortOrderString()
    for i in [0...@msgPatterns.length]
      eachSignature = @msgPatterns[i]
      #console.dir eachSignature
      if eachSignature.flToString() == signature.flToString()
        @msgPatterns[i] = signature
        @methodBodies[i] = methodBody
        console.log "adding method  signature (replacing): " + signature.flToString() + " body: " + methodBody.flToString?()
        return

    console.log "adding method  signature (appending): " + signature.flToString() + " body: " + methodBody.flToString?()
    @msgPatterns.jsArrayPush signature
    @methodBodies.jsArrayPush methodBody

    # sort all signatures in order of increasing genericity i.e.
    # more generic matches will be done last. See "sortOrderString"
    # method for more details.
    sortOrderStrings = @msgPatterns.map (elem) -> elem.sortOrderString()
    @msgPatterns = sortFirstArrayAccordingToSecond @msgPatterns, sortOrderStrings
    @methodBodies = sortFirstArrayAccordingToSecond @methodBodies, sortOrderStrings

    #for i in [0...@msgPatterns.length]
    #  console.log "msgPatterns ordered " + sortOrderStrings[i] + " : " + @msgPatterns[i].flToString()
    #console.log "-------------------- "

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

    toBeReturned.flToString = ->
      return "Class_object"

    return toBeReturned
    

FLClass = new FLClassClass FLClass

