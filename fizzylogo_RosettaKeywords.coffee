class  FLKeywordClass extends  FLPrimitiveClasses
  createNew: (theKeywordName) ->
    toBeReturned = new  FLPrimitiveObjects()
    toBeReturned.value = theKeywordName
    toBeReturned.flClass = RKeyword

    toBeReturned.print = ->
      return @value

    toBeReturned.evalMessage = (theContext) ->
      message = theContext.message
      console.log "evaluation " + indentation() + "messaging keyword " + theKeywordName + " with " + message.print()

      if message.isEmpty()
        theContext.returned = theContext.lookUpAtomValue @
        console.log "evaluation " + indentation() + "keyword " + theKeywordName + " contents: " + theContext.returned.value


      theContext.returned = @
      return theContext


    return toBeReturned

RKeyword = new  FLKeywordClass()

