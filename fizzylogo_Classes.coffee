
class FLClasses extends FLObjects
  name: null #a FLString
  msgPatterns: null # an array of FLLists
  methodBodies: null # an array of FLLists

  classVariables: null # a FLList
  instanceVariables: null # a FLList
  tempVariables: null # a FLList

  classVariablesDict: null # a JS dictionary

  constructor: ->
    super
    @classVariablesDict = {}
    @msgPatterns = []
    @methodBodies = []


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class FLPrimitiveClasses extends FLClasses


# the root of everything. An object of class
# "Class" (or, more in detail, of FLClassPrimitiveClass)
class FLClassPrimitiveClass extends FLPrimitiveClasses

  createNew: ->
    toBeReturned = new FLPrimitiveClasses()
    toBeReturned.flClass = FLClass
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging number " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      returnedContext = @findMessageAndBindParams theContext, message
      console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

      if returnedContext?
        # "findMessageAndBindParams" has already done the job of
        # making the call and fixing theContext's PC and
        # updating the return value, we are done here
        return returnedContext

      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()
      theContext.returned = @
      flContexts.pop()

    return toBeReturned
    

FLClass = new FLClassPrimitiveClass()


class FLAnonymousClass extends FLPrimitiveClasses

