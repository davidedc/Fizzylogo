rosettaParse = (command) ->
  listsStack = []
  outerList = RList.createNew()
  listsStack.push outerList
  currentList = outerList

  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    console.log "eachToken: " + eachToken

    if /^\.$/.test(eachToken)
      console.log eachToken + " is . symbol"
      currentList.push RStatementSeparatorSymbol
    else if /^\d+$/.test(eachToken)
      console.log eachToken + " is a Number"
      currentList.push (RNumber.createNew eachToken)
    else if /^\($/.test(eachToken)
      nestedList = RList.createNew()
      currentList.push nestedList
      listsStack.push currentList
      currentList = nestedList
    else if /^\)$/.test(eachToken)
      currentList = listsStack.pop()
    else
      console.log eachToken + " is something else"
      currentList.push RAtom.createNew eachToken

  return outerList


