# Fizzylogo
an object-oriented logo made in Coffeescript (Javascript)

notes for later:
* the metaphor of the message is that it could be a list of things to do that can be executed partially, maybe, the receiver can do part of the message and return the rest for some other entity to do?
* modern smalltalk does not have dot notation. This is also because temp variables are explicitly listed, so it's easy to tell whether a variable is a temp or is a lookup on the object's fields.
* you can use dot notation to read/write instance variables, but not to invoke methods (because a method signature can be complex and contain spaces and it wouldn't make sense for a complex invocation to follow the dot). If one things that "." really stands for "'s", then it's a natural distinction, but if one comes from other OO languages this can be confusing.

```npm install coffeescript -g```
```npm install replace```


to run: ```cat fizzylogo_globals.coffee fizzylogo_tokenizer.coffee fizzylogo_Objects.coffee fizzylogo_Context.coffee fizzylogo_Classes.coffee fizzylogo_UserDefinedClass.coffee fizzylogo_Token.coffee fizzylogo_ListClass.coffee  fizzylogo_Quote.coffee fizzylogo_Boolean.coffee fizzylogo_IfThen.coffee fizzylogo_IfFallThrough.coffee fizzylogo_FakeElse.coffee fizzylogo_Exception.coffee fizzylogo_Repeat1.coffee fizzylogo_Repeat2.coffee fizzylogo_For.coffee fizzylogo_In.coffee fizzylogo_Try.coffee fizzylogo_FakeCatch.coffee fizzylogo_Throw.coffee fizzylogo_Not.coffee fizzylogo_To.coffee fizzylogo_Done.coffee fizzylogo_Break.coffee fizzylogo_Return.coffee fizzylogo_AccessUpperContext.coffee fizzylogo_Forever.coffee fizzylogo_EvaluationsCounter.coffee fizzylogo_Number.coffee fizzylogo_Nil.coffee fizzylogo_String.coffee fizzylogo_Workspace.coffee fizzylogo_Console.coffee fizzylogo_populateMethods.coffee tests.coffee | coffee --stdio && say done```

to check test results more clearly: ```clear; cat fizzylogo_globals.coffee fizzylogo_tokenizer.coffee fizzylogo_Objects.coffee fizzylogo_Context.coffee fizzylogo_Classes.coffee fizzylogo_UserDefinedClass.coffee fizzylogo_Token.coffee fizzylogo_ListClass.coffee  fizzylogo_Quote.coffee fizzylogo_Boolean.coffee fizzylogo_IfThen.coffee fizzylogo_IfFallThrough.coffee fizzylogo_FakeElse.coffee fizzylogo_Exception.coffee fizzylogo_Repeat1.coffee fizzylogo_Repeat2.coffee fizzylogo_For.coffee fizzylogo_In.coffee fizzylogo_Try.coffee fizzylogo_FakeCatch.coffee fizzylogo_Throw.coffee fizzylogo_Not.coffee fizzylogo_To.coffee fizzylogo_Done.coffee fizzylogo_Break.coffee fizzylogo_Return.coffee fizzylogo_AccessUpperContext.coffee fizzylogo_Forever.coffee fizzylogo_EvaluationsCounter.coffee fizzylogo_Number.coffee fizzylogo_Nil.coffee fizzylogo_String.coffee fizzylogo_Workspace.coffee fizzylogo_Console.coffee fizzylogo_populateMethods.coffee tests.coffee | coffee --stdio | grep obtained && say done```

to just get the JS source: ```cat fizzylogo_globals.coffee fizzylogo_tokenizer.coffee fizzylogo_Objects.coffee fizzylogo_Context.coffee fizzylogo_Classes.coffee fizzylogo_UserDefinedClass.coffee fizzylogo_Token.coffee fizzylogo_ListClass.coffee  fizzylogo_Quote.coffee fizzylogo_Boolean.coffee fizzylogo_IfThen.coffee fizzylogo_IfFallThrough.coffee fizzylogo_FakeElse.coffee fizzylogo_Exception.coffee fizzylogo_Repeat1.coffee fizzylogo_Repeat2.coffee fizzylogo_For.coffee fizzylogo_In.coffee fizzylogo_Try.coffee fizzylogo_FakeCatch.coffee fizzylogo_Throw.coffee fizzylogo_Not.coffee fizzylogo_To.coffee fizzylogo_Done.coffee fizzylogo_Break.coffee fizzylogo_Return.coffee fizzylogo_AccessUpperContext.coffee fizzylogo_Forever.coffee fizzylogo_EvaluationsCounter.coffee fizzylogo_Number.coffee fizzylogo_Nil.coffee fizzylogo_String.coffee fizzylogo_Workspace.coffee fizzylogo_Console.coffee fizzylogo_populateMethods.coffee tests.coffee | coffee --stdio -c > fizzylogo.js```

you can also generate a "yielding" version of the interpreter by running
```sh makeYieldingVersion.sh```
