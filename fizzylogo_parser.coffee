
tokenizeCommand = (command) ->
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

# replace all the strings with
# references to a table, which we'll replace back
# later with string objects.
removeStrings = (code) ->
  stringsTable = []
  codeWithoutStrings = code.replace(/"((?:[^"\\\n]|\\.)*)"/g, (all, quoted) ->
    index = stringsTable.length
    stringsTable.push quoted
    return "$STRINGS_TABLE_" + index
  )
  return [codeWithoutStrings, stringsTable]

# replaces strings and regexs keyed by index with an array of strings
# see "removeStrings" function
injectStrings = (code, stringsTable) ->
  code = code.replace /\$STRINGS_TABLE_(\d+)/g, (all, index) ->
    val = stringsTable[index]
    return val
  return code

flParse = (command) ->
  listsStack = []
  outerList = FLList.createNew()
  listsStack.push outerList
  currentList = outerList

  [command, stringsTable] = removeStrings command
  console.log "codeWithoutStrings: " + command
  console.log "stringsTable: " + stringsTable

  # let's normalise the input string so we can
  # tokenise it just by looking at the spaces.
  console.log "command before replacements: " + command
  command = tokenizeCommand command  
  console.log "command after replacements: " + command

  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    console.log "eachToken: " + eachToken

    if /^\.$/.test(eachToken)
      console.log eachToken + " is . symbol"
      currentList.push RStatementSeparatorSymbol
    else if /\$STRINGS_TABLE_(\d+)/g.test(eachToken)
      console.log eachToken + " is a string literal"
      currentList.push FLString.createNew injectStrings eachToken, stringsTable
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


