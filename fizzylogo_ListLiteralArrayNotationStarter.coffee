# an ListLiteralArrayNotationStarter is needed to
# start creation of FizzyLogo Lists with a traditional "array literal"
# syntax i.e. with elements that are separated by commas, and
# each element is evaluated
# e.g.:
#  a = [someVariable, 1+2, "a" + "b", -2, - 2, 1-2]

class FLListLiteralArrayNotationStarterClass extends FLClasses
  createNew: ->
    toBeReturned = super FLListLiteralArrayNotationStarter
    toBeReturned.value = "["
    return toBeReturned

FLListLiteralArrayNotationStarter = new FLListLiteralArrayNotationStarterClass()
