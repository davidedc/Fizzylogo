# methods for everybody ---------------------------------------------------------

### TBC why we can't share these for all instances yet
printPattern = flParse "print"
###

printFunction = (context) ->
  console.log "///////// program printout: " + @value
  environmentPrintout += @value
  return @


# Atom ---------------------------------------------------------------------------

RAtom = new  FLAtomClass()

RAtom.msgPatterns.push flParse "print"
RAtom.methodBodies.push printFunction

RAtom.msgPatterns.push flParse "<- ( valueToAssign )"
RAtom.methodBodies.push (context) ->
  valueToAssign = context.tempVariablesDict[ValidID.fromString "valueToAssign"]

  theAtomName = @value

  console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
  console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

  dictToPutAtomIn = context.lookUpAtomValuePlace @
  dictToPutAtomIn[ValidID.fromString theAtomName] = valueToAssign

  console.log "evaluation " + indentation() + "stored value in dictionary"
  return valueToAssign

# Class -------------------------------------------------------------------------

RClass.msgPatterns.push flParse "print"
RClass.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Class object!"
  environmentPrintout += "Class_object"
  return @

RClass.msgPatterns.push flParse "new"
RClass.methodBodies.push (context) ->
  console.log "///////// creating a new class for the user!"

  newUserClass = RUserClass.createNew()

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

RNumber.msgPatterns.push flParse "anotherPrint"
RNumber.methodBodies.push flParse "self print"

RNumber.msgPatterns.push flParse "doublePrint"
RNumber.methodBodies.push flParse "self print print"

RNumber.msgPatterns.push flParse "increment"
RNumber.methodBodies.push flParse "@ self <- self plus 1"

RNumber.msgPatterns.push flParse "factorial"
RNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) ( self minus 1 ) factorial times self"

RNumber.msgPatterns.push flParse "factorialtwo"
RNumber.methodBodies.push flParse "( self == 0 ) => ( 1 ) self times ( ( self minus 1 ) factorial )"

RNumber.msgPatterns.push flParse "amIZero"
RNumber.methodBodies.push flParse "self == 0"

RNumber.msgPatterns.push flParse "printAFromDeeperCall"
RNumber.methodBodies.push flParse "a print"

RNumber.msgPatterns.push flParse "print"
RNumber.methodBodies.push printFunction

RNumber.msgPatterns.push flParse "plus ( operandum )"
RNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RNumber.createNew @value + operandum.value

RNumber.msgPatterns.push flParse "minus ( operandum )"
RNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RNumber.createNew @value - operandum.value

RNumber.msgPatterns.push flParse "selftimesminusone"
RNumber.methodBodies.push flParse "self times self minus 1"

RNumber.msgPatterns.push flParse "times ( operandum )"
RNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
  return RNumber.createNew @value * operandum.value


RNumber.msgPatterns.push flParse "== ( tocampare )"
RNumber.methodBodies.push (context) ->
  tocampare = context.tempVariablesDict[ValidID.fromString "tocampare"]
  if @value == tocampare.value
    return RBoolean.createNew true
  else
    return RBoolean.createNew false


RNumber.msgPatterns.push flParse "something ( param )"
RNumber.msgPatterns.push flParse "somethingElse ( @ param )"

# Boolean -------------------------------------------------------------------------

RBoolean.msgPatterns.push flParse "negate"
RBoolean.methodBodies.push (context) ->
  return RBoolean.createNew !@value

RBoolean.msgPatterns.push flParse "print"
RBoolean.methodBodies.push printFunction

RBoolean.msgPatterns.push flParse "and ( operandum )"
RBoolean.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RBoolean.createNew @value and operandum.value

RBoolean.msgPatterns.push flParse "=> ( @ trueBranch )"
RBoolean.methodBodies.push (context) ->
  trueBranch = context.tempVariablesDict[ValidID.fromString "trueBranch"]
  console.log "RBoolean => , predicate value is: " + @value

  if @value
    newContext = new  FLContext context, @, RList.emptyMessage()
    flContexts.push newContext
    [toBeReturned, unused2] = trueBranch.flEval newContext
    flContexts.pop()

    console.log "RBoolean => returning result of true branch: " + toBeReturned
    console.log "RBoolean => remaining message after true branch: " + context.message.print()
    console.log "RBoolean => ...with PC:  " + context.programCounter
    console.log "RBoolean => message length:  " + context.message.length()

    context.programCounter = context.message.length()


    return toBeReturned
  console.log "RBoolean => returning null"
  return null

RBoolean.msgPatterns.push flParse "or ( operandum )"
RBoolean.methodBodies.push (context) ->
  console.log "executing an or! "
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RBoolean.createNew @value or operandum.value

# Not --------------------------------------------------------------------------
RNot.msgPatterns.push flParse "( operandum )"
RNot.methodBodies.push flParse "operandum negate"

# List -------------------------------------------------------------------------

RList.msgPatterns.push flParse "print"
RList.methodBodies.push (context) ->
  console.log "///////// program printout: " + @print()
  environmentPrintout += @print()
  return context


RList.msgPatterns.push flParse "eval"
RList.methodBodies.push (context) ->

  newContext = new  FLContext context, @, RList.emptyMessage()
  flContexts.push newContext
  [toBeReturned, unused2] = @flEval newContext
  flContexts.pop()

  console.log "RList.eval: unused2: " + unused2.print()
  return toBeReturned

# Done -------------------------------------------------------------------------

RDone.msgPatterns.push flParse "print"
RDone.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Done_object"
  environmentPrintout += "Done_object"
  return @


RDone.msgPatterns.push flParse "with ( valueToReturn )"
RDone.methodBodies.push (context) ->
  valueToReturn = context.tempVariablesDict[ValidID.fromString "valueToReturn"]
  @value = valueToReturn
  return @


# Repeat -------------------------------------------------------------------------

RRepeat.msgPatterns.push flParse "print"
RRepeat.methodBodies.push printFunction

RRepeat.msgPatterns.push flParse "( @ loopCode )"
RRepeat.methodBodies.push (context) ->
  loopCode = context.tempVariablesDict[ValidID.fromString "loopCode"]
  console.log "RRepeat => , loop code is: " + loopCode.print()

  while true
    newContext = new  FLContext context, @, RList.emptyMessage()
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
      if toBeReturned.flClass == RDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Repeat => the loop exited with Done "
        break

  #context.programCounter = context.message.length()
  return toBeReturned


