# methods for everybody ---------------------------------------------------------

### TBC why we can't share these for all instances yet
printPattern = flParse "print"
###

commonFLPrintFunction = (context) ->
  console.log "///////// program printout: " + @value
  environmentPrintout += @value
  return @

commonFLdictFunction = (context) ->
  if !@flClass.tempVariables?
    @flClass.tempVariables = FLList.emptyList()
  return @flClass.tempVariables

commonFLIdictFunction = (context) ->
  if !@flClass.instanceVariables?
    @flClass.instanceVariables = FLList.emptyList()

  console.log "idict: context.self.flClass: "
  console.dir @flClass
  return @flClass.instanceVariables

commonFLCdictFunction = (context) ->
  if !@flClass.classVariables?
    @flClass.classVariables = FLList.emptyList()
  return @flClass.classVariables


# WorkSpace ---------------------------------------------------------------------------

FLWorkspace.msgPatterns.jsArrayPush flParse "cvarEvalParams ( variable ) <- ( value )"
FLWorkspace.methodBodies.jsArrayPush (context) ->
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


# Atom ---------------------------------------------------------------------------

FLAtom.msgPatterns.jsArrayPush flParse "print"
FLAtom.methodBodies.jsArrayPush commonFLPrintFunction

FLAtom.msgPatterns.jsArrayPush flParse "<- ( valueToAssign )"
FLAtom.methodBodies.jsArrayPush (context) ->
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

FLAtom.msgPatterns.jsArrayPush flParse "eval"
FLAtom.methodBodies.jsArrayPush (context) ->

  newContext = new FLContext context, context.self
  flContexts.jsArrayPush newContext
  toBeReturned = (@eval newContext).returned

  flContexts.pop()

  return toBeReturned

# Nil ---------------------------------------------------------------------------

FLNil.msgPatterns.jsArrayPush flParse "print"
FLNil.methodBodies.jsArrayPush commonFLPrintFunction

# To -------------------------------------------------------------------------

FLTo.msgPatterns.jsArrayPush flParse "( @ functionObjectName ) ( @ signature ) ( @ functionBody )"
FLTo.methodBodies.jsArrayPush flParse "@TempClass <- Class new. tempClass answerEvalParams (signature) by (functionBody). @functionObject <- TempClass new. WorkSpace cvarEvalParams (functionObjectName) <- functionObject"

# Class. There is only one object in the system that belongs to this class
# and it's also called "Class". We give this object the capacity to create
# new classes, via the "new" message below.

FLClass.msgPatterns.jsArrayPush flParse "print"
FLClass.methodBodies.jsArrayPush (context) ->
  console.log "///////// program printout: " + "Class object!"
  environmentPrintout += "Class_object"
  return @

FLClass.msgPatterns.jsArrayPush flParse "new"
FLClass.methodBodies.jsArrayPush (context) ->
  console.log "///////// creating a new class for the user!"

  newUserClass = new FLUserDefinedClass()

  newUserClass.msgPatterns.jsArrayPush flParse "print"
  newUserClass.methodBodies.jsArrayPush commonFLPrintFunction

  # the class we are creating has a "new"
  # so user can create objects for it
  newUserClass.msgPatterns.jsArrayPush flParse "new"
  newUserClass.methodBodies.jsArrayPush (context) ->
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


  newUserClass.msgPatterns.jsArrayPush flParse "answer ( @ signature ) by ( @ methodBody )"
  newUserClass.methodBodies.jsArrayPush (context) ->
    signature = context.tempVariablesDict[ValidIDfromString "signature"]
    methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

    @msgPatterns.jsArrayPush signature
    @methodBodies.jsArrayPush methodBody

    return @

  newUserClass.msgPatterns.jsArrayPush flParse "answerEvalParams ( signature ) by ( methodBody )"
  newUserClass.methodBodies.jsArrayPush (context) ->
    signature = context.tempVariablesDict[ValidIDfromString "signature"]
    methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

    @msgPatterns.jsArrayPush signature
    @methodBodies.jsArrayPush methodBody

    return @

  newUserClass.msgPatterns.jsArrayPush flParse "'s (@code)"
  newUserClass.methodBodies.jsArrayPush flParse "code eval"

  newUserClass.msgPatterns.jsArrayPush flParse "tdict"
  newUserClass.methodBodies.jsArrayPush commonFLdictFunction

  newUserClass.msgPatterns.jsArrayPush flParse "idict <- ( @ variable )"
  newUserClass.methodBodies.jsArrayPush (context) ->
    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    console.log "idict adding variable: @flClass.value " + @flClass.value
    if !@flClass.instanceVariables?
      @flClass.instanceVariables = FLList.emptyList()

    console.log "idict: context.self.flClass: "
    console.dir @flClass

    @flClass.instanceVariables = @flClass.instanceVariables.flListImmutablePush variable

    return @

  newUserClass.msgPatterns.jsArrayPush flParse "cvar ( @ variable ) <- ( value )"
  newUserClass.methodBodies.jsArrayPush (context) ->
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

  newUserClass.msgPatterns.jsArrayPush flParse "idict"
  newUserClass.methodBodies.jsArrayPush commonFLIdictFunction

  newUserClass.msgPatterns.jsArrayPush flParse "cdict"
  newUserClass.methodBodies.jsArrayPush commonFLCdictFunction

  return newUserClass


# String -------------------------------------------------------------------------

FLString.msgPatterns.jsArrayPush flParse "new"
FLString.methodBodies.jsArrayPush (context) ->
  return @flClass.createNew ""

FLString.msgPatterns.jsArrayPush flParse "print"
FLString.methodBodies.jsArrayPush commonFLPrintFunction

FLString.msgPatterns.jsArrayPush flParse "+ ( stringToBeAppended )"
FLString.methodBodies.jsArrayPush (context) ->
  stringToBeAppended = context.tempVariablesDict[ValidIDfromString "stringToBeAppended"]
  return FLString.createNew @value + stringToBeAppended.print()


FLString.msgPatterns.jsArrayPush flParse "eval"
FLString.methodBodies.jsArrayPush (context) ->

  newContext = new FLContext context, context.self
  flContexts.jsArrayPush newContext
  toBeReturned = (@eval newContext).returned

  flContexts.pop()

  return toBeReturned

# Number -------------------------------------------------------------------------

FLNumber.msgPatterns.jsArrayPush flParse "anotherPrint"
FLNumber.methodBodies.jsArrayPush flParse "self print"

FLNumber.msgPatterns.jsArrayPush flParse "anotherPrinttwo"
FLNumber.methodBodies.jsArrayPush flParse "(self print)"

FLNumber.msgPatterns.jsArrayPush flParse "anotherPrintthree"
FLNumber.methodBodies.jsArrayPush flParse "(((((((((self))) print))))))"

FLNumber.msgPatterns.jsArrayPush flParse "doublePrint"
FLNumber.methodBodies.jsArrayPush flParse "self print print"

FLNumber.msgPatterns.jsArrayPush flParse "increment"
FLNumber.methodBodies.jsArrayPush flParse "self <- self plus 1"

FLNumber.msgPatterns.jsArrayPush flParse "factorial"
FLNumber.methodBodies.jsArrayPush flParse "( self == 0 ) => ( 1 ) ( self minus 1 ) factorial * self"

FLNumber.msgPatterns.jsArrayPush flParse "factorialtwo"
FLNumber.methodBodies.jsArrayPush flParse "( self == 0 ) => ( 1 ) self * ( ( self minus 1 ) factorial )"

FLNumber.msgPatterns.jsArrayPush flParse "factorialthree"
FLNumber.methodBodies.jsArrayPush flParse "( self == 0 ) => ( 1 ) (@temp <- self. ( self minus 1 ) factorial * temp )"

FLNumber.msgPatterns.jsArrayPush flParse "factorialfour"
FLNumber.methodBodies.jsArrayPush flParse "( self == 0 ) => ( 1 ) (((((@temp <- self)))). ( self minus 1 ) factorial * temp )"

FLNumber.msgPatterns.jsArrayPush flParse "factorialfive"
FLNumber.methodBodies.jsArrayPush flParse "( self == 0 ) => ( 1 ) (1 plus 1.((((@temp <- self)))). ( self minus 1 ) factorial * temp )"

FLNumber.msgPatterns.jsArrayPush flParse "amIZero"
FLNumber.methodBodies.jsArrayPush flParse "self == 0"

FLNumber.msgPatterns.jsArrayPush flParse "printAFromDeeperCall"
FLNumber.methodBodies.jsArrayPush flParse "a print"

FLNumber.msgPatterns.jsArrayPush flParse "print"
FLNumber.methodBodies.jsArrayPush commonFLPrintFunction

FLNumber.msgPatterns.jsArrayPush flParse "plus ( operandum )"
FLNumber.methodBodies.jsArrayPush (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLNumber.createNew @value + operandum.value

FLNumber.msgPatterns.jsArrayPush flParse "minus ( operandum )"
FLNumber.methodBodies.jsArrayPush (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLNumber.createNew @value - operandum.value

FLNumber.msgPatterns.jsArrayPush flParse "selftimesminusone"
FLNumber.methodBodies.jsArrayPush flParse "self * self minus 1"

FLNumber.msgPatterns.jsArrayPush flParse "* ( operandum )"
FLNumber.methodBodies.jsArrayPush (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
  return FLNumber.createNew @value * operandum.value

FLNumber.msgPatterns.jsArrayPush flParse "times ( @ loopCode )"
FLNumber.methodBodies.jsArrayPush (context) ->
  loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
  console.log "FLNumber => DO loop code is: " + loopCode.print()

  for i in [0...@value]
    newContext = new FLContext context, context.self
    flContexts.jsArrayPush newContext
    toBeReturned = (loopCode.eval newContext).returned

    flContexts.pop()

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Do => the loop exited with Done "
        break

  return toBeReturned


FLNumber.msgPatterns.jsArrayPush flParse "== ( toCompare )"
FLNumber.methodBodies.jsArrayPush (context) ->
  toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
  if @value == toCompare.value
    return FLBoolean.createNew true
  else
    return FLBoolean.createNew false

FLNumber.msgPatterns.jsArrayPush flParse "<- ( valueToAssign )"
FLNumber.methodBodies.jsArrayPush (context) ->
  valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]
  @value = valueToAssign.value
  return @

FLNumber.msgPatterns.jsArrayPush flParse "tdict"
FLNumber.methodBodies.jsArrayPush commonFLdictFunction

FLNumber.msgPatterns.jsArrayPush flParse "idict"
FLNumber.methodBodies.jsArrayPush commonFLIdictFunction

FLNumber.msgPatterns.jsArrayPush flParse "cdict"
FLNumber.methodBodies.jsArrayPush commonFLCdictFunction

# Boolean -------------------------------------------------------------------------

FLBoolean.msgPatterns.jsArrayPush flParse "negate"
FLBoolean.methodBodies.jsArrayPush (context) ->
  return FLBoolean.createNew !@value

FLBoolean.msgPatterns.jsArrayPush flParse "print"
FLBoolean.methodBodies.jsArrayPush commonFLPrintFunction

FLBoolean.msgPatterns.jsArrayPush flParse "and ( operandum )"
FLBoolean.methodBodies.jsArrayPush (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLBoolean.createNew @value and operandum.value

FLBoolean.msgPatterns.jsArrayPush flParse "=> ( @ trueBranch )"
FLBoolean.methodBodies.jsArrayPush (context) ->
  trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
  console.log "FLBoolean => , predicate value is: " + @value

  if @value
    newContext = new FLContext context, context.self
    flContexts.jsArrayPush newContext
    toBeReturned = (trueBranch.eval newContext).returned
    flContexts.pop()

    console.log "FLBoolean => returning result of true branch: " + toBeReturned
    console.log "FLBoolean => remaining message after true branch: "
    console.log "FLBoolean => ...with PC:  " + context.programCounter
    console.log "FLBoolean => message length:  "

    # in this context we only have visibility of the true branch
    # but we have to make sure that in the context above the false
    # branch is never executed. So we "exhaust" the message in the
    # context above.
    context.previousContext.programCounter = Number.MAX_SAFE_INTEGER


    return toBeReturned
  console.log "FLBoolean => returning null"
  return null


FLBoolean.msgPatterns.jsArrayPush flParse "or ( operandum )"
FLBoolean.methodBodies.jsArrayPush (context) ->
  console.log "executing an or! "
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLBoolean.createNew @value or operandum.value

# any boolean with any left piece of code will just
# eval the code and return its result.
# this is how the false branch of => is executed in
#     predicate => (trueBranch) falseBranch
# for example, the => (true branch) is first
# consumed by the => call and the predicate result is
# returned, and then the predicate result (a false)
# receives the falseBranch, i.e. :
#   receiver: predicate result
#    message: falseBranch
# at which point, because of this below, the falseBranch
# is executed.
FLBoolean.msgPatterns.jsArrayPush flParse "(resultOfAnyOtherCode)"
FLBoolean.methodBodies.jsArrayPush (context) ->
  resultOfAnyOtherCode = context.tempVariablesDict[ValidIDfromString "resultOfAnyOtherCode"]
  return resultOfAnyOtherCode

# FLQuote --------------------------------------------------------------------------

FLQuote.msgPatterns.jsArrayPush flParse "( @ operandum )"
FLQuote.methodBodies.jsArrayPush (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return operandum

# Not --------------------------------------------------------------------------
FLNot.msgPatterns.jsArrayPush flParse "( operandum )"
FLNot.methodBodies.jsArrayPush flParse "operandum negate"

# List -------------------------------------------------------------------------

FLList.msgPatterns.jsArrayPush flParse "new"
FLList.methodBodies.jsArrayPush (context) ->
  return @flClass.createNew()

FLList.msgPatterns.jsArrayPush flParse "print"
FLList.methodBodies.jsArrayPush (context) ->
  console.log "///////// program printout: " + @print()
  environmentPrintout += @print()
  return context

FLList.msgPatterns.jsArrayPush flParse "eval"
FLList.methodBodies.jsArrayPush (context) ->

  newContext = new FLContext context, context.self
  flContexts.jsArrayPush newContext
  toBeReturned = (@eval newContext).returned

  flContexts.pop()

  return toBeReturned

FLList.msgPatterns.jsArrayPush flParse "+ ( elementToBeAppended )"
FLList.methodBodies.jsArrayPush (context) ->
  elementToBeAppended = context.tempVariablesDict[ValidIDfromString "elementToBeAppended"]
  return @flListImmutablePush elementToBeAppended


FLList.msgPatterns.jsArrayPush flParse "each ( @ variable ) do ( @ code )"
FLList.methodBodies.jsArrayPush (context) ->

  variable = context.tempVariablesDict[ValidIDfromString "variable"]
  code = context.tempVariablesDict[ValidIDfromString "code"]

  console.log "FLNumber each do "

  newContext = new FLContext context, context.self


  newContext.self.flClass.tempVariables = newContext.self.flClass.tempVariables.flListImmutablePush variable

  for i in [0...@value.length]

    newContext.tempVariablesDict[ValidIDfromString variable.value] = @elementAt i
    toBeReturned = (code.eval newContext).returned

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "each... do loop exited with Done "
        break

  return toBeReturned


# Done -------------------------------------------------------------------------

FLDone.msgPatterns.jsArrayPush flParse "print"
FLDone.methodBodies.jsArrayPush (context) ->
  console.log "///////// program printout: " + "Done_object"
  environmentPrintout += "Done_object"
  return @


FLDone.msgPatterns.jsArrayPush flParse "with ( valueToReturn )"
FLDone.methodBodies.jsArrayPush (context) ->
  valueToReturn = context.tempVariablesDict[ValidIDfromString "valueToReturn"]
  @value = valueToReturn
  return @


# Repeat -------------------------------------------------------------------------

FLRepeat.msgPatterns.jsArrayPush flParse "print"
FLRepeat.methodBodies.jsArrayPush commonFLPrintFunction

FLRepeat.msgPatterns.jsArrayPush flParse "( @ loopCode )"
FLRepeat.methodBodies.jsArrayPush (context) ->
  loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
  console.log "FLRepeat => , loop code is: " + loopCode.print()

  while true
    newContext = new FLContext context, context.self
    flContexts.jsArrayPush newContext
    toBeReturned = (loopCode.eval newContext).returned

    flContexts.pop()

    console.log "Repeat => returning result after loop cycle: " + toBeReturned
    console.dir toBeReturned
    console.log "Repeat => returning result CLASS after loop cycle: "
    console.dir toBeReturned.flClass
    console.log "Repeat => remaining message after loop cycle: "
    console.log "Repeat => ...with PC:  " + context.programCounter
    console.log "Repeat => message length:  "
    console.log "Repeat => did I receive a Done? " + (if toBeReturned?.flClass == FLDoneClass then "yes" else "no")

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Repeat => the loop exited with Done "
        break

  return toBeReturned

# For -----------------------------------------------------------------------------

FLFor.msgPatterns.jsArrayPush flParse "( @ loopVar ) <- ( startIndex ) to ( endIndex ) do ( @ loopCode )"
FLFor.methodBodies.jsArrayPush (context) ->


  loopVar = context.tempVariablesDict[ValidIDfromString "loopVar"]
  startIndex = context.tempVariablesDict[ValidIDfromString "startIndex"]
  endIndex = context.tempVariablesDict[ValidIDfromString "endIndex"]
  loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]

  loopVarName = loopVar.value

  forContext = new FLContext context, context.self
  forContext.self.flClass.tempVariables = forContext.self.flClass.tempVariables.flListImmutablePush loopVar
  flContexts.jsArrayPush forContext

  console.log "FLFor => loop code is: " + loopCode.print()

  for i in [startIndex.value..endIndex.value]
    console.log "FLFor => loop iterating variable to " + i

    forContext.tempVariablesDict[ValidIDfromString loopVarName] = FLNumber.createNew i

    newContext = new FLContext forContext, forContext.self
    flContexts.jsArrayPush newContext
    toBeReturned = (loopCode.eval newContext).returned

    flContexts.pop()

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "For => the loop exited with Done "
        break

  flContexts.pop()

  return toBeReturned

