tests = [
  # ---------------------------------------------------------------------------
  # surprise! this language "chains" to the right
  # so "streams" of things are run right to left. 
  "console print_ 2 * 3 + 1"
  "8"

  # ---------------------------------------------------------------------------
  "console print_ (2 * 3) + 1"
  "7"

  # ---------------------------------------------------------------------------

  "console print_ 1+1;Number answer:(+(operandum))by:(console print_ self;console print_ \"+\";console print_ operandum);2+3;Number answer:(+(operandum))by:(self $plus_binary operandum);"
  "22+3"

  # ---------------------------------------------------------------------------
  # here "print" takes "print" and does
  # nothing with it, so first (1+1) is
  # printed, and then the result of that is
  # printed again.
  "console print_(console print_ 1+1)"
  "22"

  # ---------------------------------------------------------------------------
  # there are two ways to assign things, this is
  # the most technically thorough but it's
  # more difficult to decypher.
  #
  # The semicolon separates stataments.
  "'a ← \"test string\"; 'b ← a; 'c ← 'a; console print_ 'a eval;console print_ 'b eval;console print_ 'c eval"
  "test stringtest stringa"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # the equal sign is less technically thorough but
  # it's move obvious from anybody coming from a mainstream language.
  "a=\"test string\";b=a;c='a;console print_ 'a eval;console print_ 'b eval;console print_ 'c eval"
  "test stringtest stringa"

  # the three "console print_ 'x eval" above are equivalent to "console print_ x"
  "a=\"test string\";b=a;c='a;console print_ a;console print_ b;console print_ c"
  "test stringtest stringa"

  # ---------------------------------------------------------------------------
  "'a←5;a incrementInPlace;'a←a+1;console print_ a"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a incrementInPlace;a=a+1;console print_ a"
  "7"

  # ---------------------------------------------------------------------------
  # the powers and dangers of mutating numbers in place
  "a=1;b=a;console print_ a;console print_ b;a incrementInPlace;console print_ a;console print_ b"
  "1122"

  # ---------------------------------------------------------------------------
  # testing crazy statement separations

  "'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print_ a"
  "7"

  ";'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print_ a;"
  "7"

  ";;'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print_ a;;"
  "7"

  "; ;'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print_ a; ;"
  "7"

  ";;;'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print_ a;;;"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5;'a←a+1;console print_ a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a=a+1;console print_ a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5+1;console print_ a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5+1;console print_ a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(5+1);console print_ a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(5+1);console print_ a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "console print_ 4+1+1"
  "6"

  # ---------------------------------------------------------------------------
  "'a←(4+1+1);console print_ a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4+1+1);console print_ a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(4 +(1+1));console print_ a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4 +(1+1));console print_ a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←((4+1)+(0+1));console print_ a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=((4+1)+(0+1));console print_ a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "7 anotherPrint"
  "7"

  # ---------------------------------------------------------------------------
  "7 doublePrint"
  "77"

  # ---------------------------------------------------------------------------
  "console print_ console print_ 7"
  "77"

  # ---------------------------------------------------------------------------
  "console print_ 6 doublePrint+1"
  "667"

  # ---------------------------------------------------------------------------
  "6 doublePrint + console print_ 1"
  "661"

  # ---------------------------------------------------------------------------
  "console print_ 4+3"
  "7"

  # ---------------------------------------------------------------------------
  "console print_ console print_ 4+3"
  "77"

  # ---------------------------------------------------------------------------
  "console print_ (4 +(2+1))"
  "7"

  # ---------------------------------------------------------------------------
  "4 + console print_ 2+1"
  "3"

  # ---------------------------------------------------------------------------
  "4+2+ console print_ 1"
  "1"

  # ---------------------------------------------------------------------------
  "console print_ ('(1+1))"
  "( 1 + 1 )"

  # ---------------------------------------------------------------------------
  # the ' still ties to the first element
  # that comes after it i.e. ( 1+1 )
  "console print_ '(1+1)"
  "( 1 + 1 )"

  # ---------------------------------------------------------------------------
  "console print_ ('(1+1))length"
  "3"

  # ---------------------------------------------------------------------------
  "console print_ '(1+1)length"
  "3"

  # ---------------------------------------------------------------------------
  "console print_ (('(1+1))eval)"
  "2"

  # ---------------------------------------------------------------------------
  "console print_ ('(1+1))eval"
  "2"

  # ---------------------------------------------------------------------------
  "console print_ '(1+1)eval"
  "2"

  # ---------------------------------------------------------------------------
  "'a←5;'b←'a;console print_ b;console print_ a"
  "a5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;b='a;console print_ b;console print_ a"
  "a5"

  # ---------------------------------------------------------------------------
  "console print_ true negate"
  "false"

  # ---------------------------------------------------------------------------
  # note how the first not understood
  # prevents any further statement to be
  # executed
  "1 negate; console print_ 2"
  "! message was not understood: ( negate )"

  # ---------------------------------------------------------------------------
  """
  2 1 postfixPrint
  """
  "! message was not understood: ( 1 postfixPrint )"

  # ---------------------------------------------------------------------------
  "console print_ negate"
  "nil"

  # ---------------------------------------------------------------------------
  "console print_ negate; negate = 2; console print_ negate; negate = nil; console print_ negate; negate +"
  "nil2nil! exception: message to nil: +"

  # ---------------------------------------------------------------------------
  # this is what happens here: "a" is sent the message "b".
  # "a" doesn't know what to do with it, so it returns itself
  # and "b" remains unconsumed.
  # So the assignment will assign "a" to a, then it will mandate
  # a new receiver. The new receiver will be "b. console print_ a" (the
  # semicolon separating the statements
  # comes from the linearisation), which was still
  # there to be consumed. "b." will just return itself and do nothing,
  # so then "console print_ a" will be run, which results in "a"
  """
  a = "a" "b"
  console print_ a
  """
  """
  a
  """

  # ---------------------------------------------------------------------------
  "nonExistingObject"
  ""

  # ---------------------------------------------------------------------------
  "1 == 1 negate; console print_ 2"
  "2"

  # ---------------------------------------------------------------------------
  "console print_ false and false"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ false and true"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ true and false"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ true and true"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ false or false"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ false or true"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ true or false"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ true or true"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ not true"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ not(not true)"
  "true"

  "console print_ not not true"
  "true"

  "console print_ (not not true)"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ (not not not true)"
  "false"

  "console print_ not not not true"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ (not not not not true)"
  "true"

  "console print_ not not not not true"
  "true"

  # ---------------------------------------------------------------------------
  "true⇒(console print_ 1)"
  "1"

  # Boolean's "⇒" message cannot evaluate
  # its argument automatically (because if it's
  # false obviously it can't evaluate it), so this means
  # it must pick the true branch literally, which means it
  # must be in parens. Here "console" is picked, then the
  # "remaing part" of the message is considered to be the
  # false brench and is hence discarded.
  "true⇒console print_ 1"
  ""

  # ---------------------------------------------------------------------------
  "false⇒(console print_ 1)console print_ 2"
  "2"

  # ---------------------------------------------------------------------------
  "console print_ (0==0)"
  "true"

  "console print_ 0==0"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ (1==0)"
  "false"

  "console print_ 1==0"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ (0 amIZero)"
  "true"

  "console print_ 0 amIZero"
  "true"

  # ---------------------------------------------------------------------------
  "console print_ (1 amIZero)"
  "false"

  "console print_ 1 amIZero"
  "false"

  # ---------------------------------------------------------------------------
  "console print_ (8 minus 1)"
  "7"

  "console print_ 8 minus 1"
  "7"

  # ---------------------------------------------------------------------------
  # can't remove those parens!
  "true⇒(console print_ 1)console print_ 2"
  "1"

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍console print_ "yes a is 5"
  """
  "yes a is 5"

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍console print_ "yes a is 5"
  console print_ ". the end."
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍console print_ "yes a is 5"
  else:
  ﹍console print_ "no a is not 5"
  console print_ ". the end."
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if a==5:
  ﹍console print_ "yes a is 5"
  else:
  ﹍console print_ "no a is not 5"
  console print_ ". the end."
  """
  "no a is not 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if a==5:
  ﹍console print_ "yes a is 5"
  console print_ "the end."
  """
  "the end."

  # ---------------------------------------------------------------------------
  "console print_ 0 factorial"
  "1"

  # ---------------------------------------------------------------------------
  "console print_ 1 factorial"
  "1"

  # ---------------------------------------------------------------------------
  "console print_ 2 factorial"
  "2"

  # ---------------------------------------------------------------------------
  "console print_ 7 factorial"
  "5040"

  # ---------------------------------------------------------------------------
  "console print_ 0 factorialtwo"
  "1"

  # ---------------------------------------------------------------------------
  "console print_ 1 factorialtwo"
  "1"

  # ---------------------------------------------------------------------------
  "console print_ 2 factorialtwo"
  "2"

  # ---------------------------------------------------------------------------
  "console print_ 7 factorialtwo"
  "5040"

  # ---------------------------------------------------------------------------
  "console print_ 7 factorialthree"
  "76543215040"

  # ---------------------------------------------------------------------------
  "console print_ 7 factorialfour"
  "5040"

  # ---------------------------------------------------------------------------
  "console print_ 7 factorialfive"
  "5040"

  # ---------------------------------------------------------------------------
  "console print_ 7 selftimesminusone"
  "42"

  # ---------------------------------------------------------------------------
  "'a←5;1 printAFromDeeperCall"
  "5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;1 printAFromDeeperCall"
  "5"

  # ---------------------------------------------------------------------------
  "'a←5;repeat1((a==0)⇒(done)'a←a minus 1);console print_ a"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done)a=a minus 1);console print_ a"
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  
  console print_ a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  
  console print_ a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  ;console print_ a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  ;console print_ a
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  'a←5

  repeat forever:
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  console print_ a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5

  repeat forever:
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  console print_ a
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
  console print_ a
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
  console print_ a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat 2:
  ﹍a=a minus 1
  if a==3:
  ﹍console print_ "yes a is 3"
  """
  "yes a is 3"

  # ---------------------------------------------------------------------------
  """
  a=5
  console print_ a
  console print_ b
  repeat 2:
  ﹍a=a minus 1
  ﹍b = 0
  ﹍c = 0
  console print_ a
  console print_ b
  console print_ c
  """
  "5nil300"


  # ---------------------------------------------------------------------------
  "'a←5;console print_ repeat1((a==0)⇒(done)'a←a minus 1)"
  "Done_object"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;console print_ repeat1((a==0)⇒(done)a=a minus 1)"
  "Done_object"

  # ---------------------------------------------------------------------------
  # "done" stop the execution from within a loop,
  # nothing is executed after them
  "'a←5;repeat1((a==0)⇒(done; console print_ 2)'a←a minus 1);console print_ a"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done; console print_ 2)a=a minus 1);console print_ a"
  "0"

  # ---------------------------------------------------------------------------
  "'a←5;console print_ repeat1\
    ((a==0)⇒(done with a+1)'a←a minus 1)"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;console print_ repeat1\
    ((a==0)⇒(done with a+1)a=a minus 1)"
  "1"

  # ---------------------------------------------------------------------------
  "console print_ Class"
  "Class_object"

  # ---------------------------------------------------------------------------
  "'something←3;console print_ something"
  "3"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "something=3;console print_ something"
  "3"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new"
  ""

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "MyClass=Class new"
  ""

  # ---------------------------------------------------------------------------

  "Number answer:(aaa(operandum))by:(console print_ operandum);1 aaa 1"
  "1"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;\
    MyClass answer:(printtwo)by'(console print_ self);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(console print_ self);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(console print_ @);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo
  by:
  ﹍console print_ self
  myObject = MyClass new
  myObject printtwo
  """
  "object_from_a_user_class"

  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo
  by:
  ﹍console print_ @
  myObject = MyClass new
  myObject printtwo
  """
  "object_from_a_user_class"

  # ---------------------------------------------------------------------------
  "'false←true;false⇒(console print_ 1)console print_ 2"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "false=true;false⇒(console print_ 1)console print_ 2"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;false⇒(console print_ 1)console print_ 2"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;false⇒(console print_ 1)console print_ 2"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;true⇒(console print_ 1)console print_ 2"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;true⇒(console print_ 1)console print_ 2"
  "2"

  # ---------------------------------------------------------------------------
  """
  "world" = "Dave"
  console print_ "Hello "
  console print_ "world"
  """
  "Hello Dave"

  # ---------------------------------------------------------------------------
  "'2←10;console print_ 2"
  "10"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "2=10;console print_ 2"
  "10"

  # ---------------------------------------------------------------------------
  "' & ← '; & a←8;console print_ a"
  "8"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "& = '; & a←8;console print_ a"
  "8"

  # ---------------------------------------------------------------------------
  "(4*2)times(console print_ 1)"
  "11111111"

  # ---------------------------------------------------------------------------
  "for k from(1)to(10):(console print_ k)"
  "12345678910"

  # ---------------------------------------------------------------------------

  "for k from 1 to 10 :(console print_ k)"
  "12345678910"

  # ---------------------------------------------------------------------------
  """
  for k from
  ﹍1
  to
  ﹍10
  :
  ﹍console print_ k
  console print_ "done"
  """
  "12345678910done"

  # ---------------------------------------------------------------------------
  """
  console print_ localTemp
  for k from
  ﹍1
  to
  ﹍1
  :
  ﹍localTemp = " - local temp"
  ﹍console print_ localTemp
  console print_ localTemp
  """
  "nil - local temp - local temp"

  # ---------------------------------------------------------------------------
  """
  for k from 1 to 1:
  ﹍localTemp = "local temp "
  ﹍console print_ localTemp
  console print_ localTemp
  """
  "local temp local temp "

  # ---------------------------------------------------------------------------
  # the for construct creates an open context, so it can read and
  # write variables from/into the 
  # the loop variable is created inside it so it's
  # keep sealed.

  """
  j = 1
  console print_ j
  console print_ k
  for k from 1 to 2:
  ﹍j = k
  ﹍console print_ j
  ﹍console print_ k
  ﹍l = k
  ﹍
  console print_ j
  console print_ k
  console print_ l
  """
  "1nil11222nil2"

  # ---------------------------------------------------------------------------
  "8 unintelligibleMessage"
  "! message was not understood: ( unintelligibleMessage )"

  # ---------------------------------------------------------------------------
  "' a ← 5 someUndefinedMessage"
  "! message was not understood: ( someUndefinedMessage )"


  # ---------------------------------------------------------------------------
  "console print_ \"hello world\""
  "hello world"

  # ---------------------------------------------------------------------------
  "console print_ ('(1)+2)"
  "( 1 2 )"

  # ---------------------------------------------------------------------------
  "console print_ ('(1)+(2+1))"
  "( 1 3 )"

  # ---------------------------------------------------------------------------
  "console print_ ('()+\"how to enclose something in a list\")"
  "( \"how to enclose something in a list\" )"

  # ---------------------------------------------------------------------------
  # note that the + evaluates
  # its argument, so the passed list
  # is evaluated. If you want to pass
  # a list you need to quote it, see
  # afterwards
  "console print_ ('(1)+(2))"
  "( 1 2 )"

  # ---------------------------------------------------------------------------
  "console print_ ('(1)+'(2))"
  "( 1 ( 2 ) )"

  # ---------------------------------------------------------------------------
  "console print_ ('((1))+2)"
  "( ( 1 ) 2 )"

  # ---------------------------------------------------------------------------
  "console print_ ('((1))+'(2))"
  "( ( 1 ) ( 2 ) )"

  # ---------------------------------------------------------------------------
  "'myList←List new;console print_ myList;'myList←myList+2;console print_ myList"
  "empty message( 2 )"

  # ---------------------------------------------------------------------------
  "'myString←String new;console print_ myString;\
    'myString←myString+\"Hello \";\
    'myString←myString+\"world\";\
    console print_ myString"
  "Hello world"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    MyClass answer:(printCounter)by:(console print_ self.counter);\
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
  ﹍﹍console print_ self.counter

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

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  MyClass = Class new
  MyClass.counter = nil

  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍@counter←2

  MyClass answer:
  ﹍﹍printCounter
  ﹍by:
  ﹍﹍console print_ @counter

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
    myObject setCounterToTwo;console print_ myObject's counter"
  "2"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    'myObject←MyClass new;\
    myObject setCounterToTwo;console print_ myObject.counter"
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
  console print_ myObject.counter
  """
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # dot notation here
  """
  MyClass = Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
  ﹍@counter = 2
  myObject = MyClass new
  myObject setCounterToTwo
  console print_ myObject.counter
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

  console print_ myObject.link.link.link.link
  """
  "the end"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍counter=2
  console print_ codeToBeRun
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  # you can assign arbitrary things to string tokens, even functions
  """
  "codeToBeRun" ='
  ﹍counter=2
  console print_ "codeToBeRun"
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  """
  my = 1
  little = "hello"
  array = false
  myLittleArray =' (my little array)
  console print_ myLittleArray
  console print_ myLittleArray[0]+1
  console print_ myLittleArray[1]
  if myLittleArray[2]:
  ﹍console print_ "true!"
  else:
  ﹍console print_ "false!"
  """
  "( 1 \"hello\" false )2hellofalse!"

  # ---------------------------------------------------------------------------

  # a token containing a list doesn't cause
  # the list to be run
  """
  myArray =' (console print_ 1)
  myArray
  """
  ""

  # classic "explicit" eval
  """
  myArray =' (console print_ 1)
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
  ﹍console print_ (op1+op2)
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
  console print_ myObject's counter
  myObject's counter = 3
  console print_ myObject's counter
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
  console print_ myObject.counter
  myObject.counter = 3
  console print_ myObject.counter
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
  console print_ myObject's counter
  in
  ﹍myObject
  do
  ﹍self's counter = 3
  console print_ myObject's counter
  console print_ myObject's counter+myObject's counter
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
  console print_ myObject.counter
  in
  ﹍myObject
  do
  ﹍self.counter = 3
  console print_ myObject.counter
  console print_ myObject.counter+myObject.counter
  """

  "236"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍@counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print_ myObject.counter
  in
  ﹍myObject
  do
  ﹍@counter = 3
  console print_ myObject.counter
  console print_ myObject.counter+myObject.counter
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
  ﹍console print_ argument
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
  ﹍console print_ argument
  myObject = MyClass new
  myObject.printtwo "hello"
  """
  "! exception: message to nil: TOKEN:hello"

  # ---------------------------------------------------------------------------
  # FLTO
  "to sayHello: (withName (name)) do: (console print_ \"Hello \";console print_ name); sayHello withName \"Dave\""
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # FLTO
  """
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍console print_ "Hello "; console print_ name
  sayHello withName "Dave"
  """
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # FLTO
  """
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍console print_ "Hello "
  ﹍﹍console print_ name
  sayHello withName "Dave"
  """
  "Hello Dave"


  # ---------------------------------------------------------------------------
  # FLTO

  "to sayHello2: ((name)) do: (console print_ \"HELLO \"; console print_ name); sayHello2 \"Dave\""
  "HELLO Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  to sayHello2:
  ﹍﹍(name)
  ﹍do:
  ﹍﹍console print_ "HELLO "
  ﹍﹍console print_ name
  sayHello2 "Dave"
  """
  "HELLO Dave"

  # ---------------------------------------------------------------------------
  "'( \"Hello \" \"Dave \" \"my \" \"dear \" \"friend\") each word do (console print_ word)"
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in '
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍console print_ word
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍console print_ word
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
  ﹍console print_ word
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print_ word
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print_ word
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print_ word
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
  ﹍console print_ word
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
  ﹍console print_ word
  myList =:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in
  ﹍myList
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"


  # ---------------------------------------------------------------------------
  # in this case "myList =..." causes an evaluation which ends up returning just
  # "Hello "
  """
  codeToBeRun ='
  ﹍console print_ word
  myList =
  ﹍("Hello " "Dave " "my " "dear " "friend")
  console print_ myList
  for each word in
  ﹍myList
  do:
  ﹍codeToBeRun eval
  """
  "Hello ! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  # in this case "myList" ends up being a wrapped list i.e. ((wrapped))
  # so, when the right-side is evaluated, it ends up being the normal
  # un-wrapped contents, so it all works out without the ' after the =
  """
  codeToBeRun ='
  ﹍console print_ word
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
  ﹍console print_ word
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
  console print_ acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in '
  ﹍1 2 3 4
  do:
  ﹍acc += number
  console print_ acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in:
  ﹍1 2 3 4
  do:
  ﹍acc += number
  console print_ acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print_ word
  myList = 9
  for each word in
  ﹍myList
  do:
  ﹍codeToBeRun
  """
  "! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\"; console print_ someException"
  "my custom error"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    try: ( console print_ 1; someException )\
    catch someException: ( console print_ \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; someException )\
    catch someException: ( console print_ \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; someException )\
    catch someOtherException: ( console print_ \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    try: ( console print_ 1; throw someException; console print_ 2 )\
    catch someException: ( console print_ \" caught the error I wanted\" )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  try:
  ﹍console print_ 1
  ﹍throw someException
  ﹍console print_ 2
  catch someException:
  ﹍console print_ " caught the error I wanted"
  console print_ ". the end."
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; throw someException; console print_ 2 )\
    catch someException: ( console print_ \" caught the error I wanted\" )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print_ 1
  ﹍throw someException
  ﹍console print_ 2
  catch someException:
  ﹍console print_ " caught the error I wanted"
  console print_ ". the end."
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; throw someException; console print_ 2 )\
    catch someOtherException: ( console print_ \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  # also note that the thrown exceptions is thrown right up to
  # the workspace, the ". the end." is not printed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print_ 1
  ﹍throw someException
  ﹍console print_ 2
  catch someOtherException:
  ﹍console print_ " caught the error I wanted"
  console print_ ". the end."  
  """
  "1! exception: my custom error"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; throw someOtherException; console print_ 2 )\
    catch someOtherException: ( console print_ \" caught the error the first time around\")\
    catch someException: ( console print_ \" caught the error the second time around\")"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print_ 1
  ﹍throw someOtherException
  ﹍console print_ 2
  catch someOtherException:
  ﹍console print_ " caught the error the first time around"
  catch someException:
  ﹍console print_ " caught the error the second time around"
  console print_ ". the end."
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; throw someException; console print_ 2 )\
    catch someOtherException: ( console print_ \" caught the error the first time around\")\
    catch someException: ( console print_ \" caught the error the second time around\")"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print_ 1
  ﹍throw someException
  ﹍console print_ 2
  catch someOtherException:
  ﹍console print_ " caught the error the first time around"
  catch someException:
  ﹍console print_ " caught the error the second time around"
  console print_ ". the end."
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 1
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; throw someOtherException; console print_ 2 )\
    catch someOtherException: ( console print_ \" caught the error the first time around\")\
    catch someException: ( console print_ \" caught the error the second time around\")\
    catch all: (console print_ \" catch all branch\")"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print_ 1
  ﹍throw someOtherException
  ﹍console print_ 2
  catch someOtherException:
  ﹍console print_ " caught the error the first time around"
  catch someException:
  ﹍console print_ " caught the error the second time around"
  catch all:
  ﹍console print_ " catch all branch"
  console print_ ". the end."
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 2
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print_ 1; throw someException; console print_ 2 )\
    catch someOtherException: ( console print_ \" caught the error the first time around\")\
    catch someException: ( console print_ \" caught the error the second time around\")\
    catch all: (console print_ \" catch all branch\")"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print_ 1
  ﹍throw someException
  ﹍console print_ 2
  catch someOtherException:
  ﹍console print_ " caught the error the first time around"
  catch someException:
  ﹍console print_ " caught the error the second time around"
  catch all:
  ﹍console print_ " catch all branch"
  console print_ ". the end."
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 3
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    'yetAnotherException ← Exception new initWith \"another custom error that is only caught by the catch all branch\";\
    try: ( console print_ 1; throw yetAnotherException; console print_ 2 )\
    catch someOtherException: ( console print_ \" caught the error the first time around\")\
    catch someException: ( console print_ \" caught the error the second time around\")\
    catch all: (console print_ \" catch all branch\")"
  "1 catch all branch"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  yetAnotherException = Exception new initWith "another custom error that is only caught by the catch all branch"
  try:
  ﹍console print_ 1
  ﹍throw yetAnotherException
  ﹍console print_ 2
  catch someOtherException:
  ﹍console print_ " caught the error the first time around"
  catch someException:
  ﹍console print_ " caught the error the second time around"
  catch all:
  ﹍console print_ " catch all branch"
  console print_ ". the end."
  """
  "1 catch all branch. the end."

  # ---------------------------------------------------------------------------
  """
  foo = 3
  things =' ()
  things = things+3
  things = things+"hello"
  console print_ things
  """
  "( 3 \"hello\" )"

  # ---------------------------------------------------------------------------
  """
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  console print_ myList[0]
  console print_ myList[1+1]
  """
  "Hello my "

  # ---------------------------------------------------------------------------
  """
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[1+1] = "oh "
  console print_ myList
  """
  "( \"Hello \" \"Dave \" \"oh \" \"dear \" \"friend\" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[numbers[1+1]] = "oh "
  console print_ myList
  """
  "( \"Hello \" \"Dave \" \"oh \" \"dear \" \"friend\" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  console print_ numbers[0]+numbers[1]
  """
  "12"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  console print_ myList[numbers[2]]
  """
  "( \"oh \" \"so \" )"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  myObject = MyClass new
  console print_ myObject.someField
  console print_ myObject.someOtherField
  myObject.someField =' (9 3 15 5 7)
  myObject.someField[1+1] = 1+1
  myObject.someOtherField =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  console print_ myObject.someOtherField[myObject.someField[1+1]]

  """
  "nilnil( \"oh \" \"so \" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  console print_ myList[numbers[1+1]][0+1]
  """
  "so "

  # ---------------------------------------------------------------------------
  """
  things =' (false true)
  console print_ things[0] or things[1]
  """
  "true"

  # ---------------------------------------------------------------------------
  """
  foo = 3
  things =' (foo bar 2)
  console print_ things[0]
  console print_ things[1]
  console print_ things[2]
  console print_ things
  """
  "3bar2( 3 bar 2 )"

  # ---------------------------------------------------------------------------
  """
  things1 =' (my little list)
  things2 = things1
  console print_ things1
  console print_ things2
  things1[0] = 'your
  things2[1] = 'big
  console print_ things1
  console print_ things2
  things1 = " no more a list "
  console print_ things1
  console print_ things2
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
  postfixPrint
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
  console print_ 1
  """
  "! message was not understood: ( console print_ 1 )"

  # careful! here is the ...3 postfixPrint that ends up
  # running!
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
  postfixPrint
  """
  "3"

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
  console print_ 1
  """
  "1"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print_ "hey I'm new!"
  ﹍self
  myObject = MyClass new
  console print_ " ...done!"
  """
  "hey I'm new! ...done!"

  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print_ "hey I'm new!"
  ﹍@
  myObject = MyClass new
  console print_ " ...done!"
  """
  "hey I'm new! ...done!"

  # ---------------------------------------------------------------------------
  # in this case the assignment
  # consumes up to
  #    myObject = MyClass new
  # and then it breaks the chain
  # and lets "console print_ 1" loose
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍2
  ﹍self
  myObject = MyClass new console print_ 1
  """
  "1"

  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍2
  ﹍@
  myObject = MyClass new console print_ 1
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
  console print_ myObject
  """
  "2"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print_ "hey I'm new!"
  ﹍self
  MyClass answer:
  ﹍initWith (param)
  by:
  ﹍console print_ param
  ﹍self
  myObject = MyClass new initWith " hello again! I am... "
  console print_ myObject
  """
  "hey I'm new! hello again! I am... object_from_a_user_class"

  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print_ "hey I'm new!"
  ﹍@
  MyClass answer:
  ﹍initWith (param)
  by:
  ﹍console print_ param
  ﹍@
  myObject = MyClass new initWith " hello again! I am... "
  console print_ myObject
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
  console print_ myObject
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
  ﹍﹍console print_ argument
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
  ﹍﹍﹍﹍console print_ argument
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
  ﹍﹍﹍﹍console print_ argument
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
  ﹍﹍﹍﹍﹍﹍﹍﹍﹍console print_ argument
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
  ﹍﹍﹍﹍console print_ argument
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
  ﹍﹍﹍﹍console print_ argument
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
  console print_ a
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
  console print_ a
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print_ word
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
  console print_ myObject.someField
  myObject.someField = 2
  console print_ myObject.someField
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
  # the result of "+ 1" invocation.
  """
  Counter = Class new
  Counter.counter = 0

  Counter answer:
  ﹍﹍increment
  ﹍by:
  ﹍﹍self.counter = self.counter+1

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

  console print_ MyClass getCount

  myObject = MyClass new
  console print_ MyClass getCount
  console print_ myObject getCount

  myObject2 = MyClass new
  console print_ MyClass getCount
  console print_ myObject getCount
  console print_ myObject2 getCount

  """
  "011222"

  """
  Counter = Class new
  Counter.counter = 0

  Counter answer:
  ﹍﹍increment
  ﹍by:
  ﹍﹍@counter = @counter+1

  MyClass = Class new
  MyClass.instantiationsCounter = Counter new

  MyClass answer:
  ﹍whenNew
  by:
  ﹍@instantiationsCounter increment
  ﹍@

  MyClass answer:
  ﹍getCount
  by:
  ﹍@instantiationsCounter.counter

  console print_ MyClass getCount

  myObject = MyClass new
  console print_ MyClass getCount
  console print_ myObject getCount

  myObject2 = MyClass new
  console print_ MyClass getCount
  console print_ myObject getCount
  console print_ myObject2 getCount

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
  ﹍﹍self.counter = self.counter+1

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

  console print_ MyClass getCount
  console print_ myObject getCount

  myObject2 = MyClass new
  console print_ MyClass getCount
  console print_ myObject getCount
  console print_ myObject2 getCount

  myObject2.fieldAddedToObject2 = 2

  console print_ MyClass.fieldAddedToObject2
  console print_ myObject.fieldAddedToObject2
  console print_ myObject2.fieldAddedToObject2

  MyClass.fieldAddedToClass = 3
  console print_ MyClass.fieldAddedToClass
  console print_ myObject.fieldAddedToClass
  console print_ myObject2.fieldAddedToClass

  myObject.fieldAddedToClass = 4
  console print_ MyClass.fieldAddedToClass
  console print_ myObject.fieldAddedToClass
  console print_ myObject2.fieldAddedToClass

  myObject2.fieldAddedToClass = 5
  console print_ MyClass.fieldAddedToClass
  console print_ myObject.fieldAddedToClass
  console print_ myObject2.fieldAddedToClass


  """
  "00111nilnil2333343345"

  """
  Counter = Class new
  Counter.counter = 0

  Counter answer:
  ﹍﹍increment
  ﹍by:
  ﹍﹍@counter++

  MyClass = Class new

  myObject = MyClass new

  MyClass.instantiationsCounter = Counter new

  MyClass answer:
  ﹍whenNew
  by:
  ﹍@instantiationsCounter increment
  ﹍@

  MyClass answer:
  ﹍getCount
  by:
  ﹍@instantiationsCounter.counter

  console print_ MyClass getCount
  console print_ myObject getCount

  myObject2 = MyClass new
  console print_ MyClass getCount
  console print_ myObject getCount
  console print_ myObject2 getCount

  myObject2.fieldAddedToObject2 = 2

  console print_ MyClass.fieldAddedToObject2
  console print_ myObject.fieldAddedToObject2
  console print_ myObject2.fieldAddedToObject2

  MyClass.fieldAddedToClass = 3
  console print_ MyClass.fieldAddedToClass
  console print_ myObject.fieldAddedToClass
  console print_ myObject2.fieldAddedToClass

  myObject.fieldAddedToClass = 4
  console print_ MyClass.fieldAddedToClass
  console print_ myObject.fieldAddedToClass
  console print_ myObject2.fieldAddedToClass

  myObject2.fieldAddedToClass = 5
  console print_ MyClass.fieldAddedToClass
  console print_ myObject.fieldAddedToClass
  console print_ myObject2.fieldAddedToClass


  """
  "00111nilnil2333343345"

  # ---------------------------------------------------------------------------
  # compound assignments operators
  # ---------------------------------------------------------------------------

  """
  a = 1
  a += a
  console print_ a
  """
  "2"

  """
  a = 1
  b = 2
  a += b
  console print_ a
  """
  "3"

  """
  a = 1
  b = 2
  a += b+1
  console print_ a
  """
  "4"

  # trick question
  """
  a = 1
  b = 2
  a += console print_ b
  """
  "2"

  """
  a = 1
  b = 2
  console print_ a += b
  """
  "3"



  # ---------------------------------------------------------------------------
  # increment/decrement operators
  # ---------------------------------------------------------------------------

  """
  a = 1
  a++
  console print_ a
  """
  "2"

  """
  a = 1
  a++ + 1
  console print_ a
  """
  "2"

  """
  a = 1
  a = a++ + 1
  console print_ a
  """
  "3"

  """
  a = 1
  console print_ a++
  """
  "2"

  """
  a = 1
  a++ ++
  console print_ a
  """
  "2"

  """
  a = 1
  console print_ a++ ++
  """
  "3"


  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField += 2
  console print_ myObject.someField
  """
  "4"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  console print_ myObject.someField += 2
  """
  "4"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField++
  console print_ myObject.someField
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  console print_ myObject.someField++
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  console print_ myObject.someField++ ++
  console print_ myObject.someField
  """
  "43"

  """
  myArray = '(1 2 3)
  myArray[0]++
  console print_ myArray
  """
  "( 2 2 3 )"

  """
  myArray = '(1 2 3)
  console print_ myArray[0]++ ++
  console print_ myArray
  """
  "3( 2 2 3 )"

  """
  myArray = '(1 2 3)
  console print_ myArray[0] += myArray[1]+myArray[2]
  console print_ myArray
  """
  "6( 6 2 3 )"

  """
  myArray = '(1 2 3)
  console print_ myArray[0]++
  """
  "2"

  """
  myArray = '(1 2 3)
  console print_ myArray[0]++ ++
  console print_ myArray[0]
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

  console print_ MyClass.count // 0
  console print_ myObject.count // 0
  console print_ myObject2.count // 0

  MyClass.count++

  console print_ MyClass.count // 1
  console print_ myObject.count // 1
  console print_ myObject2.count // 1

  myObject.count++

  console print_ MyClass.count // 1
  console print_ myObject.count // 2
  console print_ myObject2.count // 1

  myObject2.count++
  myObject2.count++

  console print_ MyClass.count // 1
  console print_ myObject.count // 2
  console print_ myObject2.count // 3

  MyClass.count++

  console print_ MyClass.count // 2
  console print_ myObject.count // 2
  console print_ myObject2.count // 3

  """
  "000111121123223"

  # ---------------------------------------------------------------------------
  # running with empty signature (which unfortunately is not really empty)
  # FLTO

  "to sayHello: (*nothing*) do: (console print_ \"Hello\"); sayHello;"
  "Hello"

  # ---------------------------------------------------------------------------
  #    emojis!
  # ---------------------------------------------------------------------------
  "😁 = 4; console print_ 😁"
  "4"

  # ---------------------------------------------------------------------------
  "😁 =4;console print_ 😁"
  "4"

  # ---------------------------------------------------------------------------
  "😁=4;console print_ 😁"
  "4"

  # ---------------------------------------------------------------------------
  # here "print_😁" is a single token, so there is no print happening
  "😁=4;console print_😁"
  "! message was not understood: ( print_😁 )"

  # ---------------------------------------------------------------------------
  # FLTO
  """
  to 🚀:
  ﹍*nothing*
  do:
  ﹍console print_ "launch!"
  🚀
  """
  "launch!"

  """
  to 🚀:
  ﹍console print_ "launch!"
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
  ﹍console print_ "launch!"
  "🚀"
  """
  "launch!"

 """
  to "🚀":
  ﹍console print_ "launch!"
  "🚀"
  """
  "launch!"


]

# ---------------------------------------------------------------------------
# TODO this crashes
#"to sayHello '(*nothing*) do '(console print_ \"Hello\"); sayHello;"
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
things[1+1] print
things =' (foo ('foo) 2)
things[1+1] print
"""
"3( ' foo )foo3 bar bar2210"

# ---------------------------------------------------------------------------
"""
foo = 3
things =' ()
things = things+foo
console print_ things
things[0] print
" // " print
things =' ()
things = things+'foo
console print_ things
things[0] print
" // " print
things =' ()
things = things+'('foo)
console print_ things
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
      "Number", FLNumber
      "Console", FLConsole

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

      "console", FLConsole.createNew()

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
