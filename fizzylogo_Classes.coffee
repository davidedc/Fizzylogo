class FLClasses extends FLObjects
  name: null # a standard JS string
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  # this is when you create a new class, e.g.
  # Number, String, or custom user-made classes.
  constructor: ->
    super @
    @instanceVariablesDict[ValidIDfromString "class"] = FLClass

    @msgPatterns = []
    @methodBodies = []

    # the temp variables contents
    # are in the context, not here in the class
    # similarly, the instance variables contents
    # are in the object, not here in the class
    allClasses.push @

  # this is returned when you do a print on a class
  # e.g. console print "a String object".class
  flToString: ->
    return @name

  # this is when you create a new instance of this class,
  # for example a new number or a new string or a new
  # object from custom user-made classes.
  # as you see, classes are objects.
  createNew: (theClass) ->
    # turn things like "flNumberClass" into "Number"
    @name = @flClass.constructor.name
    @name = @name.substr 2, @name.length - 7
    #console.log "class name: " + @name

    toBeReturned = new FLObjects theClass

    return toBeReturned

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


# class "Class". We'll create exactly one object for
# this class, which is going to be also called "Class".
# Normally, classes create objects, but this one class will
# create very special objects: classes, i.e. objects that can
# create further objects.
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

    return toBeReturned
    

FLClass = new FLClassClass FLClass
FLClass.flClass = FLClass
FLClass.instanceVariablesDict[ValidIDfromString "class"] = FLClass

