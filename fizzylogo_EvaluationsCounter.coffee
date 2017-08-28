# a class that prints explicitly the "eval"s and the "$nothing$"s
# invoked... so one can see more explicitly what happens.

class FLEvaluationsCounterClass extends FLClasses
  createNew: ->
    toBeReturned = super FLEvaluationsCounter

    toBeReturned.flToString = ->
      return "EvalutationsCounter"

    toBeReturned.flToStringForList = toBeReturned.flToString

    toBeReturned.eval = (theContext) ->
      yield
      stringToPrint = "EvaluationsCounter running eval // "
      console.log stringToPrint
      environmentPrintout += stringToPrint
      return @


    return toBeReturned

FLEvaluationsCounter = new FLEvaluationsCounterClass()
