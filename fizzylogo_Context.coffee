class FLContext
  self: null # a FLObject
  programCounter: 0 # an integer
  tempVariablesDict: null # a JS dictionary
  previousContext: null
  returned: null

  # contexts should only be created when "self" changes
  # (on method invocation), or when you want to
  # "seal" some temporary variables that might
  # be needed/created (e.g. the "for" case).
  constructor: (@previousContext, newSelf) ->
    if newSelf
      @self = newSelf
    else
      @self = @previousContext.self

    @tempVariablesDict = {}
    #console.log "evaluation " + indentation() + "######### constructing new context at depth: " + @depth() + " with message: " + @message.print()

  depth: ->
    depthCount = 0
    ascendingTheContext = @previousContext
    while ascendingTheContext?
      depthCount++
      ascendingTheContext = ascendingTheContext.previousContext
    depthCount

  # effectively climbs up the context chain
  # up to the last method invocation
  # TODO this can be done cleaner, looking at where
  # the self changes seems a little risky...
  topMostContextWithThisSelf: ->
    currentSelf = @self
    ascendingTheContext = @previousContext
    chosenContext = @
    while ascendingTheContext? and (currentSelf == ascendingTheContext.self)
      chosenContext = ascendingTheContext
      ascendingTheContext = ascendingTheContext.previousContext
    chosenContext

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
    # We always return a fizzylogo object (or a fizzylogo class
    # , which is also a fizzylogo object)

    # check the temporaries
    contextBeingSearched = @
    atomValue = theAtom.value

    if atomValue == "self"
      return @

    while contextBeingSearched?

      console.log "evaluation " + indentation() + " current message: "
      console.log "evaluation " + indentation() + "context temps: " 
      for keys of contextBeingSearched.tempVariablesDict
        console.log keys

      console.log "evaluation " + indentation() + "looking in class: " + contextBeingSearched.self.flClass
      #console.dir contextBeingSearched.self.flClass

      temps = contextBeingSearched.self.flClass.tempVariables
      if temps?
        console.log "evaluation " + indentation() + "lookup: checking in " + temps.print()
        if (temps.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in tempVariables"
          # even though the tempVariables contains the temp, it doesn't
          # mean it's in this context, it could be higher up, so
          # check for existence.
          if contextBeingSearched.tempVariablesDict[ValidIDfromString atomValue]?
            return contextBeingSearched.tempVariablesDict

      instances = contextBeingSearched.self.flClass.instanceVariables
      if instances?
        console.log "evaluation " + indentation() + "lookup: checking in " + instances.print()
        if instances.value? and (instances.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in instanceVariables"
          return contextBeingSearched.self.instanceVariablesDict

      statics = contextBeingSearched.self.flClass.classVariables
      if statics?
        console.log "evaluation " + indentation() + "lookup: checking in " + statics.print()
        if statics.value? and (statics.value.find (element) -> element.value == atomValue)
          console.log "evaluation " + indentation() + "lookup: found " + atomValue + " in classVariables"
          return contextBeingSearched.self.flClass.classVariablesDict

      # nothing found from this context, move up
      # to the sender (i.e. the callee)
      console.log "evaluation " + indentation() + "lookup: not found in this context, going up "
      contextBeingSearched = contextBeingSearched.previousContext

    console.log "evaluation " + indentation() + "lookup: " + atomValue + " not found!"
    return null


  createNonExistentValueLookup: (theAtom) ->
    # if the variable doesn't exist anywhere and
    # we are currently in context linked to the
    # workspace...
    atomValue = theAtom.value
    if @self == rWorkspace
      console.log "evaluation " + indentation() + "lookup: creating " + atomValue + " as instance variable in top-most context"
      @self.flClass.instanceVariables = @self.flClass.instanceVariables.flListImmutablePush FLAtom.createNew atomValue
      return @self.instanceVariablesDict
    # otherwise, in any other context create it as a temp
    else
      console.log "evaluation " + indentation() + "lookup: creating " + atomValue + " as temp variable in current context at depth: " + @depth()
      if !@self.flClass.tempVariables?
        @self.flClass.tempVariables = FLList.emptyList()

      @self.flClass.tempVariables = @self.flClass.tempVariables.flListImmutablePush FLAtom.createNew atomValue
      return @tempVariablesDict


  lookUpAtomValue: (theAtom, alreadyKnowWhichDict) ->
    # we first look _where_ the value of the Atom is,
    # then we fetch it

    if alreadyKnowWhichDict?
      dictWhereValueIs = alreadyKnowWhichDict
    else  
      dictWhereValueIs = @lookUpAtomValuePlace theAtom

    if !dictWhereValueIs?
      dictWhereValueIs = @createNonExistentValueLookup theAtom

    #console.log "evaluation " + indentation() + "lookup: " + theAtom.value + " found dictionary and it contains:"
    #console.dir dictWhereValueIs
    console.log "evaluation " + indentation() + "lookup: " + theAtom.value + " also known as " + (ValidIDfromString theAtom.value)

    console.log "evaluation " + indentation() + "lookup: value looked up: "
    console.dir dictWhereValueIs[ValidIDfromString theAtom.value]

    return dictWhereValueIs[ValidIDfromString theAtom.value]


