# Fizzylogo
an object-oriented logo made in Coffeescript (Javascript)

note for later: the metaphor of the message is that it could be a list of things to do that can be executed partially, maybe, the receiver can do part of the message and return the rest for some other entity to do?

to run: ```cat fizzylogo_globals.coffee fizzylogo_parser.coffee fizzylogo_Objects.coffee fizzylogo_Context.coffee fizzylogo_Classes.coffee fizzylogo_UserClass.coffee fizzylogo_Atom.coffee fizzylogo_ListPrimitiveClass.coffee fizzylogo_SymbolClass.coffee fizzylogo_Quote.coffee fizzylogo_Boolean.coffee fizzylogo_Repeat.coffee fizzylogo_For.coffee fizzylogo_UtilityObjects.coffee fizzylogo_Number.coffee fizzylogo_Workspace.coffee fizzylogo_populateMethods.coffee tests.coffee | coffee --stdio```

to check test results more clearly: ```clear; cat fizzylogo_globals.coffee fizzylogo_parser.coffee fizzylogo_Objects.coffee fizzylogo_Context.coffee fizzylogo_Classes.coffee fizzylogo_UserClass.coffee fizzylogo_Atom.coffee fizzylogo_ListPrimitiveClass.coffee fizzylogo_SymbolClass.coffee fizzylogo_Quote.coffee fizzylogo_Boolean.coffee fizzylogo_Repeat.coffee fizzylogo_For.coffee fizzylogo_UtilityObjects.coffee fizzylogo_Number.coffee fizzylogo_Workspace.coffee fizzylogo_populateMethods.coffee tests.coffee | coffee --stdio | grep obtained```
