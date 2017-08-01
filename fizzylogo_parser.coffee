
tokenizeString = (command) ->
  # separate parens
  command = command.replace /\(/g, " ( "
  command = command.replace /\)/g, " ) "
  
  # separate identifiers
  command = command.replace /([$A-Z_][0-9A-Z_$]*)/gi, " $1 "

  # separate the digits from anything, unless they are part of
  # an identifier
  command = command.replace /([^$A-Z_])([0-9]+)/gi, "$1 $2 "

  command = command.replace /@/g, " @ "
  # collapse all multiple spaces to one
  command = command.replace /[ ]+/g, " "
  command = command.trim()


flParse = (command) ->
  listsStack = []
  outerList = FLList.createNew()
  listsStack.push outerList
  currentList = outerList

  # let's normalise the input string so we can
  # tokenise it just by looking at the spaces.
  console.log "command before replacements: " + command
  command = tokenizeString command  
  console.log "command after replacements: " + command

  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    console.log "eachToken: " + eachToken

    if /^\.$/.test(eachToken)
      console.log eachToken + " is . symbol"
      currentList.push RStatementSeparatorSymbol
    else if /^\($/.test(eachToken)
      nestedList = FLList.createNew()
      currentList.push nestedList
      listsStack.push currentList
      currentList = nestedList
    else if /^\)$/.test(eachToken)
      currentList = listsStack.pop()
    else
      console.log eachToken + " is something else"
      currentList.push FLAtom.createNew eachToken

  return outerList


