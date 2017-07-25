
class RosettaClasses extends RosettaObjects
  name: null #a RosettaString
  msgPatterns: null # an array of RosettaLists
  methodBodies: null # an array of RosettaLists

  classVariables: null # a RosettaList
  instanceVariables: null # a RosettaList
  tempVariables: null # a RosettaList

  classVariablesDict: null # a JS dictionary

  constructor: ->
    @classVariablesDict = {}
    @msgPatterns = []
    @methodBodies = []


# implementation of these is not changeable
# and not inspectable. "Below the surface" native
# implementations here.
class RosettaPrimitiveClasses extends RosettaClasses

# the root of everything
rosettaClass = new RosettaPrimitiveClasses()
rosettaClass.rosettaClass = rosettaClass

class RosettaNonPrimitiveClasses extends RosettaClasses

class RosettaAnonymousClass extends RosettaPrimitiveClasses
