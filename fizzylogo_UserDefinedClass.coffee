class FLUserDefinedClass extends FLClasses
  # this gets invoked when user does "Class new"
  # that's going to create an object that represents a new
  # user-defined Class.
  #
  # So it's going to be:
  #   userClass = new FLUserDefinedClass()
  # which mirrors what we do when we do
  #   FLBoolean = new FLBooleanClass()
  #
  # the .flClass of this object will point to the object
  # itself, just like in all fizzylogo classes, since
  # the class of each class is itself.
  constructor: ->
    super()
    @value = "some_custom_class_of_user"

  # this is going to give to the new user-defined class
  # the capacity to create objects.
  createNew: ->
    # the @ here below is the class created by the
    # user, obviously the objects its creates must
    # belong to it.
    toBeReturned = new FLObjects @
    toBeReturned.value = "object_from_a_user_class"

    toBeReturned.flToString = ->
      return @value

    toBeReturned.flToStringForList = toBeReturned.flToString

    return toBeReturned
