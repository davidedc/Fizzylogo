# helper to add default methods -------------------------------------------


addDefaultMethods = (classToAddThemTo) ->

  classToAddThemTo.addNativeMethod \
    (flParse "print"),
    (context) ->
      console.log "///////// program printout: " + @value
      environmentPrintout += @value
      return @

  commonEvalFunction = (context) ->
    newContext = new FLContext context
    flContexts.jsArrayPush newContext
    toBeReturned = (@eval newContext, @)[0].returned
    flContexts.pop()
    return toBeReturned

  classToAddThemTo.addNativeMethod \
    (flParse "eval1"),
    commonEvalFunction

  classToAddThemTo.addNativeMethod \
    (flParse "eval"),
    commonEvalFunction

  classToAddThemTo.addNativeMethod \
    (flParse "catch all handle ( @ errorHandle )"),
    (context) -> return @

  classToAddThemTo.addNativeMethod \
    (flParse "catch ( theError ) handle ( @ errorHandle )"),
    (context) -> return @

  classToAddThemTo.addNativeMethod \
    (flParse "'s (@code)"),
    flParse "code eval1"

  classToAddThemTo.addNativeMethod \
    (flParse "idict ← ( @ variable )"),
    (context) ->
      variable = context.tempVariablesDict[ValidIDfromString "variable"]
      console.log "idict adding variable: @flClass.value " + @flClass.value
      if !@flClass.instanceVariables?
        @flClass.instanceVariables = FLList.emptyList()

      console.log "idict: context.self.flClass: "
      console.dir @flClass

      @flClass.instanceVariables = @flClass.instanceVariables.flListImmutablePush variable

      return @

  classToAddThemTo.addNativeMethod \
    (flParse "cvar ( @ variable ) ← ( value )"),
    (context) ->
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
    (flParse "answer ( @ signature ) by ( @ methodBody )"),
    (context) ->
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      @msgPatterns.jsArrayPush signature
      @methodBodies.jsArrayPush methodBody

      return @

  classToAddThemTo.addNativeMethod \
    (flParse "answerEvalParams ( signature ) by ( methodBody )"),
    (context) ->
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      @msgPatterns.jsArrayPush signature
      @methodBodies.jsArrayPush methodBody

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

commonBackArrowAndEqualsFunction = (context) ->
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
  (flParse "← ( valueToAssign )"),
  commonBackArrowAndEqualsFunction

FLAtom.addNativeMethod \
  (flParse "= ( valueToAssign )"),
  commonBackArrowAndEqualsFunction


# Nil ---------------------------------------------------------------------------

# To -------------------------------------------------------------------------

FLTo.addNativeMethod \
  (flParse "( @ functionObjectName ) ( @ signature ) ( @ functionBody )"),
  flParse \
    "@TempClass ← Class new.\
    tempClass answerEvalParams (signature) by (functionBody).\
    @functionObject ← TempClass new.\
    WorkSpace cvarEvalParams (functionObjectName) ← functionObject"

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

        return objectTBR

    addDefaultMethods newUserClass

    return newUserClass

# Exception -------------------------------------------------------------------------

FLException.addNativeMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew ""

FLException.addNativeMethod \
  (flParse "initWith ( @ errorMessage )"),
  (context) ->
    errorMessage = context.tempVariablesDict[ValidIDfromString "errorMessage"]
    @value = errorMessage.value
    return @

FLException.addNativeMethod \
  (flParse "catch all handle ( @ errorHandle )"),
  (context) ->
    errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

    console.log "catch: being thrown? " + @beingThrown

    if @beingThrown
      @beingThrown = false
      console.log "catch: got right exception, catching it"
      toBeReturned = (errorHandle.eval context, errorHandle)[0].returned
      context.findAnotherReceiver = true
    else
      console.log "catch: got wrong exception, propagating it"
      toBeReturned = @

    return toBeReturned

FLException.addNativeMethod \
  (flParse "catch ( theError ) handle ( @ errorHandle )"),
  (context) ->
    theError = context.tempVariablesDict[ValidIDfromString "theError"]
    errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

    console.log "catch: same as one to catch?" + (@ == theError) + " being thrown? " + @beingThrown

    if @beingThrown and @ == theError
      @beingThrown = false
      console.log "catch: got right exception, catching it"
      toBeReturned = (errorHandle.eval context, errorHandle)[0].returned
      context.findAnotherReceiver = true
    else
      console.log "catch: got wrong exception, propagating it"
      toBeReturned = @

    return toBeReturned

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
  (flParse "anotherPrinttwo"),
  flParse "(self print)"

FLNumber.addNativeMethod \
  (flParse "anotherPrintthree"),
  flParse "(((((((((self))) print))))))"

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
  flParse "( self == 0 ) ⇒ ( 1 ) (@temp ← self. ( self minus 1 ) factorial * temp )"

FLNumber.addNativeMethod \
  (flParse "factorialfour"),
  flParse \
    "( self == 0 ) ⇒ ( 1 ) (((((@temp ← self)))).\
    ( self minus 1 ) factorial * temp )"

FLNumber.addNativeMethod \
  (flParse "factorialfive"),
  flParse \
    "( self == 0 ) ⇒ ( 1 ) (1 plus 1.((((@temp ← self)))).\
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
  (flParse "times ( @ loopCode )"),
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
          toBeReturned.beingThrown = false
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
  (flParse "⇒ ( @ trueBranch )"),
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
  (flParse "( @ operandum )"),
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
    @flClass.createNew ""

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
  (flParse "each ( @ variable ) do ( @ code )"),
  (context) ->

    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    console.log "FLNumber each do "

    newContext = new FLContext context
    newContext.self.flClass.tempVariables = newContext.self.flClass.tempVariables.flListImmutablePush variable

    for i in [0...@value.length]

      newContext.tempVariablesDict[ValidIDfromString variable.value] = @elementAt i
      toBeReturned = (code.eval newContext, code)[0].returned

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          toBeReturned.beingThrown = false
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
  (flParse "( @ loopCode )"),
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
      console.log "Repeat1 ⇒ did I receive a Done? " + (if toBeReturned?.flClass == FLDoneClass then "yes" else "no")

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          toBeReturned.beingThrown = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "Repeat1 ⇒ the loop exited with Done "
          break

    return toBeReturned

# Repeat2 -------------------------------------------------------------------------

FLRepeat2.addNativeMethod \
  (flParse "(howManyTimes) do ( @ loopCode )"),
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
      console.log "Repeat1 ⇒ did I receive a Done? " + (if toBeReturned?.flClass == FLDoneClass then "yes" else "no")

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if toBeReturned.flClass == FLDone
          toBeReturned.beingThrown = false
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
    console.log "throwing " + theError.value
    theError.beingThrown = true
    return theError

# IfThenElse -----------------------------------------------------------------------------

FLIfThenElse.addNativeMethod \
  (flParse "( predicate ) then (@trueBranch) else (@falseBranch)"),
  (context) ->
    predicate = context.tempVariablesDict[ValidIDfromString "predicate"]
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
    falseBranch = context.tempVariablesDict[ValidIDfromString "falseBranch"]
    console.log "IfThenElse ⇒ , predicate value is: " + predicate.value

    if predicate.value
      toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
      flContexts.pop()
    else
      toBeReturned = (falseBranch.eval context, falseBranch)[0].returned
      flContexts.pop()


    context.findAnotherReceiver = true
    return toBeReturned

FLIfThenElse.addNativeMethod \
  (flParse "( predicate ) then (@trueBranch)"),
  (context) ->
    predicate = context.tempVariablesDict[ValidIDfromString "predicate"]
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
    console.log "IfThenElse ⇒ , predicate value is: " + predicate.value

    if predicate.value
      toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
      flContexts.pop()
    else
      toBeReturned = context

    context.findAnotherReceiver = true
    return toBeReturned


# Try -----------------------------------------------------------------------------

FLTry.addNativeMethod \
  (flParse "( @ code )"),
  (context) ->
    code = context.tempVariablesDict[ValidIDfromString "code"]
    toBeReturned = (code.eval context, code)[0].returned
    return toBeReturned

# Fake Catch -----------------------------------------------------------------------------
# the catch object doesn't do the real catch, that's done
# by the catch "as message". This one just consumes all the
# catches after a real catch has happened. See the class
# definition for explained example.

FLFakeCatch.addNativeMethod \
  (flParse "all handle ( @ errorHandle )"),
  (context) ->
    context.findAnotherReceiver = true
    return @

FLFakeCatch.addNativeMethod \
  (flParse "( theError ) handle ( @ errorHandle )"),
  (context) ->
    context.findAnotherReceiver = true
    return @


# For -----------------------------------------------------------------------------

FLFor.addNativeMethod \
  (flParse "( @ loopVar ) from ( startIndex ) to ( endIndex ) do ( @ loopCode )"),
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
          toBeReturned.beingThrown = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          console.log "For ⇒ the loop exited with Done "
          break

    flContexts.pop()

    context.findAnotherReceiver = true
    return toBeReturned

