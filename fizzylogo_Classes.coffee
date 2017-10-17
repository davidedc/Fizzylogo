class FLClasses extends FLObjects
  name: null # a standard JS string
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists
  priorities: null # an array of JS Numbers

  # this is when you create a new class, e.g.
  # Number, String, or custom user-made classes.
  constructor: (@name) ->
    super @
    @flClass = FLClass

    @resetInstanceVariables()
    
    # this is useful because then we can compare classes
    # (i.e. Number == String)
    # using the usual value check
    @value = @

    if !@isClass()
      @name = @constructor.name
      @name = @name.substr 2, @name.length - 7

    @resetMethods()

    # the temp variables contents
    # are in the context, not here in the class
    # similarly, the instance variables contents
    # are in the object, not here in the class
    allClasses.push @

  rename: (newName) ->
    @name = newName

  resetMethods: ->
    @msgPatterns = []
    @methodBodies = []
    @priorities = []

  resetInstanceVariables: ->
    @instanceVariablesDict = {}
    @instanceVariablesDict[ValidIDfromString "class"] = FLClass

  # this is when you create a new instance of this class,
  # for example a new number or a new string or a new
  # object from custom user-made classes.
  # as you see, classes are objects.
  createNew: (theClass) ->
    # turn things like "flNumberClass" into "Number"
    #log "class name: " + @name

    toBeReturned = new FLObjects theClass

    return toBeReturned

  addMethod: (signature, methodBody,  priority) ->
    #log "adding method " + signature.flToString() + " to: " + @flToString()
    #log "sort order: " + signature.sortOrderString()
    for i in [0...@msgPatterns.length]
      eachSignature = @msgPatterns[i]
      #dir eachSignature
      if eachSignature.flToString() == signature.flToString()
        @msgPatterns[i] = signature
        @methodBodies[i] = methodBody
        @priorities[i] = priority
        log "adding method  signature (replacing): " + signature.flToString() + " body: " + methodBody.flToString?()
        return

    log "adding method  signature (appending): " + signature.flToString() + " body: " + methodBody.flToString?()
    @msgPatterns.jsArrayPush signature
    @methodBodies.jsArrayPush methodBody
    @priorities.jsArrayPush priority

    # sort all signatures in order of increasing genericity i.e.
    # more generic matches will be done last. See "sortOrderString"
    # method for more details.
    sortOrderStrings = @msgPatterns.map (elem) -> elem.sortOrderString()
    @msgPatterns = sortFirstArrayAccordingToSecond @msgPatterns, sortOrderStrings
    @methodBodies = sortFirstArrayAccordingToSecond @methodBodies, sortOrderStrings
    @priorities = sortFirstArrayAccordingToSecond @priorities, sortOrderStrings

    #for i in [0...@msgPatterns.length]
    #  log "msgPatterns ordered " + sortOrderStrings[i] + " : " + @msgPatterns[i].flToString()
    #log "-------------------- "



