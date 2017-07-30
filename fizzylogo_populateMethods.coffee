# methods for everybody ---------------------------------------------------------

### TBC why we can't share these for all instances yet
printPattern = rosettaParse "print"
###

printFunction = (context) ->
  console.log "///////// program printout: " + @value
  environmentPrintout += @value
  return @


# Atom ---------------------------------------------------------------------------

RAtom = new RosettaAtomClass()

RAtom.msgPatterns.push rosettaParse "print"
RAtom.methodBodies.push printFunction

RAtom.msgPatterns.push rosettaParse "<- ( valueToAssign )"
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

RClass.msgPatterns.push rosettaParse "print"
RClass.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Class object!"
  environmentPrintout += "Class_object"
  return @

RClass.msgPatterns.push rosettaParse "new"
RClass.methodBodies.push (context) ->
  console.log "///////// creating a new class for the user!"

  newUserClass = RUserClass.createNew()

  newUserClass.msgPatterns.push rosettaParse "print"
  newUserClass.methodBodies.push printFunction

  # the class we are creating has a "new"
  # so user can create objects for it
  newUserClass.msgPatterns.push rosettaParse "new"
  newUserClass.methodBodies.push (context) ->
    console.log "///////// creating a new object from a user class!"
    return @createNew()


  newUserClass.msgPatterns.push rosettaParse "answer ( @ signature ) by ( @ methodBody )"
  newUserClass.methodBodies.push (context) ->
    signature = context.tempVariablesDict[ValidID.fromString "signature"]
    methodBody = context.tempVariablesDict[ValidID.fromString "methodBody"]

    @msgPatterns.push signature
    @methodBodies.push methodBody

    return @

  return newUserClass


# Number -------------------------------------------------------------------------

RNumber.msgPatterns.push rosettaParse "anotherPrint"
RNumber.methodBodies.push rosettaParse "self print"

RNumber.msgPatterns.push rosettaParse "doublePrint"
RNumber.methodBodies.push rosettaParse "self print print"

RNumber.msgPatterns.push rosettaParse "increment"
RNumber.methodBodies.push rosettaParse "@ self <- self plus 1"

RNumber.msgPatterns.push rosettaParse "factorial"
RNumber.methodBodies.push rosettaParse "( self == 0 ) => ( 1 ) ( self minus 1 ) factorial times self"

RNumber.msgPatterns.push rosettaParse "factorialtwo"
RNumber.methodBodies.push rosettaParse "( self == 0 ) => ( 1 ) self times ( ( self minus 1 ) factorial )"

RNumber.msgPatterns.push rosettaParse "amIZero"
RNumber.methodBodies.push rosettaParse "self == 0"

RNumber.msgPatterns.push rosettaParse "printAFromDeeperCall"
RNumber.methodBodies.push rosettaParse "a print"

RNumber.msgPatterns.push rosettaParse "print"
RNumber.methodBodies.push printFunction

RNumber.msgPatterns.push rosettaParse "plus ( operandum )"
RNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RNumber.createNew @value + operandum.value

RNumber.msgPatterns.push rosettaParse "minus ( operandum )"
RNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RNumber.createNew @value - operandum.value

RNumber.msgPatterns.push rosettaParse "selftimesminusone"
RNumber.methodBodies.push rosettaParse "self times self minus 1"

RNumber.msgPatterns.push rosettaParse "times ( operandum )"
RNumber.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  console.log "evaluation " + indentation() + "multiplying " + @value + " to " + operandum.value  
  return RNumber.createNew @value * operandum.value


RNumber.msgPatterns.push rosettaParse "== ( tocampare )"
RNumber.methodBodies.push (context) ->
  tocampare = context.tempVariablesDict[ValidID.fromString "tocampare"]
  if @value == tocampare.value
    return RBoolean.createNew true
  else
    return RBoolean.createNew false


RNumber.msgPatterns.push rosettaParse "something ( param )"
RNumber.msgPatterns.push rosettaParse "somethingElse ( @ param )"

# Boolean -------------------------------------------------------------------------

RBoolean.msgPatterns.push rosettaParse "negate"
RBoolean.methodBodies.push (context) ->
  return RBoolean.createNew !@value

RBoolean.msgPatterns.push rosettaParse "print"
RBoolean.methodBodies.push printFunction

RBoolean.msgPatterns.push rosettaParse "and ( operandum )"
RBoolean.methodBodies.push (context) ->
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RBoolean.createNew @value and operandum.value

RBoolean.msgPatterns.push rosettaParse "=> ( @ trueBranch )"
RBoolean.methodBodies.push (context) ->
  trueBranch = context.tempVariablesDict[ValidID.fromString "trueBranch"]
  console.log "RBoolean => , predicate value is: " + @value

  if @value
    newContext = new RosettaContext context, @, RList.emptyMessage()
    rosettaContexts.push newContext
    [toBeReturned, unused2] = trueBranch.rosettaEval newContext
    rosettaContexts.pop()

    console.log "RBoolean => returning result of true branch: " + toBeReturned
    console.log "RBoolean => remaining message after true branch: " + context.message.print()
    console.log "RBoolean => ...with PC:  " + context.programCounter
    console.log "RBoolean => message length:  " + context.message.length()

    context.programCounter = context.message.length()


    return toBeReturned
  console.log "RBoolean => returning null"
  return null

RBoolean.msgPatterns.push rosettaParse "or ( operandum )"
RBoolean.methodBodies.push (context) ->
  console.log "executing an or! "
  operandum = context.tempVariablesDict[ValidID.fromString "operandum"]
  return RBoolean.createNew @value or operandum.value

# Not --------------------------------------------------------------------------
RNot.msgPatterns.push rosettaParse "( operandum )"
RNot.methodBodies.push rosettaParse "operandum negate"

# List -------------------------------------------------------------------------

RList.msgPatterns.push rosettaParse "print"
RList.methodBodies.push (context) ->
  console.log "///////// program printout: " + @print()
  environmentPrintout += @print()
  return context


RList.msgPatterns.push rosettaParse "eval"
RList.methodBodies.push (context) ->

  newContext = new RosettaContext context, @, RList.emptyMessage()
  rosettaContexts.push newContext
  [toBeReturned, unused2] = @rosettaEval newContext
  rosettaContexts.pop()

  console.log "RList.eval: unused2: " + unused2.print()
  return toBeReturned

# Done -------------------------------------------------------------------------

RDone.msgPatterns.push rosettaParse "print"
RDone.methodBodies.push (context) ->
  console.log "///////// program printout: " + "Done_object"
  environmentPrintout += "Done_object"
  return @


RDone.msgPatterns.push rosettaParse "with ( valueToReturn )"
RDone.methodBodies.push (context) ->
  valueToReturn = context.tempVariablesDict[ValidID.fromString "valueToReturn"]
  @value = valueToReturn
  return @


# Repeat -------------------------------------------------------------------------

RRepeat.msgPatterns.push rosettaParse "print"
RRepeat.methodBodies.push printFunction

RRepeat.msgPatterns.push rosettaParse "( @ loopCode )"
RRepeat.methodBodies.push (context) ->
  loopCode = context.tempVariablesDict[ValidID.fromString "loopCode"]
  console.log "RRepeat => , loop code is: " + loopCode.print()

  while true
    newContext = new RosettaContext context, @, RList.emptyMessage()
    rosettaContexts.push newContext
    [toBeReturned, unused2] = loopCode.rosettaEval newContext
    rosettaContexts.pop()

    console.log "Repeat => returning result after loop cycle: " + toBeReturned
    console.dir toBeReturned
    console.log "Repeat => returning result CLASS after loop cycle: "
    console.dir toBeReturned.rosettaClass
    console.log "Repeat => remaining message after loop cycle: " + context.message.print()
    console.log "Repeat => ...with PC:  " + context.programCounter
    console.log "Repeat => message length:  " + context.message.length()
    console.log "Repeat => did I receive a Done? " + (if toBeReturned?.rosettaClass == RosettaDoneClass then "yes" else "no")

    if toBeReturned?
      if toBeReturned.rosettaClass == RDone
        if toBeReturned.value?
          toBeReturned = toBeReturned.value
        console.log "Repeat => the loop exited with Done "
        break

  #context.programCounter = context.message.length()
  return toBeReturned


