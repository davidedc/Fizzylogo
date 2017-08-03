
class FLNonPrimitiveClass extends FLClasses
  createNew: ->
    toBeReturned = new FLClasses()
    toBeReturned.value = "some_custom_class_of_user"

    toBeReturned.flClass = toBeReturned
    toBeReturned.classVariablesDict = {}
    toBeReturned.msgPatterns = []
    toBeReturned.methodBodies = []
    toBeReturned.instanceVariablesDict = {}

    toBeReturned.createNew = ->
      objectTBR = new FLPrimitiveObjects()
      objectTBR.value = "object_from_a_user_class"
      objectTBR.flClass = toBeReturned

      objectTBR.evalMessage = (theContext) ->
        message = theContext.message
        console.log "evaluation " + indentation() + "messaging " + @value + " with " + message.print()

        console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

        if message.isEmpty()
          theContext.returned = @

        else

          returnedContext = @findSignatureBindParamsAndMakeCall theContext, message
          console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

          if returnedContext?
            if returnedContext.returned?
              # "findSignatureBindParamsAndMakeCall" has already done the job of
              # making the call and fixing theContext's PC and
              # updating the return value, we are done here
              return returnedContext
          
          theContext.returned = @


        #if !message.isEmpty()
        #  console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()
        #flContexts.pop()
        return theContext

      return objectTBR

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if message.isEmpty()
        theContext.returned = @

      else

        returnedContext = @findSignatureBindParamsAndMakeCall theContext, message
        console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

        if returnedContext?
          if returnedContext.returned?
            # "findSignatureBindParamsAndMakeCall" has already done the job of
            # making the call and fixing theContext's PC and
            # updating the return value, we are done here
            return returnedContext

        theContext.returned = @
      

      #if !message.isEmpty()
      #  console.log "evaluation " + indentation() + "this message to number should be empty? " + message.print()
      # flContexts.pop()
      return theContext

    return toBeReturned

FLUserClass = new FLNonPrimitiveClass()

