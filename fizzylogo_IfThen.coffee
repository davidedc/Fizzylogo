# If-then-elseif-else structures require a little
# trick to work well with the "chaining" mechanics of
# fizzylogo.
#
# First off, the first taken branch mandates another
# receiver to be found, so that we can follow
# an if-then-elseif-else structure immediately with
# another command.
#
# Secondly, whenever a branch is taken, the
# following elses all play out as objects, and
# they all do nothing, they just eat up the branches.
# So, whenever a branch is taken, all the following
# branches are eaten up and do nothing, and again we
# end up executing the command after the structure.
#
# Thirdly, all the starting non-taken branches
# (i.e. all the non-taken branches before the taken one)
# all reply with an IfFallThough object, which becomes the
# receiver, and either:
#  - is followed by else-if and else, in which case it
#    does the predicate checks and takes the branch
#    (in which case it mandates another receiver and all
#    the rest of the structure is eaten up), or not
#    (replying itself, to check for the following cases),
#    or
#  - if anything else other than "else-if" or "else"
#    is sent to it, it just mandates a new receiver.
#    This happens when it reaches the end of the
#    if-then-elseif-else structure, after which
#    the next commands can follow right away.
#
# This is similar to the try-catch mechanism, but there
# an "exception" falls through the catchers.

class FLIfThenClass extends FLAnonymousClass
  createNew: ->
    toBeReturned = super FLIfThen
    toBeReturned.value = null


    toBeReturned.print = ->
      return "IfThen_object"

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned

FLIfThen = new FLIfThenClass() # this is a class, an anonymous class
