# methods for everybody ---------------------------------------------------------

### TBC why we can't share these for all instances yet
printPattern = flParse "print"
###

printFunction = (context) ->
  console.log "///////// program printout: " + @value
  environmentPrintout += @value
  return @


# Atom ---------------------------------------------------------------------------

FLAtom = new FLAtomClass()

FLAtom.msgPatterns.push flParse "print"
FLAtom.methodBodies.push printFunction

FLAtom.msgPatterns.push flParse "<- ( valueToAssign )"
FLAtom.methodBodies.push (context) ->
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

# Class -------------------------------------------------------------------------

FLClass.msgPatterns.push flParse "print"
FLClass.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Class object!"
  environmentPrintout += "Class_object"
  return @

FLClass.msgPatterns.push flParse "new"
FLClass.methodBodies.push (context) ->
  console.log "///////// creating a new class for the user!"

  newUserClass = FLUserClass.createNew()

  newUserClass.msgPatterns.push flParse "print"
  newUserClass.methodBodies.push printFunction

  # the class we are creating has a "new"
  # so user can create objects for it
  newUserClass.msgPatterns.push flParse "new"
  newUserClass.methodBodies.push (context) ->
    console.log "///////// creating a new object from a user class!"
    return @createNew()


  newUserClass.msgPatterns.push flParse "answer ( @ signature ) by ( @ methodBody )"
  newUserClass.methodBodies.push (context) ->
    signature = context.tempVariablesDict[ValidIDfromString "signature"]
    methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

    @msgPatterns.push signature
    @methodBodies.push methodBody

    return @

  return newUserClass

# String -------------------------------------------------------------------------

FLString.msgPatterns.push flParse "print"
FLString.methodBodies.push printFunction


# Number -------------------------------------------------------------------------

FLNumber.msgPatterns.push flParse "anotherPrint"
FLNumber.methodBodies.push flParse "self print"

FLNumber.msgPatterns.push flParse "anotherPrinttwo"
FLNumber.methodBodies.push flParse "(self print)"

FLNumber.msgPatterns.push flParse "anotherPrintthree"
FLNumber.methodBodies.push flParse "(((((((((self))) print))))))"

FLNumber.msgPatterns.push flParse "doublePrint"
FLNumber.methodBodies.push flParse "self print print"

FLNumber.msgPatterns.push flParse "increment"
FLNumber.methodBodies.push flParse "self <- self plus 1"

FLNumber.msgPatterns.push flParse "factorial"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) ( self minus 1 ) factorial * self"

FLNumber.msgPatterns.push flParse "factorialtwo"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) self * ( ( self minus 1 ) factorial )"

FLNumber.msgPatterns.push flParse "factorialthree"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) (@temp <- self. ( self minus 1 ) factorial * temp )"

FLNumber.msgPatterns.push flParse "factorialfour"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) (((((@temp <- self)))). ( self minus 1 ) factorial * temp )"

FLNumber.msgPatterns.push flParse "factorialfive"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) (1 plus 1.((((@temp <- self)))). ( self minus 1 ) factorial * temp )"

FLNumber.msgPatterns.push flParse "amIZero"
FLNumber.methodBodies.push flParse "self == 0"

FLNumber.msgPatterns.push flParse "printAFromDeeperCall"
FLNumber.methodBodies.push flParse "a print"

FLNumber.msgPatterns.push flParse "print"
FLNumber.methodBodies.push printFunction

FLNumber.msgPatterns.push flParse "plus ( operandum )"
FLNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLNumber.createNew @value + operandum.value

FLNumber.msgPatterns.push flParse "minus ( operandum )"
FLNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLNumber.createNew @value - operandum.value

FLNumber.msgPatterns.push flParse "selftimesminusone"
FLNumber.methodBodies.push flParse "self * self minus 1"

FLNumber.msgPatterns.push flParse "* ( operandum )"
FLNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
  return FLNumber.createNew @value * operandum.value

FLNumber.msgPatterns.push flParse "times ( @ loopCode )"
FLNumber.methodBodies.push (context) ->
  loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
  console.log "FLNumber => DO loop code is: " + loopCode.print()

  for i in [0...@value]
    newContext = new FLContext context, context.self, FLList.emptyMessage()
    flContexts.push newContext
    toBeReturned = (loopCode.eval newContext).returned

    flContexts.pop()

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Do => the loop exited with Done "
        break

  return toBeReturned


FLNumber.msgPatterns.push flParse "== ( toCompare )"
FLNumber.methodBodies.push (context) ->
  toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
  if @value == toCompare.value
    return FLBoolean.createNew true
  else
    return FLBoolean.createNew false

FLNumber.msgPatterns.push flParse "<- ( valueToAssign )"
FLNumber.methodBodies.push (context) ->
  valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]
  @value = valueToAssign.value
  return @

FLNumber.msgPatterns.push flParse "tdict"
FLNumber.methodBodies.push (context) ->
  if !@flClass.tempVariables?
    @flClass.tempVariables = FLList.emptyMessage()
  return @flClass.tempVariables

FLNumber.msgPatterns.push flParse "idict"
FLNumber.methodBodies.push (context) ->

  if !@flClass.instanceVariables?
    @flClass.instanceVariables = FLList.emptyMessage()

  console.log "idict: context.self.flClass: "
  console.dir @flClass
  return @flClass.instanceVariables

FLNumber.msgPatterns.push flParse "cdict"
FLNumber.methodBodies.push (context) ->
  if !@flClass.classVariables?
    @flClass.classVariables = FLList.emptyMessage()
  return @flClass.classVariables

# Boolean -------------------------------------------------------------------------

FLBoolean.msgPatterns.push flParse "negate"
FLBoolean.methodBodies.push (context) ->
  return FLBoolean.createNew !@value

FLBoolean.msgPatterns.push flParse "print"
FLBoolean.methodBodies.push printFunction

FLBoolean.msgPatterns.push flParse "and ( operandum )"
FLBoolean.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return FLBoolean.createNew @value and operandum.value

FLBoolean.msgPatterns.push flParse "=> ( @ trueBranch )"
FLBoolean.methodBodies.push (context) ->
  trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
  console.log "FLBoolean => , predicate value is: " + @value

  if @value
    newContext = new FLContext context, context.self, FLList.emptyMessage()
    flContexts.push newContext
    toBeReturned = (trueBranch.eval newContext).returned
    flContexts.pop()

    console.log "FLBoolean => returning result of true branch: " + toBeReturned
    console.log "FLBoolean => remaining message after true branch: " + context.message.print()
    console.log "FLBoolean => ...with PC:  " + context.programCounter
    console.log "FLBoolean => message length:  " + context.message.length()

    # in this context we only have visibility of the true branch
    # but we have to make sure that in the context above the false
    # branch is never executed. So we "exhaust" the message in the
    # context above.
    context.previousContext.programCounter = context.previousContext.message.length()


    return toBeReturned
  console.log "FLBoolean => returning null"
  return null


FLBoolean.msgPatterns.push flParse "or ( operandum )"
FLBoolean.methodBodies.push (context) ->
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
FLBoolean.msgPatterns.push flParse "(resultOfAnyOtherCode)"
FLBoolean.methodBodies.push (context) ->
  resultOfAnyOtherCode = context.tempVariablesDict[ValidIDfromString "resultOfAnyOtherCode"]
  return resultOfAnyOtherCode

# FLQuote --------------------------------------------------------------------------

FLQuote.msgPatterns.push flParse "( @ operandum )"
FLQuote.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
  return operandum

# Not --------------------------------------------------------------------------
FLNot.msgPatterns.push flParse "( operandum )"
FLNot.methodBodies.push flParse "operandum negate"

# List -------------------------------------------------------------------------

FLList.msgPatterns.push flParse "print"
FLList.methodBodies.push (context) ->
  console.log "///////// program printout: " + @print()
  environmentPrintout += @print()
  return context


FLList.msgPatterns.push flParse "eval"
FLList.methodBodies.push (context) ->

  newContext = new FLContext context, context.self, FLList.emptyMessage()
  flContexts.push newContext
  toBeReturned = (@eval newContext).returned

  flContexts.pop()

  return toBeReturned

# Done -------------------------------------------------------------------------

FLDone.msgPatterns.push flParse "print"
FLDone.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Done_object"
  environmentPrintout += "Done_object"
  return @


FLDone.msgPatterns.push flParse "with ( valueToReturn )"
FLDone.methodBodies.push (context) ->
  valueToReturn = context.tempVariablesDict[ValidIDfromString "valueToReturn"]
  @value = valueToReturn
  return @


# Repeat -------------------------------------------------------------------------

FLRepeat.msgPatterns.push flParse "print"
FLRepeat.methodBodies.push printFunction

FLRepeat.msgPatterns.push flParse "( @ loopCode )"
FLRepeat.methodBodies.push (context) ->
  loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
  console.log "FLRepeat => , loop code is: " + loopCode.print()

  while true
    newContext = new FLContext context, context.self, FLList.emptyMessage()
    flContexts.push newContext
    toBeReturned = (loopCode.eval newContext).returned

    flContexts.pop()

    console.log "Repeat => returning result after loop cycle: " + toBeReturned
    console.dir toBeReturned
    console.log "Repeat => returning result CLASS after loop cycle: "
    console.dir toBeReturned.flClass
    console.log "Repeat => remaining message after loop cycle: " + context.message.print()
    console.log "Repeat => ...with PC:  " + context.programCounter
    console.log "Repeat => message length:  " + context.message.length()
    console.log "Repeat => did I receive a Done? " + (if toBeReturned?.flClass == FLDoneClass then "yes" else "no")

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Repeat => the loop exited with Done "
        break

  #context.programCounter = context.message.length()
  return toBeReturned

# For -----------------------------------------------------------------------------

FLFor.msgPatterns.push flParse "( @ loopVar ) <- ( startIndex ) to ( endIndex ) do ( @ loopCode )"
FLFor.methodBodies.push (context) ->


  loopVar = context.tempVariablesDict[ValidIDfromString "loopVar"]
  startIndex = context.tempVariablesDict[ValidIDfromString "startIndex"]
  endIndex = context.tempVariablesDict[ValidIDfromString "endIndex"]
  loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]

  loopVarName = loopVar.value

  forContext = new FLContext context, context.self, FLList.emptyMessage()
  forContext.self.flClass.tempVariables.push loopVar
  flContexts.push forContext

  console.log "FLFor => loop code is: " + loopCode.print()

  for i in [startIndex.value..endIndex.value]
    console.log "FLFor => loop iterating variable to " + i

    forContext.tempVariablesDict[ValidIDfromString loopVarName] = FLNumber.createNew i

    newContext = new FLContext forContext, forContext.self, FLList.emptyMessage()
    flContexts.push newContext
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

