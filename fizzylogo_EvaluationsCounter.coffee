# a class that prints explicitly the "eval"s and the
# invocations of the empty method,
# so one can see more explicitly what happens.

class FLEvaluationsCounterClass extends FLClasses
  createNew: ->
    toBeReturned = super FLEvaluationsCounter

    toBeReturned.flToString = ->
      return "EvalutationsCounter"

    toBeReturned.flToStringForList = toBeReturned.flToString


    return toBeReturned

FLEvaluationsCounter = new FLEvaluationsCounterClass()