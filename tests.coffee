



tests = [
  "1plus 1 print"
  "1"

  "(1plus 1)print"
  "2"

  "(1plus 1)print print"
  "22"

  "@a<-5.a increment.@a<-a plus 1.a print",
  "7"

  "@a<-5.@a<-a plus 1.a increment print"
  "7"

  "@a<-5plus 1.a increment print"
  "7"

  "@a<-(5plus 1).a increment print"
  "7"

  "(4plus 1plus 1)print"
  "6"

  "@a<-(4plus 1plus 1).a increment print"
  "7"

  "@a<-(4plus(1plus 1)).a increment print"
  "7"

  "@a<-((4plus 1)plus(0plus 1)).a increment print"
  "7"

  "7anotherPrint"
  "7"

  "7anotherPrinttwo"
  "7"

  "7anotherPrintthree"
  "7"

  "7doublePrint"
  "77"

  "7print print"
  "77"

  "(6doublePrint plus 1)print"
  "667"

  "6doublePrint plus 1print"
  "661"

  "(4plus 3)print"
  "7"

  "(4plus 3print)print"
  "37"

  "(4plus(2plus 1))print"
  "7"

  "4plus(2plus 1)print"
  "7"

  "4plus 2plus 1print"
  "1"

  "(@(1plus 1))print"
  "(  1 plus 1 )"

  "((@(1plus 1))eval)print"
  "2"

  "(@(1plus 1))eval print"
  "2"

  # in this case still the @ ties to the first element
  # that comes after it i.e. ( 1 plus 1 )
  "@(1 plus 1)eval print"
  "2"

  "@a<-5.@b<-@a.b print.a print",
  "a5"

  "true negate print",
  "false"

  "(false and false)print",
  "false"

  "(false and true)print",
  "false"

  "(true and false)print",
  "false"

  "(true and true)print",
  "true"

  "(false or false)print",
  "false"

  "(false or true)print",
  "true"

  "(true or false)print",
  "true"

  "(true or true)print",
  "true"

  "(not true)print",
  "false"

  "(not not true)print",
  "true"

  "(not not not true)print",
  "false"

  "(not not not not true)print",
  "true"

  "true=>(1print)",
  "1"

  "false=>(1print)2print",
  "2"

  "(0==0)print",
  "true"

  "(1==0)print",
  "false"

  "(0amIZero)print",
  "true"

  "(1amIZero)print",
  "false"

  "(8minus 1)print",
  "7"

  "true=>(1print)2print",
  "1"

  "0factorial print",
  "1"

  "1factorial print",
  "1"

  "2factorial print",
  "2"

  "7factorial print",
  "5040"

  "0factorialtwo print",
  "1"

  "1factorialtwo print",
  "1"

  "2factorialtwo print",
  "2"

  "7factorialtwo print",
  "5040"

  "7factorialthree print",
  "5040"

  "7factorialfour print",
  "5040"

  "7factorialfive print",
  "5040"

  "7selftimesminusone print",
  "42"

  "@a<-5.1printAFromDeeperCall",
  "5"

  "@a<-5.repeat((a==0)=>(done)@a<-a minus 1).a print",
  "0"

  "@a<-5.repeat((a==0)=>(done)@a<-a minus 1)print",
  "Done_object"

  "@a<-5.repeat((a==0)=>(done with a plus 1)@a<-a minus 1)print",
  "1"

  "Class print",
  "Class_object"

  "@something<-3.something print",
  "3"

  "@MyClass<-Class new",
  ""

  "@MyClass<-Class new.MyClass answer(printtwo)by(self print).@myObject<-MyClass new.myObject printtwo",
  "object_from_a_user_class"

  "@false<-true.false=>(1print)2print",
  "1"

  "@temp<-true.@true<-false.@false<-temp.false=>(1print)2print",
  "1"

  "@temp<-true.@true<-false.@false<-temp.true=>(1print)2print",
  "2"

  "@2<-10.2print",
  "10"

  "@ ' <- @. 'a<-8.a print",
  "8"

  #"8 tdict print",
  #"empty message"

  "8 idict print",
  "empty message"

  "8 cdict print",
  "empty message"

  "(4*2)times(1print)",
  "11111111"

  "for k<-(1)to(10)do(k print)"
  "12345678910"

  "for k<-1to 10do(k print)"
  "12345678910"

  "8 unintelligibleMessage"
  "! something was not understood: (  unintelligibleMessage )"

  #"@ a <- 5 someUndefinedMessage"
  #"7"

]

###
tests = [
  "8 unintelligibleMessage"
  "12345678910"
]
###

flContexts = []
environmentPrintout = ""
rWorkspace = null


for i in [0...tests.length] by 2
    [testBody, testResult] = tests[i .. i + 1]
    environmentPrintout = ""
    console.log "starting test: " + (i/2+1) + ": " + testBody
    
    parsed = flParse testBody

    console.log parsed.value.length
    for eachParsedItem in parsed.value
      console.log eachParsedItem.value

    rWorkspace = FLWorkspace.createNew()


    # outer-most context
    parsed.isFromMessage = true
    outerMostContext = new FLContext null, rWorkspace, parsed
    flContexts.push outerMostContext

    rWorkspace.flClass.instanceVariables = FLList.createNew()
    
    keywordsAndTheirInit = [
      "Class", FLClass.createNew()

      "not", FLNot.createNew()
      "true", FLBoolean.createNew true
      "false", FLBoolean.createNew false

      "for", FLFor.createNew()
      "repeat", FLRepeat.createNew()
      "done", FLDone.createNew()

      "@", FLQuote.createNew()
    ]

    for keywords in [0...keywordsAndTheirInit.length] by 2
      [keyword, itsInitialisation] = keywordsAndTheirInit[keywords .. keywords + 1]
      rWorkspace.flClass.instanceVariables.push FLAtom.createNew keyword
      outerMostContext.self.instanceVariablesDict[ValidIDfromString keyword] = itsInitialisation


    rWorkspace.eval outerMostContext
    console.log "final return: " + outerMostContext.returned.value
    if environmentPrintout == testResult
      console.log "...test " + (i/2+1) + " OK, obtained: " + environmentPrintout
    else
      console.log "...test " + (i/2+1) + " FAIL, test: " + testBody + " obtained: " + environmentPrintout + " expected: " + testResult

