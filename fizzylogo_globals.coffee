indentation = ->
  return " ".repeat(rosettaContexts.length * 2)

rosettaParse = (command) ->
  listsStack = []
  outerList = RList.createNew()
  listsStack.push outerList
  currentList = outerList

  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    console.log "eachToken: " + eachToken

    if /true/.test(eachToken)
      console.log eachToken + " is Boolean true"
      currentList.push (RBoolean.createNew true)
    else if /false/.test(eachToken)
      console.log eachToken + " is Boolean false"
      currentList.push (RBoolean.createNew false)
    else if /[a-zA-Z]+/.test(eachToken)
      console.log eachToken + " is an Atom"
      currentList.push (RAtom.createNew eachToken)
    else if /@/.test(eachToken)
      console.log eachToken + " is @ symbol"
      currentList.push RLiteralSymbol
    else if /\./.test(eachToken)
      console.log eachToken + " is . symbol"
      currentList.push RStatementSeparatorSymbol
    else if /<-/.test(eachToken)
      console.log eachToken + " is <- symbol"
      currentList.push RAssignmentSymbol

    else if /==/.test(eachToken)
      console.log eachToken + " is == symbol"
      currentList.push REqualityOperatorSymbol
    else if /!=/.test(eachToken)
      console.log eachToken + " is != symbol"
      currentList.push RInequalityOperatorSymbol
    else if /</.test(eachToken)
      console.log eachToken + " is < symbol"
      currentList.push RLessThanOperatorSymbol
    else if /<=/.test(eachToken)
      console.log eachToken + " is <= symbol"
      currentList.push RLessOrEqualThanOperatorSymbol
    else if />/.test(eachToken)
      console.log eachToken + " is > symbol"
      currentList.push RMoreThanOperatorSymbol
    else if />=/.test(eachToken)
      console.log eachToken + " is >= symbol"
      currentList.push RMoreOrEqualThanOperatorSymbol

    else if /\d+/.test(eachToken)
      console.log eachToken + " is a Number"
      currentList.push (RNumber.createNew eachToken)
    else if /\(/.test(eachToken)
      nestedList = RList.createNew()
      currentList.push nestedList
      listsStack.push currentList
      currentList = nestedList
    else if /\)/.test(eachToken)
      currentList = listsStack.pop()
  return outerList


