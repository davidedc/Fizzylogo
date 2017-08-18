# helper to add default methods -------------------------------------------


addDefaultMethods = (classToAddThemTo) ->

  classToAddThemTo.addMethod \
    (flParse "print"),
    (context) ->
      console.log "///////// program printout: " + @value
      environmentPrintout += @value
      return @

  classToAddThemTo.addMethod \
    (flParse "whenNew"),
    (context) ->
      return @

  classToAddThemTo.addMethod \
    (flParse "eval"),
    (context) ->
      context.isTransparent = true
      newContext = new FLContext context
      newContext.isTransparent = true
      flContexts.jsArrayPush newContext
      toBeReturned = (@eval newContext, @)[0].returned
      flContexts.pop()
      return toBeReturned


  commonPropertyAssignmentFunction = (context) ->
    context.isTransparent = true
    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    value = context.tempVariablesDict[ValidIDfromString "value"]

    @instanceVariablesDict[ValidIDfromString variable.value] = value
    context.findAnotherReceiver = true

    return @

  commonPropertyAccessFunction = (context) ->
    context.isTransparent = true
    variable = context.tempVariablesDict[ValidIDfromString "variable"]

    console.log ". ('variable) : checking instance variables"

    # somewhat similar to Javascript, the lookup starts at the object
    # and climbs up to its class.
    objectsBeingChecked = @
    while true
      if objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]?
        console.log "yes it's an instance variable"
        return objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]
      if objectsBeingChecked == objectsBeingChecked.flClass
        break
      else objectsBeingChecked = objectsBeingChecked.flClass

    return FLNil.createNew()

  classToAddThemTo.addMethod \
    (flParse ". ('variable) = (value)"),
    commonPropertyAssignmentFunction

  classToAddThemTo.addMethod \
    (flParse ". ('variable) ← (value)"),
    commonPropertyAssignmentFunction

  classToAddThemTo.addMethod \
    (flParse ". ('variable)"),
    commonPropertyAccessFunction


  # TODO I think method body should NOT be quoted
  classToAddThemTo.addMethod \
    (flParse "answer ( ' signature ) by ( ' methodBody )"),
    (context) ->
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      @flClass.addMethod signature, methodBody

      context.findAnotherReceiver = true
      return @

  classToAddThemTo.addMethod \
    (flParse "answerEvalParams ( signature ) by ( methodBody )"),
    (context) ->
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      @flClass.addMethod signature, methodBody

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



FLAtom.addMethod \
  (flParse "← ( valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

    theAtomName = @value

    console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
    console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

    context.isTransparent = true

    # check if temp variable is visible from here.
    # if not, create it.
    dictToPutAtomIn = context.lookUpAtomValuePlace @
    if !dictToPutAtomIn?
      # no such variable, hence we create it as temp, but
      # we can't create them in this very call context, that would
      # be useless, we place it in the context of the _previous_ context
      # note that this means that any construct that creates a new context
      # will seal the temp variables in it. For example "for" loops. This
      # is like the block scoping of C or Java. If you want function scoping, it
      # could be achieved for example by marking in a special way contexts
      # that have been created because of method calls and climbing back
      # to the last one of those...
      console.log "evaluation " + indentation() + "creating temp atom: " + theAtomName + " at depth: " + context.firstNonTransparentContext().depth() + " with self: " + context.firstNonTransparentContext().self.print()
      dictToPutAtomIn = context.firstNonTransparentContext().tempVariablesDict
    else
      console.log "evaluation " + indentation() + "found temp atom: " + theAtomName

    dictToPutAtomIn[ValidIDfromString theAtomName] = valueToAssign

    console.log "evaluation " + indentation() + "stored value in dictionary"
    return valueToAssign

FLAtom.addMethod \
  (flParse "=' ( 'valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

    if valueToAssign.flClass == FLList
      valueToAssign = valueToAssign.evaluatedElementsList context

    theAtomName = @value

    console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
    console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

    context.isTransparent = true

    # check if temp variable is visible from here.
    # if not, create it.
    dictToPutAtomIn = context.lookUpAtomValuePlace @
    if !dictToPutAtomIn?
      # no such variable, hence we create it as temp, but
      # we can't create them in this very call context, that would
      # be useless, we place it in the context of the _previous_ context
      # note that this means that any construct that creates a new context
      # will seal the temp variables in it. For example "for" loops. This
      # is like the block scoping of C or Java. If you want function scoping, it
      # could be achieved for example by marking in a special way contexts
      # that have been created because of method calls and climbing back
      # to the last one of those...
      console.log "evaluation " + indentation() + "creating temp atom: " + theAtomName
      dictToPutAtomIn = context.firstNonTransparentContext().tempVariablesDict
    else
      console.log "evaluation " + indentation() + "found temp atom: " + theAtomName

    dictToPutAtomIn[ValidIDfromString theAtomName] = valueToAssign

    console.log "evaluation " + indentation() + "stored value in dictionary"
    context.findAnotherReceiver = true
    return valueToAssign

FLAtom.addMethod \
  (flParse "= ( valueToAssign )"),
  (context) ->
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

    theAtomName = @value

    console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
    console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

    context.isTransparent = true

    # check if temp variable is visible from here.
    # if not, create it.
    dictToPutAtomIn = context.lookUpAtomValuePlace @
    if !dictToPutAtomIn?
      # no such variable, hence we create it as temp, but
      # we can't create them in this very call context, that would
      # be useless, we place it in the context of the _previous_ context
      # note that this means that any construct that creates a new context
      # will seal the temp variables in it. For example "for" loops. This
      # is like the block scoping of C or Java. If you want function scoping, it
      # could be achieved for example by marking in a special way contexts
      # that have been created because of method calls and climbing back
      # to the last one of those...
      console.log "evaluation " + indentation() + "creating temp atom: " + theAtomName
      dictToPutAtomIn = context.firstNonTransparentContext().tempVariablesDict
    else
      console.log "evaluation " + indentation() + "found temp atom: " + theAtomName

    dictToPutAtomIn[ValidIDfromString theAtomName] = valueToAssign

    console.log "evaluation " + indentation() + "stored value in dictionary"
    context.findAnotherReceiver = true
    return valueToAssign


# Nil ---------------------------------------------------------------------------

FLNil.addMethod \
  (flParse "('anything)"),
  (context) ->
    anything = context.tempVariablesDict[ValidIDfromString "anything"]

    context.throwing = true
    # TODO this error should really be a stock error referanceable
    # from the workspace because someone might want to catch it.
    return FLException.createNew "message to nil: " + anything.print()


# In ---------------------------------------------------------------------------

FLIn.addMethod \
  (flParse "(object) do ('code)"),
  (context) ->
    object = context.tempVariablesDict[ValidIDfromString "object"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    newContext = new FLContext context, object

    toBeReturned = (code.eval newContext, code)[0].returned
    context.findAnotherReceiver = true

    return toBeReturned

# To -------------------------------------------------------------------------

# TODO it's be nice if there was a way not to leak the TempClass
FLTo.addMethod \
  (flParse "( ' functionObjectName ) ( ' signature ) do ( ' functionBody )"),
  flParse \
    "accessUpperContext; 'TempClass ← Class new;\
    TempClass answerEvalParams (signature) by (functionBody);\
    functionObjectName ← TempClass new;"

# Class -------------------------------------------------------------------------

# Class. There is only one object in the system that belongs to this class
# and it's also called "Class". We give this object the capacity to create
# new classes, via the "new" message below.

FLClass.addMethod \
  (flParse "print"),
  (context) ->
    console.log "///////// program printout: " + "Class object!"
    environmentPrintout += "Class_object"
    return @

FLClass.addMethod \
  (flParse "new"),
  (context) ->
    console.log "///////// creating a new class for the user!"

    newUserClass = new FLUserDefinedClass()

    # the class we are creating has a "new"
    # so user can create objects for it
    newUserClass.addMethod \
      (flParse "new"),
      (context) ->
        console.log "///////// creating a new object from a user class!"
        objectTBR = @createNew()
        console.log "///////// creating a new object from a user class - user class of object: " + objectTBR.flClass.value
        console.log "///////// creating a new object from a user class - objectTBR.value: " + objectTBR.value
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
        returnedContext = (objectTBR.findSignatureBindParamsAndMakeCall (flParse "whenNew"), context)[0]
        toBeReturned = returnedContext.returned
        return toBeReturned

    addDefaultMethods newUserClass

    return newUserClass

# Exception -------------------------------------------------------------------------

FLException.addMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew ""

FLException.addMethod \
  (flParse "initWith ( ' errorMessage )"),
  (context) ->
    errorMessage = context.tempVariablesDict[ValidIDfromString "errorMessage"]
    @value = errorMessage.value
    return @

FLException.addMethod \
  (flParse "catch all handle ( ' errorHandle )"),
  (context) ->
    errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

    console.log "catch: being thrown? " + context.throwing

    console.log "catch: got right exception, catching it"
    toBeReturned = (errorHandle.eval context, errorHandle)[0].returned
    context.findAnotherReceiver = true

    return toBeReturned

FLException.addMethod \
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

FLException.addMethod \
  (flParse "$$MATCHALL$$"),
  (context) ->
    console.log "exception - no more cacthes, has to be re-thrown"
    context.throwing = true
    return @


# String -------------------------------------------------------------------------

FLString.addMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew ""

FLString.addMethod \
  (flParse "+ ( stringToBeAppended )"),
  (context) ->
    stringToBeAppended = context.tempVariablesDict[ValidIDfromString "stringToBeAppended"]
    return FLString.createNew @value + stringToBeAppended.print()

# Number -------------------------------------------------------------------------

FLNumber.addMethod \
  (flParse "anotherPrint"),
  flParse "self print"

FLNumber.addMethod \
  (flParse "doublePrint"),
  flParse "self print print"

# mutates the very object
FLNumber.addMethod \
  (flParse "incrementInPlace"),
  # this one below actually mutates the number
  # object
  flParse "self ← self plus 1"

FLNumber.addMethod \
  (flParse "factorial"),
  flParse "( self == 0 ) ⇒ ( 1 ) ( self minus 1 ) factorial * self"

FLNumber.addMethod \
  (flParse "factorialtwo"),
  flParse "( self == 0 ) ⇒ ( 1 ) self * ( ( self minus 1 ) factorialtwo )"

FLNumber.addMethod \
  (flParse "factorialthree"),
  flParse "( self == 0 ) ⇒ ( 1 ) ('temp ← self; temp print; ( self minus 1 ) factorialthree * temp )"

FLNumber.addMethod \
  (flParse "factorialfour"),
  flParse \
    "( self == 0 ) ⇒ ( 1 ) ('temp ← self;\
    ( self minus 1 ) factorialfour * temp )"

FLNumber.addMethod \
  (flParse "factorialfive"),
  flParse \
    "( self == 0 ) ⇒ ( 1 ) (1 plus 1;'temp ← self;\
    ( self minus 1 ) factorialfive * temp )"

FLNumber.addMethod \
  (flParse "amIZero"),
  flParse "self == 0"

FLNumber.addMethod \
  (flParse "printAFromDeeperCall"),
  flParse "a print"

FLNumber.addMethod \
  (flParse "plus ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value + operandum.value

FLNumber.addMethod \
  (flParse "minus ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value - operandum.value

FLNumber.addMethod \
  (flParse "selftimesminusone"),
  flParse "self * self minus 1"

FLNumber.addMethod \
  (flParse "* ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
    return FLNumber.createNew @value * operandum.value

FLNumber.addMethod \
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


FLNumber.addMethod \
  (flParse "== ( toCompare )"),
  (context) ->
    toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
    if @value == toCompare.value
      return FLBoolean.createNew true
    else
      return FLBoolean.createNew false

# mutating the number
FLNumber.addMethod \
  (flParse "← ( valueToAssign )"),
  (context) ->
    console.log "evaluation " + indentation() + "assigning to number! "
    valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]
    @value = valueToAssign.value
    return @



# Boolean -------------------------------------------------------------------------

FLBoolean.addMethod \
  (flParse "negate"),
  (context) ->
    return FLBoolean.createNew !@value

FLBoolean.addMethod \
  (flParse "and ( operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLBoolean.createNew @value and operandum.value

FLBoolean.addMethod \
  (flParse "⇒ ( ' trueBranch )"),
  (context) ->
    context.isTransparent = true
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


FLBoolean.addMethod \
  (flParse "or ( operandum )"),
  (context) ->
    console.log "executing an or! "
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLBoolean.createNew @value or operandum.value


# FLQuote --------------------------------------------------------------------------

FLQuote.addMethod \
  (flParse "( ' operandum )"),
  (context) ->
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]

    if operandum.flClass == FLList
      operandum = operandum.evaluatedElementsList context

    return operandum


# Not --------------------------------------------------------------------------
FLNot.addMethod \
  (flParse "( operandum )"),
  flParse "operandum negate"

# List -------------------------------------------------------------------------

FLList.addMethod \
  (flParse "new"),
  (context) ->
    @flClass.createNew()

FLList.addMethod \
  (flParse "print"),
  (context) ->
    console.log "///////// program printout: " + @print()
    environmentPrintout += @print()
    return context

FLList.addMethod \
  (flParse "+ ( elementToBeAppended )"),
  (context) ->
    elementToBeAppended = context.tempVariablesDict[ValidIDfromString "elementToBeAppended"]
    return @flListImmutablePush elementToBeAppended

FLList.addMethod \
  (flParse "length"),
  (context) ->
    return FLNumber.createNew @length()

FLList.addMethod \
  (flParse "[ (indexValue) ] = (value)"),
  (context) ->
    indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
    value = context.tempVariablesDict[ValidIDfromString "value"]
    context.findAnotherReceiver = true
    return @elementAtSetMutable indexValue.value, value

FLList.addMethod \
  (flParse "[ (indexValue) ]"),
  (context) ->
    indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
    return @elementAt indexValue.value


FLList.addMethod \
  (flParse "each ( ' variable ) do ( ' code )"),
  (context) ->

    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    console.log "FLList each do "

    newContext = new FLContext context

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

FLDone.addMethod \
  (flParse "print"),
  (context) ->
    console.log "///////// program printout: " + "Done_object"
    environmentPrintout += "Done_object"
    return @


FLDone.addMethod \
  (flParse "with ( valueToReturn )"),
  (context) ->
    valueToReturn = context.tempVariablesDict[ValidIDfromString "valueToReturn"]

    @value = valueToReturn
    return @


# Repeat1 -------------------------------------------------------------------------

FLRepeat1.addMethod \
  (flParse "( ' loopCode )"),
  (context) ->
    context.isTransparent = true
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

FLRepeat2.addMethod \
  (flParse "(howManyTimes) do ( ' loopCode )"),
  (context) ->
    context.isTransparent = true
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

FLThrow.addMethod \
  (flParse "( theError )"),
  (context) ->
    theError = context.tempVariablesDict[ValidIDfromString "theError"]
    console.log "throwing an error: " + theError.value
    context.throwing = true
    return theError

# IfThen -----------------------------------------------------------------------------

FLIfThen.addMethod \
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

FLIfFallThrough.addMethod \
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

FLIfFallThrough.addMethod \
  (flParse "else ('trueBranch)"),
  (context) ->
    trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]

    toBeReturned = (trueBranch.eval context, trueBranch)[0].returned
    flContexts.pop()
    context.findAnotherReceiver = true
    return toBeReturned

FLIfFallThrough.addMethod \
  (flParse "$$MATCHALL$$"),
  (context) ->
    console.log "no more cases for the if"
    context.findAnotherReceiver = true
    return @


# FakeElse -----------------------------------------------------------------------------

FLFakeElse.addMethod \
  (flParse "else if ( predicate ) then ('trueBranch)"),
  (context) ->
    context.findAnotherReceiver = true
    return @

FLFakeElse.addMethod \
  (flParse "else ('trueBranch)"),
  (context) ->
    context.findAnotherReceiver = true
    return @



# Try -----------------------------------------------------------------------------

FLTry.addMethod \
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

FLFakeCatch.addMethod \
  (flParse "all handle ( ' errorHandle )"),
  (context) ->
    context.findAnotherReceiver = true
    return @

FLFakeCatch.addMethod \
  (flParse "( theError ) handle ( ' errorHandle )"),
  (context) ->
    context.findAnotherReceiver = true
    return @

# For -----------------------------------------------------------------------------

FLFor.addMethod \
  (flParse "( ' loopVar ) from ( startIndex ) to ( endIndex ) do ( ' loopCode )"),
  (context) ->
    context.isTransparent = true
    loopVar = context.tempVariablesDict[ValidIDfromString "loopVar"]
    startIndex = context.tempVariablesDict[ValidIDfromString "startIndex"]
    endIndex = context.tempVariablesDict[ValidIDfromString "endIndex"]
    loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]

    loopVarName = loopVar.value

    forContext = new FLContext context
    forContext.isTransparent = true
    flContexts.jsArrayPush forContext

    console.log "FLFor ⇒ loop code is: " + loopCode.print()

    for i in [startIndex.value..endIndex.value]
      console.log "FLFor ⇒ loop iterating variable to " + i

      # the looping var is always in the new local for context
      # so it keeps any previous instance safe, and goes
      # away when this for is done.
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
FLFor.addMethod \
  (flParse "each ( ' variable ) in ( theList ) do ( ' code )"),
  (context) ->
    context.isTransparent = true
    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    theList = context.tempVariablesDict[ValidIDfromString "theList"]
    code = context.tempVariablesDict[ValidIDfromString "code"]

    if theList.flClass != FLList
      context.throwing = true
      # TODO this error should really be a stock error referanceable
      # from the workspace because someone might want to catch it.
      return FLException.createNew "for...each expects a list"


    console.log "FLEach do on the list: " + theList.print()

    forContext = new FLContext context
    forContext.isTransparent = true

    for i in [0...theList.value.length]

      forContext.tempVariablesDict[ValidIDfromString variable.value] = theList.elementAt i
      console.log "FLEach do evaling...: " + code.print()
      toBeReturned = (code.eval forContext, code)[0].returned

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
