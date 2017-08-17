# Notes on the scope mechanics:
# atoms are always looked-up in the temp variables.
# temp variables are local to the context, _however_
# if you open a context (with the accessUpperContext) command
# then you can see and influence the context(s) above.
# So, in a normal method invocation the new context is sealed,
# but other constructs such as the _for_ construct
# create an "open" context
# i.e. the atoms can also be looked up in the context(s) above
# as well and
# the newly created variables are visible from above.
# (however note that the for construct creates the loop
# variable in its context so not to clobber existing
# ones and not to leak the loop variable).
# to access fields of an object, the "."... methods are used
# , which explicitely use the following atems to look up
# the dictionaries of the receiver, no reference to temp
# variables in the context is made in those cases.

class FLContext
  self: null # a FLObject
  tempVariablesDict: null # a JS dictionary
  previousContext: null
  returned: null
  isTransparent: false

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

  # climbs up the context chain
  firstNonTransparentContext: ->
    ascendingTheContext = @

    # the top-most context is NOT transparent,
    # so we know this loop will never go "beyond" the top
    while ascendingTheContext.isTransparent
      ascendingTheContext = ascendingTheContext.previousContext

    ascendingTheContext

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
      return @firstNonTransparentContext()

    while true

      console.log "evaluation " + indentation() + "context temps: " 
      for keys of contextBeingSearched.tempVariablesDict
        console.log keys

      # check if temp variable is in current context.
      if contextBeingSearched.tempVariablesDict[ValidIDfromString atomValue]?
        console.log "evaluation " + indentation() + "lookup: found in context at depth " + contextBeingSearched.depth() + " with self: " + contextBeingSearched.self.print()
        return contextBeingSearched.tempVariablesDict

      # nothing found from this context, move up
      # to the sender (i.e. the callee)
      console.log "evaluation " + indentation() + "lookup: not found in context at depth " + contextBeingSearched.depth() + " with self: " + contextBeingSearched.self.print()


      if contextBeingSearched.isTransparent
        console.log "evaluation " + indentation() + "lookup: ... this context is transparent so I can go up"
        contextBeingSearched = contextBeingSearched.previousContext
      else
        break

    # check if temp variable is in the outer-most context
    if outerMostContext.tempVariablesDict[ValidIDfromString atomValue]?
      return outerMostContext.tempVariablesDict


    console.log "evaluation " + indentation() + "lookup: " + atomValue + " not found!"
    return null


  createNonExistentValueLookup: ->
    # if the variable doesn't exist anywhere and
    # we are currently in context linked to the
    # workspace...
    return @firstNonTransparentContext().tempVariablesDict


  lookUpAtomValue: (theAtom, alreadyKnowWhichDict) ->
    # we first look _where_ the value of the Atom is,
    # then we fetch it

    if alreadyKnowWhichDict?
      dictWhereValueIs = alreadyKnowWhichDict
    else  
      dictWhereValueIs = @lookUpAtomValuePlace theAtom

    if !dictWhereValueIs?
      dictWhereValueIs = @createNonExistentValueLookup()

    #console.log "evaluation " + indentation() + "lookup: " + theAtom.value + " found dictionary and it contains:"
    #console.dir dictWhereValueIs
    console.log "evaluation " + indentation() + "lookup: " + theAtom.value + " also known as " + (ValidIDfromString theAtom.value)

    console.log "evaluation " + indentation() + "lookup: value looked up: "
    console.dir dictWhereValueIs[ValidIDfromString theAtom.value]

    return dictWhereValueIs[ValidIDfromString theAtom.value]


