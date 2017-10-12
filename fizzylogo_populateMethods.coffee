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
  toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
  if @value == toCompare.value
    return FLBoolean.createNew true
  else
    return FLBoolean.createNew false

commonSimpleValueInequalityFunction = (context) ->
  #yield
  toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
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
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      newContext = new FLContext context
      newContext.isTransparent = true
      log "newContext now tramsparent at depth: " + newContext.depth() + " with self: " + newContext.self.flToString?()
      flContexts.jsArrayPush newContext
      # yield from
      toBeReturned = @eval newContext, @
      flContexts.pop()
      return toBeReturned


  # this is the common object identity function
  # strings, numbers and booleans override this
  # by just comparing the values.
  classToAddThemTo.addMethod \
    (flTokenize "== ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
      if @ == toCompare
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false

  # this is the common object identity function
  # strings, numbers and booleans override this
  # by just comparing the values.
  classToAddThemTo.addMethod \
    (flTokenize "!= ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
      if @ != toCompare
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false

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
    log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
    variable = context.tempVariablesDict[ValidIDfromString "variable"]
    value = context.tempVariablesDict[ValidIDfromString "value"]

    @instanceVariablesDict[ValidIDfromString variable.value] = value
    

    return @

  commonPropertyAccessFunction = (context) ->
    #yield
    context.isTransparent = true
    log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
    variable = context.tempVariablesDict[ValidIDfromString "variable"]

    log ". ('variable) : checking instance variables"

    # somewhat similar to Javascript, the lookup starts at the object
    # and climbs up to its class.
    objectsBeingChecked = @
    loop
      if objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]?
        log "yes it's an instance variable: "
        #dir objectsBeingChecked.instanceVariablesDict[ValidIDfromString variable.value]
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
      variable = context.tempVariablesDict[ValidIDfromString "variable"]
      value = context.tempVariablesDict[ValidIDfromString "value"]

      runThis = flTokenize "(self . evaluating variable) += value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      @instanceVariablesDict[ValidIDfromString variable.value] = toBeReturned
      

      return toBeReturned

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) *= (value)"),
    (context) ->
      # this is a token
      variable = context.tempVariablesDict[ValidIDfromString "variable"]
      value = context.tempVariablesDict[ValidIDfromString "value"]

      runThis = flTokenize "(self . evaluating variable) *= value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      @instanceVariablesDict[ValidIDfromString variable.value] = toBeReturned
      

      return toBeReturned

  classToAddThemTo.addMethod \
    (flTokenize ". ('variable) ++"),
    (context) ->
      # this is a token
      variable = context.tempVariablesDict[ValidIDfromString "variable"]

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
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      if @isClass()
        @addMethod signature, methodBody
      else
        @flClass.addMethod signature, methodBody

      
      return @

  classToAddThemTo.addMethod \
    (flTokenize "answerEvalSignatureAndBody ( signature ) by ( methodBody )"),
    (context) ->
      #yield
      signature = context.tempVariablesDict[ValidIDfromString "signature"]
      methodBody = context.tempVariablesDict[ValidIDfromString "methodBody"]

      if @isClass()
        @addMethod signature, methodBody
      else
        @flClass.addMethod signature, methodBody

      
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
      valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

      assigneeTokenString = @value

      log "evaluation " + indentation() + "assignment to token " + assigneeTokenString
      log "evaluation " + indentation() + "value to assign to token: " + assigneeTokenString + " : " + valueToAssign.value

      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()

      # check if temp variable is visible from here.
      # if not, create it.
      dictToPutValueIn = context.whichDictionaryContainsToken @

      if !dictToPutValueIn?
        dictToPutValueIn = definitionContext?.whichDictionaryContainsToken @

      if !dictToPutValueIn?
        # no such variable, hence we create it as temp, but
        # we can't create them in this very call context, that would
        # be useless, we place it in the context of the _previous_ context
        # note that this means that any construct that creates a new context
        # will seal the temp variables in it. For example "for" loops. This
        # is like the block scoping of C or Java. If you want function scoping, it
        # could be achieved for example by marking in a special way contexts
        # that have been created because of method calls and climbing back
        # to the last one of those...
        log "evaluation " + indentation() + "creating temp token: " + assigneeTokenString + " at depth: " + context.firstNonTransparentContext().depth() + " with self: " + context.firstNonTransparentContext().self.flToString()
        dictToPutValueIn = context.firstNonTransparentContext().tempVariablesDict
      else
        log "evaluation " + indentation() + "found temp token: " + assigneeTokenString

      dictToPutValueIn[ValidIDfromString assigneeTokenString] = valueToAssign

      log "evaluation " + indentation() + "stored value in dictionary"
      context.isTransparent = false
      return valueToAssign

  FLToken.addMethod \
    (flTokenize "= ( valueToAssign )"),
    (context, definitionContext) ->
      #yield
      valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]

      assigneeTokenString = @value

      log "evaluation " + indentation() + "assignment to token " + assigneeTokenString
      log "evaluation " + indentation() + "value to assign to token: " + assigneeTokenString + " : " + valueToAssign.value

      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()

      # check if temp variable is visible from here.
      # if not, create it.
      dictToPutValueIn = context.whichDictionaryContainsToken @

      if dictToPutValueIn?
        log "evaluation " + indentation() + "token IS in running context"

      if !dictToPutValueIn?
        log "evaluation " + indentation() + "token not in running context, trying definition context: " + definitionContext
        dictToPutValueIn = definitionContext?.whichDictionaryContainsToken @

      if !dictToPutValueIn?
        # no such variable, hence we create it as temp, but
        # we can't create them in this very call context, that would
        # be useless, we place it in the context of the _previous_ context
        # note that this means that any construct that creates a new context
        # will seal the temp variables in it. For example "for" loops. This
        # is like the block scoping of C or Java. If you want function scoping, it
        # could be achieved for example by marking in a special way contexts
        # that have been created because of method calls and climbing back
        # to the last one of those...
        log "evaluation " + indentation() + "creating temp token: " + assigneeTokenString
        dictToPutValueIn = context.firstNonTransparentContext().tempVariablesDict
      else
        log "evaluation " + indentation() + "found temp token: " + assigneeTokenString

      dictToPutValueIn[ValidIDfromString assigneeTokenString] = valueToAssign

      log "evaluation " + indentation() + "stored value in dictionary"

      context.isTransparent = false
      
      return valueToAssign

  commonClassCreationFunction = (context, definitionContext, assigneeTokenString, className) ->
    #yield
    valueToAssign = FLClass.createNew className

    log "evaluation " + indentation() + "assignment to token " + assigneeTokenString
    log "evaluation " + indentation() + "value to assign to token: " + assigneeTokenString + " : " + valueToAssign.value

    context.isTransparent = true
    log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()

    # check if temp variable is visible from here.
    # if not, create it.
    dictToPutValueIn = context.whichDictionaryContainsToken @

    if !dictToPutValueIn?
      dictToPutValueIn = definitionContext?.whichDictionaryContainsToken @

    if !dictToPutValueIn?
      # no such variable, hence we create it as temp, but
      # we can't create them in this very call context, that would
      # be useless, we place it in the context of the _previous_ context
      # note that this means that any construct that creates a new context
      # will seal the temp variables in it. For example "for" loops. This
      # is like the block scoping of C or Java. If you want function scoping, it
      # could be achieved for example by marking in a special way contexts
      # that have been created because of method calls and climbing back
      # to the last one of those...
      log "evaluation " + indentation() + "creating temp token: " + assigneeTokenString
      dictToPutValueIn = context.firstNonTransparentContext().tempVariablesDict
    else
      log "evaluation " + indentation() + "found temp token: " + assigneeTokenString

    dictToPutValueIn[ValidIDfromString assigneeTokenString] = valueToAssign

    log "evaluation " + indentation() + "stored value in dictionary"
    
    return valueToAssign

  FLToken.addMethod \
    (flTokenize "= Class new"),
    (context, definitionContext) ->
      # yield from
      toBeReturned = commonClassCreationFunction context, definitionContext, @value, @value
      return toBeReturned

  FLToken.addMethod \
    (flTokenize "= Class new named (theName)"),
    (context, definitionContext) ->
      theName = context.tempVariablesDict[ValidIDfromString "theName"]
      # yield from
      toBeReturned = commonClassCreationFunction context, definitionContext, @value, theName.value
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
      toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
      if toCompare.flClass == FLNil
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false

  # In ---------------------------------------------------------------------------

  FLIn.addMethod \
    (flTokenize "(object) do ('code)"),
    (context) ->
      object = context.tempVariablesDict[ValidIDfromString "object"]
      code = context.tempVariablesDict[ValidIDfromString "code"]

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

      # we take the first branch:
      # if the token is completely new, or if it's
      # a string or a number for example, because it's clear that we don't
      # want to add new methods to String or Number using "to" in
      # that way. So we create a temp class and put a single instance
      # of such class in the token.
      #
      # we take the second branch:
      # if the token is bound to anything else other than
      # a primitive type. In that case we just add/replace the
      # method to whatever the token is bound to

      """
      accessUpperContext
      if (nil == functionObjectName eval) or (functionObjectName eval isPrimitiveType):
      ﹍'TempClass ← Class new
      ﹍TempClass nameit "Class_of_" + functionObjectName
      ﹍functionObjectName ← TempClass new
      ﹍TempClass answerEvalSignatureAndBody (signature) by (functionBody)
      else:
      ﹍functionObjectName eval answerEvalSignatureAndBody (signature) by (functionBody)


      """

  # TODO it'd be nice if there was a way not to leak the TempClass
  FLTo.addMethod \
    (flTokenize "( ' functionObjectName ) : ( 'functionBody )"),
    flTokenize \
      """
      accessUpperContext
      // functionObjectName contains a token i.e.
      // it's a pointer. So to put something inside the
      // variable *it's pointing at*,
      // you need to do "functionObjectName eval"
      if (nil == functionObjectName eval) or (functionObjectName eval isPrimitiveType):
      ﹍'TempClass ← Class new
      ﹍TempClass nameit "Class_of_" + functionObjectName
      ﹍functionObjectName ← TempClass new
      ﹍TempClass answerEvalSignatureAndBody: () by (functionBody)
      else:
      ﹍functionObjectName eval answerEvalSignatureAndBody: () by (functionBody)

      
      """

  # Class -------------------------------------------------------------------------

  # Class. Like all classes, it's also an object, but it's the only object
  # in the system that has the capacity to create
  # new classes, via the "new" message below.

  FLClass.addMethod \
    (flTokenize "new"),
    (context) ->
      #yield
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
      errorMessage = context.tempVariablesDict[ValidIDfromString "errorMessage"]
      @value = errorMessage.value
      return @

  FLException.addMethod \
    (flTokenize "catch all : ( ' errorHandle )"),
    (context) ->
      errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

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
      theError = context.tempVariablesDict[ValidIDfromString "theError"]
      errorHandle = context.tempVariablesDict[ValidIDfromString "errorHandle"]

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

      log "catch: same as one to catch?" + (@ == theError) + " being thrown? " + context.throwing

      if @ == theError
        log "catch: got right exception, catching it"
        if @thrown
          # yield from
          toBeReturned = errorHandle.eval context, errorHandle
        else
          toBeReturned = @

        
      else
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
      stringToBeAppended = context.tempVariablesDict[ValidIDfromString "stringToBeAppended"]
      return FLString.createNew @value + stringToBeAppended.flToString()

  FLString.addMethod \
    (flTokenize "== ( toCompare )"),
    commonSimpleValueEqualityFunction

  FLString.addMethod \
    (flTokenize "!= ( toCompare )"),
    commonSimpleValueInequalityFunction

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

  FLNumber.addMethod \
    (flTokenize "...(endRange)"),
    (context) ->
      #yield
      endRange = context.tempVariablesDict[ValidIDfromString "endRange"]
      listToBeReturned = FLList.createNew()
      for i in [@value...endRange.value]
        listToBeReturned.value.jsArrayPush FLNumber.createNew i
        listToBeReturned.cursorEnd++

      return listToBeReturned

  # ---

  BasePlusFunction =  (context) ->
    #yield
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
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
    (flTokenize "self $plus_binary_default operandum")

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
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value % operandum.value

  FLNumber.addMethod \
    (flTokenize "$percent_binary_default ( operandum )"),
    BasePercentFunction

  FLNumber.addMethod \
    (flTokenize "% ( operandum )"),
    (flTokenize "self $percent_binary_default operandum")

  # ---

  BaseFloorDivisionFunction =  (context) ->
    #yield
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew Math.floor(@value / operandum.value)

  FLNumber.addMethod \
    (flTokenize "$floordivision_binary_default ( operandum )"),
    BaseFloorDivisionFunction

  FLNumber.addMethod \
    (flTokenize "/_ ( operandum )"),
    (flTokenize "self $floordivision_binary_default operandum")

  # ---

  BaseMinusFunction =  (context) ->
    #yield
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value - operandum.value

  FLNumber.addMethod \
    (flTokenize "$minus_binary_default ( operandum )"),
    BaseMinusFunction

  FLNumber.addMethod \
    (flTokenize "- ( operandum )"),
    (flTokenize "self $minus_binary_default operandum")

  # ---

  BaseDivideFunction =  (context) ->
    #yield
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value / operandum.value

  FLNumber.addMethod \
    (flTokenize "$divide_binary_default ( operandum )"),
    BaseDivideFunction

  FLNumber.addMethod \
    (flTokenize "/ ( operandum )"),
    (flTokenize "self $divide_binary_default operandum")

  # ---

  BaseMultiplyFunction =  (context) ->
    #yield
    operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
    return FLNumber.createNew @value * operandum.value

  FLNumber.addMethod \
    (flTokenize "$multiply_binary_default ( operandum )"),
    BaseMultiplyFunction

  FLNumber.addMethod \
    (flTokenize "* ( operandum )"),
    (flTokenize "self $multiply_binary_default operandum")

  # see "++" regarding why this could be confusing
  FLNumber.addMethod \
    (flTokenize "*= (value)"),
    flTokenize "self * value"

  # ---

  FLNumber.addMethod \
    (flTokenize "minus ( operandum )"),
    (context) ->
      #yield
      operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
      return FLNumber.createNew @value - operandum.value

  FLNumber.addMethod \
    (flTokenize "selftimesminusone"),
    flTokenize "self * self minus 1"

  FLNumber.addMethod \
    (flTokenize "times ( ' loopCode )"),
    (context) ->
      loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
      log "FLNumber ⇒ DO loop code is: " + loopCode.flToString()


      for i in [0...@value]
        # yield from
        toBeReturned = loopCode.eval context, loopCode

        flContexts.pop()

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            log "times loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            log "times loop exited with Return "
            break

      
      return toBeReturned




  FLNumber.addMethod \
    (flTokenize "== ( toCompare )"),
    commonSimpleValueEqualityFunction

  FLNumber.addMethod \
    (flTokenize "!= ( toCompare )"),
    commonSimpleValueInequalityFunction

  FLNumber.addMethod \
    (flTokenize "< ( toCompare )"),
    (context) ->
      #yield
      toCompare = context.tempVariablesDict[ValidIDfromString "toCompare"]
      if @value < toCompare.value
        return FLBoolean.createNew true
      else
        return FLBoolean.createNew false

  # mutating the number
  FLNumber.addMethod \
    (flTokenize "← ( valueToAssign )"),
    (context) ->
      #yield
      log "evaluation " + indentation() + "assigning to number! "
      valueToAssign = context.tempVariablesDict[ValidIDfromString "valueToAssign"]
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
      operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
      return FLBoolean.createNew @value and operandum.value

  FLBoolean.addMethod \
    (flTokenize "or ( operandum )"),
    (context) ->
      #yield
      log "executing an or! "
      operandum = context.tempVariablesDict[ValidIDfromString "operandum"]
      return FLBoolean.createNew @value or operandum.value

  FLBoolean.addMethod \
    (flTokenize "== ( toCompare )"),
    commonSimpleValueEqualityFunction

  FLBoolean.addMethod \
    (flTokenize "!= ( toCompare )"),
    commonSimpleValueInequalityFunction


  # FLQuote --------------------------------------------------------------------------

  FLQuote.addMethod \
    (flTokenize "( ' operandum )"),
    (context) ->
      #yield
      operandum = context.tempVariablesDict[ValidIDfromString "operandum"]

      if operandum.flClass == FLList
        # in the unfortunate case that the list contains the element
        # "operandum" - we can't bind that to the "operandum" RIGHT IN THIS
        # CONTEXT! Hence we need to evaluate the list elements in the
        # previous context!
        operandum = operandum.evaluatedElementsList context.previousContext

      return operandum


  # Not --------------------------------------------------------------------------
  FLNot.addMethod \
    (flTokenize "( operandum )"),
    flTokenize "operandum negate"

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
      elementToBeAppended = context.tempVariablesDict[ValidIDfromString "elementToBeAppended"]
      log "appending element to: " + @flToString() + " : " + elementToBeAppended.toString()
      return @flListImmutablePush elementToBeAppended

  FLList.addMethod \
    (flTokenize "length"),
    (context) ->
      #yield
      return FLNumber.createNew @length()

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] = (value)"),
    (context) ->
      #yield
      indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
      value = context.tempVariablesDict[ValidIDfromString "value"]
      
      return @elementAtSetMutable indexValue.value, value

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] += (value)"),
    (context) ->
      indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
      value = context.tempVariablesDict[ValidIDfromString "value"]

      runThis = flTokenize "(self [indexValue]) += value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      

      @elementAtSetMutable indexValue.value, toBeReturned

      return toBeReturned

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] *= (value)"),
    (context) ->
      indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
      value = context.tempVariablesDict[ValidIDfromString "value"]

      runThis = flTokenize "(self [indexValue]) *= value"

      # yield from
      toBeReturned = runThis.eval context, runThis

      

      @elementAtSetMutable indexValue.value, toBeReturned

      return toBeReturned

  FLList.addMethod \
    (flTokenize "[ (indexValue) ] ++"),
    (context) ->
      indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]

      runThis = flTokenize "(self [indexValue]) ++"

      # yield from
      toBeReturned = runThis.eval context, runThis

      @elementAtSetMutable indexValue.value, toBeReturned

      return toBeReturned


  FLList.addMethod \
    (flTokenize "[ (indexValue) ]"),
    (context) ->
      #yield
      indexValue = context.tempVariablesDict[ValidIDfromString "indexValue"]
      return @elementAt indexValue.value


  FLList.addMethod \
    (flTokenize "each ( ' variable ) do ( ' code )"),
    (context) ->

      variable = context.tempVariablesDict[ValidIDfromString "variable"]
      code = context.tempVariablesDict[ValidIDfromString "code"]

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
            log "list-each-do loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            log "list-each-do loop exited with Return "
            break

      return toBeReturned


  # AccessUpperContextClass -------------------------------------------------------------------------

  FLAccessUpperContext.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      log "FLAccessUpperContext running emptyMessage"
      context.previousContext.isTransparent = true
      log "context.previousContext now tramsparent at depth: " + context.previousContext.depth() + " with self: " + context.previousContext.self.flToString?()
      return @

  # Console -----------------------------------------------------------------------------

  FLConsole.addMethod \
    (flTokenize "print ( thingToPrint )"),
    (context) ->
      #yield
      thingToPrint = context.tempVariablesDict[ValidIDfromString "thingToPrint"]
      stringToPrint = thingToPrint.flToString()
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
      distance = context.tempVariablesDict[ValidIDfromString "distance"].value
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
      degrees = context.tempVariablesDict[ValidIDfromString "degrees"].value
      @direction += degrees
      @direction = @direction % 360
    
      return @

  FLTurtle.addMethod \
    (flTokenize "left ( degrees )"),
    (context) ->
      #yield
      degrees = context.tempVariablesDict[ValidIDfromString "degrees"].value
      @direction += (360-degrees)
      @direction = @direction % 360
    
      return @


  # Done -------------------------------------------------------------------------

  FLDone.addMethod \
    (flTokenize "with ( valueToReturn )"),
    (context) ->
      #yield
      valueToReturn = context.tempVariablesDict[ValidIDfromString "valueToReturn"]
      log "Done_object thrown with return value: " + valueToReturn.flToString()
      @value = valueToReturn
      context.throwing = true
      @thrown = true
      return @

  FLDone.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      log "Done_object running emptyMessage"
      context.throwing = true
      @thrown = true
      return @

  # Break -------------------------------------------------------------------------

  FLBreak.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      log "Break_object"
      context.throwing = true
      return @

  # Return -------------------------------------------------------------------------

  FLReturn.addMethod \
    (flTokenize "( valueToReturn )"),
    (context) ->
      #yield
      valueToReturn = context.tempVariablesDict[ValidIDfromString "valueToReturn"]

      log "Return_object running a value"

      @value = valueToReturn
      context.throwing = true
      return @

  FLReturn.addMethod \
    FLList.emptyMessage(),
    (context) ->
      #yield
      log "Return_object running emptyMessage"
      context.throwing = true
      @value = FLNil.createNew()
      return @




  # Repeat1 -------------------------------------------------------------------------

  FLRepeat1.addMethod \
    (flTokenize "( ' loopCode )"),
    (context) ->
      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
      log "FLRepeat1 ⇒ loop code is: " + loopCode.flToString()

      loop
        
        context.throwing = false

        # yield from
        toBeReturned = loopCode.eval context, loopCode

        flContexts.pop()

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
            log "Repeat1 ⇒ the loop exited with Done at context depth " + context.depth()
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            log "Repeat1 ⇒ the loop exited with Return "
            break

      return toBeReturned

  # Repeat2 -------------------------------------------------------------------------

  repeatFunctionContinuation = (context) ->
    context.isTransparent = true
    log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
    howManyTimes = context.tempVariablesDict[ValidIDfromString "howManyTimes"]
    loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]
    log "FLRepeat2 ⇒ loop code is: " + loopCode.flToString()

    if howManyTimes.flClass == FLForever
      limit = Number.MAX_SAFE_INTEGER
    else
      limit = howManyTimes.value


    for i in [0...limit]
      #yield "from repeatFunctionContinuation"
      log "Repeat2 ⇒ starting a(nother) cycle: "
      # yield from
      toBeReturned = loopCode.eval context, loopCode

      flContexts.pop()

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
          log "Repeat2 ⇒ the loop exited with Done at context depth " + context.depth()
          break
        if context.throwing and toBeReturned.flClass == FLReturn
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
      log stringToPrint
      rWorkspace.environmentPrintout += stringToPrint
      return @

  # Throw -----------------------------------------------------------------------------

  FLThrow.addMethod \
    (flTokenize "( theError )"),
    (context) ->
      #yield
      theError = context.tempVariablesDict[ValidIDfromString "theError"]
      theError.thrown = true
      log "throwing an error: " + theError.value
      context.throwing = true
      return theError

  # IfThen -----------------------------------------------------------------------------

  FLIfThen.addMethod \
    (flTokenize "( predicate ) : ('trueBranch)"),
    (context) ->
      #yield
      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      predicate = context.tempVariablesDict[ValidIDfromString "predicate"]
      trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
      log "FLIfThen: predicate value is: " + predicate.value

      if predicate.value
        log "FLIfThen: evaling true branch at depth " + context.depth()
        # yield from
        toBeReturned = trueBranch.eval context, trueBranch
        flContexts.pop()
        
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
      log "no more cases for the if"
      
      return FLNil.createNew()

  FLIfFallThrough.addMethod \
    (flTokenize "else if ( predicate ): ('trueBranch)"),
    (context) ->
      #yield
      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      predicate = context.tempVariablesDict[ValidIDfromString "predicate"]
      trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]
      log "FLIfFallThrough: predicate value is: " + predicate.value
      log "FLIfFallThrough: true branch is: " + trueBranch.flToString()

      if predicate.value
        # yield from
        toBeReturned = trueBranch.eval context, trueBranch
        flContexts.pop()
        
      else
        toBeReturned = FLIfFallThrough.createNew()

      return toBeReturned

  FLIfFallThrough.addMethod \
    (flTokenize "else: ('trueBranch)"),
    (context) ->
      log "FLIfFallThrough else: case "
      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      trueBranch = context.tempVariablesDict[ValidIDfromString "trueBranch"]

      # yield from
      log "FLIfFallThrough else: evalling code "
      toBeReturned = trueBranch.eval context, trueBranch
      flContexts.pop()
      
      return toBeReturned




  # Try -----------------------------------------------------------------------------

  FLTry.addMethod \
    (flTokenize ": ( ' code )"),
    (context) ->
      code = context.tempVariablesDict[ValidIDfromString "code"]
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
    seconds = context.tempVariablesDict[ValidIDfromString "seconds"]
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
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      loopVar = context.tempVariablesDict[ValidIDfromString "loopVar"]
      startIndex = context.tempVariablesDict[ValidIDfromString "startIndex"]
      endIndex = context.tempVariablesDict[ValidIDfromString "endIndex"]
      loopCode = context.tempVariablesDict[ValidIDfromString "loopCode"]

      loopVarName = loopVar.value

      forContext = new FLContext context
      forContext.isTransparent = true
      flContexts.jsArrayPush forContext

      log "FLFor ⇒ loop code is: " + loopCode.flToString()

      for i in [startIndex.value..endIndex.value]
        log "FLFor ⇒ loop iterating variable to " + i

        # the looping var is always in the new local for context
        # so it keeps any previous instance safe, and goes
        # away when this for is done.
        forContext.tempVariablesDict[ValidIDfromString loopVarName] = FLNumber.createNew i

        # yield from
        toBeReturned = loopCode.eval forContext, loopCode

        flContexts.pop()

        # catch any thrown "done" object, used to
        # exit from a loop.
        if toBeReturned?
          if context.throwing and (toBeReturned.flClass == FLDone or toBeReturned.flClass == FLBreak)
            context.throwing = false
            if toBeReturned.value?
              toBeReturned = toBeReturned.value
            log "For ⇒ the loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            log "For ⇒ the loop exited with Return "
            break

      flContexts.pop()

      
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
    (flTokenize "each ( ' variable ) in: ( 'theList ) do: ( 'code )"),
    (context) ->
      #yield
      context.isTransparent = true
      log "context now tramsparent at depth: " + context.depth() + " with self: " + context.self.flToString?()
      variable = context.tempVariablesDict[ValidIDfromString "variable"]
      theList = context.tempVariablesDict[ValidIDfromString "theList"]
      code = context.tempVariablesDict[ValidIDfromString "code"]

      if theList.flClass != FLList
        context.throwing = true
        # TODO this error should really be a stock error referanceable
        # from the workspace because someone might want to catch it.
        return FLException.createNew "for...each expects a list"

      # trivial case
      if theList.isEmpty()
        
        return theList

      # you could adjust the examples OK without these two
      # lines, but why not give the chance for clarity
      # to add an extra pair or parens to make sure that
      # lists are clearly visible?
      if theList.length() == 1
        theList = theList.firstElement()

      log "evalling list: " + theList.flToString()
      # yield from
      evalledList = theList.eval context, theList
      log "evalled list: " + evalledList.flToString()

      if context.throwing
        # the list doesn't run as a program, so we just
        # consider the original list to be the input
        theList = theList.evaluatedElementsList context
        # remember to turn off the "throwing" flag as we
        # do nothing with tha aborted evaluation.
        context.throwing = false
      else
        # the list DOES run as a program, so we use
        # the evaluation result as the input
        theList = evalledList

      if theList.flClass != FLList
        context.throwing = true
        # TODO this error should really be a stock error referanceable
        # from the workspace because someone might want to catch it.
        return FLException.createNew "for...each expects a list"

      log "FLEach do on the list: " + theList.flToString()

      forContext = new FLContext context
      forContext.isTransparent = true

      for i in [0...theList.value.length]
        forContext.throwing = false

        log "FLEach element at " + i + " : " + (theList.elementAt i).flToString()
        forContext.tempVariablesDict[ValidIDfromString variable.value] = theList.elementAt i
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
            log "for-each-in-list loop exited with Done "
            break
          if context.throwing and toBeReturned.flClass == FLReturn
            log "for-each-in-list loop exited with Return "
            break

      
      return toBeReturned
