
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

  # @ as shorthand for "self." or "self", à la coffeescript:
  # any @ that is just before something that is not a closing delimiter
  # is a field access. Note that there must be no space, so:
  #
  #    @print // is a field access
  #
  #  ...is different from:
  #
  #    @ print // not a field access
  #
  # any other @ (i.e. next to a space or a closing delimeter) is just
  # "self" like in the second case.

  command = command.replace /@([^\]);\s])/g, " self . $1"
  command = command.replace /@/g, " self "
  
  # separate numbers and punctuation from anything else
  # note that:
  # 1) numbers and punctuation are dealt together because
  # otherwise something like 3.14 is separated into 3 . 14
  # so we need to handle them both here so we get that floating
  # point case before we separate the dots
  #
  # 2) consecutive operators like ++, --, +=, **
  # ^^ are left untouched, so you can give good meaning to them
  # for example this:
  #   a++ +
  # becomes
  #   a ++ +
  # so the spacing between the operators can be significant
  #
  # see this playground with an example:
  # https://regex101.com/r/LRqxeN/3
  #
  command = command.replace /([0-9]*\.[0-9]+([eE][- ]?[0-9]*)?)|([^+\-^*/()=←⇒.!%])([+\-^*/()=←⇒.!%]+)/g, "$1$3 $4 "


  # separates the *end* of a sequence of punctuations from what
  # comes after. e.g. 3.14 =a becomes 3.14 = a
  # not that we can't/donn't need to do that with the dot because
  # a) it was already done by the regex above and
  # b) it would wreck floating point numbers
  command = command.replace /([+\-^*/()=←⇒!%])([^+\-^*/()=←⇒!%])/g, "$1 $2"

  # things that are now a / _2 become a /_ 2
  # this is so we can have an "underscore" version of
  # an operator, in this case floor division
  command = command.replace /([+\-^*/=←⇒!%_])[ ]+_/g, "$1_ "

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
    #log "$STRING_TOKEN_" + (ValidIDfromString quoted) + " i.e." + quoted
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

    #log "INJECTING $STRING_TOKEN_" + index
    #log "INJECTING i.e. " +  val
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

  code = code.replace /﹍/g, " "

  # remove all empty lines,
  # because we really don't want
  # to have the length of empty lines to
  # be meaningful. That would be really cruel,
  # since they are invisible,
  # so to avoid any such situation we just remove empty
  # lines here so that we are forced to give the user
  # alternative ways.
  code = code.replace /^\s*[\r\n]/gm, ""

  sourceByLine = code.split("\n")
  startOfPreviousLine = ""
  linesWithBlockStart = []
  unclosedParens = 0
  outputSource = ""

  actualLineTabs = []
  correctedLineTabs = []
  
  for eachLine in [0...sourceByLine.length]
    line = sourceByLine[eachLine]
    #log "checking " + line
    rx = RegExp("^([ ]*)",'gm')
    match = rx.exec line
    if eachLine == 0
      outputSource += " " + line
      actualLineTabs.push 0
      correctedLineTabs.push 0
      continue
    startOfThisLine = match[1]
    #log "start of line: >" + startOfThisLine + "<"

    # leftOrRightOrAligned is only used to understand if the current
    # line if to the left, to the right or aligned. The actual
    # correct difference in indentation is calculated later.
    leftOrRightOrAligned = startOfThisLine.length - actualLineTabs[actualLineTabs.length - 1]
    actualLineTabs.push startOfThisLine.length

    log "linearize startOfThisLine: " + startOfThisLine + " " + startOfThisLine.length + " difference in alignment: " + leftOrRightOrAligned + " content: " + line
    if leftOrRightOrAligned == 0
      correctedIndentationDifference = 0
      # this is the statement separator
      outputSource += " ; " + line
    else if leftOrRightOrAligned > 0
      correctedIndentationDifference = 1
      log "linearize adding a ( "
      outputSource += (Array(correctedIndentationDifference+1).join "(") + line
    else # leftOrRightOrAligned < 0
      for k in [(actualLineTabs.length - 2)..0]
        log " k: " + k + " checking line " + sourceByLine[k] + " for alignment "
        if actualLineTabs[k] <= startOfThisLine.length
          log "line " + sourceByLine[k] + " is aligned with me and the corrected tabs for that were: " + correctedLineTabs[k]
          correctedIndentationDifference = correctedLineTabs[k] - correctedLineTabs[correctedLineTabs.length - 1]
          break

      log "linearize adding " + (-correctedIndentationDifference) + " ) "
      
      # if a line is aligned exactly with a line above,
      # then we add a ";" as well. So for example in
      #
      #   if a==5:
      #   ﹍console print "yes a is 5"
      #   else:
      #   ﹍console print "no a is not 5"
      #   console print ". the end."
      #
      # the if, the else and the last line are all separated by
      # ";"
      # However, we make some tokens "eat up" the previous ";" in
      # via the "removeStatementSeparatorsBeforeAlignedConstructs"
      # function, in this case the "else" eats up the ";" separator
      # before it, so the if/else construction can work
      # properly.
      # This is the best way I found to have the "if/else-if/else"
      # construct to behave like an expression, and in the process
      # I could also get rid of the fakeCatch and fakeElse
      # tricks.

      if actualLineTabs[k] == startOfThisLine.length
        outputSource += (Array(-correctedIndentationDifference+1).join ")") + " ; " + line
      else
        outputSource += (Array(-correctedIndentationDifference+1).join ")") + line

    unclosedParens += correctedIndentationDifference
    correctedLineTabs.push unclosedParens

  # final close-off of pending parens
  outputSource += (Array(unclosedParens+1).join ")")

  #log "code length at identifyBlockStarts: " + code.split("\n").length

  log "linearized program: " + outputSource.replace /^[ ]*/g, ""

  return outputSource.replace /^[ ]*/g, ""

# since we separate with ";" all aligned lines, we need
# a way to make the program "flow" again in some cases,
# so here we go. Note that this is not strictly necessary,
# you can always indent in non-aligned way, for example
# in the case of the "do" one could write:
#
#    for each word in
#    ﹍﹍myList
#    ﹍do
#    ﹍﹍codeToBeRun eval
#    something else
#
# and that needs no fixing by this function. However,
# it's rather unconventional to have that second line
# to have TWO tabs, expecially in some cases such as
# if/else-if/else , where you'd have to write:
#
#   if a==5:
#   ﹍﹍console print "yes a is 5"
#   ﹍else:
#   ﹍﹍console print "no a is not 5"
#   console print ". the end."
#
# which is somewhat unconventional.
# Hence, we apply this trick here.

removeStatementSeparatorsBeforeAlignedConstructs = (command) ->
  command = command.replace /[; ]*(do[ \n])/g, " $1"
  command = command.replace /[; ]*(by[ \n])/g, " $1"
  command = command.replace /[; ]*(else[ \n])/g, " $1"
  command = command.replace /[; ]*(catch[ \n])/g, " $1"
  command = command.replace /[ ]+/g, " "
  command = command.trim()
  return command


flTokenize = (command) ->
  listsStack = []
  listsStack.jsArrayPush FLList.createNew()

  # join the multi-line first before we do the strings
  command = command.replace /\\\n[ ]*/g, " "

  # remove comments first, so we can ignore
  # any strings that might be in them
  command = removeComments command

  command = removeStrings command
  log "codeWithoutStrings: " + command

  command = linearize command
  log "linearized command: " + command


  # let's normalise the input string so we can
  # tokenise it just by looking at the spaces.
  log "command before replacements: " + command
  command = tokenizeCommand command
  log "command after replacements: " + command
  #log "obtained: command after replacements: " + command

  command = removeStatementSeparatorsBeforeAlignedConstructs command
  log "removed statement separators before aligned constructs: " + command

  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    log "eachToken: " + eachToken

    if /\$STRING_TOKEN_([\$a-zA-Z0-9_]+)/g.test(eachToken)
      log eachToken + " is a string literal"
      listsStack[listsStack.length-1] = listsStack[listsStack.length-1].flListImmutablePush FLToken.createNew eachToken
    else if /^\($/.test(eachToken)
      nestedList = FLList.createNew()
      listsStack.jsArrayPush nestedList
    else if /^\)$/.test(eachToken)
      nestedList = listsStack.pop()
      listsStack[listsStack.length-1] = listsStack[listsStack.length-1].flListImmutablePush nestedList
    else
      log eachToken + " is something else"
      listsStack[listsStack.length-1] = listsStack[listsStack.length-1].flListImmutablePush FLToken.createNew eachToken

  return listsStack[listsStack.length-1]
