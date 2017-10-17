# a ListLiteralArrayNotation is just a temporary object to create
# a FizzyLogo List.
#
# Note that there are no "Array"s in FL, everything is done
# via FizzyLogo "List"s, we call this ListLiteralArrayNotation
# because it looks like an array literal but it's not, it's
# a List literal in the form of a traditional "array notation"
# of other languages.
#
# A ListLiteralArrayNotation will resolve itself to a List
# when the closing "]" is found.
#
# Contrary to lists, an ListLiteralArrayNotation accepts the
# ", (elementToBeAdded)" message to add
# elements to the list, and as indicated by the
# signature each element is evaluated before being
# added.
#
# So, all of this is so we can initiate Lists
# of evaluated elements with a
# "standard" notation like:
#
#   myList = [someVariable, 1+2, "a" + "b", -2, - 2, 1-2]
#
# Note how the "," is now needed (it wasn't needed for
# normal lists) so we can initialise things like
#
#   myList = [ 1 , - 2 ]
#
# which would have a different result without the ","
#
# This sorts of assignments would be impossible to do
# with the standard List assignment like so:
#
#   myList = '(2+2)
#
# ...since this "quoted List assignment" doesn't quite
# evaluate the elements, it rather preserves the
# structure so for example the "+" is preserved.
# (however, this "quoted List assignment"
# is useful as it is since this is how we can store code
# using Lists).

class FLListLiteralArrayNotationClass extends FLClasses
  createNew: ->
    toBeReturned = super FLListLiteralArrayNotation
    toBeReturned.value = FLList.createNew()
    return toBeReturned

FLListLiteralArrayNotation = new FLListLiteralArrayNotationClass()
