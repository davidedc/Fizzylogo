class FLClasses extends FLObjects
  name: null # a standard JS string
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  # this is when you create a new class, e.g.
  # Number, String, or custom user-made classes.
  constructor: (@name) ->
    super @
    @flClass = FLClass
    @instanceVariablesDict[ValidIDfromString "class"] = FLClass
    
    # this is useful because then we can compare classes
    # (i.e. Number == String)
    # using the usual value check
    @value = @

    if !@isClass()
      @name = @constructor.name
      @name = @name.substr 2, @name.length - 7

    @msgPatterns = []
    @methodBodies = []

    # the temp variables contents
    # are in the context, not here in the class
    # similarly, the instance variables contents
    # are in the object, not here in the class
    allClasses.push @

  # this is when you create a new instance of this class,
  # for example a new number or a new string or a new
  # object from custom user-made classes.
  # as you see, classes are objects.
  createNew: (theClass) ->
    # turn things like "flNumberClass" into "Number"
    #console.log "class name: " + @name

    toBeReturned = new FLObjects theClass

    return toBeReturned

  addMethod: (signature, methodBody) ->
    #console.log "adding method " + signature.flToString() + " to: " + @flToString()
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


# class "Class". Like all classes, it's an object, and there
# is only one of its kind, because this one Class object will be used to
# create other classes, i.e. special objects that can
# create further objects.
class FLClassClass extends FLClasses

  # create new classes e.g. myClass = Class new
  createNew: ->
    newUserClass = new FLClasses ""

    addDefaultMethods newUserClass

    # the class we are creating has a "new"
    # so user can create objects for it
    newUserClass.addMethod \
      (flTokenize "new"),
      (context) ->
        console.log "///////// creating a new object from a user class!"
        objectTBR = newUserClass.createNew()
        objectTBR.flClass = newUserClass

        objectTBR.instanceVariablesDict[ValidIDfromString "class"] = newUserClass

        console.log "///////// creating a new object from a user class - user class of object: " + objectTBR.flClass.flToString()
        console.log "///////// creating a new object from a user class - objectTBR: " + objectTBR.flToString()
        console.log "///////// creating a new object from a user class - making space for instanceVariables"

        # we give the chance to automatically execute some initialisation code,
        # but without any parameters. For example drawing a box, giving a message,
        # initing some default values.
        # However for initialisations that _requires_ parameters, the user
        # will have to use a method call such as the "initWith" in FLException.
        # The reasoning is that if the user is bothering with initing with
        # parameters, then it might as well bother with sticking an
        # "initWith" method call in front of them.
        # Passing parameters to whenNew (and consuming them) from in here
        # defies the whole architecture of the mechanism.
        console.log "invoking whenNew"
        #catch yields
        returnedContext = objectTBR.findSignatureBindParamsAndMakeCall (flTokenize "whenNew"), context
        returnedContext = returnedContext[0]


        toBeReturned = returnedContext.returned
        return toBeReturned

    return newUserClass
    

FLClass = new FLClassClass FLClass
FLClass.flClass = FLClass
FLClass.instanceVariablesDict[ValidIDfromString "class"] = FLClass

