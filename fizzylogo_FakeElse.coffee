# See IfThen and FakeCatch classes for explanation.

class FLFakeElseClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLFakeElse
    toBeReturned.value = null


    toBeReturned.print = ->
      return "Done_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLFakeElse = new FLFakeElseClass() # this is a class, an anonymous class
