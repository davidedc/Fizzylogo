# We code the runtime ONLY in terms of JS/coffeescript classes/code.
# We don't mimic runtime-created classes/objects with JS/coffee classes/objects,
# we just model the runtime here i.e. the "ground" mechanisms,
# i.e. what can't be really changed
# from the system itself. Stuff like the matching of messages with
# "method patterns",
# the primitive classes and objects, what the context is and
# how it works, how the scoping works, looking up the value
# of an atom from the correct place, etc.

class RosettaObjects
  rosettaClass: null # the class it belongs to
  instanceVariablesDict: null # a JS dictionary

  constructor: ->
    #console.log " instanceVariablesDict initiated "
    @instanceVariablesDict = {}

class RosettaPrimitiveObjects extends RosettaObjects

class RosettaContext
  self: null # a RosettaObject
  programCounter: 0 # an integer
  message: null # a RosettaMessage, which is an RList and a cursor
  tempVariablesDict: null # a JS dictionary
  previousContext: null
  returned: null

  constructor: (@previousContext, @self, @message) ->
    @tempVariablesDict = {}

  lookUpAtomValuePlace: (theAtom) ->
    # we first look in this context, and then we go up
    # context by context until we reach the top without
    # having found anything.

    # so, for each context,
    #   first, check the temporaries
    #     if the class lists the atom in the temporaties
    #       then the value resides in the context itself
    #   then the instance variables
    #     if the class lists the atom in the intance variables
    #       then the value resides in the self object
    #   then the class variables.
    #     if the class lists the atom in the class variables
    #       then the value resides in the class
    # We always return a rosetta object (or a rosetta class
    # , which is also a rosetta object)

    # check the temporaries
    contextBeingSearched = @
    atomValue = theAtom.value

    if atomValue == "self"
      return @

    while contextBeingSearched?

      console.log "evaluation " + indentation() + "looking in class: " + contextBeingSearched.self.rosettaClass
      console.dir contextBeingSearched.self.rosettaClass

      temps = contextBeingSearched.self.rosettaClass.tempVariables
      if temps?
        console.log "evaluation " + indentation() + "lookup: checking in " + temps.value
        if temps.value? and (temps.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in tempVariables"
          return contextBeingSearched.tempVariablesDict

      instances = contextBeingSearched.self.rosettaClass.instanceVariables
      if instances?
        console.log "evaluation " + indentation() + "lookup: checking in " + instances.value
        if instances.value? and (instances.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in instanceVariables"
          return contextBeingSearched.self.instanceVariablesDict

      statics = contextBeingSearched.self.rosettaClass.classVariables
      if statics?
        console.log "evaluation " + indentation() + "lookup: checking in " + statics.value
        if statics.value? and (statics.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in classVariables"
          return contextBeingSearched.self.rosettaClass.classVariablesDict

      # nothing found from this context, move up
      # to the sender (i.e. the callee)
      console.log "evaluation " + indentation() + "lookup: not found in this context, going up "
      contextBeingSearched = contextBeingSearched.previousContext

    console.log "evaluation " + indentation() + "lookup: " + atomValue + " not found!"

  lookUpAtomValue: (theAtom) ->
    # we first look _where_ the value of the Atom is,
    # then we fetch it

    dictWhereValueIs = @lookUpAtomValuePlace theAtom
    console.log "evaluation " + indentation() + "lookup: " + theAtom.value + " found dictionary and it contains:"
    console.dir dictWhereValueIs
    return dictWhereValueIs[theAtom.value]


rosettaContexts = []


class RosettaClasses extends RosettaObjects
  name: null #a RosettaString
  msgPatterns: null # an array of RosettaLists
  methodBodies: null # an array of RosettaLists

  classVariables: null # a RosettaList
  instanceVariables: null # a RosettaList
  tempVariables: null # a RosettaList

  classVariablesDict: null # a JS dictionary

  constructor: ->
    @classVariablesDict = {}
    @msgPatterns = []
    @methodBodies = []


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class RosettaPrimitiveClasses extends RosettaClasses

class RosettaNonPrimitiveClasses extends RosettaClasses

# the root of everything
rosettaClass = new RosettaPrimitiveClasses()
rosettaClass.rosettaClass = rosettaClass

class RosettaAnonymousClass extends RosettaPrimitiveClasses


skipNextMessageElement = (message, theContext) ->
  message = message.restOfMessage()
  theContext.programCounter++
  return message

evalFirstMessageElement = (message, theContext) ->
  firstElement = message.firstElement()
  console.log "           " + indentation() + "evaling element " + firstElement.value
  [evaledFirstElement, unused] = rosettaEval firstElement, theContext
  restOfMessage = skipNextMessageElement message, theContext
  return [evaledFirstElement, restOfMessage]

# this could be native or non-native
messageSend = (object, methodBody, theContext) ->
  # note that this doesn't change the program counter,
  # because we don't care here what we consume from the body
  # execution, from the caller perspective it only matters
  # what we consume from the invocation, which we accounted
  # for just above.
  if methodBody.rosettaClass == RList
    console.log "evaluation " + indentation() + "  matching - method body: " + methodBody.print()
    # non-native method, i.e. further fizzylogo code
    # creates a context and evals the message in it
    # the rest of the message is not used because all of the list should
    # be run, no remains from the message body should overspill
    # into the calling context. 
    [theContext, unusedRestOfMessage] = nonNativeMessageSend object, methodBody, theContext
  else
    console.log "evaluation " + indentation() + "  matching - NATIVE method body: " + methodBody
    # native method, i.e. coffeescript/javascript code
    theContext.returned = methodBody.call object, theContext.tempVariablesDict
    rosettaContexts.pop()
  return theContext

nonNativeMessageSend = (object, message, theContext) ->
  # so, we need to keep the program counter unchanged here,
  # because otherwise we add the consumption of the method BODY
  # which we don't want. From the caller's perspective, we
  # just consume from the method invocation, i.e. we just consume
  # while we matched the correct method, which we account for
  # when we do the matching, not here after the matching happened.

  newContext = new RosettaContext theContext, object, message
  rosettaContexts.push newContext
  rosettaEval message, newContext
  rosettaContexts.pop()
  message = message.advanceMessageBy newContext.programCounter
  return [newContext, message]


# Note that only part of the message might be consumed
# also note that we are creating a new context, but
# "self" remains the same since we are still in the
# same "method call" and the same "object". I.e. this
# is not a method call, this is progressing within
# an existing call
progressWithMessage = (object, message, theContext) ->
  newContext = new RosettaContext theContext, theContext.self, message
  rosettaContexts.push newContext
  object.evalMessage newContext
  rosettaContexts.pop()
  theContext.programCounter += newContext.programCounter
  message = message.advanceMessageBy newContext.programCounter
  return [newContext, message]

# You eval things just by sending them the empty message.
# Note that if you invoke this on a list, the whole list is evaluated.
rosettaEval = (message, theContext) ->
  console.log "           " + indentation() + "messageList " + message.print()
  [newContext, message] = progressWithMessage message, emptyMessage(), theContext
  return [newContext.returned, message]

class RosettaAtomClass extends RosettaPrimitiveClasses
  createNew: (theAtomName) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = theAtomName
    toBeReturned.rosettaClass = RAtom

    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging atom " + theAtomName + " with " + message.print()

      if message.isEmpty()
        theContext.returned = theContext.lookUpAtomValue @
        console.log "evaluation " + indentation() + "atom " + theAtomName + " contents: " + theContext.returned.value

      else if message.firstElement().value == "<-"
        console.log "evaluation " + indentation() + "assignment to atom " + theAtomName

        # skip the <- symbol
        message = skipNextMessageElement message, theContext

        # now evaluate the rest of the list
        # now we are using the message as a list because we have to evaluate it.
        # to evaluate it, we treat it as a list and we send it the empty message
        [theValue, unusedRestOfMessage] = rosettaEval message, theContext
        theContext.returned = theValue

        console.log "evaluation " + indentation() + "value to assign to atom: " + theAtomName + " : " + theValue.value

        dictToPutAtomIn = theContext.lookUpAtomValuePlace @
        dictToPutAtomIn[theAtomName] = theValue

        console.log "evaluation " + indentation() + "stored value in dictionary"



    return toBeReturned

RAtom = new RosettaAtomClass() # ...


class RosettaListPrimitiveClass extends RosettaPrimitiveClasses


  # A note about messages, which are special lists.
  # ...a rosetta message is just an RList which is meant to
  # be used as a message only, which means that:
  #    - its elements don't change
  #    - it can be split ( "." splits statements)
  #    - we can "consume" one or more elements
  #    - we don't need messages to be rosetta objects,
  #      they are part of the runtime and invisible to
  #      the user.
  #    - a message is never sent a message, because
  #      a message is not a rosetta object
  # so we try to make some of these operations more efficient
  # for messages, since all operations don't modify the elements
  # we can do splits and we can consume things just by moving
  # around a start index and an end index of an unchanging
  # array of elements.
  # The alternative would be to use no indexes and just
  # do shallow copies around. That would be fine for performance
  # but there is just something about the constant shallow copying
  # during interpretation that looks like it's a quadratic
  # operation, so we say no to that.

  createNew: ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = []
    toBeReturned.rosettaClass = RList

    # these are only used for messages, which
    # are special kinds of lists
    toBeReturned.cursorStart = 0
    toBeReturned.cursorEnd = -1
    toBeReturned.isFromMessage = false

    # nothing much to do, but it makes it more
    # clear in the code to show "how"
    # one is using the message/list
    toBeReturned.toList = ->
      @

    # nothing much to do, but it makes it more
    # clear in the code to show "how"
    # one is using the message/list
    toBeReturned.toMessage = ->
      @isFromMessage = true
      @

    toBeReturned.push = (theItemToPush) ->
      if @isFromMessage
        throw "RList deriving from a message should never be modified"
      @value.push theItemToPush
      @cursorEnd++

    toBeReturned.elementAt = (theElementNumber) ->
      @value[@cursorStart + theElementNumber]

    toBeReturned.print = ->
      #console.log "@value:" + @value
      if @length() == 0
        return "empty message"
      toBePrinted = "( "
      for i in [0...@length()]
        #console.log "@value element " + i + " : " + @value[i]
        #console.log "@value element " + i + " content: " + @value[i].value
        toBePrinted += " " + @elementAt(i).print()
      toBePrinted += " )"
      return toBePrinted

    # the first receiver is optional
    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging list with " + message.print()

      if message.isEmpty()
        # a list without any messages just evaluates itself, which
        # consists of the following:
        #  a) separate all the statements (parts separated by ".")
        #  b) for each statement, evaluate its first element as the receiver
        #  c) send to the receiver the remaining part of the statement, as the message

        console.log "evaluation " + indentation() + "list received empty message, evaluating content of list"
        console.log "evaluation " + indentation() + "  i.e. " + @print()

        @isFromMessage = true

        statements = @separateStatements()

        for eachStatement in statements

          list = eachStatement.toList()

          console.log "evaluation " + indentation() + "evaluating single statement"
          console.log "evaluation " + indentation() + "  i.e. " + list.print()

          [receiver, restOfMessage] = evalFirstMessageElement list, theContext

          console.log "evaluation " + indentation() + "remaining part of list to be sent as message is: " + restOfMessage.print()

          # now that we have the receiver, we send it the rest of the original message
          until restOfMessage.isEmpty()

            console.log "evaluation " + indentation() + "receiver: " + receiver.value
            console.log "evaluation " + indentation() + "message: " + restOfMessage.print()

            # now actually send the message to the receiver. Note that
            # only part of the message might be consumed, this is why
            # we have to keep iterating until the whole message is consumed
            [newContext, restOfMessage] = progressWithMessage receiver, restOfMessage, theContext
            receiver = newContext.returned

            rosettaContexts.pop()
            console.log "evaluation " + indentation() + "list evaluation returned: " + receiver?.value



          console.log "evaluation " + indentation() + "list: nothing more to evaluate"
          theContext.returned = receiver
          rosettaContexts.pop()

    toBeReturned.length = ->
      return @cursorEnd - @cursorStart + 1

    toBeReturned.restOfMessage = ->
      copy = @copy()
      copy.cursorStart++
      return copy

    toBeReturned.firstElement =  ->
      if @cursorStart > @cursorEnd
        throw "no first element, array is empty"
      return @elementAt 0

    # returns the first element and returns
    # a copy of the rest of the message
    toBeReturned.nextElement = ->
      [@firstElement(), @restOfMessage()]

    toBeReturned.advanceMessageBy = (numberOfElements) ->
      
      if numberOfElements > @length()
        return emptyMessage()

      copy = @copy()
      copy.cursorStart += numberOfElements
      return copy

    toBeReturned.isEmpty = ->
      return @length() == 0

    toBeReturned.copy = ->
      copy = RList.createNew()
      copy.value = @value
      copy.cursorStart = @cursorStart
      copy.cursorEnd = @cursorEnd
      copy.isFromMessage = @isFromMessage
      return copy

    toBeReturned.separateStatements = ->
      console.log "evaluation " + indentation() + "separating statements   start "
      arrayOfStatements = []
      lastStatementEnd = @cursorStart - 1
      for i in [@cursorStart..@cursorEnd]
        console.log "evaluation " + indentation() + "separating statements   examining element " + @value[i].print()
        if (@value[i] == RStatementSeparatorSymbol) or (i == @cursorEnd)
          statementToBeAdded = @copy()
          statementToBeAdded.cursorStart = lastStatementEnd + 1
          statementToBeAdded.cursorEnd = i - 1
          if (i == @cursorEnd) then statementToBeAdded.cursorEnd++
          lastStatementEnd = i
          arrayOfStatements.push statementToBeAdded
          console.log "evaluation " + indentation() + "separating statements isolated new statement " + statementToBeAdded.print()


      return arrayOfStatements



    return toBeReturned

    
RList = new RosettaListPrimitiveClass()

isEvaluatingParam = (element) ->
  element.length() == 1

getParamAtom = (element) ->
  if isEvaluatingParam(element)
    return element.elementAt(0)
  else
    return element.elementAt(1)

class RosettaNumberPrimitiveClass extends RosettaPrimitiveClasses
  createNew: (value) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = parseFloat(value)
    toBeReturned.rosettaClass = RNumber

    toBeReturned.print = ->
      return @value

    toBeReturned.findMessageAndBindParams = (theContext, methodInvocationToBeChecked) ->
      console.log "evaluation " + indentation() + "  !!! looking up method invocation " + methodInvocationToBeChecked.print() + " with signatures!" + " PC: " + theContext.programCounter
      console.log "evaluation " + indentation() + "  !!! looking up method invocation, is method empty? " + methodInvocationToBeChecked.isEmpty() + " PC: " + theContext.programCounter

      # as we check the matches of the invocation with the
      # signature, we might need to roll back the program
      # counter, which is what keeps tab of how much of the
      # message (in the context) we consume.
      # so let's remember the original value here
      originalProgramCounter = theContext.programCounter

      countSignaturePosition = -1
      for eachSignature in @rosettaClass.msgPatterns
        console.log "evaluation " + indentation() + "  matching - checking if this signature matches: " + eachSignature.print() + " PC: " + theContext.programCounter
        method = methodInvocationToBeChecked
        countSignaturePosition++

        # as we might have failed a match of a signature, we need to restore
        # the program counter so we keep the correct tab of how much
        # of the message (in the context) we consume.
        theContext.programCounter = originalProgramCounter

        console.log "evaluation " + indentation() + "  matching - checking if signature matches this invocation " + method.print() + " PC: " + theContext.programCounter

        soFarEverythingMatched = true
        originalMethodStart = method.cursorStart
        until eachSignature.isEmpty() or method.isEmpty()

          console.log "evaluation " + indentation() + "  matching: - next signature piece: " + eachSignature.print() + " is atom: " + " with: " + method.print() + " PC: " + theContext.programCounter

          [eachElementOfSignature, eachSignature] = eachSignature.nextElement()

          
          # the element of a signature can only be of two kinds:
          # an atom or an RList containing one parameter (with
          # prepended "@" in case the parameter doesn't require
          # evaluation)
          if eachElementOfSignature.rosettaClass == RAtom
            # if the signature contains an atom, the message
            # must contain the same atom, otherwise we don't
            # have a match.

            [eachElementOfInvocation, method] = method.nextElement()

            if eachElementOfInvocation.rosettaClass == RAtom

              console.log "evaluation " + indentation() + "  matching atoms: - next signature piece: " + eachElementOfSignature.print() + " is atom: " + (eachElementOfSignature.rosettaClass == RAtom) + " with: " + eachElementOfInvocation.print() + " PC: " + theContext.programCounter

              # ok at least the message contains an atom, but
              # now we have to check that they spell the same
              if eachElementOfSignature.value == eachElementOfInvocation.value
                console.log "evaluation " + indentation() + "  matching - atom matched: " + eachElementOfSignature.print() + " PC: " + theContext.programCounter
                # OK good match of atomsr,
                # check the next token in the signature
                continue
              else
                # no match between the atoms, check next signature
                soFarEverythingMatched = false
                break
            else
              # the signature sais "atom" but the message contains
              # something else: no match, check the next
              # signature
              console.log "evaluation " + indentation() + "  matching - no match: " + eachElementOfSignature.print() + " vs. " + eachElementOfInvocation.print() + " PC: " + theContext.programCounter
              # this signature doesn't match check the next one
              soFarEverythingMatched = false
              break
          else
            # the signature has a param. we have to check if
            # it requires an evaluation or not
            console.log "evaluation " + indentation() + "  matching - getting the atom inside the parameter: " + eachElementOfSignature.print() + " PC: " + theContext.programCounter
            paramAtom = getParamAtom(eachElementOfSignature)
            console.dir paramAtom
            console.log "evaluation " + indentation() + "  matching - atom inside the parameter: " + paramAtom.print() + " PC: " + theContext.programCounter
            if isEvaluatingParam(eachElementOfSignature)
              console.log "evaluation " + indentation() + "  matching - need to evaluate next msg element from invocation: " + method.print() + " and bind to: " + paramAtom.print() + " PC: " + theContext.programCounter
              [valueToBeBound, method] = evalFirstMessageElement method, theContext
            else
              console.log "evaluation " + indentation() + "  matching - need to get next msg element from invocation: " + method.print() + " and bind to: " + paramAtom.print() + " PC: " + theContext.programCounter
              [valueToBeBound, method] = method.nextElement()
            # TODO we should insert without repetition
            if !theContext.self.rosettaClass.tempVariables?
              theContext.self.rosettaClass.tempVariables = []
            theContext.self.rosettaClass.tempVariables.push paramAtom
            theContext.tempVariablesDict[paramAtom.value] = valueToBeBound
            # ok we matched a paramenter, now let's keep matching further
            # parts of the signature
            continue

        # ok a the signature has matched completely
        if eachSignature.isEmpty() and soFarEverythingMatched

          # now, the correct PC that we need to report is
          # the original plus what we consumed from matching the
          # signature.
          console.log "evaluation " + indentation() + "  matching - consumed from matching this sig: " + (method.cursorStart - originalMethodStart)

          theContext.programCounter = originalProgramCounter + method.cursorStart - originalMethodStart

          return countSignaturePosition

      # we are still here trying to match but
      # there are no signatures left, time to quit.
      # fix the program counter first! Put it back
      # to what it was because we matched nothing from
      # the message we were sent.
      console.log "evaluation " + indentation() + "  matching - no match found" + " PC: " + theContext.programCounter
      theContext.programCounter = originalProgramCounter
      return null




    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging number " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter
      anyMatch = @findMessageAndBindParams(theContext, message)
      if anyMatch?
        returned = lookupAndSendFoundMessage @, theContext, anyMatch
      console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if returned?
        # "findMessageAndBindParams" has already done the job of
        # making the call and fixing theContext's PC and
        # updating the return value, we are done here
        return


      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()
      theContext.returned = @
      rosettaContexts.pop()

    return toBeReturned
    

lookupAndSendFoundMessage = (object, theContext, countSignaturePosition) ->
  console.log "evaluation " + indentation() + "  matching - found a matching signature: " + object.rosettaClass.msgPatterns[countSignaturePosition].print() + " , PC: " + theContext.programCounter
  # we have a matching signature!
  methodBody = object.rosettaClass.methodBodies[countSignaturePosition]


  # this could be a native or non-native message send
  theContext = messageSend object, methodBody, theContext

  return theContext.returned


class RosettaSymbolClass extends RosettaAnonymousClass
  createNew: (value) ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.rosettaClass = RSymbol

    toBeReturned.print = ->
      return @value

    return toBeReturned

RSymbol = new RosettaSymbolClass() # this is a class, an anonymous class


# there is nothing special what all symbols do,
# so we just have them to be part of the anonymous class
# Literals are things that don't have value, just
# some sort of role.

RLiteralSymbol = RSymbol.createNew "@"
# the signature is: @ (@x), so this consumes only one token
# example: @x returns the Atom X
RLiteralSymbol.evalMessage = (theContext) ->
    message = theContext.message
    console.log "evaluation " + indentation() + "messaging literal symbol with " + message.print()

    if message.isEmpty()
      theContext.returned = @
    else
      theContext.returned = message.firstElement()
      message = skipNextMessageElement message, theContext

    console.log "evaluation " + indentation() + "literal symbol evaluation returning " + theContext.returned.value

    rosettaContexts.pop()


RNewSymbol = RSymbol.createNew "new"
RAssignmentSymbol = RSymbol.createNew "<-"
RStatementSeparatorSymbol = RSymbol.createNew "."


indentation = ->
  return " ".repeat(rosettaContexts.length * 2)

rosettaParse = (command) ->
  listsStack = []
  outerList = RList.createNew()
  listsStack.push outerList
  currentList = outerList

  simpleTokenization = command.split(" ")
  for eachToken in simpleTokenization
    console.log "eachToken: " + eachToken
    if /[a-zA-Z]+/.test(eachToken)
      console.log eachToken + " is an Atom"
      currentList.push (RAtom.createNew eachToken)
    else if /@/.test(eachToken)
      console.log eachToken + " is @ symbol"
      currentList.push RLiteralSymbol
    else if /\./.test(eachToken)
      console.log eachToken + " is . symbol"
      currentList.push RStatementSeparatorSymbol
    else if /<-/.test(eachToken)
      console.log eachToken + " is <- symbol"
      currentList.push RAssignmentSymbol
    else if /\d+/.test(eachToken)
      console.log eachToken + " is a Number"
      currentList.push (RNumber.createNew eachToken)
    else if /\(/.test(eachToken)
      nestedList = RList.createNew()
      currentList.push nestedList
      listsStack.push currentList
      currentList = nestedList
    else if /\)/.test(eachToken)
      currentList = listsStack.pop()
  return outerList

emptyMessage = ->
  newMessage = RList.createNew()
  newMessage.isFromMessage = true
  return newMessage

RNumber = new RosettaNumberPrimitiveClass()
RNumber.msgPatterns.push rosettaParse "anotherPrint"
RNumber.methodBodies.push rosettaParse "self print"

RNumber.msgPatterns.push rosettaParse "doublePrint"
RNumber.methodBodies.push rosettaParse "self print print"

RNumber.msgPatterns.push rosettaParse "increment"
RNumber.methodBodies.push rosettaParse "@ self <- self plus 1"

RNumber.msgPatterns.push rosettaParse "print"
RNumber.methodBodies.push ->
  console.log "///////// program printout: " + @value
  return @

RNumber.msgPatterns.push rosettaParse "plus ( addendum )"
RNumber.methodBodies.push (params) ->
  addendum = params.addendum
  @value += addendum.value
  return @

RNumber.msgPatterns.push rosettaParse "something ( param )"
RNumber.msgPatterns.push rosettaParse "somethingElse ( @ param )"


#parsed = rosettaParse "@ a <- 5 . a increment . @ a <- a plus 1 . a print"
#parsed = rosettaParse "@ a <- 5 . @ a <- a plus 1 . a increment print"
#parsed = rosettaParse "@ a <- 5 plus 1 . a increment print"
#parsed = rosettaParse "@ a <- ( 5 plus 1 ) . a increment print"
#parsed = rosettaParse "@ a <- ( 4 plus 1 plus 1 ) . a increment print"
#parsed = rosettaParse "@ a <- ( 4 plus ( 1 plus 1 ) ) . a increment print"
#parsed = rosettaParse "@ a <- ( ( 4 plus 1 ) plus ( 0 plus 1 ) ) . a increment print"
#parsed = rosettaParse "7 anotherPrint"
#parsed = rosettaParse "7 doublePrint"
#parsed = rosettaParse "7 print print"
#parsed = rosettaParse "6 doublePrint plus 1"
#parsed = rosettaParse "4 plus 3"
parsed = rosettaParse "4 plus ( 2 plus 1 )"

console.log parsed.value.length
for eachParsedItem in parsed.value
  console.log eachParsedItem.value

class RosettaWorkspaceClass extends RosettaAnonymousClass
  createNew: ->
    toBeReturned = new RosettaPrimitiveObjects()
    toBeReturned.rosettaClass = RWorkspace

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging workspace with " + message.print()

      # now we are using the message as a list because we have to evaluate it.
      # to evaluate it, we treat it as a list and we send it the empty message
      # note that "self" will remain the current one, since anything that
      # is in here will still refer to "self" as the current self in the
      # overall message.
      [theValue, unusedRestOfMessage] = rosettaEval message, theContext
      theContext.returned = theValue

      console.log "evaluation " + indentation() + "end of workspace evaluation"

    return toBeReturned



RWorkspace = new RosettaWorkspaceClass() # this is a class
rWorkspace = RWorkspace.createNew()

rWorkspace.rosettaClass.instanceVariables = RList.createNew()
rWorkspace.rosettaClass.instanceVariables.push RAtom.createNew "a"

# outer-most context
parsed.isFromMessage = true
outerMostContext = new RosettaContext null, rWorkspace, parsed
rosettaContexts.push outerMostContext
rWorkspace.evalMessage outerMostContext
console.log "final return: " + outerMostContext.returned.value
