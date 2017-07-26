



tests = [
  "1 plus 1 print"
  "1"

  "( 1 plus 1 ) print"
  "2"

  "( 1 plus 1 ) print print"
  "22"

  "@ a <- 5 . a increment . @ a <- a plus 1 . a print",
  "7"

  "@ a <- 5 . @ a <- a plus 1 . a increment print"
  "7"

  "@ a <- 5 plus 1 . a increment print"
  "7"

  "@ a <- ( 5 plus 1 ) . a increment print"
  "7"

  "( 4 plus 1 plus 1 ) print"
  "6"

  "@ a <- ( 4 plus 1 plus 1 ) . a increment print"
  "7"

  "@ a <- ( 4 plus ( 1 plus 1 ) ) . a increment print"
  "7"

  "@ a <- ( ( 4 plus 1 ) plus ( 0 plus 1 ) ) . a increment print"
  "7"

  "7 anotherPrint"
  "7"

  "7 doublePrint"
  "77"

  "7 print print"
  "77"

  "( 6 doublePrint plus 1 ) print"
  "667"

  "6 doublePrint plus 1  print"
  "661"

  "( 4 plus 3 ) print"
  "7"

  "( 4 plus 3 print ) print"
  "37"

  "( 4 plus ( 2 plus 1 ) ) print"
  "7"

  "4 plus ( 2 plus 1 ) print"
  "7"

  "4 plus 2 plus 1 print"
  "1"

  "( @ ( 1 plus 1 ) ) print"
  "(  1 plus 1 )"

  "( ( @ ( 1 plus 1 ) ) eval ) print"
  "2"

  "( @ ( 1 plus 1 ) ) eval print"
  "2"

  # in this case still the @ ties to the first element
  # that comes after it i.e. ( 1 plus 1 )
  " @ ( 1 plus 1 ) eval print"
  "2"

  "@ a <- 5 . @ b <- @ a  . b print . a print",
  "a5"

  "true negate print",
  "false"


  #"@ a <- 5 someUndefinedMessage"
  #"7"

]


rosettaContexts = []
environmentPrintout = ""


for i in [0...tests.length] by 2
    [testBody, testResult] = tests[i .. i + 1]
    environmentPrintout = ""
    console.log "starting test: " + (i/2+1) + ": " + testBody
    
    parsed = rosettaParse testBody

    console.log parsed.value.length
    for eachParsedItem in parsed.value
      console.log eachParsedItem.value

    rWorkspace = RWorkspace.createNew()

    rWorkspace.rosettaClass.instanceVariables = RList.createNew()
    rWorkspace.rosettaClass.instanceVariables.push RAtom.createNew "a"
    rWorkspace.rosettaClass.instanceVariables.push RAtom.createNew "b"

    # outer-most context
    parsed.isFromMessage = true
    outerMostContext = new RosettaContext null, rWorkspace, parsed
    rosettaContexts.push outerMostContext
    rWorkspace.evalMessage outerMostContext
    console.log "final return: " + outerMostContext.returned.value
    if environmentPrintout == testResult
      console.log "...test OK, obtained: " + environmentPrintout
    else
      console.log "...test FAIL, test: " + testBody + " obtained: " + environmentPrintout + " expected: " + testResult

