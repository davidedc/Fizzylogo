class FLBooleanPrimitiveClass extends FLPrimitiveClasses
  createNew: (value) ->
    toBeReturned = new FLPrimitiveObjects()
    toBeReturned.value = value
    toBeReturned.flClass = FLBoolean


    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging boolean " + @value + " with " + message.print()

      console.log "evaluation " + indentation() + "before matching game the message is: " + message.print() + " and PC: " + theContext.programCounter

      if message.isEmpty()
        theContext.returned = @

      else
        returnedContext = @findSignatureBindParamsAndMakeCall theContext, message

        if returnedContext?
          console.log "evaluation " + indentation() + "after having sent message: " + message.print() + " and PC: " + theContext.programCounter

          if returnedContext.returned?
            # "findSignatureBindParamsAndMakeCall" has already done the job of
            # making the call and fixing theContext's PC and
            # updating the return value, we are done here
            return returnedContext

          #console.log "evaluation " + indentation() + "evalMessage in boolean matched: " + @flClass.methodBodies[anyMatch]
          console.log "evaluation " + indentation() + "boolean keeping evaluation because it got null result"
          console.log "evaluation " + indentation() + "...continuing, message is: " + message.print() + " and PC: " + returnedContext.programCounter


        console.log "evaluation " + indentation() + "boolean: no matches on any methods or returned null"
        theContext.returned = @
      

      ###
      flContexts.pop()

      if theContext.returned?.value?
        console.log "evaluation " + indentation() + "evalMessage in boolean returned: " + theContext.returned.value
      ###

      return theContext

    return toBeReturned
    

FLBoolean = new FLBooleanPrimitiveClass()

