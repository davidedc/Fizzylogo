# Overall comments -------------------------------------------

# ----
# in the "for" and in the "repeat" and in all the branches in the if-then-else,
# the loopCode/branch is passed as UNevaluated.
# This is because if it were passed as evaluated, it'd have to be passed as
#   repeat 3 'code
# which would turn it into a closure.
# Since out closures are read-only, that usually creates chaos, because
# you are very likely to reference several variables from outside the
# loop, and "closing" those as read only is problematic for example
# this never ends, because the "a" inside the branch "a=a minus 1" is
# replaced with a 5 when closed, so it never decreases to zero!
#
#  a=5
#
#  repeat forever:
#  ﹍if a==0:
#  ﹍﹍done
#  ﹍else:
#  ﹍﹍a=a minus 1
#  console print a
#
# On the other hand, in "to" and "answer", the code block is passed as
# evaluated so it's actually closed (in read-only mode). This is
# because in those cases one is less prone towards changing variables
# from the outer scope. You can read them, but you can't write them.


commonSimpleValueEqualityFunction = (context) ->
  #yield
  toCompare = context.lookupTemp "toCompare"
  if @value == toCompare.value
    return FLBoolean.createNew true
  else
    return FLBoolean.createNew false

commonSimpleValueInequalityFunction = (context) ->
  #yield
  toCompare = context.lookupTemp "toCompare"
  if @value != toCompare.value
    return FLBoolean.createNew true
  else
    return FLBoolean.createNew false


# helper to add default methods -------------------------------------------


addDefaultMethods = (classToAddThemTo) ->

  classToAddThemTo.addMethod \
    (flTokenize "isPrimitiveType"),
    flTokenize \
      """
      if (self.class == Class) or (self.class == String) or (self.class == Number) or (self.class == List) or (self.class == Boolean):
      ﹍return true
      else:
      ﹍return false
      """

  classToAddThemTo.addMethod \
    (flTokenize "postfixPrint"),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "///////// program printout: " + @flToString()
      rWorkspace.environmentPrintout += @flToString()
      return @

  classToAddThemTo.addMethod \
    (flTokenize "toString"),
    (context) ->
      #yield
      return FLString.createNew @flToString()

  classToAddThemTo.addMethod \
    (flTokenize "whenNew"),
    (context) ->
      #yield
      return @

  classToAddThemTo.addMethod \
    (flTokenize "eval"),
    (context) ->
      context.isTransparent = true
      if methodsExecutionDebug
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      newContext = new FLContext context
      newContext.isTransparent = true
      if methodsExecutionDebug
        log "newContext now tramsparent at depth: " + newContext.depth() + " with self: " + newContext.self.flToString?()
      #flContexts.jsArrayPush newContext
      # yield from
      toBeReturned = @eval newContext, @
      #flContexts.pop()
      return toBeReturned


  # this is the common object identity function
  # strings, numbers and booleans override this
  # by just comparing the values.
  classToAddThemTo.addMethod \
    (flTokenize "== ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.lookupTemp "toCompare"
      if @ == toCompare
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false
    ,7

  # this is the common object identity function
  # strings, numbers and booleans override this
  # by just comparing the values.
  classToAddThemTo.addMethod \
    (flTokenize "!= ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.lookupTemp "toCompare"
      if @ != toCompare
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false
    ,7

  classToAddThemTo.addMethod \
    (flTokenize "else if ( predicate ): ('trueBranch)"),
    (context) ->
      #yield
      return @

  classToAddThemTo.addMethod \
    (flTokenize "else: ('trueBranch)"),
    (context) ->
      #yield
      return @

  classToAddThemTo.addMethod \
    (flTokenize "catch all : ( ' errorHandle )"),
    (context) ->
      #yield
      return @

  classToAddThemTo.addMethod \
    (flTokenize "catch ( 'theError ) : ( ' errorHandle )"),
    (context) ->
      #yield
      return @


  commonPropertyAssignmentFunction = (context) ->
    #yield
    context.isTransparent = true
    if methodsExecutionDebug
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
    variable = context.lookupTemp "variable"
    value = context.lookupTemp "value"

    @instanceVariablesDict[ValidIDfromString variable.value] = value
    

    return @

  commonPropertyAccessFunction = (context) ->
    #yield
    context.isTransparent = true
    if methodsExecutionDebug
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
    variable = context.lookupTemp "variable"

    if methodsExecutionDebug
      log ". ('variable) : checking instance variables"

    # somewhat similar to Javascript, the lookup starts at the object
    # and climbs up to its class.
    objectsBeingChecked = @
    loop
      if objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]?
        if methodsExecutionDebug
          log "yes it's an instance variable: "
          #dir objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]
        context.justDidAFieldOrArrayAccess = true
        return objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]
      if objectsBeingChecked == objectsBeingChecked.flClass
        break
      else objectsBeingChecked = objectsBeingChecked.flClass

    return FLNil.createNew()

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) = (value)"),
    commonPropertyAssignmentFunction

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) ← (value)"),
    commonPropertyAssignmentFunction

  classToAddThemTo.addMethod \
    (flTokenize ". evaluating (variable)"),
    commonPropertyAccessFunction

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) += (value)"),
    (context) ->
      # this is a token
      variable = context.lookupTemp "variable"
      value = context.lookupTemp "value"

      runThis = flTokenize "(self . evaluating variable) += value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      @instanceVariablesDict[ValidIDfromString variable.value] = toBeReturned
      

      return toBeReturned

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) *= (value)"),
    (context) ->
      # this is a token
      variable = context.lookupTemp "variable"
      value = context.lookupTemp "value"

      runThis = flTokenize "(self . evaluating variable) *= value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      @instanceVariablesDict[ValidIDfromString variable.value] = toBeReturned
      

      return toBeReturned

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) ++"),
    (context) ->
      # this is a token
      variable = context.lookupTemp "variable"

      runThis = flTokenize "(self . evaluating variable) ++"

      # yield from
      toBeReturned = runThis.eval context, runThis

      @instanceVariablesDict[ValidIDfromString variable.value] = toBeReturned

      return toBeReturned

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable)"),
    commonPropertyAccessFunction

  # we DON't want the signature to be "closed", so we use
  #  (flTokenize "answer : ( 'signature ) by ( methodBody )"),
  # however then we need another variant of "answer" called "answerEvalSignatureAndBody"
  # that can take an evaluated parameter, because the implementation for
  # "to" needs it.
  #
  # Note that you can call "answer" on both a Class or on any instance
  # of any class. In the second case, you'll still have to add the method
  # to the class, not to the instance.

  classToAddThemTo.addMethod \
    (flTokenize "answer: ( 'signature ) by: ( 'methodBody )"),
    (context) ->
      #yield
      signature = context.lookupTemp "signature"
      methodBody = context.lookupTemp "methodBody"

      if @isClass()
        @addMethod signature, methodBody
      else
        @flClass.addMethod signature, methodBody

      
      return @

  classToAddThemTo.addMethod \
    (flTokenize "answerEvalSignatureAndBody ( signature ) by ( methodBody )"),
    (context) ->
      #yield
      signature = context.lookupTemp "signature"
      methodBody = context.lookupTemp "methodBody"

      log "answer: giving the method body a definitionContext!"
      methodBody.definitionContext = context.previousContext
      methodBody.giveDefinitionContextToElements context.previousContext

      if @isClass()
        @addMethod signature, methodBody
      else
        @flClass.addMethod signature, methodBody

      
      return @

  classToAddThemTo.addMethod \
    (flTokenize "answer with priority (priority) : ( 'signature ) by: ( 'methodBody )"),
    (context) ->
      #yield
      signature = context.lookupTemp "signature"
      methodBody = context.lookupTemp "methodBody"
      priority = context.lookupTemp "priority"

      if @isClass()
        @addMethod signature, methodBody, priority.value
      else
        @flClass.addMethod signature, methodBody, priority.value

      
      return @


# with time, allClasses contains all the classes
# (boot classes and user-defined classes), but right
# now only the boot classes (i.e. primitive classes +
# helper classes such as FLForClass, etc.) have been defined
# We call this set the "bootClasses"
bootClasses = allClasses.slice()

clearClasses = ->
  # user might have modified some methods in the boot
  # classes.
  for eachClass in bootClasses
    eachClass.resetInstanceVariables()
    eachClass.resetMethods()

  allClasses = []

initBootClasses = ->
  # Common to all -------------------------------------------------------------------
  # first, add the methods common to them all
  # then we'll proceed to add the class-specific classes

  for eachClass in bootClasses
    addDefaultMethods eachClass


  # WorkSpace -----------------------------------------------------------------------


  # Token ---------------------------------------------------------------------------

  FLToken.addMethod \
    (flTokenize "← ( valueToAssign )"),
    (context, definitionContext) ->
      #yield
      valueToAssign = context.lookupTemp "valueToAssign"

      assigneeTokenString = @value

      if methodsExecutionDebug
        log "evaluation " + indentation() + "assignment to token " + assigneeTokenString
        log "evaluation " + indentation() + "value to assign to token: " + assigneeTokenString + " : " + valueToAssign.value
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()

      context.isTransparent = true

      @assignValue context, definitionContext, valueToAssign

      context.isTransparent = false
      return valueToAssign

  FLToken.addMethod \
    (flTokenize "= ( valueToAssign )"),
    (context, definitionContext) ->
      #yield
      valueToAssign = context.lookupTemp "valueToAssign"

      assigneeTokenString = @value

      if methodsExecutionDebug
        log "evaluation " + indentation() + "assignment to token " + assigneeTokenString
        log "evaluation " + indentation() + "value to assign to token: " + assigneeTokenString + " : " + valueToAssign.value
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()

      context.isTransparent = true

      @assignValue context, definitionContext, valueToAssign

      context.isTransparent = false
      
      return valueToAssign

  commonClassCreationFunction = (context, definitionContext, assigneeToken, className) ->
    #yield
    valueToAssign = FLClass.createNew className

    if methodsExecutionDebug
      log "evaluation " + indentation() + "assignment to token " + assigneeToken.value
      log "evaluation " + indentation() + "value to assign to token: " + assigneeToken.value + " : " + valueToAssign.value
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()

    context.isTransparent = true

    assigneeToken.assignValue context, definitionContext, valueToAssign
    
    return valueToAssign

  FLToken.addMethod \
    (flTokenize "= Class new"),
    (context, definitionContext) ->
      # yield from
      toBeReturned = commonClassCreationFunction context, definitionContext, @, @value
      return toBeReturned

  FLToken.addMethod \
    (flTokenize "= Class new named (theName)"),
    (context, definitionContext) ->
      theName = context.lookupTemp "theName"
      # yield from
      toBeReturned = commonClassCreationFunction context, definitionContext, @, theName.value
      return toBeReturned

  FLToken.addMethod \
    (flTokenize "+= ( operandum )"),
    (flTokenize "self ← self eval + operandum")

  FLToken.addMethod \
    (flTokenize "*= ( operandum )"),
    (flTokenize "self ← self eval * operandum")

  FLToken.addMethod \
    (flTokenize "++"),
    (flTokenize "self ← self eval + 1")


  # Nil ---------------------------------------------------------------------------

  FLNil.addMethod \
    (flTokenize "== ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.lookupTemp "toCompare"
      if toCompare.flClass == FLNil
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false
    ,7

  # In ---------------------------------------------------------------------------

  FLIn.addMethod \
    (flTokenize "(object) do ('code)"),
    (context) ->
      object = context.lookupTemp "object"
      code = context.lookupTemp "code"

      newContext = new FLContext context, object

      # yield from
      toBeReturned = code.eval newContext, code
      

      return toBeReturned

  # To -------------------------------------------------------------------------

  # TODO it'd be nice if there was a way not to leak the TempClass
  # Note 1----
  # we DON't want the signature to be "closed", so we use
  #  (flTokenize "( ' functionObjectName ) : ( 'signature ) do: ( 'functionBody )"),
  # however at that point we also had to adjust the signature in
  # "answer" otherwise you
  # have a discrepancy, and "answer" needs an additional version
  # that evaluates the signature because it needs
  # a version where the signature is evalled exactly to implement the "to"
  # here below.
  #
  # Note 2----
  # the "functionObjectName" is not evalled to keep definitions more logo-like
  # otherwise if you want to eval it you need to have it on its own line
  # otherwise its evaluation might eat up the signature definition that
  # follows it.
  # The drawback is that you can't conditionally name a functionObjectName
  # but that's not that common in other languages either.

  FLTo.addMethod \
    (flTokenize "( ' functionObjectName ) : ( 'signature ) do: ( 'functionBody )"),
    flTokenize \
      # functionObjectName contains a token i.e.
      # it's a pointer. So to put something inside the
      # variable *it's pointing at*,
      # you need to do "functionObjectName eval"

      # we take the "if" when the token is completely new, or if it's
      # a string or a number for example, because it's clear that we don't
      # want to add new methods to String or Number using "to" in
      # that way. So we create a temp class and put a single instance
      # of such class in the token.
      #
      # we skip the "if" when the token is bound to anything else other than
      # a primitive type. In that case we just add/replace the
      # method to whatever the token is bound to

      """
      accessUpperContext
      if (nil == functionObjectName eval) or (functionObjectName eval isPrimitiveType):
      ﹍'TempClass ← Class new
      ﹍TempClass nameit "Class_of_" + functionObjectName
      ﹍functionObjectName ← TempClass new
      ﹍TempClass answerEvalSignatureAndBody (signature) by (functionBody)
      functionObjectName eval answerEvalSignatureAndBody (signature) by (functionBody)
      """

  # TODO it'd be nice if there was a way not to leak the TempClass
  FLTo.addMethod \
    (flTokenize "( ' functionObjectName ) : ( 'functionBody )"),
    flTokenize \
      # see comments in method definition above
      """
      accessUpperContext
      if (nil == functionObjectName eval) or (functionObjectName eval isPrimitiveType):
      ﹍'TempClass ← Class new
      ﹍TempClass nameit "Class_of_" + functionObjectName
      ﹍functionObjectName ← TempClass new
      functionObjectName eval answerEvalSignatureAndBody: () by (functionBody)
      """

  # Class -------------------------------------------------------------------------

  # Class. Like all classes, it's also an object, but it's the only object
  # in the system that has the capacity to create
  # new classes, via the "new" message below.

  FLClass.addMethod \
    (flTokenize "new"),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "///////// creating a new class for the user!"
      @createNew()

  # Exception -------------------------------------------------------------------------

  FLException.addMethod \
    (flTokenize "new"),
    (context) ->
      #yield
      @createNew ""

  FLException.addMethod \
    (flTokenize "initWith ( errorMessage )"),
    (context) ->
      #yield
      errorMessage = context.lookupTemp "errorMessage"
      @value = errorMessage.value
      return @

  FLException.addMethod \
    (flTokenize "catch all : ( ' errorHandle )"),
    (context) ->
      errorHandle = context.lookupTemp "errorHandle"

      if methodsExecutionDebug
        log "catch: being thrown? " + context.throwing
        log "catch: got right exception, catching it"
      
      if @thrown
        # yield from
        toBeReturned = errorHandle.eval context, errorHandle
      else
        toBeReturned = @
      

      return toBeReturned

  FLException.addMethod \
    # theError here is a token!
    (flTokenize "catch ( 'theError ) : ( ' errorHandle )"),
    (context) ->
      #yield
      theError = context.lookupTemp "theError"
      errorHandle = context.lookupTemp "errorHandle"

      # OK this is tricky: we'd normally just evaluate this from the
      # signature BUT we can't, because it's going to be in this form:
      # WITHOUT parens
      #    catch someError :
      # so it's going to try to match the ":" token, and
      # whenever an exception touches
      # anything else other than a catch, it ALWAYS matches and
      # re-throws itself, because this
      # is how we get exceptions to bubble up when they are not
      # caught. So, we get the token instead, and we look it up
      # here.
      # theError here is a token, with this evaluation we get an
      # actual exception.
      # yield from
      theError = theError.eval context, theError

      if methodsExecutionDebug
        log "catch: same as one to catch?" + (@ == theError) + " being thrown? " + context.throwing

      if @ == theError
        if methodsExecutionDebug
          log "catch: got right exception, catching it"
        if @thrown
          # yield from
          toBeReturned = errorHandle.eval context, errorHandle
        else
          toBeReturned = @

        
      else
        if methodsExecutionDebug
          log "catch: got wrong exception, propagating it"
        toBeReturned = @
        

      return toBeReturned

  FLException.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      if @thrown
        context.throwing = true
      return @


  # String -------------------------------------------------------------------------

  FLString.addMethod \
    (flTokenize "new"),
    (context) ->
      #yield
      @createNew ""

  FLString.addMethod \
    (flTokenize "+ ( stringToBeAppended )"),
    (context) ->
      #yield
      stringToBeAppended = context.lookupTemp "stringToBeAppended"
      return FLString.createNew @value + stringToBeAppended.flToString()
    ,4

  FLString.addMethod \
    (flTokenize "== ( toCompare )"),
    commonSimpleValueEqualityFunction,
    7

  FLString.addMethod \
    (flTokenize "!= ( toCompare )"),
    commonSimpleValueInequalityFunction,
    7

  # Number -------------------------------------------------------------------------

  FLNumber.addMethod \
    (flTokenize "new"),
    (context) ->
      #yield
      @createNew 0

  FLNumber.addMethod \
    (flTokenize "anotherPrint"),
    flTokenize "console print self"

  FLNumber.addMethod \
    (flTokenize "doublePrint"),
    flTokenize "console print(console print self)"

  # mutates the very object
  FLNumber.addMethod \
    (flTokenize "incrementInPlace"),
    # this one below actually mutates the number
    # object
    flTokenize "self ← self + 1"


  FLNumber.addMethod \
    (flTokenize "factorialtwo"),
    flTokenize "if self == 0: ( 1 ) else: (self * ( ( self minus 1 ) factorialtwo ))"

  FLNumber.addMethod \
    (flTokenize "factorialthree"),
    flTokenize "if self == 0: ( 1 ) else: ('temp ← self;console print temp; ( self minus 1 ) factorialthree * temp )"

  FLNumber.addMethod \
    (flTokenize "factorialfour"),
    flTokenize \
      "if self == 0: ( 1 ) else: ('temp ← self;\
      ( self minus 1 ) factorialfour * temp )"

  FLNumber.addMethod \
    (flTokenize "factorialfive"),
    flTokenize \
      "if self == 0: ( 1 ) else: (1 + 1;'temp ← self;\
      ( self minus 1 ) factorialfive * temp )"

  FLNumber.addMethod \
    (flTokenize "factorialsix"),
    flTokenize "if self == 0: ( 1 ) else: (( self minus 1 ) factorialsix * self)"


  FLNumber.addMethod \
    (flTokenize "amIZero"),
    flTokenize "self == 0"

  FLNumber.addMethod \
    (flTokenize "printAFromDeeperCall"),
    flTokenize "console print a"

  # generates a range list including the extremes
  # e.g. 1...1 is (1), 1...0 is (1 0), 1...2 is (1 2)
  #
  # hs higher priority NUMBER (i.e. lower precedence)
  # than +,-,*,/ so things like this can work:
  #    
  #   for each number in:
  #     numParams-1...0
  #
  FLNumber.addMethod \
    (flTokenize "...(endRange)"),
    (context) ->
      #yield
      endRange = context.lookupTemp "endRange"
      listToBeReturned = FLList.createNew()
      for i in [@value..endRange.value]
        listToBeReturned.value.jsArrayPush FLNumber.createNew i
        listToBeReturned.cursorEnd++

      return listToBeReturned
    ,5

  # ---

  BasePlusFunction =  (context) ->
    #yield
    operandum = context.lookupTemp "operandum"
    # todo more type conversions needed, and also in the other operations
    if operandum.flClass == FLString
      return FLString.createNew @value + operandum.value
    else
      return FLNumber.createNew @value + operandum.value

  FLNumber.addMethod \
    (flTokenize "$plus_binary_default ( operandum )"),
    BasePlusFunction

  FLNumber.addMethod \
    (flTokenize "+ ( operandum )"),
    (flTokenize "self $plus_binary_default operandum"),
    4

  # although there are some good reasons to have this,
  # it can get confusing, consider for example
  # a++ ++
  # the first ++ does this: a = a+1 and returns a number
  # the second just increments the number without modifying
  # a.
  FLNumber.addMethod \
    (flTokenize "++"),
    flTokenize "self + 1"

  # see "++" regarding why this could be confusing
  FLNumber.addMethod \
    (flTokenize "+= (value)"),
    flTokenize "self + value"

  # ---

  BasePercentFunction =  (context) ->
    #yield
    operandum = context.lookupTemp "operandum"
    return FLNumber.createNew @value % operandum.value

  FLNumber.addMethod \
    (flTokenize "$percent_binary_default ( operandum )"),
    BasePercentFunction

  FLNumber.addMethod \
    (flTokenize "% ( operandum )"),
    (flTokenize "self $percent_binary_default operandum"),
    3

  # ---

  BaseFloorDivisionFunction =  (context) ->
    #yield
    operandum = context.lookupTemp "operandum"
    return FLNumber.createNew Math.floor(@value / operandum.value)

  FLNumber.addMethod \
    (flTokenize "$floordivision_binary_default ( operandum )"),
    BaseFloorDivisionFunction

  FLNumber.addMethod \
    (flTokenize "/_ ( operandum )"),
    (flTokenize "self $floordivision_binary_default operandum"),
    3

  # ---

  BaseMinusFunction =  (context) ->
    #yield
    operandum = context.lookupTemp "operandum"
    return FLNumber.createNew @value - operandum.value

  FLNumber.addMethod \
    (flTokenize "$minus_binary_default ( operandum )"),
    BaseMinusFunction

  FLNumber.addMethod \
    (flTokenize "- ( operandum )"),
    (flTokenize "self $minus_binary_default operandum"),
    4

  # ---

  BaseDivideFunction =  (context) ->
    #yield
    operandum = context.lookupTemp "operandum"
    return FLNumber.createNew @value / operandum.value

  FLNumber.addMethod \
    (flTokenize "$divide_binary_default ( operandum )"),
    BaseDivideFunction

  FLNumber.addMethod \
    (flTokenize "/ ( operandum )"),
    (flTokenize "self $divide_binary_default operandum"),
    3

  # ---

  BaseMultiplyFunction =  (context) ->
    #yield
    operandum = context.lookupTemp "operandum"
    return FLNumber.createNew @value * operandum.value

  FLNumber.addMethod \
    (flTokenize "$multiply_binary_default ( operandum )"),
    BaseMultiplyFunction

  FLNumber.addMethod \
    (flTokenize "* ( operandum )"),
    (flTokenize "self $multiply_binary_default operandum"),
    3

  # see "++" regarding why this could be confusing
  FLNumber.addMethod \
    (flTokenize "*= (value)"),
    flTokenize "self * value"

  # ---

  FLNumber.addMethod \
    (flTokenize "minus ( operandum )"),
    (context) ->
      #yield
      operandum = context.lookupTemp "operandum"
      return FLNumber.createNew @value - operandum.value

  FLNumber.addMethod \
    (flTokenize "selftimesminusone"),
    flTokenize "self * self minus 1"

  FLNumber.addMethod \
    (flTokenize "times ( ' loopCode )"),
    (context) ->
      loopCode = context.lookupTemp "loopCode"
      if methodsExecutionDebug
        log "FLNumber: times loop code is: " + loopCode.flToString()


      for i in [0...@value]
        # yield from
        toBeReturned = loopCode.eval context, loopCode

        #flContexts.pop()

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            if methodsExecutionDebug
              log "times loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            if methodsExecutionDebug
              log "times loop exited with Return "
            break

      
      return toBeReturned




  FLNumber.addMethod \
    (flTokenize "== ( toCompare )"),
    commonSimpleValueEqualityFunction,
    7

  FLNumber.addMethod \
    (flTokenize "!= ( toCompare )"),
    commonSimpleValueInequalityFunction,
    7

  FLNumber.addMethod \
    (flTokenize "< ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.lookupTemp "toCompare"
      if @value < toCompare.value
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false
    ,6

  FLNumber.addMethod \
    (flTokenize "> ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.lookupTemp "toCompare"
      if @value > toCompare.value
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false
    ,6

  # mutating the number
  FLNumber.addMethod \
    (flTokenize "← ( valueToAssign )"),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "evaluation " + indentation() + "assigning to number! "
      valueToAssign = context.lookupTemp "valueToAssign"
      @value = valueToAssign.value
      return @



  # Boolean -------------------------------------------------------------------------

  FLBoolean.addMethod \
    (flTokenize "negate"),
    (context) ->
      #yield
      return FLBoolean.createNew !@value

  FLBoolean.addMethod \
    (flTokenize "and ( operandum )"),
    (context) ->
      #yield
      operandum = context.lookupTemp "operandum"
      return FLBoolean.createNew @value and operandum.value

  FLBoolean.addMethod \
    (flTokenize "or ( operandum )"),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "executing an or! "
      operandum = context.lookupTemp "operandum"
      return FLBoolean.createNew @value or operandum.value

  FLBoolean.addMethod \
    (flTokenize "== ( toCompare )"),
    commonSimpleValueEqualityFunction,
    7

  FLBoolean.addMethod \
    (flTokenize "!= ( toCompare )"),
    commonSimpleValueInequalityFunction,
    7


  # FLQuote --------------------------------------------------------------------------

  FLQuote.addMethod \
    (flTokenize "( ' operandum )"),
    (context) ->
      #yield
      operandum = context.lookupTemp "operandum"

      if operandum.flClass == FLList
        log "list quote, giving it a definitionContext!"
        operandum.definitionContext = context.previousContext
        operandum.giveDefinitionContextToElements context.previousContext

      return operandum


  # Not --------------------------------------------------------------------------
  FLNot.addMethod \
    (flTokenize "( operandum )"),
    flTokenize "operandum negate"

  # UnaryMinus --------------------------------------------------------------------------
  FLUnaryMinus.addMethod \
    (flTokenize "( operandum )"),
    flTokenize "0 - operandum",
    4

  # ListLiteralArrayNotationStarter -------------------------------------------------------------------------

  FLListLiteralArrayNotationStarter.addMethod \
    (flTokenize "]"),
    (context) ->
      #yield
      # returns a List, not an ListLiteralArrayNotation
      return FLList.createNew()

  FLListLiteralArrayNotationStarter.addMethod \
    (flTokenize "( elementToBeAppended )"),
    (context) ->
      #yield
      # returns an ListLiteralArrayNotation with the first element put in
      elementToBeAppended = context.lookupTemp "elementToBeAppended"
      toBeReturned = FLListLiteralArrayNotation.createNew()
      toBeReturned.value.mutablePush elementToBeAppended
      return toBeReturned

  # ListLiteralArrayNotation -------------------------------------------------------------------------

  FLListLiteralArrayNotation.addMethod \
    (flTokenize "]"),
    (context) ->
      #yield
      # returns a List, not an ListLiteralArrayNotation
      return @value

  FLListLiteralArrayNotation.addMethod \
    (flTokenize ", ( elementToBeAppended )"),
    (context) ->
      #yield
      elementToBeAppended = context.lookupTemp "elementToBeAppended"
      @value.mutablePush elementToBeAppended
      return @

  # List -------------------------------------------------------------------------

  FLList.addMethod \
    (flTokenize "new"),
    (context) ->
      #yield
      @createNew()

  FLList.addMethod \
    (flTokenize "+ ( elementToBeAppended )"),
    (context) ->
      #yield
      elementToBeAppended = context.lookupTemp "elementToBeAppended"
      if methodsExecutionDebug
        log "appending element to: " + @flToString() + " : " + elementToBeAppended.toString()
      return @flListImmutablePush elementToBeAppended
    ,4

  FLList.addMethod \
    (flTokenize "length"),
    (context) ->
      #yield
      return FLNumber.createNew @length()

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] = (value)"),
    (context) ->
      #yield
      indexValue = context.lookupTemp "indexValue"
      value = context.lookupTemp "value"
      
      # -1 here is because arrays in Fizzylogo are 1-based
      return @elementAtSetMutable indexValue.value - 1, value

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] += (value)"),
    (context) ->
      indexValue = context.lookupTemp "indexValue"
      value = context.lookupTemp "value"

      runThis = flTokenize "(self [indexValue]) += value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      # -1 here is because arrays in Fizzylogo are 1-based
      @elementAtSetMutable indexValue.value - 1, toBeReturned

      return toBeReturned

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] *= (value)"),
    (context) ->
      indexValue = context.lookupTemp "indexValue"
      value = context.lookupTemp "value"

      runThis = flTokenize "(self [indexValue]) *= value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      # -1 here is because arrays in Fizzylogo are 1-based
      @elementAtSetMutable indexValue.value - 1, toBeReturned

      return toBeReturned

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] ++"),
    (context) ->
      indexValue = context.lookupTemp "indexValue"

      runThis = flTokenize "(self [indexValue]) ++"

      # yield from
      toBeReturned = runThis.eval context, runThis

      # -1 here is because arrays in Fizzylogo are 1-based
      @elementAtSetMutable indexValue.value - 1, toBeReturned

      return toBeReturned


  FLList.addMethod \
    (flTokenize "[ (indexValue) ]"),
    (context) ->
      #yield
      indexValue = context.lookupTemp "indexValue"
      if methodsExecutionDebug
        log "reading list element at index: "+ indexValue.value

      context.justDidAFieldOrArrayAccess = true
      # -1 here is because arrays in Fizzylogo are 1-based
      return @elementAt indexValue.value - 1


  FLList.addMethod \
    (flTokenize "each ( ' variable ) do ( ' code )"),
    (context) ->

      variable = context.lookupTemp "variable"
      code = context.lookupTemp "code"

      if methodsExecutionDebug
        log "FLList each do "

      newContext = new FLContext context

      for i in [0...@value.length]

        newContext.tempVariablesDict[ValidIDfromString variable.value] = @elementAt i
        # yield from
        toBeReturned = code.eval newContext, code

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            if methodsExecutionDebug
              log "list-each-do loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            if methodsExecutionDebug
              log "list-each-do loop exited with Return "
            break

      return toBeReturned


  # AccessUpperContextClass -------------------------------------------------------------------------

  FLAccessUpperContext.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "FLAccessUpperContext running emptyMessage"
        log "context.previousContext now tramsparent at depth: " + context.previousContext.depth() + " with self: " + context.previousContext.self.flToString?()
      context.previousContext.isTransparent = true
      return @

  # Console -----------------------------------------------------------------------------

  FLConsole.addMethod \
    (flTokenize "print ( thingToPrint )"),
    (context) ->
      #yield
      thingToPrint = context.lookupTemp "thingToPrint"
      stringToPrint = thingToPrint.flToString()
      if methodsExecutionDebug
        log "///////// program printout: " + stringToPrint
      if textOutputElement?
        textOutputElement.value += stringToPrint

      rWorkspace.environmentPrintout += stringToPrint
      return thingToPrint

  # Turtle -----------------------------------------------------------------------------

  FLTurtle.addMethod \
    (flTokenize "home"),
    (context) ->
      #yield
      @sendHome()
      return @


  FLTurtle.addMethod \
    (flTokenize "forward ( distance )"),
    (context) ->
      #yield
      distance = context.lookupTempValue "distance"
      if canvasOutputElement?
        canvasContext = canvasOutputElement.getContext("2d");
        canvasContext.strokeStyle = "#000";
        canvasContext.lineWidth = 1;

        radians = @direction * Math.PI / 180.0

        if @penDown
          canvasContext.beginPath()
          canvasContext.moveTo @x, @y

        # new coords. The minus is because of
        # how HTML5 Canvas orients its y axis (points downwards)
        @x += distance * Math.sin radians
        @y -= distance * Math.cos radians

        if @penDown
          canvasContext.lineTo @x,@y
          canvasContext.stroke()

      return @

  FLTurtle.addMethod \
    (flTokenize "right ( degrees )"),
    (context) ->
      #yield
      degrees = context.lookupTempValue "degrees"
      @direction += degrees
      @direction = @direction % 360
    
      return @

  FLTurtle.addMethod \
    (flTokenize "left ( degrees )"),
    (context) ->
      #yield
      degrees = context.lookupTempValue "degrees"
      @direction += (360-degrees)
      @direction = @direction % 360
    
      return @


  # Done -------------------------------------------------------------------------

  FLDone.addMethod \
    (flTokenize "with ( valueToReturn )"),
    (context) ->
      #yield
      valueToReturn = context.lookupTemp "valueToReturn"
      if methodsExecutionDebug
        log "Done_object thrown with return value: " + valueToReturn.flToString()
      @value = valueToReturn
      context.throwing = true
      @thrown = true
      return @

  FLDone.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "Done_object running emptyMessage"
      context.throwing = true
      @thrown = true
      return @

  # Break -------------------------------------------------------------------------

  FLBreak.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "Break_object"
      context.throwing = true
      return @

  # Return -------------------------------------------------------------------------

  FLReturn.addMethod \
    (flTokenize "( valueToReturn )"),
    (context) ->
      #yield
      valueToReturn = context.lookupTemp "valueToReturn"

      if methodsExecutionDebug
        log "Return_object running a value"

      @value = valueToReturn
      context.throwing = true
      return @

  FLReturn.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "Return_object running emptyMessage"
      context.throwing = true
      @value = FLNil.createNew()
      return @




  # Repeat1 -------------------------------------------------------------------------

  FLRepeat1.addMethod \
    (flTokenize "( ' loopCode )"),
    (context) ->
      context.isTransparent = true
      if methodsExecutionDebug
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
        log "FLRepeat1 ⇒ loop code is: " + loopCode.flToString()
      loopCode = context.lookupTemp "loopCode"

      loop
        
        context.throwing = false

        # yield from
        toBeReturned = loopCode.eval context, loopCode

        #flContexts.pop()

        if methodsExecutionDebug
          log "Repeat1 ⇒ returning result after loop cycle: " + toBeReturned
          log "Repeat1 ⇒ returning result CLASS after loop cycle: "
          log "Repeat1 ⇒ remaining message after loop cycle: "
          log "Repeat1 ⇒ message length:  "
          log "Repeat1 ⇒ did I receive a Done? " + (if toBeReturned?.flClass == FLDone then "yes" else "no")

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            if methodsExecutionDebug
              log "Repeat1 ⇒ the loop exited with Done at context depth " + context.depth()
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            if methodsExecutionDebug
              log "Repeat1 ⇒ the loop exited with Return "
            break

      return toBeReturned

  # Repeat2 -------------------------------------------------------------------------

  repeatFunctionContinuation = (context) ->
    context.isTransparent = true
    if methodsExecutionDebug
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
    howManyTimes = context.lookupTemp "howManyTimes"
    loopCode = context.lookupTemp "loopCode"
    if methodsExecutionDebug
      log "FLRepeat2 ⇒ loop code is: " + loopCode.flToString()

    if howManyTimes.flClass == FLForever
      limit = Number.MAX_SAFE_INTEGER
    else
      limit = howManyTimes.value


    for i in [0...limit]
      #yield "from repeatFunctionContinuation"
      if methodsExecutionDebug
        log "Repeat2 ⇒ starting a(nother) cycle: "
      # yield from
      toBeReturned = loopCode.eval context, loopCode

      #flContexts.pop()

      if methodsExecutionDebug
        log "Repeat2 ⇒ returning result after loop cycle: " + toBeReturned
        log "Repeat2 ⇒ returning result CLASS after loop cycle: "
        log "Repeat2 ⇒ remaining message after loop cycle: "
        log "Repeat2 ⇒ message length:  "
        log "Repeat2 ⇒ did I receive a Done? " + (if toBeReturned?.flClass == FLDone then "yes" else "no")
        log "Repeat2 ⇒ did I receive a thrown object? " + (if context.throwing then "yes" else "no")

      # catch any thrown "done" object, used to
      # exit from a loop.
      if toBeReturned?
        if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
          context.throwing = false
          if toBeReturned.value?
            toBeReturned = toBeReturned.value
          if methodsExecutionDebug
            log "Repeat2 ⇒ the loop exited with Done at context depth " + context.depth()
          break
        if context.throwing and toBeReturned.flClass == FLReturn
          if methodsExecutionDebug
            log "Repeat2 ⇒ the loop exited with Return "
          break

    
    return toBeReturned

  FLRepeat2.addMethod \
    (flTokenize "(howManyTimes) :( ' loopCode )"),
    repeatFunctionContinuation

  # FLEvaluationsCounter -----------------------------------------------------------------------------

  FLEvaluationsCounter.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      stringToPrint = "EvaluationsCounter running the \"empty\" method // "
      if methodsExecutionDebug
        log stringToPrint
      rWorkspace.environmentPrintout += stringToPrint
      return @

  # Throw -----------------------------------------------------------------------------

  FLThrow.addMethod \
    (flTokenize "( theError )"),
    (context) ->
      #yield
      theError = context.lookupTemp "theError"
      theError.thrown = true
      if methodsExecutionDebug
        log "throwing an error: " + theError.value
      context.throwing = true
      return theError

  # IfThen -----------------------------------------------------------------------------

  FLIfThen.addMethod \
    (flTokenize "( predicate ) : ('trueBranch)"),
    (context) ->
      #yield
      context.isTransparent = true
      if methodsExecutionDebug
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      predicate = context.lookupTemp "predicate"
      trueBranch = context.lookupTemp "trueBranch"
      if methodsExecutionDebug
        log "FLIfThen: predicate value is: " + predicate.value

      if predicate.value
        if methodsExecutionDebug
          log "FLIfThen: evaling true branch at depth " + context.depth()
        # yield from
        toBeReturned = trueBranch.eval context, trueBranch
        #flContexts.pop()
        
      else
        toBeReturned = FLIfFallThrough.createNew()

      return toBeReturned

  # FLIfFallThrough -----------------------------------------------------------------------------

  # all these "emptyMessage" signatures are going to be examined
  # last because "addMethod" sorts all methods in order of increasing
  # genericity. (more generic matches will be done last)
  FLIfFallThrough.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      if methodsExecutionDebug
        log "no more cases for the if"
      
      return FLNil.createNew()

  FLIfFallThrough.addMethod \
    (flTokenize "else if ( predicate ): ('trueBranch)"),
    (context) ->
      #yield
      context.isTransparent = true
      if methodsExecutionDebug
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      predicate = context.lookupTemp "predicate"
      trueBranch = context.lookupTemp "trueBranch"
      if methodsExecutionDebug
        log "FLIfFallThrough: predicate value is: " + predicate.value
        log "FLIfFallThrough: true branch is: " + trueBranch.flToString()

      if predicate.value
        # yield from
        toBeReturned = trueBranch.eval context, trueBranch
        #flContexts.pop()
        
      else
        toBeReturned = FLIfFallThrough.createNew()

      return toBeReturned

  FLIfFallThrough.addMethod \
    (flTokenize "else: ('trueBranch)"),
    (context) ->
      if methodsExecutionDebug
        log "FLIfFallThrough else: case "
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      context.isTransparent = true
      trueBranch = context.lookupTemp "trueBranch"

      # yield from
      if methodsExecutionDebug
        log "FLIfFallThrough else: evalling code "
      toBeReturned = trueBranch.eval context, trueBranch
      #flContexts.pop()
      
      return toBeReturned




  # Try -----------------------------------------------------------------------------

  FLTry.addMethod \
    (flTokenize ": ( ' code )"),
    (context) ->
      code = context.lookupTemp "code"
      # yield from
      toBeReturned = code.eval context, code

      # if there _is_ somethig being thrown, then
      # we do not want another receiver, the thrown
      # exception has to go through some catches
      # hopefully.
      

      context.throwing = false
      return toBeReturned

  # Pause -----------------------------------------------------------------------------

  pauseFunctionContinuation = (context) ->
    #yield
    seconds = context.lookupTemp "seconds"
    startTime = new Date().getTime()
    endTime = startTime + seconds.value * 1000
    while (remainingTime = new Date().getTime() - endTime) < 0
      #yield remainingTime
      "do nothing"

    
    return @

  FLPause.addMethod \
    (flTokenize "( seconds )"),
    pauseFunctionContinuation

  # For -----------------------------------------------------------------------------

  FLFor.addMethod \
    (flTokenize "( ' loopVar ) from ( startIndex ) to ( endIndex ) : ( 'loopCode )"),
    (context) ->
      context.isTransparent = true
      if methodsExecutionDebug
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      loopVar = context.lookupTemp "loopVar"
      startIndex = context.lookupTemp "startIndex"
      endIndex = context.lookupTemp "endIndex"
      loopCode = context.lookupTemp "loopCode"

      loopVarName = loopVar.value

      forContext = new FLContext context
      forContext.isTransparent = true
      #flContexts.jsArrayPush forContext

      if methodsExecutionDebug
        log "FLFor ⇒ loop code is: " + loopCode.flToString()

      for i in [startIndex.value..endIndex.value]
        if methodsExecutionDebug
          log "FLFor ⇒ loop iterating variable to " + i

        # the looping var is always in the new local for context
        # so it keeps any previous instance safe, and goes
        # away when this for is done.
        forContext.tempVariablesDict[ValidIDfromString loopVarName] = FLNumber.createNew i

        # yield from
        toBeReturned = loopCode.eval forContext, loopCode

        #flContexts.pop()

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            if methodsExecutionDebug
              log "For ⇒ the loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            if methodsExecutionDebug
              log "For ⇒ the loop exited with Return "
            break

      #flContexts.pop()

      
      return toBeReturned

  # there a few tricks that we performs on 'theList
  # FIRST OFF, we can't just pass theList as an evaluated
  # parameter because if you pass a list literal, then you
  # need the : to mean "quote", but at that point you can't
  # use the : when you pass statements that create a list
  # That does work, but it makes it tricky to understand when
  # to use the : and when not to.
  # So we make theList a quoted param instead, and we eval it.
  # If the evaluation returns a list, then we take that as
  # input. If not, we take the original list as input.
  FLFor.addMethod \
    (flTokenize "each ( ' variable ) in: ( theList ) do: ( 'code )"),
    (context) ->
      #yield
      context.isTransparent = true
      if methodsExecutionDebug
        log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      variable = context.lookupTemp "variable"
      theList = context.lookupTemp "theList"
      code = context.lookupTemp "code"

      if theList.flClass != FLList
        context.throwing = true
        # TODO this error should really be a stock error referanceable
        # from the workspace because someone might want to catch it.
        return FLException.createNew "for...each expects a list"

      # trivial case
      if theList.isEmpty()
        
        return theList

      if methodsExecutionDebug
        log "FLEach do on the list: " + theList.flToString()

      forContext = new FLContext context
      forContext.isTransparent = true

      for i in [0...theList.value.length]
        forContext.throwing = false

        if methodsExecutionDebug
          log "FLEach element at " + i + " : " + (theList.elementAt i).flToString()
        forContext.tempVariablesDict[ValidIDfromString variable.value] = theList.elementAt i
        if methodsExecutionDebug
          log "FLEach do evaling...: " + code.flToString()
        # yield from
        toBeReturned = code.eval forContext, code

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            if methodsExecutionDebug
              log "for-each-in-list loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            if methodsExecutionDebug
              log "for-each-in-list loop exited with Return "
            break

      
      return toBeReturned
