# methods for everybody ---------------------------------------------------------

### TBC why we can't share these for all instances yet
printPattern = flParse "print"
###

printFunction = (context) ->
  console.log "///////// program printout: " + @value
  environmentPrintout += @value
  return @


# Atom ---------------------------------------------------------------------------

FLAtom = new  FLAtomClass()

FLAtom.msgPatterns.push flParse "print"
FLAtom.methodBodies.push printFunction

FLAtom.msgPatterns.push flParse "<- ( valueToAssign )"
FLAtom.methodBodies.push (context) ->
  valueToAssign = context.tempVariablesDict[ValidID.fromString "valueToAssign"]

  theAtomName = @value

  console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
  console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

  dictToPutAtomIn = context.lookUpAtomValuePlace @
  dictToPutAtomIn[ValidID.fromString theAtomName] = valueToAssign

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
    signature = context.tempVariablesDict[ValidID.fromString "signature"]
    methodBody = context.tempVariablesDict[ValidID.fromString "methodBody"]

    @msgPatterns.push signature
    @methodBodies.push methodBody

    return @

  return newUserClass


# Number -------------------------------------------------------------------------

FLNumber.msgPatterns.push flParse "anotherPrint"
FLNumber.methodBodies.push flParse "self print"

FLNumber.msgPatterns.push flParse "doublePrint"
FLNumber.methodBodies.push flParse "self print print"

FLNumber.msgPatterns.push flParse "increment"
FLNumber.methodBodies.push flParse "@ self <- self plus 1"

FLNumber.msgPatterns.push flParse "factorial"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) ( self minus 1 ) factorial times self"

FLNumber.msgPatterns.push flParse "factorialtwo"
FLNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) self times ( ( self minus 1 ) factorial )"

FLNumber.msgPatterns.push flParse "amIZero"
FLNumber.methodBodies.push flParse "self == 0"

FLNumber.msgPatterns.push flParse "printAFromDeeperCall"
FLNumber.methodBodies.push flParse "a print"

FLNumber.msgPatterns.push flParse "print"
FLNumber.methodBodies.push printFunction

FLNumber.msgPatterns.push flParse "plus ( operandum )"
FLNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return FLNumber.createNew @value + operandum.value

FLNumber.msgPatterns.push flParse "minus ( operandum )"
FLNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return FLNumber.createNew @value - operandum.value

FLNumber.msgPatterns.push flParse "selftimesminusone"
FLNumber.methodBodies.push flParse "self times self minus 1"

FLNumber.msgPatterns.push flParse "times ( operandum )"
FLNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
  return FLNumber.createNew @value * operandum.value


FLNumber.msgPatterns.push flParse "== ( tocampare )"
FLNumber.methodBodies.push (context) ->
  tocampare = context.tempVariablesDict[ValidID.fromString "tocampare"]
  if @value == tocampare.value
    return FLBoolean.createNew true
  else
    return FLBoolean.createNew false


FLNumber.msgPatterns.push flParse "something ( param )"
FLNumber.msgPatterns.push flParse "somethingElse ( @ param )"

# Boolean -------------------------------------------------------------------------

FLBoolean.msgPatterns.push flParse "negate"
FLBoolean.methodBodies.push (context) ->
  return FLBoolean.createNew !@value

FLBoolean.msgPatterns.push flParse "print"
FLBoolean.methodBodies.push printFunction

FLBoolean.msgPatterns.push flParse "and ( operandum )"
FLBoolean.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return FLBoolean.createNew @value and operandum.value

FLBoolean.msgPatterns.push flParse "=> ( @ trueBranch )"
FLBoolean.methodBodies.push (context) ->
  trueBranch = context.tempVariablesDict[ValidID.fromString "trueBranch"]
  console.log "FLBoolean => , predicate value is: " + @value

  if @value
    newContext = new  FLContext context, @, FLList.emptyMessage()
    flContexts.push newContext
    [toBeReturned, unused2] = trueBranch.flEval newContext
    flContexts.pop()

    console.log "FLBoolean => returning result of true branch: " + toBeReturned
    console.log "FLBoolean => remaining message after true branch: " + context.message.print()
    console.log "FLBoolean => ...with PC:  " + context.programCounter
    console.log "FLBoolean => message length:  " + context.message.length()

    context.programCounter = context.message.length()


    return toBeReturned
  console.log "FLBoolean => returning null"
  return null

FLBoolean.msgPatterns.push flParse "or ( operandum )"
FLBoolean.methodBodies.push (context) ->
  console.log "executing an or! "
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return FLBoolean.createNew @value or operandum.value

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

  newContext = new  FLContext context, @, FLList.emptyMessage()
  flContexts.push newContext
  [toBeReturned, unused2] = @flEval newContext
  flContexts.pop()

  console.log "FLList.eval: unused2: " + unused2.print()
  return toBeReturned

# Done -------------------------------------------------------------------------

FLDone.msgPatterns.push flParse "print"
FLDone.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Done_object"
  environmentPrintout += "Done_object"
  return @


FLDone.msgPatterns.push flParse "with ( valueToReturn )"
FLDone.methodBodies.push (context) ->
  valueToReturn = context.tempVariablesDict[ValidID.fromString "valueToReturn"]
  @value = valueToReturn
  return @


# Repeat -------------------------------------------------------------------------

FLRepeat.msgPatterns.push flParse "print"
FLRepeat.methodBodies.push printFunction

FLRepeat.msgPatterns.push flParse "( @ loopCode )"
FLRepeat.methodBodies.push (context) ->
  loopCode = context.tempVariablesDict[ValidID.fromString "loopCode"]
  console.log "FLRepeat => , loop code is: " + loopCode.print()

  while true
    newContext = new  FLContext context, @, FLList.emptyMessage()
    flContexts.push newContext
    [toBeReturned, unused2] = loopCode.flEval newContext
    flContexts.pop()

    console.log "Repeat => returning result after loop cycle: " + toBeReturned
    console.dir toBeReturned
    console.log "Repeat => returning result CLASS after loop cycle: "
    console.dir toBeReturned.flClass
    console.log "Repeat => remaining message after loop cycle: " + context.message.print()
    console.log "Repeat => ...with PC:  " + context.programCounter
    console.log "Repeat => message length:  " + context.message.length()
    console.log "Repeat => did I receive a Done? " + (if toBeReturned?.flClass ==  FLDoneClass then "yes" else "no")

    if toBeReturned?
      if toBeReturned.flClass == FLDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Repeat => the loop exited with Done "
        break

  #context.programCounter = context.message.length()
  return toBeReturned


