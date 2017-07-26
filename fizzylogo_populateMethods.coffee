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
  valueToAssign = context.tempVariablesDict.valueToAssign

  theAtomName = @value

  console.log "evaluation " + indentation() + "assignment to atom " + theAtomName
  console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + valueToAssign.value

  dictToPutAtomIn = context.lookUpAtomValuePlace @
  dictToPutAtomIn[theAtomName] = valueToAssign

  console.log "evaluation " + indentation() + "stored value in dictionary"
  return valueToAssign

# Number -------------------------------------------------------------------------

RNumber.msgPatterns.push rosettaParse "anotherPrint"
RNumber.methodBodies.push rosettaParse "self print"

RNumber.msgPatterns.push rosettaParse "doublePrint"
RNumber.methodBodies.push rosettaParse "self print print"

RNumber.msgPatterns.push rosettaParse "increment"
RNumber.methodBodies.push rosettaParse "@ self <- self plus 1"

RNumber.msgPatterns.push rosettaParse "print"
RNumber.methodBodies.push printFunction


RNumber.msgPatterns.push rosettaParse "plus ( addendum )"
RNumber.methodBodies.push (context) ->
  addendum = context.tempVariablesDict.addendum
  @value += addendum.value
  return @

RNumber.msgPatterns.push rosettaParse "something ( param )"
RNumber.msgPatterns.push rosettaParse "somethingElse ( @ param )"

# Boolean -------------------------------------------------------------------------

RBoolean.msgPatterns.push rosettaParse "negate"
RBoolean.methodBodies.push (context) ->
  @value = !@value
  return @

RBoolean.msgPatterns.push rosettaParse "print"
RBoolean.methodBodies.push printFunction

RBoolean.msgPatterns.push rosettaParse "and ( operandum )"
RBoolean.methodBodies.push (context) ->
  operandum = context.tempVariablesDict.operandum
  @value = @value and operandum.value
  return @

RBoolean.msgPatterns.push rosettaParse "=> ( @ trueBranch )"
RBoolean.methodBodies.push (context) ->
  trueBranch = context.tempVariablesDict.trueBranch
  console.log "RBoolean => , predicate value is: " + @value

  if @value
    newContext = new RosettaContext context, @, RList.emptyMessage()
    rosettaContexts.push newContext
    [toBeReturned, unused2] = trueBranch.rosettaEval newContext
    rosettaContexts.pop()

    console.log "RBoolean => returning result of true branch: " + toBeReturned
    return toBeReturned
  console.log "RBoolean => returning null"
  return null

RBoolean.msgPatterns.push rosettaParse "or ( operandum )"
RBoolean.methodBodies.push (context) ->
  operandum = context.tempVariablesDict.operandum
  @value = @value or operandum.value
  return @

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
