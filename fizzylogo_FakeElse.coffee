# See IfThen and FakeCatch classes for explanation.

class FLFakeElseClass extends FLClasses
  createNew: ->
    toBeReturned = super FLFakeElse
    toBeReturned.value = null


    toBeReturned.flToString = ->
      return "FakeElse_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLFakeElse = new FLFakeElseClass()
