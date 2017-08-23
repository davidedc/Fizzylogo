tests = [
  # ---------------------------------------------------------------------------
  # surprise! this language "chains" to the right
  # so "streams" of things are run right to left. 
  "1 plus 1 print"
  "1"

  # ---------------------------------------------------------------------------
  # parens can help
  "(1 plus 1)print"
  "2"

  # ---------------------------------------------------------------------------
  # here "print" takes "print" and does
  # nothing with it, so first (1 plus 1) is
  # printed, and then the result of that is
  # printed again.
  "(1 plus 1)print print"
  "22"

  # ---------------------------------------------------------------------------
  # there are two ways to assign things, this is
  # the most technically thorough but it's
  # more difficult to decypher.
  #
  # The semicolon separates stataments.
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
  "'a←5;a incrementInPlace;'a←a plus 1;a print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a incrementInPlace;a=a plus 1;a print"
  "7"

  # ---------------------------------------------------------------------------
  # the powers and dangers of mutating numbers in place
  "a=1;b=a;a print;b print;a incrementInPlace; a print; b print"
  "1122"

  # ---------------------------------------------------------------------------
  # testing crazy statement separations

  "'a←5;;a incrementInPlace; ;;;  ;'a←a plus 1;a print"
  "7"

  ";'a←5;;a incrementInPlace; ;;;  ;'a←a plus 1;a print;"
  "7"

  ";;'a←5;;a incrementInPlace; ;;;  ;'a←a plus 1;a print;;"
  "7"

  "; ;'a←5;;a incrementInPlace; ;;;  ;'a←a plus 1;a print; ;"
  "7"

  ";;;'a←5;;a incrementInPlace; ;;;  ;'a←a plus 1;a print;;;"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5;'a←a plus 1;a incrementInPlace print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a=a plus 1;a incrementInPlace print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5 plus 1;a incrementInPlace print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5 plus 1;a incrementInPlace print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(5 plus 1);a incrementInPlace print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(5 plus 1);a incrementInPlace print"
  "7"

  # ---------------------------------------------------------------------------
  "(4 plus 1 plus 1)print"
  "6"

  # ---------------------------------------------------------------------------
  "'a←(4 plus 1 plus 1);a incrementInPlace print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4 plus 1 plus 1);a incrementInPlace print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(4 plus(1 plus 1));a incrementInPlace print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4 plus(1 plus 1));a incrementInPlace print"
  "7"

  # ---------------------------------------------------------------------------
  "'a←((4 plus 1)plus(0 plus 1));a incrementInPlace print"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=((4 plus 1)plus(0 plus 1));a incrementInPlace print"
  "7"

  # ---------------------------------------------------------------------------
  "7 anotherPrint"
  "7"

  # ---------------------------------------------------------------------------
  "7 doublePrint"
  "77"

  # ---------------------------------------------------------------------------
  "7 print print"
  "77"

  # ---------------------------------------------------------------------------
  "(6 doublePrint plus 1)print"
  "667"

  # ---------------------------------------------------------------------------
  "6 doublePrint plus 1 print"
  "661"

  # ---------------------------------------------------------------------------
  "(4 plus 3)print"
  "7"

  # ---------------------------------------------------------------------------
  "(4 plus 3 print)print"
  "37"

  # ---------------------------------------------------------------------------
  "(4 plus(2 plus 1))print"
  "7"

  # ---------------------------------------------------------------------------
  "4 plus(2 plus 1)print"
  "7"

  # ---------------------------------------------------------------------------
  "4 plus 2 plus 1 print"
  "1"

  # ---------------------------------------------------------------------------
  "('(1 plus 1))print"
  "( 1 plus 1 )"

  # ---------------------------------------------------------------------------
  # the ' still ties to the first element
  # that comes after it i.e. ( 1 plus 1 )
  "'(1 plus 1)print"
  "( 1 plus 1 )"

  # ---------------------------------------------------------------------------
  "('(1 plus 1))length print"
  "3"

  # ---------------------------------------------------------------------------
  "'(1 plus 1)length print"
  "3"

  # ---------------------------------------------------------------------------
  "(('(1 plus 1))eval)print"
  "2"

  # ---------------------------------------------------------------------------
  "('(1 plus 1))eval print"
  "2"

  # ---------------------------------------------------------------------------
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
  "1 negate; 2 print"
  "! message was not understood: ( negate )"

  # ---------------------------------------------------------------------------
  """
  2 1 print
  """
  "! message was not understood: ( 1 print )"

  # ---------------------------------------------------------------------------
  "negate print"
  "nil"

  # ---------------------------------------------------------------------------
  "negate print; negate = 2; negate print; negate = nil; negate print; negate plus"
  "nil2nil! exception: message to nil: plus"

  # ---------------------------------------------------------------------------
  # this is what happens here: "a" is sent the message "b".
  # "a" doesn't know what to do with it, so it returns itself
  # and "b" remains unconsumed.
  # So the assignment will assign "a" to a, then it will mandate
  # a new receiver. The new receiver will be "b. a print" (the
  # semicolon separating the statements
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
  ""

  # ---------------------------------------------------------------------------
  "1 == 1 negate; 2 print"
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
  "true⇒(1 print)"
  "1"

  # ---------------------------------------------------------------------------
  "false⇒(1 print)2 print"
  "2"

  # ---------------------------------------------------------------------------
  "(0==0)print"
  "true"

  # ---------------------------------------------------------------------------
  "(1==0)print"
  "false"

  # ---------------------------------------------------------------------------
  "(0 amIZero)print"
  "true"

  # ---------------------------------------------------------------------------
  "(1 amIZero)print"
  "false"

  # ---------------------------------------------------------------------------
  "(8 minus 1)print"
  "7"

  # ---------------------------------------------------------------------------
  "true⇒(1 print)2 print"
  "1"

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍"yes a is 5" print
  """
  "yes a is 5"

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍"yes a is 5" print
  ". the end." print
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍"yes a is 5" print
  else:
  ﹍"no a is not 5" print
  ". the end." print
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if a==5:
  ﹍"yes a is 5" print
  else:
  ﹍"no a is not 5" print
  ". the end." print
  """
  "no a is not 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if a==5:
  ﹍"yes a is 5" print
  "the end." print
  """
  "the end."

  # ---------------------------------------------------------------------------
  "0 factorial print"
  "1"

  # ---------------------------------------------------------------------------
  "1 factorial print"
  "1"

  # ---------------------------------------------------------------------------
  "2 factorial print"
  "2"

  # ---------------------------------------------------------------------------
  "7 factorial print"
  "5040"

  # ---------------------------------------------------------------------------
  "0 factorialtwo print"
  "1"

  # ---------------------------------------------------------------------------
  "1 factorialtwo print"
  "1"

  # ---------------------------------------------------------------------------
  "2 factorialtwo print"
  "2"

  # ---------------------------------------------------------------------------
  "7 factorialtwo print"
  "5040"

  # ---------------------------------------------------------------------------
  "7 factorialthree print"
  "76543215040"

  # ---------------------------------------------------------------------------
  "7 factorialfour print"
  "5040"

  # ---------------------------------------------------------------------------
  "7 factorialfive print"
  "5040"

  # ---------------------------------------------------------------------------
  "7 selftimesminusone print"
  "42"

  # ---------------------------------------------------------------------------
  "'a←5;1 printAFromDeeperCall"
  "5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;1 printAFromDeeperCall"
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

  repeat forever:
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  a print
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5

  repeat forever:
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a minus 1
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  # alternate formatting of the above, more C-like
  """
  a=5

  repeat (forever):
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a minus 1
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat 2:
  ﹍a=a minus 1
  if a==3:
  ﹍"yes a is 3" print
  """
  "yes a is 3"

  # ---------------------------------------------------------------------------
  """
  a=5
  a print
  b print
  repeat 2:
  ﹍a=a minus 1
  ﹍b = 0
  ﹍c = 0
  a print
  b print
  c print
  """
  "5nil300"


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

  "Number answer:(aaa(operandum))by:(operandum print);1 aaa 1"
  "1"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;\
    MyClass answer:(printtwo)by'(self print);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(self print);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo
  by:
  ﹍self print
  myObject = MyClass new
  myObject printtwo
  """
  "object_from_a_user_class"

  # ---------------------------------------------------------------------------
  "'false←true;false⇒(1 print)2 print"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "false=true;false⇒(1 print)2 print"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;false⇒(1 print)2 print"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;false⇒(1 print)2 print"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;true⇒(1 print)2 print"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;true⇒(1 print)2 print"
  "2"

  # ---------------------------------------------------------------------------
  """
  "world" = "Dave"
  "Hello " print
  "world" print
  """
  "Hello Dave"

  # ---------------------------------------------------------------------------
  "'2←10;2 print"
  "10"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "2=10;2 print"
  "10"

  # ---------------------------------------------------------------------------
  "' @ ← '; @ a←8;a print"
  "8"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "@ = '; @ a←8;a print"
  "8"

  # ---------------------------------------------------------------------------
  "(4*2)times(1 print)"
  "11111111"

  # ---------------------------------------------------------------------------
  "for k from(1)to(10):(k print)"
  "12345678910"

  # ---------------------------------------------------------------------------

  "for k from 1 to 10 :(k print)"
  "12345678910"

  # ---------------------------------------------------------------------------
  """
  for k from
  ﹍1
  to
  ﹍10
  :
  ﹍k print
  "done" print
  """
  "12345678910done"

  # ---------------------------------------------------------------------------
  """
  localTemp print
  for k from
  ﹍1
  to
  ﹍1
  :
  ﹍localTemp = " - local temp"
  ﹍localTemp print
  localTemp print
  """
  "nil - local temp - local temp"

  # ---------------------------------------------------------------------------
  """
  for k from 1 to 1:
  ﹍localTemp = "local temp "
  ﹍localTemp print
  localTemp print
  """
  "local temp local temp "

  # ---------------------------------------------------------------------------
  # the for construct creates an open context, so it can read and
  # write variables from/into the 
  # the loop variable is created inside it so it's
  # keep sealed.

  """
  j = 1
  j print
  k print
  for k from 1 to 2:
  ﹍j = k
  ﹍j print
  ﹍k print
  ﹍l = k
  ﹍
  j print
  k print
  l print
  """
  "1nil11222nil2"

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
  "('(1)+(2 plus 1))print"
  "( 1 3 )"

  # ---------------------------------------------------------------------------
  "('() + \"how to enclose something in a list\")print"
  "( \"how to enclose something in a list\" )"

  # ---------------------------------------------------------------------------
  # note that the + evaluates
  # its argument, so the passed list
  # is evaluated. If you want to pass
  # a list you need to quote it, see
  # afterwards
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
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    MyClass answer:(printCounter)by:(self.counter print);\
    'myObject←MyClass new;myObject printCounter;\
    myObject setCounterToTwo;myObject printCounter;\
    'myObject2←MyClass new;myObject2 printCounter;\
    myObject2 setCounterToTwo;myObject2 printCounter"
  "nil2nil2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  MyClass = Class new
  MyClass.counter = nil

  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍self.counter←2

  MyClass answer:
  ﹍﹍printCounter
  ﹍by:
  ﹍﹍self.counter print

  myObject = MyClass new
  myObject printCounter
  myObject setCounterToTwo
  myObject printCounter

  myObject2 = MyClass new
  myObject2 printCounter
  myObject2 setCounterToTwo
  myObject2 printCounter
  """
  "nil2nil2"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    'myObject←MyClass new;\
    myObject setCounterToTwo;myObject's counter print"
  "2"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    'myObject←MyClass new;\
    myObject setCounterToTwo;myObject.counter print"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # dot notation here
  """
  MyClass = Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
  ﹍self.counter = 2
  myObject = MyClass new
  myObject setCounterToTwo
  myObject.counter print
  """
  "2"

  # ---------------------------------------------------------------------------
  # navigating a little list via dot notation
  """
  MyClass = Class new
  MyClass.link = nil

  myObject = MyClass new
  myObject2 = MyClass new
  myObject3 = MyClass new
  myObject4 = MyClass new

  myObject.link = myObject2
  myObject2.link = myObject3
  myObject3.link = myObject4
  myObject4.link = "the end"

  myObject.link.link.link.link print
  """
  "the end"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍counter=2
  codeToBeRun print
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  # you can assign arbitrary things to string tokens, even functions
  """
  "codeToBeRun" ='
  ﹍counter=2
  "codeToBeRun" print
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  """
  my = 1
  little = "hello"
  array = false
  myLittleArray =' (my little array)
  myLittleArray print
  (myLittleArray[0]+1) print
  (myLittleArray[1]) print
  if myLittleArray[2]:
  ﹍"true!" print
  else:
  ﹍"false!" print
  """
  "( 1 \"hello\" false )1hellofalse!"

  # ---------------------------------------------------------------------------

  # a token containing a list doesn't cause
  # the list to be run
  """
  myArray =' (1 print)
  myArray
  """
  ""

  # classic "explicit" eval
  """
  myArray =' (1 print)
  myArray eval
  """
  "1"

  # ---------------------------------------------------------------------------
  # something similar to closures, the
  # code is just a list of tokens, and with the quote
  # assignment (or any quote for that matter)
  # its elements (excluding "self") are all evaluated,
  # hence the bound elements are copied in terms of their values, so
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
  ﹍self's counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject's counter print
  myObject's counter = 3
  myObject's counter print
  """

  "23"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍self.counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
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
  ﹍self's counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject's counter print
  in
  ﹍myObject
  do
  ﹍self's counter = 3
  myObject's counter print
  (myObject's counter plus myObject's counter) print
  """

  "236"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍self.counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  myObject.counter print
  in
  ﹍myObject
  do
  ﹍self.counter = 3
  myObject.counter print
  (myObject.counter plus myObject.counter) print
  """

  "236"

  # ---------------------------------------------------------------------------
  # note that while the dot notation can be used to access instance variables,
  # and in theory it could be used to invoke methods without
  # parameters, it can't be used to invoke methods with parameters
  # (you can just omit the dot and it works though)

  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo (argument)
  by:
  ﹍argument print
  myObject = MyClass new
  myObject printtwo "hello"
  """
  "hello"

  # -.-.-.-.-.-.-.-.--.-             vs.             .--.-.-.--.-.-.-.-.-.-.-.-

  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo (argument)
  by:
  ﹍argument print
  myObject = MyClass new
  myObject.printtwo "hello"
  """
  "! exception: message to nil: TOKEN:hello"

  # ---------------------------------------------------------------------------
  # FLTO
  "to sayHello: (withName (name)) do: (\"Hello \" print; name print); sayHello withName \"Dave\""
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # FLTO
  """
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍"Hello " print; name print
  sayHello withName "Dave"
  """
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # FLTO
  """
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍"Hello " print
  ﹍﹍name print
  sayHello withName "Dave"
  """
  "Hello Dave"


  # ---------------------------------------------------------------------------
  # FLTO

  "to sayHello2: ((name)) do: (\"HELLO \" print; name print); sayHello2 \"Dave\""
  "HELLO Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  to sayHello2:
  ﹍﹍(name)
  ﹍do:
  ﹍﹍"HELLO " print
  ﹍﹍name print
  sayHello2 "Dave"
  """
  "HELLO Dave"

  # ---------------------------------------------------------------------------
  "'( \"Hello \" \"Dave \" \"my \" \"dear \" \"friend\") each word do (word print)"
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in '
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍word print
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍word print
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍"Hello "\\
  ﹍"Dave "\\
  ﹍"my "\\
  ﹍"dear "\\
  ﹍"friend"
  do:
  ﹍word print
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
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
  do:
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
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun =:
  ﹍word print
  myList =:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in
  ﹍myList
  do:
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
  do:
  ﹍codeToBeRun eval
  """
  "TOKEN:Hello TOKEN:Dave TOKEN:my TOKEN:dear TOKEN:friend"

  # ---------------------------------------------------------------------------
  # in this case "myList" ends up being a wrapped list i.e. ((wrapped))
  # so, when the right-side is evaluated, it ends up being the normal
  # un-wrapped contents, so it all works out without the ' after the =
  """
  codeToBeRun ='
  ﹍word print
  myList =
  ﹍'("Hello " "Dave " "my " "dear " "friend")
  for each word in
  ﹍myList
  do:
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
  myList = '
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in
  ﹍myList
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in
  ﹍'(1 2 3 4)
  do:
  ﹍acc += number
  acc print
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in '
  ﹍1 2 3 4
  do:
  ﹍acc += number
  acc print
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in:
  ﹍1 2 3 4
  do:
  ﹍acc += number
  acc print
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  myList = 9
  for each word in
  ﹍myList
  do:
  ﹍codeToBeRun
  """
  "! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\"; someException print"
  "my custom error"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    try: ( 1 print; someException )\
    catch someException: ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; someException )\
    catch someException: ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; someException )\
    catch someOtherException: ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    try: ( 1 print; throw someException; 2 print )\
    catch someException: ( \" caught the error I wanted\" print )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  try:
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch someException:
  ﹍" caught the error I wanted" print
  ". the end." print
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; throw someException; 2 print )\
    catch someException: ( \" caught the error I wanted\" print )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch someException:
  ﹍" caught the error I wanted" print
  ". the end." print
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; throw someException; 2 print )\
    catch someOtherException: ( \" caught the error I wanted\" print )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  # also note that the thrown exceptions is thrown right up to
  # the workspace, the ". the end." is not printed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch someOtherException:
  ﹍" caught the error I wanted" print
  ". the end." print  
  """
  "1! exception: my custom error"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; throw someOtherException; 2 print )\
    catch someOtherException: ( \" caught the error the first time around\" print)\
    catch someException: ( \" caught the error the second time around\" print)"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍1 print
  ﹍throw someOtherException
  ﹍2 print
  catch someOtherException:
  ﹍" caught the error the first time around" print
  catch someException:
  ﹍" caught the error the second time around" print
  ". the end." print
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; throw someException; 2 print )\
    catch someOtherException: ( \" caught the error the first time around\" print)\
    catch someException: ( \" caught the error the second time around\" print)"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch someOtherException:
  ﹍" caught the error the first time around" print
  catch someException:
  ﹍" caught the error the second time around" print
  ". the end." print
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 1
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; throw someOtherException; 2 print )\
    catch someOtherException: ( \" caught the error the first time around\" print)\
    catch someException: ( \" caught the error the second time around\" print)\
    catch all: (\" catch all branch\" print)"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍1 print
  ﹍throw someOtherException
  ﹍2 print
  catch someOtherException:
  ﹍" caught the error the first time around" print
  catch someException:
  ﹍" caught the error the second time around" print
  catch all:
  ﹍" catch all branch" print
  ". the end." print
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 2
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( 1 print; throw someException; 2 print )\
    catch someOtherException: ( \" caught the error the first time around\" print)\
    catch someException: ( \" caught the error the second time around\" print)\
    catch all: (\" catch all branch\" print)"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍1 print
  ﹍throw someException
  ﹍2 print
  catch someOtherException:
  ﹍" caught the error the first time around" print
  catch someException:
  ﹍" caught the error the second time around" print
  catch all:
  ﹍" catch all branch" print
  ". the end." print
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 3
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    'yetAnotherException ← Exception new initWith \"another custom error that is only caught by the catch all branch\";\
    try: ( 1 print; throw yetAnotherException; 2 print )\
    catch someOtherException: ( \" caught the error the first time around\" print)\
    catch someException: ( \" caught the error the second time around\" print)\
    catch all: (\" catch all branch\" print)"
  "1 catch all branch"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  yetAnotherException = Exception new initWith "another custom error that is only caught by the catch all branch"
  try:
  ﹍1 print
  ﹍throw yetAnotherException
  ﹍2 print
  catch someOtherException:
  ﹍" caught the error the first time around" print
  catch someException:
  ﹍" caught the error the second time around" print
  catch all:
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
  myList[numbers[1 plus 1]] = "oh "
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
  MyClass = Class new
  myObject = MyClass new
  myObject.someField print
  myObject.someOtherField print
  myObject.someField =' (9 3 15 5 7)
  myObject.someField[1 plus 1] = 1 plus 1
  myObject.someOtherField =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  myObject.someOtherField[myObject.someField[1 plus 1]] print

  """
  "nilnil( \"oh \" \"so \" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  myList[numbers[1 plus 1]][0 plus 1] print
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
  MyClass answer:
  ﹍getYourself (param)
  by:
  ﹍param
  myObject = MyClass new
  myObject getYourself
  ﹍2
  print
  """
  "2"

  """
  MyClass = Class new
  MyClass answer:
  ﹍getYourself (param)
  by:
  ﹍param
  myObject = MyClass new
  myObject getYourself
  ﹍2
  1 print
  """
  "! message was not understood: ( 1 print )"

  """
  MyClass = Class new
  MyClass answer:
  ﹍getYourself (param)
  by:
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
  MyClass answer:
  ﹍getYourself (param)
  by:
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
  MyClass answer:
  ﹍whenNew
  by:
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
  MyClass answer:
  ﹍whenNew
  by:
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
  MyClass answer:
  ﹍whenNew
  by:
  ﹍2
  myObject = MyClass new
  myObject print
  """
  "2"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍"hey I'm new!" print
  ﹍self
  MyClass answer:
  ﹍initWith (param)
  by:
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
  MyClass answer:
  ﹍whenNew
  // another comment here
  by:
  ﹍2
  myObject = MyClass new
  myObject print
  """
  "2"

  # ---------------------------------------------------------------------------
  # handling extra indentation
  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍printtwo (argument)
  ﹍by:
  ﹍﹍argument print
  myObject = MyClass new
  myObject printtwo "hello"
  """
  "hello"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍﹍printthree (argument)
  ﹍by:
  ﹍﹍﹍﹍argument print
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  # ---------------------------------------------------------------------------
  # unclear why you'd do this but it works
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍﹍﹍﹍﹍﹍﹍printthree (argument)
  ﹍by:
  ﹍﹍﹍﹍argument print
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  # ---------------------------------------------------------------------------
  # unclear why you'd do this but it works
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍﹍printthree (argument)
  ﹍by:
  ﹍﹍﹍﹍﹍﹍﹍﹍﹍argument print
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍﹍printthree (argument)
  ﹍﹍by:
  ﹍﹍﹍﹍argument print
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍﹍printthree (argument)
  ﹍﹍﹍by:
  ﹍﹍﹍﹍argument print
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  # ---------------------------------------------------------------------------
  # particularly useful extra indentation for repeat
  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a minus 1
  a print
  """
  "0"

  # ---------------------------------------------------------------------------
  # you would NOT want to indent the if but you could
  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍﹍done
  ﹍﹍else:
  ﹍﹍﹍a=a minus 1
  a print
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍word print
  myList = 9
  for each word in
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun
  """
  "! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField print
  myObject.someField = 2
  myObject.someField print
  """
  "nil2"

  # ---------------------------------------------------------------------------
  # simple example on how to implement a class variable
  # even though there is no special mechanism for them -
  # the classic "instantiations" counter.
  # We keep a "counter" object in MyClass.
  # When new objects are created from MyClass,
  # the class's instance variables are copied
  # (just the reference to them), so effectively
  # the counter is shared between MyClass and all its
  # instances.
  # Note how we could just directly use a number for the counter and
  # mutate it with something like "incrementInPlace", which mutates the
  # actual value of the number object, but here we choose the
  # other alternative, we don't change the value of the number itself, rather
  # we wrap the number into a "counter" object and give it a method to
  # swap-out the number with a new incremented number we get from
  # the result of "plus 1" invocation.
  """
  Counter = Class new
  Counter.counter = 0

  Counter answer:
  ﹍﹍increment
  ﹍by:
  ﹍﹍self.counter = self.counter plus 1

  MyClass = Class new
  MyClass.instantiationsCounter = Counter new

  MyClass answer:
  ﹍whenNew
  by:
  ﹍self.instantiationsCounter increment
  ﹍self

  MyClass answer:
  ﹍getCount
  by:
  ﹍self.instantiationsCounter.counter

  MyClass getCount print

  myObject = MyClass new
  MyClass getCount print
  myObject getCount print

  myObject2 = MyClass new
  MyClass getCount print
  myObject getCount print
  myObject2 getCount print

  """
  "011222"

  # ---------------------------------------------------------------------------
  # because the field look-up mechanism, you can add a field to a class
  # at any time and it will affect all its objects (the ones already created
  # from it and the ones created from it after).
  # but of course as soon as an object changes the value, the object will
  # create the field in itself and stop "looking up the chain" (just like in
  # javascript).
  """
  Counter = Class new
  Counter.counter = 0

  Counter answer:
  ﹍﹍increment
  ﹍by:
  ﹍﹍self.counter = self.counter plus 1

  MyClass = Class new

  myObject = MyClass new

  MyClass.instantiationsCounter = Counter new

  MyClass answer:
  ﹍whenNew
  by:
  ﹍self.instantiationsCounter increment
  ﹍self

  MyClass answer:
  ﹍getCount
  by:
  ﹍self.instantiationsCounter.counter

  MyClass getCount print
  myObject getCount print

  myObject2 = MyClass new
  MyClass getCount print
  myObject getCount print
  myObject2 getCount print

  myObject2.fieldAddedToObject2 = 2

  MyClass.fieldAddedToObject2 print
  myObject.fieldAddedToObject2 print
  myObject2.fieldAddedToObject2 print

  MyClass.fieldAddedToClass = 3
  MyClass.fieldAddedToClass print
  myObject.fieldAddedToClass print
  myObject2.fieldAddedToClass print

  myObject.fieldAddedToClass = 4
  MyClass.fieldAddedToClass print
  myObject.fieldAddedToClass print
  myObject2.fieldAddedToClass print

  myObject2.fieldAddedToClass = 5
  MyClass.fieldAddedToClass print
  myObject.fieldAddedToClass print
  myObject2.fieldAddedToClass print


  """
  "00111nilnil2333343345"

  # ---------------------------------------------------------------------------
  # compound assignments operators
  # ---------------------------------------------------------------------------

  """
  a = 1
  a += a
  a print
  """
  "2"

  """
  a = 1
  b = 2
  a += b
  a print
  """
  "3"

  """
  a = 1
  b = 2
  a += b plus 1
  a print
  """
  "4"

  # trick question
  """
  a = 1
  b = 2
  a += b print
  """
  "2"

  """
  a = 1
  b = 2
  (a += b) print
  """
  "3"



  # ---------------------------------------------------------------------------
  # increment/decrement operators
  # ---------------------------------------------------------------------------

  """
  a = 1
  a++
  a print
  """
  "2"

  """
  a = 1
  a++ plus 1
  a print
  """
  "2"

  """
  a = 1
  a = a++ plus 1
  a print
  """
  "3"

  """
  a = 1
  a++ print
  """
  "2"

  """
  a = 1
  a++ ++
  a print
  """
  "2"

  """
  a = 1
  a++ ++ print
  """
  "3"

  """
  a = 1
  (a++ ++) print
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField += 2
  myObject.someField print
  """
  "4"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  (myObject.someField += 2) print
  """
  "4"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField++
  myObject.someField print
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField++ print
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField++ ++ print
  myObject.someField print
  """
  "43"

  """
  myArray = '(1 2 3)
  myArray[0]++
  myArray print
  """
  "( 2 2 3 )"

  """
  myArray = '(1 2 3)
  myArray[0]++ ++ print
  myArray print
  """
  "3( 2 2 3 )"

  """
  myArray = '(1 2 3)
  (myArray[0] += myArray[1] plus myArray[2]) print
  myArray print
  """
  "6( 6 2 3 )"

  """
  myArray = '(1 2 3)
  myArray[0]++ print
  """
  "2"

  """
  myArray = '(1 2 3)
  myArray[0]++ ++ print
  myArray[0] print
  """
  "32"

  # this shows how the ++ operator
  # CREATES a new object, so it creates
  # an entry in the object if it wasn't there
  """
  MyClass = Class new
  MyClass.count = 0

  myObject = MyClass new
  myObject2 = MyClass new

  MyClass.count print // 0
  myObject.count print // 0
  myObject2.count print // 0

  MyClass.count++

  MyClass.count print // 1
  myObject.count print // 1
  myObject2.count print // 1

  myObject.count++

  MyClass.count print // 1
  myObject.count print // 2
  myObject2.count print // 1

  myObject2.count++
  myObject2.count++

  MyClass.count print // 1
  myObject.count print // 2
  myObject2.count print // 3

  MyClass.count++

  MyClass.count print // 2
  myObject.count print // 2
  myObject2.count print // 3

  """
  "000111121123223"

  # ---------------------------------------------------------------------------
  # running with empty signature (which unfortunately is not really empty)
  # FLTO

  "to sayHello: (*nothing*) do: (\"Hello\" print); sayHello;"
  "Hello"

  # ---------------------------------------------------------------------------
  #    emojis!
  # ---------------------------------------------------------------------------
  "😁 = 4; 😁 print"
  "4"

  # ---------------------------------------------------------------------------
  "😁 =4;😁 print"
  "4"

  # ---------------------------------------------------------------------------
  "😁=4;😁 print"
  "4"

  # ---------------------------------------------------------------------------
  # here "😁print" is a single token, so there is no print happening
  "😁=4;😁print"
  ""

  # ---------------------------------------------------------------------------
  # FLTO
  """
  to 🚀:
  ﹍*nothing*
  do:
  ﹍"launch!" print
  🚀
  """
  "launch!"

  """
  to 🚀:
  ﹍"launch!" print
  🚀
  """
  "launch!"


  # ---------------------------------------------------------------------------
  # you can assign arbitrary things to a string token, including
  # objects which take the empty message
  # FLTO
  """
  to "🚀":
  ﹍*nothing*
  do:
  ﹍"launch!" print
  "🚀"
  """
  "launch!"

 """
  to "🚀":
  ﹍"launch!" print
  "🚀"
  """
  "launch!"


]

# ---------------------------------------------------------------------------
# TODO this crashes
#"to sayHello '(*nothing*) do '(\"Hello\" print); sayHello;"
#"Hello"


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
    if DEBUG_STRINGIFICATION_CHECKS
      stringsTable_TO_CHECK_CONVERTIONS = {}

    testBodyMultiline = testBody.replace /\n/g, ' ⏎ '
    console.log "starting test: " + (i/2+1) + ": " + testBodyMultiline
    
    parsed = flTokenize testBody

    console.log parsed.value.length
    for eachParsedItem in parsed.value
      console.log eachParsedItem.value

    rWorkspace = FLWorkspace.createNew()


    # outer-most context
    parsed.isMessage = true
    outerMostContext = new FLContext null, rWorkspace
    flContexts.jsArrayPush outerMostContext
    
    keywordsAndTheirInit = [
      "WorkSpace", FLWorkspace # todo probably not needed?
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
      "accessUpperContext", FLAccessUpperContext.createNew()

      "nil", FLNil.createNew()

      "'", FLQuote.createNew()
      ":", FLQuote.createNew()
    ]

    for keywords in [0...keywordsAndTheirInit.length] by 2
      [keyword, itsInitialisation] = keywordsAndTheirInit[keywords .. keywords + 1]
      outerMostContext.tempVariablesDict[ValidIDfromString keyword] = itsInitialisation

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
