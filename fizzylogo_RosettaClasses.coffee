
class RosettaClasses extends RosettaObjects
  name: null #a RosettaString
  msgPatterns: null # an array of RosettaLists
  methodBodies: null # an array of RosettaLists

  classVariables: null # a RosettaList
  instanceVariables: null # a RosettaList
  tempVariables: null # a RosettaList

  classVariablesDict: null # a JS dictionary

  constructor: ->
    super
    @classVariablesDict = {}
    @msgPatterns = []
    @methodBodies = []


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class RosettaPrimitiveClasses extends RosettaClasses


# the root of everything. An object of class
# "Class" (or, more in detail, of RosettaClassPrimitiveClass)
class RosettaClassPrimitiveClass extends RosettaPrimitiveClasses

  createNew: ->
    toBeReturned = new RosettaPrimitiveClasses()
    toBeReturned.rosettaClass = RClass
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging number " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter
      anyMatch = @findMessageAndBindParams theContext, message
      if anyMatch?
        returned = @lookupAndSendFoundMessage theContext, anyMatch
      console.log "evaluation " + indentation() + "after matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if returned?
        # "findMessageAndBindParams" has already done the job of
        # making the call and fixing theContext's PC and
        # updating the return value, we are done here
        if returned.returned?.value?
          console.log "evaluation " + indentation() + "evalMessage in number returned: " + returned.returned.value
        return returned


      if !message.isEmpty()
        console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()
      theContext.returned = @
      rosettaContexts.pop()

    return toBeReturned
    

RClass = new RosettaClassPrimitiveClass()


class RosettaAnonymousClass extends RosettaPrimitiveClasses

