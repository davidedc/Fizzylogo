# class "Class". Like all classes, it's an object, and there
# is only one of its kind, because this one Class object will be used to
# create other classes, i.e. special objects that can
# create further objects.
class FLClassClass extends FLClasses

  # create new classes e.g. myClass = Class new
  createNew: (theName = "") ->
    newUserClass = new FLClasses theName

    addDefaultMethods newUserClass

    # the class we are creating has a "new"
    # so user can create objects for it
    newUserClass.addMethod \
      (flTokenize "new"),
      (context) ->
        #yield
        log "///////// creating a new object from a user class!"
        objectTBR = newUserClass.createNew()
        objectTBR.flClass = newUserClass

        objectTBR.instanceVariablesDict[ValidIDfromString "class"] = newUserClass

        log "///////// creating a new object from a user class - user class of object: " + objectTBR.flClass.flToString()
        log "///////// creating a new object from a user class - objectTBR: " + objectTBR.flToString()
        log "///////// creating a new object from a user class - making space for instanceVariables"

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
        log "invoking whenNew"
        # yield from
        returnedContext = objectTBR.findSignatureBindParamsAndMakeCall (flTokenize "whenNew"), context
        returnedContext = returnedContext[0]


        toBeReturned = returnedContext.returned
        return toBeReturned

    # also all user classes can change their name
    newUserClass.addMethod \
      (flTokenize "nameit (newName)"),
      (context) ->
        #yield
        newName = context.tempVariablesDict[ValidIDfromString "newName"]
        @rename? newName.value
        return @


    return newUserClass


FLClass = new FLClassClass FLClass
FLClass.flClass = FLClass
FLClass.instanceVariablesDict[ValidIDfromString "class"] = FLClass
