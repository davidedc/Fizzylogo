class FLUserDefinedClass extends FLNonPrimitiveClasses
  # this gets invoked when user does "Class new"
  # that's going to create an object that represents a new
  # user-defined Class.
  #
  # So it's going to be:
  #   userClass = new FLUserDefinedClass()
  # which mirrors what we do when we do
  #   FLBoolean = new FLBooleanPrimitiveClass()
  #
  # the .flClass of this object will point to the object
  # itself, just like in all fizzylogo classes, since
  # the class of each class is itself.
  constructor: ->
    super()
    @value = "some_custom_class_of_user"

    @instanceVariables = FLList.emptyList()
    @classVariables = FLList.emptyList()
    @tempVariables = FLList.emptyList()


  # this is going to give to the new user-defined class
  # the capacity to create objects.
  createNew: ->
    # the @ here below is the class created by the
    # user, obviously the objects its creates must
    # belong to it.
    toBeReturned = new FLNonPrimitiveObjects @
    toBeReturned.value = "object_from_a_user_class"

    toBeReturned.print = ->
      return @value

    toBeReturned.printForList = toBeReturned.print

    return toBeReturned
