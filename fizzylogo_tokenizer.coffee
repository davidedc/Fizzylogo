
tokenizeCommand = (command) ->

  # we can just use the dot instead of 's.
  # Using 's would make things more complicated
  # because we also use ' as quote symbol
  command = command.replace /'[ ]*s[\s]/g, "."

  # separate parens
  command = command.replace /\(/g, " ( "
  command = command.replace /\)/g, " ) "
  command = command.replace /\[/g, " [ "
  command = command.replace /\]/g, " ] "

  # this is the statement separator
  command = command.replace /;/g, " ; "
  
  # separate numbers and punctuation from anything else
  # note that numbers and punctuation are dealt together because
  # otherwise something like 3.14 is separated into 3 . 14
  # so we need to handle them both here so we get that floating
  # point case before we separate the dots
  command = command.replace /([0-9]*\.[0-9]+([eE][- ]?[0-9]*)?)|([+\-^*/()=←⇒.])/g, " $1 $3 "

  # re-group consecutive punctuation, so things like ++, --, +=, **
  # ^^, etc. can all live separately to have their own meaning
  command = command.replace /([+\-^*/=←⇒.])[ ]*([+\-^*/=←⇒.])/g, "$1$2"

  command = command.replace /'/g, " ' "
  command = command.replace /:/g, " : "

  # quote symbol used by Rosetta Smalltalk
  # while we use the standard ' i.e. "quote"
  #command = command.replace /@/g, " @ "

  # collapse all multiple spaces to one
  command = command.replace /[ ]+/g, " "


  command = command.trim()

removeComments = (code) ->
  # this fizzylogo is empty-line sensitive, this regex is custom
  # and also properly removes the lines where there are comments
  # (i.e. it doesn't just strip the comment leaving empty the line
  # where it was)
  #
  # 1st part: multi-line comments starting with new line
  # 2nd part: multi-line comments NOT starting with new line
  # 3rd part: single-line comments starting with new line
  # 4th part: single-line comments NOT starting with new line
  # 5th part: multi-line comment at the end of the text
  # 6th part: single-line comment at the end of the text
  #
  # see: https://regex101.com/r/U5pYX4/1

  return code.replace ///
    (^)\/\*[\s\S]*?\*\/\n?|
    ([^\\\n])\/\*[\s\S]*?\*\/|
    (^)\/\/.*$\n|
    ([^\\\n])\/\/.*$|
    \n\/\/.*$|
    \n\/\*[\s\S]*?\*\
    ///gm, "$1$2$3$4"

# replace all the strings with
# references to a table, which we'll replace back
# later with string objects.
removeStrings = (code) ->
  codeWithoutStrings = code.replace(/"((?:[^"\\\n]|\\.)*)"/g, (all, quoted) ->
    if DEBUG_STRINGIFICATION_CHECKS
      stringsTable_TO_CHECK_CONVERTIONS[ValidIDfromString quoted] = quoted
    console.log "$STRING_TOKEN_" + (ValidIDfromString quoted)
    console.log "i.e." + quoted
    return "$STRING_TOKEN_" + (ValidIDfromString quoted)
  )
  return codeWithoutStrings

# replaces strings and regexs keyed by index with an array of strings
# see "removeStrings" function
injectStrings = (code) ->
  code = code.replace /\$STRING_TOKEN_([\$a-zA-Z0-9_]+)/g, (all, index) ->
    val = StringFromValidID index
    if DEBUG_STRINGIFICATION_CHECKS
      if val != stringsTable_TO_CHECK_CONVERTIONS[index]
        throw "ERROR cannot get back string from ID, got back: " + StringFromValidID index

    console.log "INJECTING $STRING_TOKEN_" + index
    console.log "INJECTING i.e. " +  val
    return val
  return code

# transform indentations into brackets
# it tries to be smart, so you can add "innocuous" extra
# indentation.
# Typical innocuous indentations that is useful to add
# is the kind that transforms things like this:
#
#    for each word in
#    ﹍myList
#    do
#    ﹍codeToBeRun eval
#    something else
#
# into this:
#
#    for each word in
#    ﹍﹍myList            // still "under the umbrella" of for
#    ﹍do                  // still "under the umbrella" of for
#    ﹍﹍codeToBeRun eval  // still "under the umbrella" of do
#    something else       // NOT "under the umbrella" of do anymore
#                         // BUT it's still "under the umbrella" of
#                            for so it's OK
#
# basically you can add tabs within reason if you preserve
# the logical alignment of things, i.e. if a line is still
# "under the umbrella of" or "aligned to" the same line
# then it's OK.
#
# It works this way:
#   1) for any jump "inside" of more
#      than one tab is corrected to a jump of one tab.
#   2) for any jump outside:
#      the current line is checked for the fist line above
#      that is either aligned with it or to the left of it.
#      Since we keep the correct identation for all
#      lines above, we pick the "correct" tab
#      of the current line to be the tab of the found
#      one above.
#   3) once the "correct" tab of this line is found
#      as per 1) and 2), we just add and remove
#      () based on the difference in the "correct"
#      tab numbers.

linearize = (code) ->
  sourceByLine = code.split("\n")
  startOfPreviousLine = ""
  linesWithBlockStart = []
  unclosedParens = 0
  outputSource = ""

  actualLineTabs = []
  correctedLineTabs = []
  
  for eachLine in [0...sourceByLine.length]
    line = sourceByLine[eachLine]
    #console.log "checking " + line
    rx = RegExp("^(﹍*)",'gm')
    match = rx.exec line
    if eachLine == 0
      outputSource += " " + line
      actualLineTabs.push 0
      correctedLineTabs.push 0
      continue
    startOfThisLine = match[1]
    #console.log "start of line: >" + startOfThisLine + "<"

    # leftOrRightOrAligned is only used to understand if the current
    # line if to the left, to the right or aligned. The actual
    # correct difference in indentation is calculated later.
    leftOrRightOrAligned = startOfThisLine.length - actualLineTabs[actualLineTabs.length - 1]
    actualLineTabs.push startOfThisLine.length

    console.log "linearize startOfThisLine: " + startOfThisLine + " " + startOfThisLine.length + " difference in alignment: " + leftOrRightOrAligned + " content: " + line
    if leftOrRightOrAligned == 0
      correctedIndentationDifference = 0
      # this is the statement separator
      outputSource += " ; " + line
    else if leftOrRightOrAligned > 0
      correctedIndentationDifference = 1
      console.log "linearize adding a ( "
      outputSource += (Array(correctedIndentationDifference+1).join "(") + line
    else # leftOrRightOrAligned < 0
      for k in [(actualLineTabs.length - 2)..0]
        console.log " k: " + k + " checking line " + sourceByLine[k] + " for alignment "
        if actualLineTabs[k] <= startOfThisLine.length
          console.log "line " + sourceByLine[k] + " is aligned with me and the corrected tabs for that were: " + correctedLineTabs[k]
          correctedIndentationDifference = correctedLineTabs[k] - correctedLineTabs[correctedLineTabs.length - 1]
          break

      console.log "linearize adding " + (-correctedIndentationDifference) + " ) "
      outputSource += (Array(-correctedIndentationDifference+1).join ")") + line

    unclosedParens += correctedIndentationDifference
    correctedLineTabs.push unclosedParens

  # final close-off of pending parens
  outputSource += (Array(unclosedParens+1).join ")")

  #console.log "code length at identifyBlockStarts: " + code.split("\n").length
  return outputSource.replace /﹍/g, ""



flTokenize = (command) ->
  listsStack = []
  listsStack.jsArrayPush FLList.createNew()

  # join the multi-line first before we do the strings
  command = command.replace /\\\n﹍*/g, " "

  command = removeStrings command
  console.log "codeWithoutStrings: " + command

  command = removeComments command

  command = linearize command
  console.log "linearized command: " + command

  # let's normalise the input string so we can
  # tokenise it just by looking at the spaces.
  console.log "command before replacements: " + command
  command = tokenizeCommand command  
  console.log "command after replacements: " + command


  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    console.log "eachToken: " + eachToken

    if /\$STRING_TOKEN_([\$a-zA-Z0-9_]+)/g.test(eachToken)
      console.log eachToken + " is a string literal"
      listsStack[listsStack.length-1] = listsStack[listsStack.length-1].flListImmutablePush FLToken.createNew eachToken
    else if /^\($/.test(eachToken)
      nestedList = FLList.createNew()
      listsStack.jsArrayPush nestedList
    else if /^\)$/.test(eachToken)
      nestedList = listsStack.pop()
      listsStack[listsStack.length-1] = listsStack[listsStack.length-1].flListImmutablePush nestedList
    else
      console.log eachToken + " is something else"
      listsStack[listsStack.length-1] = listsStack[listsStack.length-1].flListImmutablePush FLToken.createNew eachToken

  return listsStack[listsStack.length-1]


