# See IfThen and FakeCatch classes for explanation.

class FLFakeElseClass extends FLClasses
  createNew: ->
    toBeReturned = super FLFakeElse
    toBeReturned.value = "else"
    return toBeReturned


FLFakeElse = new FLFakeElseClass()
