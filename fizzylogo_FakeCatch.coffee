# Similar to FakeElse.
#
# This catch is not actually going to do the proper
# "catch" (that's done by the catch as a message).
# The catch object enters the scene when a catch has
# already happened, it works like this:
#
#  someException = Exception new initWith "my custom error"
#  try
#  ﹍1 print
#  ﹍throw someException
#  ﹍2 print
#  catch  <<<<<<< this catch is part of the "try" signature
#                 and does the actual work of trying a catch 
#  ﹍someException
#  handle
#  ﹍" caught the error the first time around" print
#    ^^^^^^^^^^^^^^ this handle runs and mandates a new receiver
#  catch  <<<<<<< once any a catch has actually happened, the next catch
#                 is the new receiver, so it's the "object" catch,
#                 like the one of this file, but it has to do nothing
#                 i.e. all the catches that end up being receivers
#                 do nothing. Only "message" catches attemp to do
#                 a real exception catch!
#  ﹍someOtherException
#  handle
#  ﹍" caught the error the second time around" print
#  ^^^^^^^ these three lines above are consumed by the "object" catch
#  ". the end." print  
#

class FLFakeCatchClass extends FLClasses
  createNew: ->
    toBeReturned = super FLFakeCatch

    toBeReturned.flToString = ->
      return "Try_object"

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned

FLFakeCatch = new FLFakeCatchClass()
