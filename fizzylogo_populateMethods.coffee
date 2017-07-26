# Atom ---------------------------------------------------------------------------

RAtom = new RosettaAtomClass()

RAtom.msgPatterns.push rosettaParse "print"
RAtom.methodBodies.push (context) ->
  console.log "///////// program printout (RAtom) : " + @value
  environmentPrintout += @value
  return @

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

environmentPrintout = ""
RNumber.msgPatterns.push rosettaParse "print"
RNumber.methodBodies.push (context) ->
  console.log "///////// program printout: " + @value
  environmentPrintout += @value
  return @



RNumber.msgPatterns.push rosettaParse "plus ( addendum )"
RNumber.methodBodies.push (context) ->
  addendum = context.tempVariablesDict.addendum
  @value += addendum.value
  return @

RNumber.msgPatterns.push rosettaParse "something ( param )"
RNumber.msgPatterns.push rosettaParse "somethingElse ( @ param )"

# List -------------------------------------------------------------------------

RList.msgPatterns.push rosettaParse "print"
RList.methodBodies.push (context) ->
  console.log "///////// program printout: " + @print()
  environmentPrintout += @print()
  return context.returned


RList.msgPatterns.push rosettaParse "eval"
RList.methodBodies.push (theContext) ->

  newContext = new RosettaContext theContext, @, emptyMessage()
  rosettaContexts.push newContext
  [toBeReturned, unused2] = @rosettaEval newContext
  rosettaContexts.pop()

  console.log "RList.eval: unused2: " + unused2.print()
  return toBeReturned
