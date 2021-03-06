# Notes on the scope mechanics:
# tokens are always looked-up in the temp variables.
# temp variables are local to the context, _however_
# if you open a context (with the accessUpperContext) command
# then you can see and influence the context(s) above.
# So, in a normal method invocation the new context is sealed,
# but other constructs such as the _for_ construct
# create an "open" context
# i.e. the tokens can also be looked up in the context(s) above
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
    #log "evaluation " + indentation() + "######### constructing new context at depth: " + @depth() + " with message: " + @message.flToString()

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
      if contextDebug
        log "evaluation " + indentation() + "firstNonTransparentContext: context is transparent at depth " + ascendingTheContext.depth() + " with self: " + ascendingTheContext.self.flToString?()
      ascendingTheContext = ascendingTheContext.previousContext

    if contextDebug
      log "first non-transparent context is the one at depth: " + ascendingTheContext.depth() + " with self: " + ascendingTheContext.self.flToString?()

    ascendingTheContext

  lookupTemp: (variableNameAsString) ->
    return @tempVariablesDict[ValidIDfromString variableNameAsString]

  lookupTempValue: (variableNameAsString) ->
    return (@lookupTemp variableNameAsString).value

  # from here, a Token matches a temp variable, which could be
  # in this context, or further up across transparent contexts,
  # OR at the top level context.
  whichDictionaryContainsToken: (theToken) ->

    contextBeingSearched = @
    tokenString = theToken.value

    if tokenString == "self"
      return @firstNonTransparentContext()

    loop
      #log "evaluation " + indentation() + "context temps: " 
      #for keys of contextBeingSearched.tempVariablesDict
      #  log keys

      # check if temp variable is in current context.
      if contextBeingSearched.tempVariablesDict[ValidIDfromString tokenString]?
        if contextDebug
          log "evaluation " + indentation() + "lookup: found in context at depth " + contextBeingSearched.depth() + " with self: " + contextBeingSearched.self.flToString?()
        return contextBeingSearched.tempVariablesDict

      # nothing found from this context, move up
      # to the sender (i.e. the callee)
      if contextDebug
        log "evaluation " + indentation() + "lookup: not found in context at depth " + contextBeingSearched.depth() + " with self: " + contextBeingSearched.self.flToString?()


      if contextBeingSearched.isTransparent
        if contextDebug
          log "evaluation " + indentation() + "lookup: ... this context is transparent so I can go up"
        contextBeingSearched = contextBeingSearched.previousContext
      else
        break

    # check if temp variable is in the outer-most context
    if outerMostContext.tempVariablesDict[ValidIDfromString tokenString]?
      return outerMostContext.tempVariablesDict


    if contextDebug
      log "evaluation " + indentation() + "lookup: " + tokenString + " not found!"
    return null

