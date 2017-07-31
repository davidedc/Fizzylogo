rosettaParse = (command) ->
  listsStack = []
  outerList = RList.createNew()
  listsStack.push outerList
  currentList = outerList

  # let's normalise the input string so we can
  # tokenise it just by looking at the spaces.
  console.log "command before replacements: " + command
  command = command.replace /\(/g, " ( "
  command = command.replace /\)/g, " ) "
  command = command.replace /([$A-Za-z_][0-9a-zA-Z_$]*)/g, " $1 "
  command = command.replace /([^$A-Za-z_])([0-9]*)/g, " $1 $2 "
  command = command.replace /@/g, " @ "
  command = command.replace /[ ]+/g, " "
  command = command.replace /^[ ]+/g, ""
  command = command.replace /[ ]+$/g, ""
  console.log "command after replacements: " + command

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


