flContexts = []
rWorkspace = null
environmentPrintout = ""
environmentErrors = ""

initContext = (context) ->
  keywordsAndTheirInit = [
    "WorkSpace", FLWorkspace # todo probably not needed?
    "Class", FLClass
    "List", FLList
    "String", FLString
    "Exception", FLException
    "Number", FLNumber
    "Boolean", FLBoolean
    "Console", FLConsole

    "not", FLNot.createNew()
    "true", FLBoolean.createNew true
    "false", FLBoolean.createNew false

    "for", FLFor.createNew()
    "repeat1", FLRepeat1.createNew()
    "done", FLDone.createNew()
    "break", FLBreak.createNew()
    "return", FLReturn.createNew()

    "if", FLIfThen.createNew()
    "else", FLFakeElse.createNew()
    "forever", FLForever.createNew()
    "repeat", FLRepeat2.createNew()

    "try", FLTry.createNew()
    "throw", FLThrow.createNew()
    "catch", FLFakeCatch.createNew()

    "to", FLTo.createNew()

    "in", FLIn.createNew()
    "accessUpperContext", FLAccessUpperContext.createNew()

    "evaluationsCounter", FLEvaluationsCounter.createNew()

    "nil", FLNil.createNew()

    "console", FLConsole.createNew()
    "pause", FLPause.createNew()

    "'", FLQuote.createNew()
    ":", FLQuote.createNew()
  ]

  for keywords in [0...keywordsAndTheirInit.length] by 2
    [keyword, itsInitialisation] = keywordsAndTheirInit[keywords .. keywords + 1]
    context.tempVariablesDict[ValidIDfromString keyword] = itsInitialisation


quickReset = ->
  environmentPrintout = ""
  environmentErrors = ""
  rWorkspace = FLWorkspace.createNew()
  outerMostContext = new FLContext null, rWorkspace
  flContexts.jsArrayPush outerMostContext
  initContext outerMostContext

reset = ->
  # resetting the classes and initing them
  # adds quite a bit more time to the tests
  # but it's worth checking once in a while
  # that the tests behave well when the state
  # is reset more deeply.
  clearClasses()
  initBootClasses()

  quickReset()

textOutputElement = null

Fizzylogo.init = (textOutElem) ->
  textOutputElement = textOutElem
  reset()

# this one is for the browser, and the yielding is always
# enabled for the browser build, so this is always used
# as a generator.
Fizzylogo.runOneStep = (code) ->
  quickReset()
  parsed = flTokenize code
  console.log "evaluation " + indentation() + "messaging workspace with " + parsed.flToString()

  # yield from
  returned = parsed.eval outerMostContext, parsed
  outerMostContext.returned = returned.value

  console.log "evaluation " + indentation() + "end of workspace evaluation"

  if outerMostContext.throwing and outerMostContext.returned.flClass == FLException
    console.log "evaluation " + indentation() + "exception: " + outerMostContext.returned.value
    environmentErrors += "! exception: " + outerMostContext.returned.value
    if textOutputElement?
      textOutputElement.value += environmentErrors + "\n"

  return null
  

run = (code) ->
  quickReset()
  parsed = flTokenize code
  console.log "evaluation " + indentation() + "messaging workspace with " + parsed.flToString()

  yieldMode = false
  #yieldMode = true
  if yieldMode
    gen = parsed.eval outerMostContext, parsed
    until (ret = gen.next()).done
      if ret.value?
        console.log "obtained: " + ret.value
      console.log "obtained: yieldingfromtoplevel"
    outerMostContext.returned = ret.value
  else
    outerMostContext.returned = parsed.eval outerMostContext, parsed

  console.log "evaluation " + indentation() + "end of workspace evaluation"

  if outerMostContext.throwing and outerMostContext.returned.flClass == FLException
    console.log "evaluation " + indentation() + "exception: " + outerMostContext.returned.value
    environmentErrors += "! exception: " + outerMostContext.returned.value

  return null
