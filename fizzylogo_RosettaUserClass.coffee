
class RosettaNonPrimitiveClass extends RosettaClasses
  createNew: ->
    toBeReturned = new RosettaClasses()
    toBeReturned.value = "some_custom_class_of_user"

    toBeReturned.rosettaClass = toBeReturned
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    toBeReturned.createNew = ->
      objectTBR = new RosettaPrimitiveObjects()
      objectTBR.value = "object_from_a_user_class"
      objectTBR.rosettaClass = toBeReturned

      objectTBR.evalMessage = (theContext) ->
        message = theContext.message
        console.log "evaluation " + indentation() + "messaging " + @value + " with " + message.print()

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

      return objectTBR

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging " + @value + " with " + message.print()

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

RUserClass = new RosettaNonPrimitiveClass()

