class RosettaContext
  self: null # a RosettaObject
  programCounter: 0 # an integer
  message: null # a RosettaMessage, which is an RList and a cursor
  tempVariablesDict: null # a JS dictionary
  previousContext: null
  returned: null

  constructor: (@previousContext, @self, @message) ->
    @tempVariablesDict = {}

  lookUpAtomValuePlace: (theAtom) ->
    # we first look in this context, and then we go up
    # context by context until we reach the top without
    # having found anything.

    # so, for each context,
    #   first, check the temporaries
    #     if the class lists the atom in the temporaties
    #       then the value resides in the context itself
    #   then the instance variables
    #     if the class lists the atom in the intance variables
    #       then the value resides in the self object
    #   then the class variables.
    #     if the class lists the atom in the class variables
    #       then the value resides in the class
    # We always return a rosetta object (or a rosetta class
    # , which is also a rosetta object)

    # check the temporaries
    contextBeingSearched = @
    atomValue = theAtom.value

    if atomValue == "self"
      return @

    while contextBeingSearched?

      console.log "evaluation " + indentation() + "looking in class: " + contextBeingSearched.self.rosettaClass
      console.dir contextBeingSearched.self.rosettaClass

      temps = contextBeingSearched.self.rosettaClass.tempVariables
      if temps?
        console.log "evaluation " + indentation() + "lookup: checking in " + temps.value
        if temps.value? and (temps.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in tempVariables"
          return contextBeingSearched.tempVariablesDict

      instances = contextBeingSearched.self.rosettaClass.instanceVariables
      if instances?
        console.log "evaluation " + indentation() + "lookup: checking in " + instances.value
        if instances.value? and (instances.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in instanceVariables"
          return contextBeingSearched.self.instanceVariablesDict

      statics = contextBeingSearched.self.rosettaClass.classVariables
      if statics?
        console.log "evaluation " + indentation() + "lookup: checking in " + statics.value
        if statics.value? and (statics.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in classVariables"
          return contextBeingSearched.self.rosettaClass.classVariablesDict

      # nothing found from this context, move up
      # to the sender (i.e. the callee)
      console.log "evaluation " + indentation() + "lookup: not found in this context, going up "
      contextBeingSearched = contextBeingSearched.previousContext

    console.log "evaluation " + indentation() + "lookup: " + atomValue + " not found!"

  lookUpAtomValue: (theAtom) ->
    # we first look _where_ the value of the Atom is,
    # then we fetch it

    dictWhereValueIs = @lookUpAtomValuePlace theAtom
    console.log "evaluation " + indentation() + "lookup: " + theAtom.value + " found dictionary and it contains:"
    console.dir dictWhereValueIs
    return dictWhereValueIs[theAtom.value]


