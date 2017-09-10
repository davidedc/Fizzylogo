# Fizzylogo
an object-oriented logo made in Coffeescript (Javascript)

notes for later:
* the metaphor of the message is that it could be a list of things to do that can be executed partially, maybe, the receiver can do part of the message and return the rest for some other entity to do?
* modern smalltalk does not have dot notation. This is also because temp variables are explicitly listed, so it's easy to tell whether a variable is a temp or is a lookup on the object's fields.
* you can use dot notation to read/write instance variables, but not to invoke methods (because a method signature can be complex and contain spaces and it wouldn't make sense for a complex invocation to follow the dot). If one things that "." really stands for "'s", then it's a natural distinction, but if one comes from other OO languages this can be confusing.
* some tricks happen behind the scene on the use of : as quote, and it plays on the perception of what users think are explicit lists, and other things that users don't perceive as lists but are actually lists behind the scenes, e.g. signatures and method bodies.

```npm install coffeescript -g```
```npm install replace```


to run the tests using node: ```clear; cat $(cat sourceFilesOrder.txt) | coffee --stdio | grep obtained && say done```

to just get the JS source: ```clear; cat $(cat sourceFilesOrder.txt) | coffee --stdio -c > dist/fizzylogo.js```

note for later: ```grep -v '^tests' sourceFilesOrder.txt``` to exlude the tests to build the browser version

you can also generate a "yielding" version of the interpreter by running
```sh makeYieldingVersion.sh```
