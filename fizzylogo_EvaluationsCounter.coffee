# a class that prints explicitly the "eval"s and the
# invocations of the empty method,
# so one can see more explicitly what happens.

class FLEvaluationsCounterClass extends FLClasses
  createNew: ->
    return super FLEvaluationsCounter

FLEvaluationsCounter = new FLEvaluationsCounterClass()
