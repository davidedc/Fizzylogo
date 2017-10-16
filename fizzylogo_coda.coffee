#flContexts = []
mainTurtle = null

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
    "Turtle", FLTurtle

    "not", FLNot.createNew()
    "true", FLBoolean.createNew true
    "false", FLBoolean.createNew false

    "for", FLFor.createNew()
    "repeat1", FLRepeat1.createNew()
    "done", FLDone.createNew()
    "break", FLBreak.createNew()
    "return", FLReturn.createNew()

    "if", FLIfThen.createNew()
    "forever", FLForever.createNew()
    "repeat", FLRepeat2.createNew()

    "try", FLTry.createNew()
    "throw", FLThrow.createNew()

    "to", FLTo.createNew()

    "in", FLIn.createNew()
    "accessUpperContext", FLAccessUpperContext.createNew()

    "evaluationsCounter", FLEvaluationsCounter.createNew()

    "nil", FLNil.createNew()

    "console", FLConsole.createNew()
    "turtle", (mainTurtle = FLTurtle.createNew())
    "pause", FLPause.createNew()

    "'", FLQuote.createNew()
    ":", FLQuote.createNew()
  ]

  for keywords in [0...keywordsAndTheirInit.length] by 2
    [keyword, itsInitialisation] = keywordsAndTheirInit[keywords .. keywords + 1]
    context.tempVariablesDict[ValidIDfromString keyword] = itsInitialisation


quickReset = ->

  #flContexts = []

  rWorkspace = FLWorkspace.createNew()
  rWorkspace.environmentPrintout = ""
  console.log "resetting rWorkspace.environmentErrors"
  rWorkspace.environmentErrors = ""

  outerMostContext = new FLContext null, rWorkspace
  #flContexts.jsArrayPush outerMostContext
  initContext outerMostContext

  mainTurtle.sendHome()

  # instead of clearing and re-initiating all the classes,
  # let's just get rid of all the classes created after
  # booting, also so we don't create a memory leak.
  allClasses = bootClasses.slice()

  for eachClass in allClasses
    eachClass.resetInstanceVariables()


reset = ->
  # resetting the classes and initing them
  # adds quite a bit more time to the tests
  # but it's worth checking once in a while
  # that the tests behave well when the state
  # is reset more deeply.
  clearClasses()
  initBootClasses()

  #flContexts = []

  rWorkspace = FLWorkspace.createNew()
  rWorkspace.environmentPrintout = ""
  console.log "resetting rWorkspace.environmentErrors"
  rWorkspace.environmentErrors = ""

  outerMostContext = new FLContext null, rWorkspace
  #flContexts.jsArrayPush outerMostContext
  initContext outerMostContext

  mainTurtle.sendHome()

textOutputElement = null
canvasOutputElement = null
devicePixelRatio = 1

# this is called from the browser
Fizzylogo.init = (textOutElem, canvasOutElem, devPixRatio) ->
  if textOutElem?
    # don't do any logging when used in
    # the browser
    log = ->
    dir = ->
  textOutputElement = textOutElem
  canvasOutputElement = canvasOutElem
  devicePixelRatio = devPixRatio

  # scale all drawing operations by the
  # devicePixelRatio value, otherwise, say,
  # in Retina Displays 2x we'd get drawings that
  # are much smaller.

  canvasOutputElement?.getContext('2d').scale devicePixelRatio, devicePixelRatio

  reset()

# this one is for the browser, and the yielding is always
# enabled for the browser build, so this is always used
# as a generator.
Fizzylogo.runOneStep = (code) ->
  quickReset()
  parsed = flTokenize code
  log "evaluation " + indentation() + "messaging workspace with " + parsed.flToString()

  # yield from
  returned = parsed.eval outerMostContext, parsed
  outerMostContext.returned = returned

  console.log "evaluation " + indentation() + "end of workspace evaluation"
  console.log "rWorkspace.environmentPrintout " + rWorkspace.environmentPrintout
  console.log "rWorkspace.environmentErrors " + rWorkspace.environmentErrors


  if outerMostContext.throwing and outerMostContext.returned.flClass == FLException
    log "evaluation " + indentation() + "exception: " + outerMostContext.returned.value
    rWorkspace.environmentErrors += "! exception: " + outerMostContext.returned.value
    log "rWorkspace.environmentErrors " + rWorkspace.environmentErrors
    if textOutputElement?
      textOutputElement.value += rWorkspace.environmentErrors + "\n"

  return null
  

run = (code) ->
  quickReset()
  parsed = flTokenize code
  log "evaluation " + indentation() + "messaging workspace with " + parsed.flToString()

  yieldMode = false
  #yieldMode = true
  if yieldMode
    gen = parsed.eval outerMostContext, parsed
    until (ret = gen.next()).done
      if ret.value?
        log "obtained: " + ret.value
      log "obtained: yieldingfromtoplevel"
    outerMostContext.returned = ret.value
  else
    outerMostContext.returned = parsed.eval outerMostContext, parsed

  log "evaluation " + indentation() + "end of workspace evaluation"
  console.log "rWorkspace.environmentErrors " + rWorkspace.environmentErrors

  if outerMostContext.throwing and outerMostContext.returned.flClass == FLException
    log "evaluation " + indentation() + "exception: " + outerMostContext.returned.value
    rWorkspace.environmentErrors += "! exception: " + outerMostContext.returned.value
    log "rWorkspace.environmentErrors " + rWorkspace.environmentErrors

  return null
