tests = [
  # ---------------------------------------------------------------------------
  # surprise! this language "chains" to the right
  # so "streams" of things are run right to left. 
  "1plus 1 print"
  "1"

  # ---------------------------------------------------------------------------
  # parens can help
  "(1plus 1)print"
  "2"

  # ---------------------------------------------------------------------------
  # here "print" takes "print" and does
  # nothing with it, so first (1 plus 1) is
  # printed, and then the result of that is
  # printed again.
  "(1plus 1)print print"
  "22"

  # ---------------------------------------------------------------------------
  # there are two ways to assign things, this is
  # the most technically thorough but it's
  # more difficult to decypher.
  #
  # The dot separates stataments.
  "'a ← \"test string\"; 'b ← a; 'c ← 'a; 'a eval print;'b eval print;'c eval print"
  "test stringtest stringa"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # the equal sign is less technically thorough but
  # it's move obvious from anybody coming from a mainstream language.
  "a=\"test string\";b=a;c='a;'a eval print;'b eval print;'c eval print"
  "test stringtest stringa"

  # the three "'x eval print" above are equivalent to "x print"
  "a=\"test string\";b=a;c='a;a print;b print;c print"
  "test stringtest stringa"

  # ---------------------------------------------------------------------------
  "'a←5;a increment;'a←a plus 1;a print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a increment;a=a plus 1;a print"
  "7"

  # ---------------------------------------------------------------------------
  # testing crazy statement separations

  "'a←5;;a increment; ;;;  ;'a←a plus 1;a print"
  "7"

  ";'a←5;;a increment; ;;;  ;'a←a plus 1;a print;"
  "7"

  ";;'a←5;;a increment; ;;;  ;'a←a plus 1;a print;;"
  "7"

  "; ;'a←5;;a increment; ;;;  ;'a←a plus 1;a print; ;"
  "7"

  ";;;'a←5;;a increment; ;;;  ;'a←a plus 1;a print;;;"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5;'a←a plus 1;a increment print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a=a plus 1;a increment print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5plus 1;a increment print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5plus 1;a increment print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(5plus 1);a increment print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(5plus 1);a increment print"
  "7"

  # ---------------------------------------------------------------------------
  "(4plus 1plus 1)print"
  "6"

  # ---------------------------------------------------------------------------
  "'a←(4plus 1plus 1);a increment print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4plus 1plus 1);a increment print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(4plus(1plus 1));a increment print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4plus(1plus 1));a increment print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←((4plus 1)plus(0plus 1));a increment print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=((4plus 1)plus(0plus 1));a increment print"
  "7"

  # ---------------------------------------------------------------------------
  "7anotherPrint"
  "7"

  # ---------------------------------------------------------------------------
  "7doublePrint"
  "77"

  # ---------------------------------------------------------------------------
  "7print print"
  "77"

  # ---------------------------------------------------------------------------
  "(6doublePrint plus 1)print"
  "667"

  # ---------------------------------------------------------------------------
  "6doublePrint plus 1print"
  "661"

  # ---------------------------------------------------------------------------
  "(4plus 3)print"
  "7"

  # ---------------------------------------------------------------------------
  "(4plus 3print)print"
  "37"

  # ---------------------------------------------------------------------------
  "(4plus(2plus 1))print"
  "7"

  # ---------------------------------------------------------------------------
  "4plus(2plus 1)print"
  "7"

  # ---------------------------------------------------------------------------
  "4plus 2plus 1print"
  "1"

  # ---------------------------------------------------------------------------
  "('(1plus 1))print"
  "( 1 plus 1 )"

  # ---------------------------------------------------------------------------
  "(('(1plus 1))eval)print"
  "2"

  # ---------------------------------------------------------------------------
  "('(1plus 1))eval print"
  "2"

  # ---------------------------------------------------------------------------
  # in this case still the ' ties to the first element
  # that comes after it i.e. ( 1 plus 1 )
  "'(1 plus 1)eval print"
  "2"

  # ---------------------------------------------------------------------------
  "'a←5;'b←'a;b print;a print"
  "a5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;b='a;b print;a print"
  "a5"

  # ---------------------------------------------------------------------------
  "true negate print"
  "false"

  # ---------------------------------------------------------------------------
  # note how the first not understood
  # prevents any further statement to be
  # executed
  "1 negate; 2print"
  "! message was not understood: ( negate )"

  # ---------------------------------------------------------------------------
  """
  2 1 print
  """
  "! message was not understood: ( 1 print )"

  # ---------------------------------------------------------------------------
  "negate print"
  "! no meaning found for: negate was sent message: ( print )"

  # ---------------------------------------------------------------------------
  # this is what happens here: "a" is sent the message "b".
  # "a" doesn't know what to do with it, so it returns itself
  # and "b" remains unconsumed.
  # So the assignment will assign "a" to a, then it will mandate
  # a new receiver. The new receiver will be "b. a print" (the dot
  # comes from the linearisation), which was still
  # there to be consumed. "b." will just return itself and do nothing,
  # so then "a print" will be run, which results in "a"
  """
  a = "a" "b"
  a print
  """
  """
  a
  """

  # ---------------------------------------------------------------------------
  "nonExistingObject"
  "! no meaning found for: nonExistingObject was sent message: empty message"

  # ---------------------------------------------------------------------------
  "1 == 1 negate; 2print"
  "2"

  # ---------------------------------------------------------------------------
  "(false and false)print"
  "false"

  # ---------------------------------------------------------------------------
  "(false and true)print"
  "false"

  # ---------------------------------------------------------------------------
  "(true and false)print"
  "false"

  # ---------------------------------------------------------------------------
  "(true and true)print"
  "true"

  # ---------------------------------------------------------------------------
  "(false or false)print"
  "false"

  # ---------------------------------------------------------------------------
  "(false or true)print"
  "true"

  # ---------------------------------------------------------------------------
  "(true or false)print"
  "true"

  # ---------------------------------------------------------------------------
  "(true or true)print"
  "true"

  # ---------------------------------------------------------------------------
  "(not true)print"
  "false"

  # ---------------------------------------------------------------------------
  "(not not true)print"
  "true"

  # ---------------------------------------------------------------------------
  "(not not not true)print"
  "false"

  # ---------------------------------------------------------------------------
  "(not not not not true)print"
  "true"

  # ---------------------------------------------------------------------------
  "true⇒(1print)"
  "1"

  # ---------------------------------------------------------------------------
  "false⇒(1print)2print"
  "2"

  # ---------------------------------------------------------------------------
  "(0==0)print"
  "true"

  # ---------------------------------------------------------------------------
  "(1==0)print"
  "false"

  # ---------------------------------------------------------------------------
  "(0amIZero)print"
  "true"

  # ---------------------------------------------------------------------------
  "(1amIZero)print"
  "false"

  # ---------------------------------------------------------------------------
  "(8minus 1)print"
  "7"

  # ---------------------------------------------------------------------------
  "true⇒(1print)2print"
  "1"

  # ---------------------------------------------------------------------------
  """
  a=5

  if
  ﹍a==5
  then
  ﹍"yes a is 5" print
  """
  "yes a is 5"

  # ---------------------------------------------------------------------------
  """
  a=5

  if
  ﹍a==5
  then
  ﹍"yes a is 5" print
  ". the end." print
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if
  ﹍a==5
  then
  ﹍"yes a is 5" print
  "the end." print
  """
  "the end."

  # ---------------------------------------------------------------------------
  "0factorial print"
  "1"

  # ---------------------------------------------------------------------------
  "1factorial print"
  "1"

  # ---------------------------------------------------------------------------
  "2factorial print"
  "2"

  # ---------------------------------------------------------------------------
  "7factorial print"
  "5040"

  # ---------------------------------------------------------------------------
  "0factorialtwo print"
  "1"

  # ---------------------------------------------------------------------------
  "1factorialtwo print"
  "1"

  # ---------------------------------------------------------------------------
  "2factorialtwo print"
  "2"

  # ---------------------------------------------------------------------------
  "7factorialtwo print"
  "5040"

  # ---------------------------------------------------------------------------
  "7factorialthree print"
  "5040"

  # ---------------------------------------------------------------------------
  "7factorialfour print"
  "5040"

  # ---------------------------------------------------------------------------
  "7factorialfive print"
  "5040"

  # ---------------------------------------------------------------------------
  "7selftimesminusone print"
  "42"

  # ---------------------------------------------------------------------------
  "'a←5;1printAFromDeeperCall"
  "5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;1printAFromDeeperCall"
  "5"

  # ---------------------------------------------------------------------------
  "'a←5;repeat1((a==0)⇒(done)'a←a minus 1);a print"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done)a=a minus 1);a print"
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  
  a print
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  ;a print
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  ;a print
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  'a←5

  repeat
  ﹍forever
  do
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  a print
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5

  repeat
  ﹍forever
  do
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat
  ﹍forever
  do
  ﹍if
  ﹍﹍a==0
  ﹍then
  ﹍﹍done
  ﹍else
  ﹍﹍a=a minus 1
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat
  ﹍2
  do
  ﹍a=a minus 1
  if
  ﹍a==3
  then
  ﹍"yes a is 3" print
  """
  "yes a is 3"


  # ---------------------------------------------------------------------------
  "'a←5;repeat1((a==0)⇒(done)'a←a minus 1)print"
  "Done_object"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done)a=a minus 1)print"
  "Done_object"

  # ---------------------------------------------------------------------------
  # "done" stop the execution from within a loop,
  # nothing is executed after them
  "'a←5;repeat1((a==0)⇒(done; 2 print)'a←a minus 1);a print"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done; 2 print)a=a minus 1);a print"
  "0"

  # ---------------------------------------------------------------------------
  "'a←5;repeat1\
    ((a==0)⇒(done with a plus 1)'a←a minus 1)print"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1\
    ((a==0)⇒(done with a plus 1)a=a minus 1)print"
  "1"

  # ---------------------------------------------------------------------------
  "Class print"
  "Class_object"

  # ---------------------------------------------------------------------------
  "'something←3;something print"
  "3"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "something=3;something print"
  "3"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new"
  ""

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "MyClass=Class new"
  ""

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;\
    MyClass answer(printtwo)by(self print);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "MyClass=Class new;\
    MyClass answer(printtwo)by(self print);\
    myObject=MyClass new;myObject printtwo"
  "object_from_a_user_class"

  # ---------------------------------------------------------------------------
  "'false←true;false⇒(1print)2print"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "false=true;false⇒(1print)2print"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;false⇒(1print)2print"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;false⇒(1print)2print"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;true⇒(1print)2print"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;true⇒(1print)2print"
  "2"

  # ---------------------------------------------------------------------------
  "'2←10;2print"
  "10"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "2=10;2print"
  "10"

  # ---------------------------------------------------------------------------
  "' @ ← '; @a←8;a print"
  "8"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "@ = '; @a←8;a print"
  "8"

  # ---------------------------------------------------------------------------
  #'8 tdict print'
  #'empty message"

  # ---------------------------------------------------------------------------
  "8 idict print"
  "empty message"

  # ---------------------------------------------------------------------------
  "8 cdict print"
  "empty message"

  # ---------------------------------------------------------------------------
  "(4*2)times(1print)"
  "11111111"

  # ---------------------------------------------------------------------------
  "for k from(1)to(10)do(k print)"
  "12345678910"

  # ---------------------------------------------------------------------------
  "for k from 1to 10do(k print)"
  "12345678910"

  # ---------------------------------------------------------------------------
  """
  for k from
  ﹍1
  to
  ﹍10
  do
  ﹍k print
  "done" print
  """
  "12345678910done"

  # ---------------------------------------------------------------------------
  "8 unintelligibleMessage"
  "! message was not understood: ( unintelligibleMessage )"

  # ---------------------------------------------------------------------------
  "' a ← 5 someUndefinedMessage"
  "! message was not understood: ( someUndefinedMessage )"


  # ---------------------------------------------------------------------------
  "\"hello world\" print"
  "hello world"

  # ---------------------------------------------------------------------------
  "('(1)+2)print"
  "( 1 2 )"

  # ---------------------------------------------------------------------------
  "('(1)+(2plus 1))print"
  "( 1 3 )"

  # ---------------------------------------------------------------------------
  "('() + \"how to enclose something in a list\")print"
  "( \"how to enclose something in a list\" )"

  # ---------------------------------------------------------------------------
  # note that the + evaluates
  # its argument, so the passed list
  # is evaluated. If you want to pass
  # a list you need to quote it, see
  # afterwards.
  "('(1)+(2))print"
  "( 1 2 )"

  # ---------------------------------------------------------------------------
  "('(1)+'(2))print"
  "( 1 ( 2 ) )"

  # ---------------------------------------------------------------------------
  "('((1))+2)print"
  "( ( 1 ) 2 )"

  # ---------------------------------------------------------------------------
  "('((1))+'(2))print"
  "( ( 1 ) ( 2 ) )"

  # ---------------------------------------------------------------------------
  "'myList←List new;myList print;'myList←myList+2;myList print"
  "empty message( 2 )"

  # ---------------------------------------------------------------------------
  "'myString←String new;myString print;\
    'myString←myString+\"Hello \";\
    'myString←myString+\"world\";\
    myString print"
  "Hello world"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass idict←counter;\
    MyClass answer(setCounterToTwo)by('counter←2);\
    MyClass answer(printCounter)by(counter print);\
    'myObject←MyClass new;myObject printCounter;\
    myObject setCounterToTwo;myObject printCounter;\
    'myObject2←MyClass new;myObject2 printCounter;\
    myObject2 setCounterToTwo;myObject2 printCounter"
  "nil2nil2"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass idict←counter;\
    MyClass answer(setCounterToTwo)by('counter←2);\
    'myObject←MyClass new;\
    myObject setCounterToTwo;myObject's counter print"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  MyClass = Class new
  MyClass idict = counter
  MyClass answer
  ﹍setCounterToTwo
  by
  ﹍counter = 2
  myObject = MyClass new
  myObject setCounterToTwo
  myObject.counter print
  """
  "2"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍counter=2
  codeToBeRun print
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  # the equivalent of closures, the
  # code is just a list, and with the quote assignment
  # its elements are all evaluated, hence the bound
  # elements are copied in terms of their values, so
  # those can't be changed anymore.
  # The unassigned elements are kept as is and hence
  # they are free to be bound later
  """
  op1 = 2
  codeToBeRun ='
  ﹍(op1 plus op2) print
  op2 = 3
  codeToBeRun eval
  op2 = 6
  codeToBeRun eval
  op1 = 1000
  codeToBeRun eval
  """
  "588"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍counter=2

  MyClass=Class new
  MyClass idict = counter
  MyClass answer
  ﹍setCounterToTwo
  by
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject's counter print
  myObject's counter = 3
  myObject's counter print
  """

  "23"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  codeToBeRun ='
  ﹍counter=2

  MyClass=Class new
  MyClass idict = counter
  MyClass answer
  ﹍setCounterToTwo
  by
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject.counter print
  myObject.counter = 3
  myObject.counter print
  """

  "23"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍counter=2

  MyClass=Class new
  MyClass idict = counter
  MyClass answer
  ﹍setCounterToTwo
  by
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject's counter print
  in
  ﹍myObject
  do
  ﹍counter = 3
  myObject's counter print
  (myObject's counter plus myObject's counter) print
  """

  "236"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  codeToBeRun ='
  ﹍counter=2

  MyClass=Class new
  MyClass idict = counter
  MyClass answer
  ﹍setCounterToTwo
  by
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject.counter print
  in
  ﹍myObject
  do
  ﹍counter = 3
  myObject.counter print
  (myObject.counter plus myObject.counter) print
  """

  "236"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass cvar classCounter ← 0;\
    MyClass answer(incrementClassCounterByTwo)by('classCounter←classCounter plus 2);\
    MyClass answer(printClassCounter)by(classCounter print);\
    'myObject←MyClass new;myObject printClassCounter;\
    myObject incrementClassCounterByTwo;\
    myObject printClassCounter;\
    'myObject2←MyClass new;myObject2 printClassCounter;\
    myObject2 incrementClassCounterByTwo;\
    myObject2 printClassCounter"
  "0224"

  # ---------------------------------------------------------------------------
  "to sayHello (withName (name)) do (\"Hello \" print; name print); sayHello withName \"Dave\""
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  to sayHello
  ﹍withName (name)
  do
  ﹍"Hello " print; name print
  sayHello withName "Dave"
  """
  "Hello Dave"


  # ---------------------------------------------------------------------------
  "to sayHello2 ((name)) do (\"HELLO \" print; name print); sayHello2 \"Dave\""
  "HELLO Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # todo needs a way to remove that empty line
  # before the sayHello2 "Dave"
  """
  to sayHello2
  ﹍(name)
  do
  ﹍"HELLO " print; name print
  sayHello2 "Dave"
  """
  "HELLO Dave"

  # ---------------------------------------------------------------------------
  "'( \"Hello \" \"Dave \" \"my \" \"dear \" \"friend\") each word do (word print)"
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  # note here how the list is evaluated. Because it's a "wrapped" list,
  # its evaluation is the unwrapped content, so it's the list
  # as you expect it.

  """
  for each word in
  ﹍("Hello " "Dave " "my " "dear " "friend")
  do
  ﹍word print
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  for each word in
  ﹍("Hello " "Dave " "my " "dear " "friend")
  do
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  for each word in
  ﹍myList
  do
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  myList ='
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in
  ﹍myList
  do
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  # in this case "myList" ends up being a wrapped list i.e. ((wrapped))
  # so, when the right-side is evaluated, it ends up being the normal
  # un-wrapped contents, so it all works out without the ' after the =
  """
  codeToBeRun ='
  ﹍word print
  myList =
  ﹍("Hello " "Dave " "my " "dear " "friend")
  for each word in
  ﹍myList
  do
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  myList = 9
  for each word in
  ﹍myList
  do
  ﹍codeToBeRun eval
  """
  "! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\"; someException print"
  "my custom error"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    try ( 1 print; someException )\
    catch ( someException ) handle ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; someException )\
    catch ( someException ) handle ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; someException )\
    catch ( someOtherException ) handle ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    try ( 1 print; throw someException; 2 print )\
    catch ( someException ) handle ( \" caught the error I wanted\" print )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  try
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch
  ﹍someException
  handle
  ﹍" caught the error I wanted" print
  ". the end." print
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; throw someException; 2 print )\
    catch ( someException ) handle ( \" caught the error I wanted\" print )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch
  ﹍someException
  handle
  ﹍" caught the error I wanted" print
  ". the end." print
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; throw someException; 2 print )\
    catch ( someOtherException ) handle ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  # also note that the thrown exceptions is thrown right up to
  # the workspace, the ". the end." is not printed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch
  ﹍someOtherException
  handle
  ﹍" caught the error I wanted" print
  ". the end." print  
  """
  "1! exception: my custom error"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; throw someOtherException; 2 print )\
    catch ( someOtherException ) handle ( \" caught the error the first time around\" print)\
    catch ( someException ) handle ( \" caught the error the second time around\" print)"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try
  ﹍1 print
  ﹍throw someOtherException
  ﹍2 print
  catch
  ﹍someOtherException
  handle
  ﹍" caught the error the first time around" print
  catch
  ﹍someException
  handle
  ﹍" caught the error the second time around" print
  ". the end." print
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; throw someException; 2 print )\
    catch ( someOtherException ) handle ( \" caught the error the first time around\" print)\
    catch ( someException ) handle ( \" caught the error the second time around\" print)"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch
  ﹍someOtherException
  handle
  ﹍" caught the error the first time around" print
  catch
  ﹍someException
  handle
  ﹍" caught the error the second time around" print
  ". the end." print
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 1
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; throw someOtherException; 2 print )\
    catch ( someOtherException ) handle ( \" caught the error the first time around\" print)\
    catch ( someException ) handle ( \" caught the error the second time around\" print)\
    catch all handle (\" catch all branch\" print)"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try
  ﹍1 print
  ﹍throw someOtherException
  ﹍2 print
  catch
  ﹍someOtherException
  handle
  ﹍" caught the error the first time around" print
  catch
  ﹍someException
  handle
  ﹍" caught the error the second time around" print
  catch all handle
  ﹍" catch all branch" print
  ". the end." print
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 2
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try ( 1 print; throw someException; 2 print )\
    catch ( someOtherException ) handle ( \" caught the error the first time around\" print)\
    catch ( someException ) handle ( \" caught the error the second time around\" print)\
    catch all handle (\" catch all branch\" print)"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch
  ﹍someOtherException
  handle
  ﹍" caught the error the first time around" print
  catch
  ﹍someException
  handle
  ﹍" caught the error the second time around" print
  catch all handle
  ﹍" catch all branch" print
  ". the end." print
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 3
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    'yetAnotherException ← Exception new initWith \"another custom error that is only caught by the catch all branch\";\
    try ( 1 print; throw yetAnotherException; 2 print )\
    catch ( someOtherException ) handle ( \" caught the error the first time around\" print)\
    catch ( someException ) handle ( \" caught the error the second time around\" print)\
    catch all handle (\" catch all branch\" print)"
  "1 catch all branch"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  yetAnotherException = Exception new initWith "another custom error that is only caught by the catch all branch"
  try
  ﹍1 print
  ﹍throw yetAnotherException
  ﹍2 print
  catch
  ﹍someOtherException
  handle
  ﹍" caught the error the first time around" print
  catch
  ﹍someException
  handle
  ﹍" caught the error the second time around" print
  catch all handle
  ﹍" catch all branch" print
  ". the end." print
  """
  "1 catch all branch. the end."

  # ---------------------------------------------------------------------------
  """
  foo = 3
  things =' ()
  things = things + 3
  things = things + "hello"
  things print
  """
  "( 3 \"hello\" )"

  # ---------------------------------------------------------------------------
  """
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[0] print
  myList[1 plus 1] print
  """
  "Hello my "

  # ---------------------------------------------------------------------------
  """
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[1 plus 1] = "oh "
  myList print
  """
  "( \"Hello \" \"Dave \" \"oh \" \"dear \" \"friend\" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[numbers[1plus 1]] = "oh "
  myList print
  """
  "( \"Hello \" \"Dave \" \"oh \" \"dear \" \"friend\" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  (numbers[0] plus numbers[1]) print
  """
  "12"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  myList[numbers[2]] print
  """
  "( \"oh \" \"so \" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  myList[numbers[1plus 1]][0 plus 1] print
  """
  "so "

  # ---------------------------------------------------------------------------
  """
  things =' (false true)
  (things[0] or things[1]) print
  """
  "true"

  # ---------------------------------------------------------------------------
  """
  foo = 3
  things =' (foo bar 2)
  things[0] print
  things[1] print
  things[2] print
  things print
  """
  "3bar2( 3 bar 2 )"

  # ---------------------------------------------------------------------------
  """
  things1 =' (my little list)
  things2 = things1
  things1 print
  things2 print
  things1[0] = 'your
  things2[1] = 'big
  things1 print
  things2 print
  things1 = " no more a list "
  things1 print
  things2 print
  """
  "( my little list )( my little list )( your big list )( your big list ) no more a list ( your big list )"

  # ---------------------------------------------------------------------------
  # ... an extra line (extra ;) at the end of user-defined methods
  # means that a new receiver is mandated. Affects whether a particular
  # method "returns" something or not. Not returning anything is useful
  # (for example for user made control structures), because this way
  # they can be immediately followed by any other statement without
  # the obligation of having to chain with them.
  """
  MyClass = Class new
  MyClass answer
  ﹍getYourself (param)
  by
  ﹍param
  myObject = MyClass new
  myObject getYourself
  ﹍2
  print
  """
  "2"

  """
  MyClass = Class new
  MyClass answer
  ﹍getYourself (param)
  by
  ﹍param
  myObject = MyClass new
  myObject getYourself
  ﹍2
  1 print
  """
  "! message was not understood: ( 1 print )"

  """
  MyClass = Class new
  MyClass answer
  ﹍getYourself (param)
  by
  ﹍param
  ﹍
  myObject = MyClass new
  myObject getYourself
  ﹍3
  print
  """
  ""

  """
  MyClass = Class new
  MyClass answer
  ﹍getYourself (param)
  by
  ﹍param
  ﹍
  myObject = MyClass new
  myObject getYourself
  ﹍3
  1 print
  """
  "1"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer
  ﹍whenNew
  by
  ﹍"hey I'm new!" print
  ﹍self
  myObject = MyClass new
  " ...done!" print
  """
  "hey I'm new! ...done!"

  # ---------------------------------------------------------------------------
  # in this case the assignment
  # consumes up to
  #    myObject = MyClass new
  # and then it breaks the chain
  # and lets "1 print" loose
  """
  MyClass = Class new
  MyClass answer
  ﹍whenNew
  by
  ﹍2
  ﹍self
  myObject = MyClass new 1 print
  """
  "1"

  # ---------------------------------------------------------------------------
  # ooops in this case the "whenNew" returned an
  # integer and we assign that to the new object!
  # in this case it's an error, but it can be used
  # for the factory pattern to construct other things
  """
  MyClass = Class new
  MyClass answer
  ﹍whenNew
  by
  ﹍2
  myObject = MyClass new
  myObject print
  """
  "2"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer
  ﹍whenNew
  by
  ﹍"hey I'm new!" print
  ﹍self
  MyClass answer
  ﹍initWith (param)
  by
  ﹍param print
  ﹍self
  myObject = MyClass new initWith " hello again! I am... "
  myObject print
  """
  "hey I'm new! hello again! I am... object_from_a_user_class"

  # ---------------------------------------------------------------------------
  """
  // a comment here
  MyClass = Class new
  MyClass answer
  ﹍whenNew
  // another comment here
  by
  ﹍2
  myObject = MyClass new
  myObject print
  """
  "2"

]

###
# ---------------------------------------------------------------------------
"""
foo = 3
things =' (foo ('foo) 2)
things[0] print
things[1] print
(things[1] eval) print
((things[1] eval) eval) print
(things[1] eval) ← " bar"
foo print
((things[1] eval) eval) print
things[2] print
2 = 10
things[1 plus 1] print
things =' (foo ('foo) 2)
things[1 plus 1] print
"""
"3( ' foo )foo3 bar bar2210"

# ---------------------------------------------------------------------------
"""
foo = 3
things =' ()
things = things + foo
things print
things[0] print
" // " print
things =' ()
things = things + 'foo
things print
things[0] print
" // " print
things =' ()
things = things + '('foo)
things print
things[0] print
"""
"( 3 )3 // ( foo )3 // ( ( ' foo ) )( ' foo )"
###

###
tests = [
]
###

flContexts = []
rWorkspace = null
OKs = 0
FAILs = 0

for i in [0...tests.length] by 2
    [testBody, testResult] = tests[i .. i + 1]
    environmentPrintout = ""
    environmentErrors = ""

    testBodyMultiline = testBody.replace /\n/g, ' ⏎ '
    console.log "starting test: " + (i/2+1) + ": " + testBodyMultiline
    
    parsed = flParse testBody

    console.log parsed.value.length
    for eachParsedItem in parsed.value
      console.log eachParsedItem.value

    rWorkspace = FLWorkspace.createNew()


    # outer-most context
    parsed.isMessage = true
    outerMostContext = new FLContext null, rWorkspace
    flContexts.jsArrayPush outerMostContext

    rWorkspace.flClass.instanceVariables = FLList.emptyList()
    
    keywordsAndTheirInit = [
      "WorkSpace", FLWorkspace
      "Class", FLClass.createNew()
      "List", FLList
      "String", FLString
      "Exception", FLException

      "not", FLNot.createNew()
      "true", FLBoolean.createNew true
      "false", FLBoolean.createNew false

      "for", FLFor.createNew()
      "repeat1", FLRepeat1.createNew()
      "done", FLDone.createNew()

      "if", FLIfThen.createNew()
      "else", FLFakeElse.createNew()
      "forever", FLForever.createNew()
      "repeat", FLRepeat2.createNew()

      "try", FLTry.createNew()
      "throw", FLThrow.createNew()
      "catch", FLFakeCatch.createNew()

      "to", FLTo.createNew()

      "in", FLIn.createNew()

      "'", FLQuote.createNew()
    ]

    for keywords in [0...keywordsAndTheirInit.length] by 2
      [keyword, itsInitialisation] = keywordsAndTheirInit[keywords .. keywords + 1]
      rWorkspace.flClass.instanceVariables = rWorkspace.flClass.instanceVariables.flListImmutablePush FLAtom.createNew keyword
      outerMostContext.self.instanceVariablesDict[ValidIDfromString keyword] = itsInitialisation


    messageLength = parsed.length()
    console.log "evaluation " + indentation() + "messaging workspace with " + parsed.print()

    # now we are using the message as a list because we have to evaluate it.
    # to evaluate it, we treat it as a list and we send it the empty message
    # note that "self" will remain the current one, since anything that
    # is in here will still refer to "self" as the current self in the
    # overall message.
    
    [returnedContext] = parsed.eval outerMostContext, parsed

    console.log "evaluation " + indentation() + "end of workspace evaluation"

    if !returnedContext.returned?
      if returnedContext.unparsedMessage?
        unparsedPartOfMessage = " was sent message: " + returnedContext.unparsedMessage.print()
      else
        unparsedPartOfMessage = ""
      console.log "evaluation " + indentation() + "no meaning found for: " + rWorkspace.lastUndefinedArom.value + unparsedPartOfMessage
      environmentErrors += "! no meaning found for: " + rWorkspace.lastUndefinedArom.value + unparsedPartOfMessage
      rWorkspace.lastUndefinedArom
    else
      if returnedContext.throwing and returnedContext.returned.flClass == FLException
        console.log "evaluation " + indentation() + "exception: " + returnedContext.returned.value
        environmentErrors += "! exception: " + returnedContext.returned.value

      if returnedContext.unparsedMessage
        console.log "evaluation " + indentation() + "message was not understood: " + returnedContext.unparsedMessage.print()
        environmentErrors += "! message was not understood: " + returnedContext.unparsedMessage.print()


    console.log "final return: " + returnedContext.returned?.value
    if environmentPrintout + environmentErrors == testResult
      OKs++
      console.log "...test " + (i/2+1) + " OK, obtained: " + environmentPrintout + environmentErrors
    else
      FAILs++
      console.log "...test " + (i/2+1) + " FAIL, test: " + testBodyMultiline + " obtained: " + environmentPrintout + environmentErrors + " expected: " + testResult

console.log "all tests done. obtained " + OKs + " OKs and " + FAILs + " FAILs"
