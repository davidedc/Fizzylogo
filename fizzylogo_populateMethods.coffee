# helper to add default methods -------------------------------------------


addDefaultMethods = (classToAddThemTo) ->

  classToAddThemTo.addNativeMethod \
    (flParse "print"),
    (context) ->
      console.log "///////// program printout: " + @value
      environmentPrintout += @value
      return @

  classToAddThemTo.addNativeMethod \
    (flParse "whenNew"),
    (context) ->
      return @

  commonEvalFunction = (context) ->
    newContext = new FLContext context
    flContexts.jsArrayPush newContext
    toBeReturned = (@eval newContext, @)[0].returned
    flContexts.pop()
    return toBeReturned

  classToAddThemTo.addNativeMethod \
    (flParse "eval"),
    commonEvalFunction

  classToAddThemTo.addNativeMethod \
    (flParse "'s ('variable) = (value)"),
    # in this case the arrow notation, which
    # evaluates both sides, is pretty handy!
    flParse "in (self) do (variable ← value)"

  classToAddThemTo.addNativeMethod \
    (flParse "'s ('code)"),
    flParse "code eval"

  classToAddThemTo.addNativeMethod \
    (flParse ". ('variable) = (value)"),
    # in this case the arrow notation, which
    # evaluates both sides, is pretty handy!
    flParse "in (self) do (variable ← value)"

  classToAddThemTo.addNativeMethod \
    (flParse ". ('code)"),
    flParse "code eval"


  commonIdictAssignmentFunction = (context) ->
    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    console.log "idict adding variable: @flClass.value " + @flClass.value
    if !@flClass.instanceVariables?
      @flClass.instanceVariables = FLList.emptyList()

    console.log "idict: context.self.flClass: "
    console.dir @flClass

    @flClass.instanceVariables = @flClass.instanceVariables.flListImmutablePush variable

    return @

  classToAddThemTo.addNativeMethod \
    (flParse "idict ← ( ' variable )"),
    commonIdictAssignmentFunction

  classToAddThemTo.addNativeMethod \
    (flParse "idict = ( ' variable )"),
    commonIdictAssignmentFunction

  commonCVarAssignmentFunction = (context) ->
    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    value = context.tempVariablesDict[ValidIDfromString "value"]

    console.log "cvar adding and setting class variable"
    if !@flClass.classVariables?
      @flClass.classVariables = FLList.emptyList()

    console.log "idict: context.self.flClass: "
    console.dir @flClass

    @flClass.classVariables = @flClass.classVariables.flListImmutablePush variable
    @flClass.classVariablesDict[ValidIDfromString variable.value] = value

    return @

  classToAddThemTo.addNativeMethod \
    (flParse "cvar ( ' variable ) ← ( value )"),
    commonCVarAssignmentFunction

  classToAddThemTo.addNativeMethod \
    (flParse "cvar ( ' variable ) = ( value )"),
    commonCVarAssignmentFunction

  classToAddThemTo.addNativeMethod \
    (flParse "cvarEvalParams ( variable ) ← ( value )"),
    (context) ->
      variable = context.tempVariablesDict[ValidIDfromString "variable"]
      value = context.tempVariablesDict[ValidIDfromString "value"]

      console.log "cvarEvalParams adding and setting class variable"
      if !@flClass.classVariables?
        @flClass.classVariables = FLList.emptyList()

      console.log "cval: class variables before: "
      console.dir @flClass.classVariablesDict

      @flClass.classVariables = @flClass.classVariables.flListImmutablePush variable
      @flClass.classVariablesDict[ValidIDfromString variable.value] = value

      console.log "cvarEvalParams: class variables after: "
      console.dir @flClass.classVariablesDict

      return @


  classToAddThemTo.addNativeMethod \
    (flParse "tdict"),
    (context) ->
      if !@flClass.tempVariables?
        @flClass.tempVariables = FLList.emptyList()
      return @flClass.tempVariables

  classToAddThemTo.addNativeMethod \
    (flParse "idict"),
    (context) ->
      if !@flClass.instanceVariables?
        @flClass.instanceVariables = FLList.emptyList()

      console.log "idict: context.self.flClass: "
      console.dir @flClass
      return @flClass.instanceVariables

  classToAddThemTo.addNativeMethod \
    (flParse "cdict"),
    (context) ->
      if !@flClass.classVariables?
        @flClass.classVariables = FLList.emptyList()
      return @flClass.classVariables

  classToAddThemTo.addNativeMethod \
    (flParse "answer ( ' signature ) by ( ' methodBody )"),
    (context) ->
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      @flClass.addNativeMethod signature, methodBody

      context.findAnotherReceiver = true
      return @

  classToAddThemTo.addNativeMethod \
    (flParse "answerEvalParams ( signature ) by ( methodBody )"),
    (context) ->
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      @msgPatterns.jsArrayPush signature
      @methodBodies.jsArrayPush methodBody

      context.findAnotherReceiver = true
      return @


# all native classes ---------------------------------------------------------------------------

# with time, allClasses contains all the classes
# (native classes and user-defined classes), but right
# now only the "native" classes have been defined
# so we add the default methods to those.
for eachClass in allClasses
  addDefaultMethods eachClass


# WorkSpace ---------------------------------------------------------------------------


# Atom ---------------------------------------------------------------------------



FLAtom.addNativeMethod \
  (flParse "← ( valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

    theAtomName = @value

    console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
    console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

    # this is the place where we come to create new temp variables
    # and we can't create them in this very call context, that would
    # be useless, we place it in the context of the _previous_ method call
    topMostContextWithThisSelf = context.previousContext.topMostContextWithThisSelf()
    dictToPutAtomIn = topMostContextWithThisSelf.lookUpAtomValuePlace @
    if !dictToPutAtomIn?
      dictToPutAtomIn = topMostContextWithThisSelf.createNonExistentValueLookup @

    dictToPutAtomIn[ValidIDfromString theAtomName] = valueToAssign

    console.log "evaluation " + indentation() + "stored value in dictionary"
    return valueToAssign

FLAtom.addNativeMethod \
  (flParse "=' ( 'valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

    if valueToAssign.flClass == FLList
      valueToAssign = valueToAssign.evaluatedElementsList context

    theAtomName = @value

    console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
    console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

    # this is the place where we come to create new temp variables
    # and we can't create them in this very call context, that would
    # be useless, we place it in the context of the _previous_ method call
    topMostContextWithThisSelf = context.previousContext.topMostContextWithThisSelf()
    dictToPutAtomIn = topMostContextWithThisSelf.lookUpAtomValuePlace @
    if !dictToPutAtomIn?
      dictToPutAtomIn = topMostContextWithThisSelf.createNonExistentValueLookup @

    dictToPutAtomIn[ValidIDfromString theAtomName] = valueToAssign

    console.log "evaluation " + indentation() + "stored value in dictionary"
    context.findAnotherReceiver = true
    return valueToAssign

FLAtom.addNativeMethod \
  (flParse "= ( valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

    theAtomName = @value

    console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
    console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

    # this is the place where we come to create new temp variables
    # and we can't create them in this very call context, that would
    # be useless, we place it in the context of the _previous_ method call
    topMostContextWithThisSelf = context.previousContext.topMostContextWithThisSelf()
    dictToPutAtomIn = topMostContextWithThisSelf.lookUpAtomValuePlace @
    if !dictToPutAtomIn?
      dictToPutAtomIn = topMostContextWithThisSelf.createNonExistentValueLookup @

    dictToPutAtomIn[ValidIDfromString theAtomName] = valueToAssign

    console.log "evaluation " + indentation() + "stored value in dictionary"
    context.findAnotherReceiver = true
    return valueToAssign


# Nil ---------------------------------------------------------------------------

# In ---------------------------------------------------------------------------

FLIn.addNativeMethod \
  (flParse "(object) do ('code)"),
  (context) ->
    object = context.tempVariablesDict[ValidIDfromString "object"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    newContext = new FLContext context, object

    toBeReturned = (code.eval newContext, code)[0].returned
    context.findAnotherReceiver = true

    return toBeReturned

# To -------------------------------------------------------------------------

FLTo.addNativeMethod \
  (flParse "( ' functionObjectName ) ( ' signature ) do ( ' functionBody )"),
  flParse \
    "'TempClass ← Class new;\
    tempClass answerEvalParams (signature) by (functionBody);\
    'functionObject ← TempClass new;\
    WorkSpace cvarEvalParams (functionObjectName) ← functionObject;"

# Class -------------------------------------------------------------------------

# Class. There is only one object in the system that belongs to this class
# and it's also called "Class". We give this object the capacity to create
# new classes, via the "new" message below.

FLClass.addNativeMethod \
  (flParse "print"),
  (context) ->
    console.log "///////// program printout: " + "Class object!"
    environmentPrintout += "Class_object"
    return @

FLClass.addNativeMethod \
  (flParse "new"),
  (context) ->
    console.log "///////// creating a new class for the user!"

    newUserClass = new FLUserDefinedClass()

    # the class we are creating has a "new"
    # so user can create objects for it
    newUserClass.addNativeMethod \
      (flParse "new"),
      (context) ->
        console.log "///////// creating a new object from a user class!"
        objectTBR = @createNew()
        console.log "///////// creating a new object from a user class - user class of object: " + objectTBR.flClass.value
        console.log "///////// creating a new object from a user class - objectTBR.value: " + objectTBR.value
        console.log "///////// creating a new object from a user class - making space for instanceVariables"
        console.log "///////// creating a new object from a user class - instance variables in this class: " + objectTBR.flClass.instanceVariables.print()
        for eachInstanceVariable in objectTBR.flClass.instanceVariables.value
          console.log "///////// creating a new object from a user class - adding this to dict: " + ValidIDfromString eachInstanceVariable.value
          objectTBR.instanceVariablesDict[ValidIDfromString eachInstanceVariable.value] = FLNil.createNew()

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
        returnedContext = (objectTBR.findSignatureBindParamsAndMakeCall (flParse "whenNew"), context)[0]
        toBeReturned = returnedContext.returned
        return toBeReturned

    addDefaultMethods newUserClass

    return newUserClass

# Exception -------------------------------------------------------------------------

FLException.addNativeMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew ""

FLException.addNativeMethod \
  (flParse "initWith ( ' errorMessage )"),
  (context) ->
    errorMessage = context.tempVariablesDict[ValidIDfromString "errorMessage"]
    @value = errorMessage.value
    return @

FLException.addNativeMethod \
  (flParse "catch all handle ( ' errorHandle )"),
  (context) ->
    errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

    console.log "catch: being thrown? " + context.throwing

    console.log "catch: got right exception, catching it"
    toBeReturned = (errorHandle.eval context, errorHandle)[0].returned
    context.findAnotherReceiver = true

    return toBeReturned

FLException.addNativeMethod \
  (flParse "catch ( theError ) handle ( ' errorHandle )"),
  (context) ->
    theError = context.tempVariablesDict[ValidIDfromString "theError"]
    errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

    console.log "catch: same as one to catch?" + (@ == theError) + " being thrown? " + context.throwing

    if @ == theError
      console.log "catch: got right exception, catching it"
      toBeReturned = (errorHandle.eval context, errorHandle)[0].returned
      context.findAnotherReceiver = true
    else
      console.log "catch: got wrong exception, propagating it"
      toBeReturned = @
      context.findAnotherReceiver = false

    return toBeReturned

FLException.addNativeMethod \
  (flParse "$$MATCHALL$$"),
  (context) ->
    console.log "exception - no more cacthes, has to be re-thrown"
    context.throwing = true
    return @


# String -------------------------------------------------------------------------

FLString.addNativeMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew ""

FLString.addNativeMethod \
  (flParse "+ ( stringToBeAppended )"),
  (context) ->
    stringToBeAppended = context.tempVariablesDict[ValidIDfromString "stringToBeAppended"]
    return FLString.createNew @value + stringToBeAppended.print()

# Number -------------------------------------------------------------------------

FLNumber.addNativeMethod \
  (flParse "anotherPrint"),
  flParse "self print"

FLNumber.addNativeMethod \
  (flParse "doublePrint"),
  flParse "self print print"

FLNumber.addNativeMethod \
  (flParse "increment"),
  flParse "self ← self plus 1"

FLNumber.addNativeMethod \
  (flParse "factorial"),
  flParse "( self == 0 ) ⇒ ( 1 ) ( self minus 1 ) factorial * self"

FLNumber.addNativeMethod \
  (flParse "factorialtwo"),
  flParse "( self == 0 ) ⇒ ( 1 ) self * ( ( self minus 1 ) factorial )"

FLNumber.addNativeMethod \
  (flParse "factorialthree"),
  flParse "( self == 0 ) ⇒ ( 1 ) ('temp ← self; ( self minus 1 ) factorial * temp )"

FLNumber.addNativeMethod \
  (flParse "factorialfour"),
  flParse \
    "( self == 0 ) ⇒ ( 1 ) ('temp ← self;\
    ( self minus 1 ) factorial * temp )"

FLNumber.addNativeMethod \
  (flParse "factorialfive"),
  flParse \
    "( self == 0 ) ⇒ ( 1 ) (1 plus 1;'temp ← self;\
    ( self minus 1 ) factorial * temp )"

FLNumber.addNativeMethod \
  (flParse "amIZero"),
  flParse "self == 0"

FLNumber.addNativeMethod \
  (flParse "printAFromDeeperCall"),
  flParse "a print"

FLNumber.addNativeMethod \
  (flParse "plus ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value + operandum.value

FLNumber.addNativeMethod \
  (flParse "minus ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value - operandum.value

FLNumber.addNativeMethod \
  (flParse "selftimesminusone"),
  flParse "self * self minus 1"

FLNumber.addNativeMethod \
  (flParse "* ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
    return FLNumber.createNew @value * operandum.value

FLNumber.addNativeMethod \
  (flParse "times ( ' loopCode )"),
  (context) ->
    loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
    console.log "FLNumber ⇒ DO loop code is: " + loopCode.print()


    for i in [0...@value]
      toBeReturned = (loopCode.eval context, loopCode)[0].returned

      flContexts.pop()

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "Do ⇒ the loop exited with Done "
          break

    context.findAnotherReceiver = true
    return toBeReturned


FLNumber.addNativeMethod \
  (flParse "== ( toCompare )"),
  (context) ->
    toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
    if @value == toCompare.value
      return FLBoolean.createNew true
    else
      return FLBoolean.createNew false

FLNumber.addNativeMethod \
  (flParse "← ( valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]
    @value = valueToAssign.value
    return @



# Boolean -------------------------------------------------------------------------

FLBoolean.addNativeMethod \
  (flParse "negate"),
  (context) ->
    return FLBoolean.createNew !@value

FLBoolean.addNativeMethod \
  (flParse "and ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLBoolean.createNew @value and operandum.value

FLBoolean.addNativeMethod \
  (flParse "⇒ ( ' trueBranch )"),
  (context) ->
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
    console.log "FLBoolean ⇒ , predicate value is: " + @value

    if @value
      toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
      flContexts.pop()

      console.log "FLBoolean ⇒ returning result of true branch: " + toBeReturned
      console.log "FLBoolean ⇒ remaining message after true branch: "
      console.log "FLBoolean ⇒ message length:  "

      # in this context we only have visibility of the true branch
      # but we have to make sure that in the context above, the false
      # branch is never executed. So we set a flag to "exhaust" the message
      # in the context above
      context.exhaustPreviousContextMessage = true


      return toBeReturned

    context.findAnotherReceiver = true
    return @


FLBoolean.addNativeMethod \
  (flParse "or ( operandum )"),
  (context) ->
    console.log "executing an or! "
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLBoolean.createNew @value or operandum.value


# FLQuote --------------------------------------------------------------------------

FLQuote.addNativeMethod \
  (flParse "( ' operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return operandum

# Not --------------------------------------------------------------------------
FLNot.addNativeMethod \
  (flParse "( operandum )"),
  flParse "operandum negate"

# List -------------------------------------------------------------------------

FLList.addNativeMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew()

FLList.addNativeMethod \
  (flParse "print"),
  (context) ->
    console.log "///////// program printout: " + @print()
    environmentPrintout += @print()
    return context

FLList.addNativeMethod \
  (flParse "+ ( elementToBeAppended )"),
  (context) ->
    elementToBeAppended = context.tempVariablesDict[ValidIDfromString "elementToBeAppended"]
    return @flListImmutablePush elementToBeAppended

FLList.addNativeMethod \
  (flParse "length"),
  (context) ->
    return FLNumber.createNew @length()

FLList.addNativeMethod \
  (flParse "[ (indexValue) ] = (value)"),
  (context) ->
    indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
    value = context.tempVariablesDict[ValidIDfromString "value"]
    context.findAnotherReceiver = true
    return @elementAtSetMutable indexValue.value, value

FLList.addNativeMethod \
  (flParse "[ (indexValue) ]"),
  (context) ->
    indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
    return @elementAt indexValue.value


FLList.addNativeMethod \
  (flParse "each ( ' variable ) do ( ' code )"),
  (context) ->

    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    console.log "FLList each do "

    newContext = new FLContext context
    newContext.self.flClass.tempVariables = newContext.self.flClass.tempVariables.flListImmutablePush variable

    for i in [0...@value.length]

      newContext.tempVariablesDict[ValidIDfromString variable.value] = @elementAt i
      toBeReturned = (code.eval newContext, code)[0].returned

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "each... do loop exited with Done "
          break

    return toBeReturned


# Done -------------------------------------------------------------------------

FLDone.addNativeMethod \
  (flParse "print"),
  (context) ->
    console.log "///////// program printout: " + "Done_object"
    environmentPrintout += "Done_object"
    return @


FLDone.addNativeMethod \
  (flParse "with ( valueToReturn )"),
  (context) ->
    valueToReturn = context.tempVariablesDict[ValidIDfromString "valueToReturn"]

    @value = valueToReturn
    return @


# Repeat1 -------------------------------------------------------------------------

FLRepeat1.addNativeMethod \
  (flParse "( ' loopCode )"),
  (context) ->
    loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
    console.log "FLRepeat1 ⇒ loop code is: " + loopCode.print()

    while true
      toBeReturned = (loopCode.eval context, loopCode)[0].returned

      flContexts.pop()

      console.log "Repeat1 ⇒ returning result after loop cycle: " + toBeReturned
      console.log "Repeat1 ⇒ returning result CLASS after loop cycle: "
      console.log "Repeat1 ⇒ remaining message after loop cycle: "
      console.log "Repeat1 ⇒ message length:  "
      console.log "Repeat1 ⇒ did I receive a Done? " + (if toBeReturned?.flClass == FLDone then "yes" else "no")

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "Repeat1 ⇒ the loop exited with Done "
          break

    return toBeReturned

# Repeat2 -------------------------------------------------------------------------

FLRepeat2.addNativeMethod \
  (flParse "(howManyTimes) do ( ' loopCode )"),
  (context) ->
    howManyTimes = context.tempVariablesDict[ValidIDfromString "howManyTimes"]
    loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
    console.log "FLRepeat1 ⇒ loop code is: " + loopCode.print()

    if howManyTimes.flClass == FLForever
      limit = Number.MAX_SAFE_INTEGER
    else
      limit = howManyTimes.value


    for i in [0...limit]
      toBeReturned = (loopCode.eval context, loopCode)[0].returned

      flContexts.pop()

      console.log "Repeat1 ⇒ returning result after loop cycle: " + toBeReturned
      console.log "Repeat1 ⇒ returning result CLASS after loop cycle: "
      console.log "Repeat1 ⇒ remaining message after loop cycle: "
      console.log "Repeat1 ⇒ message length:  "
      console.log "Repeat1 ⇒ did I receive a Done? " + (if toBeReturned?.flClass == FLDone then "yes" else "no")
      console.log "Repeat1 ⇒ did I receive a thrown object? " + (if context.throwing then "yes" else "no")

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "Repeat1 ⇒ the loop exited with Done "
          break

    context.findAnotherReceiver = true
    return toBeReturned

# Throw -----------------------------------------------------------------------------

FLThrow.addNativeMethod \
  (flParse "( theError )"),
  (context) ->
    theError = context.tempVariablesDict[ValidIDfromString "theError"]
    console.log "throwing an error: " + theError.value
    context.throwing = true
    return theError

# IfThen -----------------------------------------------------------------------------

FLIfThen.addNativeMethod \
  (flParse "( predicate ) then ('trueBranch)"),
  (context) ->
    predicate = context.tempVariablesDict[ValidIDfromString "predicate"]
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
    console.log "IfThen ⇒ , predicate value is: " + predicate.value

    if predicate.value
      toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
      flContexts.pop()
      context.findAnotherReceiver = true
    else
      toBeReturned = FLIfFallThrough.createNew()

    return toBeReturned

# FLIfFallThrough -----------------------------------------------------------------------------

FLIfFallThrough.addNativeMethod \
  (flParse "else if ( predicate ) then ('trueBranch)"),
  (context) ->
    predicate = context.tempVariablesDict[ValidIDfromString "predicate"]
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
    console.log "IfThen ⇒ , predicate value is: " + predicate.value

    if predicate.value
      toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
      flContexts.pop()
      context.findAnotherReceiver = true
    else
      toBeReturned = FLIfFallThrough.createNew()

    return toBeReturned

FLIfFallThrough.addNativeMethod \
  (flParse "else ('trueBranch)"),
  (context) ->
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]

    toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
    flContexts.pop()
    context.findAnotherReceiver = true
    return toBeReturned

FLIfFallThrough.addNativeMethod \
  (flParse "$$MATCHALL$$"),
  (context) ->
    console.log "no more cases for the if"
    context.findAnotherReceiver = true
    return @


# FakeElse -----------------------------------------------------------------------------

FLFakeElse.addNativeMethod \
  (flParse "else if ( predicate ) then ('trueBranch)"),
  (context) ->
    context.findAnotherReceiver = true
    return @

FLFakeElse.addNativeMethod \
  (flParse "else ('trueBranch)"),
  (context) ->
    context.findAnotherReceiver = true
    return @



# Try -----------------------------------------------------------------------------

FLTry.addNativeMethod \
  (flParse "( ' code )"),
  (context) ->
    code = context.tempVariablesDict[ValidIDfromString "code"]
    toBeReturned = (code.eval context, code)[0].returned

    # if there _is_ somethig being thrown, then
    # we do not want another receiver, the thrown
    # exception has to go through some catches
    # hopefully.
    if !context.throwing
      context.findAnotherReceiver = true

    context.throwing = false
    return toBeReturned

# Fake Catch -----------------------------------------------------------------------------
# the catch object doesn't do the real catch, that's done
# by the catch "as message". This one just consumes all the
# catches after a real catch has happened. See the class
# definition for explained example.

FLFakeCatch.addNativeMethod \
  (flParse "all handle ( ' errorHandle )"),
  (context) ->
    context.findAnotherReceiver = true
    return @

FLFakeCatch.addNativeMethod \
  (flParse "( theError ) handle ( ' errorHandle )"),
  (context) ->
    context.findAnotherReceiver = true
    return @

# For -----------------------------------------------------------------------------

FLFor.addNativeMethod \
  (flParse "( ' loopVar ) from ( startIndex ) to ( endIndex ) do ( ' loopCode )"),
  (context) ->
    loopVar = context.tempVariablesDict[ValidIDfromString "loopVar"]
    startIndex = context.tempVariablesDict[ValidIDfromString "startIndex"]
    endIndex = context.tempVariablesDict[ValidIDfromString "endIndex"]
    loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]

    loopVarName = loopVar.value

    forContext = new FLContext context
    forContext.self.flClass.tempVariables = forContext.self.flClass.tempVariables.flListImmutablePush loopVar
    flContexts.jsArrayPush forContext

    console.log "FLFor ⇒ loop code is: " + loopCode.print()

    for i in [startIndex.value..endIndex.value]
      console.log "FLFor ⇒ loop iterating variable to " + i

      forContext.tempVariablesDict[ValidIDfromString loopVarName] = FLNumber.createNew i

      toBeReturned = (loopCode.eval forContext, loopCode)[0].returned

      flContexts.pop()

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "For ⇒ the loop exited with Done "
          break

    flContexts.pop()

    context.findAnotherReceiver = true
    return toBeReturned

# bacause a ((wrappedList)) evaluates to (wrappedList)
# you can pass a ((list)) as second param, so you can
# pass (list) when you are in indented form, which makes
# more sense to the user.
FLFor.addNativeMethod \
  (flParse "each ( ' variable ) in ( theList ) do ( ' code )"),
  (context) ->

    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    theList = context.tempVariablesDict[ValidIDfromString "theList"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    if theList.flClass != FLList
      context.throwing = true
      return FLException.createNew "for...each expects a list"


    console.log "FLEach do on the list: " + theList.print()

    newContext = new FLContext context
    newContext.self.flClass.tempVariables = newContext.self.flClass.tempVariables.flListImmutablePush variable

    for i in [0...theList.value.length]

      newContext.tempVariablesDict[ValidIDfromString variable.value] = theList.elementAt i
      console.log "FLEach do evaling...: " + code.print()
      toBeReturned = (code.eval newContext, code)[0].returned

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "each... do loop exited with Done "
          break

    context.findAnotherReceiver = true
    return toBeReturned
