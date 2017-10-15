tests = [

  # ---------------------------------------------------------------------------
  "console print \"start of tests\""
  "start of tests"

  # ---------------------------------------------------------------------------
  "pause 2"
  ""

  # ---------------------------------------------------------------------------
  # surprise! this language "chains" to the right
  # so "streams" of things are run right to left. 
  "console print 2 * 3 + 1"
  "8"

  # ---------------------------------------------------------------------------
  # another surprise! For the same reason as above,
  # this gives a different result from C, where the
  # "-"" is left - associative
  "console print 8 - 3 - 2"
  "7"

  # ---------------------------------------------------------------------------
  "console print (2 * 3) + 1"
  "7"

  # ---------------------------------------------------------------------------
  "console print (1.2 * 3.4) + 5.6"
  "9.68"

  # ---------------------------------------------------------------------------

  "console print 1+1;Number answer:(+(operandum))by:(console print self;console print \"+\";console print operandum);2+3;Number answer:(+(operandum))by:(self $plus_binary_default operandum);"
  "22+3"

  """
  console print 1+1
  Number answer:
  ﹍﹍+ (operandum)
  ﹍by:
  ﹍﹍console print self
  ﹍﹍console print \"+\"
  ﹍﹍console print operandum
  2+3

  Number answer:
  ﹍﹍+ (operandum)
  ﹍by:
  ﹍﹍self $plus_binary_default operandum
  """
  "22+3"

  # ---------------------------------------------------------------------------
  # here "print" takes "print" and does
  # nothing with it, so first (1+1) is
  # printed, and then the result of that is
  # printed again.
  "console print(console print 1+1)"
  "22"

  # ---------------------------------------------------------------------------
  # there are two ways to assign things, this is
  # the most technically thorough but it's
  # more difficult to decypher.
  #
  # The semicolon separates stataments.
  "'a ← \"test string\"; 'b ← a; 'c ← 'a; console print 'a eval;console print 'b eval;console print 'c eval"
  "test stringtest stringa"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # the equal sign is less technically thorough but
  # it's move obvious from anybody coming from a mainstream language.
  "a=\"test string\";b=a;c='a;console print 'a eval;console print 'b eval;console print 'c eval"
  "test stringtest stringa"

  # the three "console print 'x eval" above are equivalent to "console print x"
  "a=\"test string\";b=a;c='a;console print a;console print b;console print c"
  "test stringtest stringa"

  # ---------------------------------------------------------------------------
  "'a←5;a incrementInPlace;'a←a+1;console print a"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a incrementInPlace;a=a+1;console print a"
  "7"

  # ---------------------------------------------------------------------------
  # the powers and dangers of mutating numbers in place
  "a=1;b=a;console print a;console print b;a incrementInPlace;console print a;console print b"
  "1122"

  # ---------------------------------------------------------------------------
  # testing crazy statement separations

  "'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print a"
  "7"

  ";'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print a;"
  "7"

  ";;'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print a;;"
  "7"

  "; ;'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print a; ;"
  "7"

  ";;;'a←5;;a incrementInPlace; ;;;  ;'a←a+1;console print a;;;"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5;'a←a+1;console print a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;a=a+1;console print a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←5+1;console print a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5+1;console print a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(5+1);console print a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(5+1);console print a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "console print 4+1+1"
  "6"

  # ---------------------------------------------------------------------------
  "'a←(4+1+1);console print a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4+1+1);console print a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←(4 +(1+1));console print a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=(4 +(1+1));console print a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "'a←((4+1)+(0+1));console print a incrementInPlace"
  "7"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=((4+1)+(0+1));console print a incrementInPlace"
  "7"

  # ---------------------------------------------------------------------------
  "7 anotherPrint"
  "7"

  # ---------------------------------------------------------------------------
  "7 doublePrint"
  "77"

  # ---------------------------------------------------------------------------
  "console print console print 7"
  "77"

  # ---------------------------------------------------------------------------
  "console print 6 doublePrint+1"
  "667"

  # ---------------------------------------------------------------------------
  "6 doublePrint + console print 1"
  "661"

  # ---------------------------------------------------------------------------
  "console print 4+3"
  "7"

  # ---------------------------------------------------------------------------
  "console print console print 4+3"
  "77"

  # ---------------------------------------------------------------------------
  "console print (4 +(2+1))"
  "7"

  # ---------------------------------------------------------------------------
  "4 + console print 2+1"
  "3"

  # ---------------------------------------------------------------------------
  "4+2+ console print 1"
  "1"

  # ---------------------------------------------------------------------------
  "console print ('(1+1))"
  "( 1 + 1 )"

  # ---------------------------------------------------------------------------
  # the ' still ties to the first element
  # that comes after it i.e. ( 1+1 )
  "console print '(1+1)"
  "( 1 + 1 )"

  # ---------------------------------------------------------------------------
  "console print ('(1+1))length"
  "3"

  # ---------------------------------------------------------------------------
  "console print '(1+1)length"
  "3"

  # ---------------------------------------------------------------------------
  "console print (('(1+1))eval)"
  "2"

  # ---------------------------------------------------------------------------
  "console print ('(1+1))eval"
  "2"

  # ---------------------------------------------------------------------------
  "console print '(1+1)eval"
  "2"

  # ---------------------------------------------------------------------------
  # here is why we need eval to run a list,
  # and we can't just drop the list without eval
  # and hope that the "empty message" causes
  # it to run: because we want these two
  # statements to work the same.
  # Another way of saying it is that if a list
  # could run on its own without eval,
  # any *quoted* list would run on its own too!
  # *even if it's quoted*!
  """
  codeToBeRun = '(console print 1+2)
  console print codeToBeRun
  console print " - "
  console print '(console print 1+2)
  """
  "( [object of class \"Console\"] print 1 + 2 ) - ( [object of class \"Console\"] print 1 + 2 )"

  # ---------------------------------------------------------------------------
  "'a←5;'b←'a;console print b;console print a"
  "a5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;b='a;console print b;console print a"
  "a5"

  # ---------------------------------------------------------------------------
  "console print true negate"
  "false"

  # ---------------------------------------------------------------------------
  # note how the first not understood
  # prevents any further statement to be
  # executed
  "1 negate; console print 2"
  "! exception: message was not understood: ( negate )"

  # ---------------------------------------------------------------------------
  """
  2 1 postfixPrint
  """
  "! exception: message was not understood: ( 1 postfixPrint )"

  # ---------------------------------------------------------------------------
  "console print negate"
  "nil"

  # ---------------------------------------------------------------------------
  "console print negate; negate = 2; console print negate; negate = nil; console print negate; negate +"
  "nil2nil! exception: message was not understood: ( + )"

  # ---------------------------------------------------------------------------
  """
  a = "a" "b"
  console print a
  """
  """
  ! exception: message was not understood: ( TOKEN:b )
  """

  # ---------------------------------------------------------------------------
  "nonExistingObject"
  ""

  # ---------------------------------------------------------------------------
  "2 nonExistingMessage"
  "! exception: message was not understood: ( nonExistingMessage )"

  # ---------------------------------------------------------------------------
  "1 == 1 negate; console print 2"
  "2"

  # ---------------------------------------------------------------------------
  "console print false and false"
  "false"

  # ---------------------------------------------------------------------------
  "console print false and true"
  "false"

  # ---------------------------------------------------------------------------
  "console print true and false"
  "false"

  # ---------------------------------------------------------------------------
  "console print true and true"
  "true"

  # ---------------------------------------------------------------------------
  "console print false or false"
  "false"

  # ---------------------------------------------------------------------------
  "console print false or true"
  "true"

  # ---------------------------------------------------------------------------
  "console print true or false"
  "true"

  # ---------------------------------------------------------------------------
  "console print true or true"
  "true"

  # ---------------------------------------------------------------------------
  "console print not true"
  "false"

  # ---------------------------------------------------------------------------
  "console print not(not true)"
  "true"

  "console print not not true"
  "true"

  "console print (not not true)"
  "true"

  # ---------------------------------------------------------------------------
  "console print (not not not true)"
  "false"

  "console print not not not true"
  "false"

  # ---------------------------------------------------------------------------
  "console print (not not not not true)"
  "true"

  "console print not not not not true"
  "true"

  # ---------------------------------------------------------------------------
  "if true: (console print 1)"
  "1"

  # ---------------------------------------------------------------------------
  "if false: (console print 1) else: (console print 2)"
  "2"

  # ---------------------------------------------------------------------------
  "console print (0==0)"
  "true"

  "console print 0==0"
  "true"

  # ---------------------------------------------------------------------------
  "console print (1==0)"
  "false"

  "console print 1==0"
  "false"

  # ---------------------------------------------------------------------------
  "console print (0 amIZero)"
  "true"

  "console print 0 amIZero"
  "true"

  # ---------------------------------------------------------------------------
  "console print (1 amIZero)"
  "false"

  "console print 1 amIZero"
  "false"

  # ---------------------------------------------------------------------------
  "console print (8 - 1)"
  "7"

  "console print 8 - 1"
  "7"

  # ---------------------------------------------------------------------------
  # can't remove those parens!
  "if true: (console print 1) else: (console print 2)"
  "1"

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍console print "yes a is 5"
  """
  "yes a is 5"

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍console print "yes a is 5"
  console print ". the end."
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=5

  if a==5:
  ﹍console print "yes a is 5"
  else:
  ﹍console print "no a is not 5"
  console print ". the end."
  """
  "yes a is 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if a==5:
  ﹍console print "yes a is 5"
  else:
  ﹍console print "no a is not 5"
  console print ". the end."
  """
  "no a is not 5. the end."

  # ---------------------------------------------------------------------------
  """
  a=0

  if a==5:
  ﹍console print "yes a is 5"
  console print "the end."
  """
  "the end."

  # ---------------------------------------------------------------------------
  # if as expression
  """
  a = 0
  a += if true:
  ﹍﹍1
  ﹍else:
  ﹍﹍2
  console print a
  """
  "1"

  """
  a = 0
  a +=
  ﹍if true:
  ﹍﹍1
  ﹍else:
  ﹍﹍2
  console print a
  """
  "1"

  """
  a = 0
  a += if false:
  ﹍﹍1
  ﹍else:
  ﹍﹍2
  console print a
  """
  "2"

  """
  a = 0
  a +=
  ﹍if false:
  ﹍﹍1
  ﹍else:
  ﹍﹍2
  console print a
  """
  "2"

  # ---------------------------------------------------------------------------
  # more "if" as expression

  """
  to ifAsExpession:
  ﹍if true:
  ﹍﹍1

  console print ifAsExpession
  """
  "1"

  """
  to ifAsExpession:
  ﹍if false:
  ﹍﹍1

  console print ifAsExpession
  """
  "nil"

  """
  to ifAsExpession:
  ﹍if false:
  ﹍﹍1
  ﹍2

  console print ifAsExpession
  """
  "2"


  # ---------------------------------------------------------------------------
  "console print 0 factorialsix"
  "1"

  # ---------------------------------------------------------------------------
  "console print 1 factorialsix"
  "1"

  # ---------------------------------------------------------------------------
  "console print 2 factorialsix"
  "2"

  # ---------------------------------------------------------------------------
  "console print 7 factorialsix"
  "5040"

  # ---------------------------------------------------------------------------
  "console print 0 factorialtwo"
  "1"

  # ---------------------------------------------------------------------------
  "console print 1 factorialtwo"
  "1"

  # ---------------------------------------------------------------------------
  "console print 2 factorialtwo"
  "2"

  # ---------------------------------------------------------------------------
  "console print 7 factorialtwo"
  "5040"

  # ---------------------------------------------------------------------------
  "console print 7 factorialthree"
  "76543215040"

  # ---------------------------------------------------------------------------
  "console print 7 factorialfour"
  "5040"

  # ---------------------------------------------------------------------------
  "console print 7 factorialfive"
  "5040"

  # ---------------------------------------------------------------------------
  "console print 7 selftimesminusone"
  "42"

  # ---------------------------------------------------------------------------
  "'a←5;1 printAFromDeeperCall"
  "5"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;1 printAFromDeeperCall"
  "5"

  # ---------------------------------------------------------------------------
  "'a←5;repeat1(if a==0: (done) else: ('a←a - 1));console print a"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1(if a==0: (done) else: (a=a - 1));console print a"
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍'a←a - 1
  
  console print a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a - 1
  
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍'a←a - 1
  ;console print a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a - 1
  ;console print a
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  'a←5

  repeat forever:
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍'a←a - 1
  console print a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a - 1
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a - 1
  console print a
  """
  "0"

  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍break
  ﹍else:
  ﹍﹍a=a - 1
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  # nested loops with breaks

  """
  j=5
  counter = 0

  repeat forever:
  ﹍k=5
  ﹍console print " o/j: " + j
  ﹍console print " o/k: " + k
  ﹍if j==0:
  ﹍﹍break
  ﹍else:
  ﹍﹍j=j - 1
  ﹍﹍repeat forever:
  ﹍﹍﹍console print " i/j: " + j
  ﹍﹍﹍console print " i/k: " + k
  ﹍﹍﹍if k==0:
  ﹍﹍﹍﹍break
  ﹍﹍﹍else:
  ﹍﹍﹍﹍k=k - 1
  ﹍﹍﹍﹍counter++
  ﹍﹍﹍﹍console print " count so far: " + counter

  console print " total count: " + counter
  """
  " o/j: 5 o/k: 5 \
  i/j: 4 i/k: 5 count so far: 1 \
  i/j: 4 i/k: 4 count so far: 2 \
  i/j: 4 i/k: 3 count so far: 3 \
  i/j: 4 i/k: 2 count so far: 4 \
  i/j: 4 i/k: 1 count so far: 5 \
  i/j: 4 i/k: 0 \
  o/j: 4 o/k: 5 \
  i/j: 3 i/k: 5 count so far: 6 \
  i/j: 3 i/k: 4 count so far: 7 \
  i/j: 3 i/k: 3 count so far: 8 \
  i/j: 3 i/k: 2 count so far: 9 \
  i/j: 3 i/k: 1 count so far: 10 \
  i/j: 3 i/k: 0 \
  o/j: 3 o/k: 5 \
  i/j: 2 i/k: 5 count so far: 11 \
  i/j: 2 i/k: 4 count so far: 12 \
  i/j: 2 i/k: 3 count so far: 13 \
  i/j: 2 i/k: 2 count so far: 14 \
  i/j: 2 i/k: 1 count so far: 15 \
  i/j: 2 i/k: 0 \
  o/j: 2 o/k: 5 \
  i/j: 1 i/k: 5 count so far: 16 \
  i/j: 1 i/k: 4 count so far: 17 \
  i/j: 1 i/k: 3 count so far: 18 \
  i/j: 1 i/k: 2 count so far: 19 \
  i/j: 1 i/k: 1 count so far: 20 \
  i/j: 1 i/k: 0 \
  o/j: 1 o/k: 5 \
  i/j: 0 i/k: 5 count so far: 21 \
  i/j: 0 i/k: 4 count so far: 22 \
  i/j: 0 i/k: 3 count so far: 23 \
  i/j: 0 i/k: 2 count so far: 24 \
  i/j: 0 i/k: 1 count so far: 25 \
  i/j: 0 i/k: 0 \
  o/j: 0 o/k: 5 \
  total count: 25"

  # ---------------------------------------------------------------------------
  # alternate formatting of the above, more C-like
  """
  a=5

  repeat (forever):
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a - 1
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat 2:
  ﹍a=a - 1
  if a==3:
  ﹍console print "yes a is 3"
  """
  "yes a is 3"

  # ---------------------------------------------------------------------------
  """
  a=5
  console print a
  console print b
  repeat 2:
  ﹍a=a - 1
  ﹍b = 0
  ﹍c = 0
  console print a
  console print b
  console print c
  """
  "5nil300"


  # ---------------------------------------------------------------------------
  "'a←5;console print repeat1(if a==0: (done) else: ('a←a - 1))"
  "[object of class \"Done\"]"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;console print repeat1(if a==0: (done) else: (a=a - 1))"
  "[object of class \"Done\"]"

  # ---------------------------------------------------------------------------
  # "done" stop the execution from within a loop,
  # nothing is executed after them
  "'a←5;repeat1(if a==0: (done; console print 2) else: ('a←a - 1));console print a"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1(if a==0: (done; console print 2) else: (a=a - 1));console print a"
  "0"

  # ---------------------------------------------------------------------------
  "'a←5;console print repeat1\
    (if a==0: (done with a+1) else: ('a←a - 1))"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;console print repeat1\
    (if a==0: (done with a+1) else: (a=a - 1))"
  "1"

  # ---------------------------------------------------------------------------
  "console print Class"
  "[class \"Class\" (an object of class Class)]"

  # ---------------------------------------------------------------------------
  "'something←3;console print something"
  "3"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "something=3;console print something"
  "3"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new"
  ""

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "MyClass=Class new"
  ""

  # ---------------------------------------------------------------------------

  "Number answer:(aaa(operandum))by:(console print operandum);1 aaa 1"
  "1"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(console print self);\
    'myObject←MyClass new;myObject printtwo"
  "[object of anonymous class]"

  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(console print @);\
    'myObject←MyClass new;myObject printtwo"
  "[object of anonymous class]"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍printtwo
  ﹍by:
  ﹍﹍console print self
  myObject = MyClass new
  myObject printtwo
  """
  "[object of class \"MyClass\"]"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍printtwo
  ﹍by:
  ﹍﹍console print @
  myObject = MyClass new
  myObject printtwo
  """
  "[object of class \"MyClass\"]"

  # ---------------------------------------------------------------------------
  "'false←true;if false: (console print 1) else: (console print 2)"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "false=true;if false: (console print 1) else: (console print 2)"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;if false: (console print 1) else: (console print 2)"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;if false: (console print 1) else: (console print 2)"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;if true: (console print 1) else: (console print 2)"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;if true: (console print 1) else: (console print 2)"
  "2"

  # ---------------------------------------------------------------------------
  """
  "world" = "Dave"
  console print "Hello "
  console print "world"
  """
  "Hello Dave"

  # ---------------------------------------------------------------------------
  "'2←10;console print 2"
  "10"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "2=10;console print 2"
  "10"

  # ---------------------------------------------------------------------------
  "3.14=\"pi\";console print 3.14"
  "pi"

  # ---------------------------------------------------------------------------
  "' & ← '; & a←8;console print a"
  "8"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "& = '; & a←8;console print a"
  "8"

  # ---------------------------------------------------------------------------
  "(4*2)times(console print 1)"
  "11111111"

  # ---------------------------------------------------------------------------
  "for k from(1)to(10):(console print k)"
  "12345678910"

  # ---------------------------------------------------------------------------

  "for k from 1 to 10 :(console print k)"
  "12345678910"

  # ---------------------------------------------------------------------------
  """
  for k from
  ﹍﹍﹍1
  ﹍to
  ﹍﹍﹍10
  ﹍﹍:
  ﹍﹍﹍console print k
  console print "done"
  """
  "12345678910done"

  # ---------------------------------------------------------------------------
  """
  console print localTemp
  for k from
  ﹍﹍﹍1
  ﹍to
  ﹍﹍﹍1
  ﹍﹍:
  ﹍﹍﹍localTemp = " - local temp"
  ﹍﹍﹍console print localTemp
  console print localTemp
  """
  "nil - local temp - local temp"

  # ---------------------------------------------------------------------------
  """
  for k from 1 to 1:
  ﹍localTemp = "local temp "
  ﹍console print localTemp
  console print localTemp
  """
  "local temp local temp "

  # ---------------------------------------------------------------------------
  # the for construct creates an open context, so it can read and
  # write variables from/into the 
  # the loop variable is created inside it so it's
  # keep sealed.

  """
  j = 1
  console print j
  console print k
  for k from 1 to 2:
  ﹍j = k
  ﹍console print j
  ﹍console print k
  ﹍l = k
  ﹍
  console print j
  console print k
  console print l
  """
  "1nil11222nil2"

  """
  j = 1
  console print j
  console print k
  for k from 1 to 2:
  ﹍j = k
  ﹍console print j
  ﹍console print k
  ﹍l = k
  console print j
  console print k
  console print l
  """
  "1nil11222nil2"

  # ---------------------------------------------------------------------------
  "8 unintelligibleMessage"
  "! exception: message was not understood: ( unintelligibleMessage )"

  # ---------------------------------------------------------------------------
  "' a ← 5 someUndefinedMessage"
  "! exception: message was not understood: ( someUndefinedMessage )"


  # ---------------------------------------------------------------------------
  "console print \"hello world\""
  "hello world"

  # ---------------------------------------------------------------------------
  "console print ('(1)+2)"
  "( 1 2 )"

  # ---------------------------------------------------------------------------
  "console print ('(1)+(2+1))"
  "( 1 3 )"

  # ---------------------------------------------------------------------------
  "console print ('()+\"how to enclose something in a list\")"
  "( \"how to enclose something in a list\" )"

  # ---------------------------------------------------------------------------
  # note that the + evaluates
  # its argument, so the passed list
  # is evaluated. If you want to pass
  # a list you need to quote it, see
  # afterwards
  "console print ('(1)+(2))"
  "( 1 2 )"

  # ---------------------------------------------------------------------------
  "console print ('(1)+'(2))"
  "( 1 ( 2 ) )"

  # ---------------------------------------------------------------------------
  "console print ('((1))+2)"
  "( ( 1 ) 2 )"

  # ---------------------------------------------------------------------------
  "console print ('((1))+'(2))"
  "( ( 1 ) ( 2 ) )"

  # ---------------------------------------------------------------------------
  "'myList←List new;console print myList;'myList←myList+2;console print myList"
  "empty message( 2 )"

  # ---------------------------------------------------------------------------
  "'myString←String new;console print myString;\
    'myString←myString+\"Hello \";\
    'myString←myString+\"world\";\
    console print myString"
  "Hello world"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    MyClass answer:(printCounter)by:(console print self.counter);\
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
  ﹍﹍console print self.counter

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
  ﹍﹍console print @counter

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
    myObject setCounterToTwo;console print myObject's counter"
  "2"

  # ---------------------------------------------------------------------------
  "'MyClass←Class new;MyClass.counter = nil;\
    MyClass answer:(setCounterToTwo)by:(self.counter←2);\
    'myObject←MyClass new;\
    myObject setCounterToTwo;console print myObject.counter"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # dot notation here
  """
  MyClass = Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍self.counter = 2
  myObject = MyClass new
  myObject setCounterToTwo
  console print myObject.counter
  """
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  # dot notation here
  """
  MyClass = Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍@counter = 2
  myObject = MyClass new
  myObject setCounterToTwo
  console print myObject.counter
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

  console print myObject.link.link.link.link
  """
  "the end"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍counter=2
  console print codeToBeRun
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  # you can assign arbitrary things to string tokens, even functions
  """
  "codeToBeRun" ='
  ﹍counter=2
  console print "codeToBeRun"
  """
  "( counter = 2 )"

  # ---------------------------------------------------------------------------
  """
  my = 1
  little = "hello"
  array = false
  myLittleArray =' (my little array)
  console print myLittleArray
  console print myLittleArray[0]+1
  console print myLittleArray[1]
  if myLittleArray[2]:
  ﹍console print "true!"
  else:
  ﹍console print "false!"
  """
  "( 1 \"hello\" false )2hellofalse!"

  # ---------------------------------------------------------------------------

  # a token containing a list doesn't cause
  # the list to be run
  """
  myArray =' (console print 1)
  myArray
  """
  ""

  # classic "explicit" eval
  """
  myArray =' (console print 1)
  myArray eval
  """
  "1"

  # ---------------------------------------------------------------------------
  # Closures
  # There are two types of closures
  #
  # 1) A "read only" closure
  # which works with degining a code block as a list, and
  # then evalling it.
  # It comes from the fact that
  # code is just a list of tokens, and with the quote
  # assignment (or any quote for that matter)
  # its elements (excluding "self") are all evaluated,
  # hence the bound elements are copied in terms of their values, so
  # those can't be changed anymore.
  # The unassigned elements are kept as is and hence
  # they are free to be bound later.
  #
  # 2) A "proper" closure
  # this one works with "to" and "answer" and works
  # much more like a closure: one can read and write
  # variables that come from the context where the
  # closure was defined.

  """
  op1 = 2
  codeToBeRun ='
  ﹍console print (op1+op2)
  op2 = 3
  codeToBeRun eval
  op2 = 6
  codeToBeRun eval
  op1 = 1000
  codeToBeRun eval
  """
  "588"

  """
  op1 = 2
  codeToBeRun ='
  ﹍op1++
  ﹍console print op1
  codeToBeRun eval
  console print op1
  """
  "22"

  # "eval" opens up the current context
  # so both op1 and op2 get modified
  """
  op1 = 2
  codeToBeRun ='
  ﹍op1++
  ﹍op2 = 1
  ﹍console print op1
  ﹍console print op2
  codeToBeRun eval
  console print op1
  console print op2
  """
  "2121"

  """
  op1 = 2
  to codeToBeRun:
  ﹍op1++
  ﹍console print op1
  codeToBeRun
  console print op1
  """
  "33"

  """
  op1 = 2
  Number answer:
  ﹍﹍aClosure
  ﹍by:
  ﹍﹍op1++
  ﹍﹍console print op1
  0 aClosure
  console print op1
  """
  "33"


  """
  op1 = 2
  to codeToBeRun:
  ﹍op1++
  ﹍op2 = 1
  ﹍console print op1
  ﹍console print op2
  codeToBeRun
  console print op1
  console print op2
  """
  "313nil"

  """
  op1 = 2
  Number answer:
  ﹍﹍aClosure
  ﹍by:
  ﹍﹍op1++
  ﹍﹍op2 = 1
  ﹍﹍console print op1
  ﹍﹍console print op2
  0 aClosure
  console print op1
  console print op2
  """
  "313nil"



  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍self's counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject's counter
  myObject's counter = 3
  console print myObject's counter
  """

  "23"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍self.counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject.counter
  myObject.counter = 3
  console print myObject.counter
  """

  "23"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍self's counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject's counter
  in
  ﹍﹍myObject
  ﹍do
  ﹍﹍self's counter = 3
  console print myObject's counter
  console print myObject's counter+myObject's counter
  """

  "236"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍self.counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject.counter
  in
  ﹍﹍myObject
  ﹍do
  ﹍﹍self.counter = 3
  console print myObject.counter
  console print myObject.counter+myObject.counter
  """

  "236"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍@counter=2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍setCounterToTwo
  ﹍by:
  ﹍﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject.counter
  in
  ﹍﹍myObject
  ﹍do
  ﹍﹍@counter = 3
  console print myObject.counter
  console print myObject.counter+myObject.counter
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
  ﹍﹍printtwo (argument)
  ﹍by:
  ﹍﹍console print argument
  myObject = MyClass new
  myObject printtwo "hello"
  """
  "hello"

  # -.-.-.-.-.-.-.-.--.-             vs.             .--.-.-.--.-.-.-.-.-.-.-.-

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍printtwo (argument)
  ﹍by:
  ﹍﹍console print argument
  myObject = MyClass new
  myObject.printtwo "hello"
  """
  "! exception: message was not understood: ( TOKEN:hello )"

  # ---------------------------------------------------------------------------
  # FLTO
  "to sayHello: (withName (name)) do: (console print \"Hello \";console print name); sayHello withName \"Dave\""
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # FLTO
  """
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍console print "Hello "; console print name
  sayHello withName "Dave"
  """
  "Hello Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  # FLTO
  """
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍console print "Hello "
  ﹍﹍console print name
  sayHello withName "Dave"
  """
  "Hello Dave"

  # ---------------------------------------------------------------------------
  # FLTO

  "to sayHello2: ((name)) do: (console print \"HELLO \"; console print name); sayHello2 \"Dave\""
  "HELLO Dave"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  """
  to sayHello2:
  ﹍﹍(name)
  ﹍do:
  ﹍﹍console print "HELLO "
  ﹍﹍console print name
  sayHello2 "Dave"
  """
  "HELLO Dave"

  # ---------------------------------------------------------------------------
  # FLTO with no signature
  """
  to testingReturn:
  ﹍console print "start"
  """
  ""

  """
  to testingReturn:
  ﹍console print "start"
  testingReturn
  """
  "start"

  # ---------------------------------------------------------------------------
  # FLTO you can add multiple methods to a class/object
  # created with "to"
  """
  to anotherFunc:
  ﹍﹍withAParameter
  ﹍do:
  ﹍﹍console print "running with a param."

  anotherFunc withAParameter

  to anotherFunc:
  ﹍console print "running without params."

  anotherFunc
  anotherFunc withAParameter

  """
  "running with a param.running without params.running with a param."


  # ---------------------------------------------------------------------------
  # lists that get evaluated but cannot be evaluated fully
  # ---------------------------------------------------------------------------

  "a = (1 2 3)"
  "! exception: message was not understood: ( 2 3 )"

  "a = (\"hello\" \"world\")"
  "! exception: message was not understood: ( TOKEN:world )"

  """
  myList = ("Hello " "Dave " "my " "dear " "friend")
  1
  """
  "! exception: message was not understood: ( TOKEN:Dave  TOKEN:my  TOKEN:dear  TOKEN:friend )"

  # ---------------------------------------------------------------------------
  "'( \"Hello \" \"Dave \" \"my \" \"dear \" \"friend\") each word do (console print word)"
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  
  # this was working before I decided to eliminate
  # all empty lines, because it's difficult to make
  # them meaningful in this way, since they are completely
  # invisible. There is still a way to do something
  # analogous to this, see example
  # below.
  """
  for each word in:
  ﹍﹍
  ﹍do:
  ﹍﹍console print word
  console print "the end."
  """
  "! exception: message was not understood: ( each word in : ( do : ( console print word ) ) )"


  """
  for each word in: () do:
  ﹍console print word
  console print "the end."
  """
  "the end."

  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍﹍'(1 + 1)
  ﹍do:
  ﹍﹍console print word
  """
  "1+1"


  # ---------------------------------------------------------------------------
  # since here 1+1 gives us a result that is a number, we throw
  # an error. note that we could interpret it as a list, but it
  # would become very confusing to understand where to use
  # a list explicitly and when not.
  """
  for each word in:
  ﹍﹍1 + 1
  ﹍do:
  ﹍﹍console print word
  """
  "! exception: for...each expects a list"


  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍﹍("Hello " "Dave " "my " "dear " "friend")
  ﹍do:
  ﹍﹍console print word
  """
  "Hello Dave my dear friend"


  # ---------------------------------------------------------------------------
  # we try to avaluate that list of strings but since
  # it gives an error we revert to interpret it
  # as the list of strings
  """
  for each word in:
  ﹍﹍"Hello " "Dave " "my " "dear " "friend"
  ﹍do:
  ﹍﹍console print word
  """
  "Hello Dave my dear friend"

  """
  for each word in: ('("Hello " "Dave " "my " "dear " "friend")) do:
  ﹍console print word
  """
  "Hello Dave my dear friend"

  # we try to avaluate that list of strings but since
  # it gives an error we revert to interpret it
  # as the list of strings
  """
  for each word in: ("Hello " "Dave " "my " "dear " "friend") do:
  ﹍console print word
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍﹍(\\
  ﹍﹍"Hello "\\
  ﹍﹍"Dave "\\
  ﹍﹍"my "\\
  ﹍﹍"dear "\\
  ﹍﹍"friend"\\
  ﹍﹍)
  ﹍do:
  ﹍﹍console print word
  """
  "Hello Dave my dear friend"

  """
  for each word in:
  ﹍﹍"Hello "\\
  ﹍﹍"Dave "\\
  ﹍﹍"my "\\
  ﹍﹍"dear "\\
  ﹍﹍"friend"
  ﹍do:
  ﹍﹍console print word
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  for each word in:
  ﹍﹍("Hello " "Dave " "my " "dear " "friend")
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  for each word in:
  ﹍﹍'("Hello " "Dave ") + "my " + "dear " + "friend"
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList = '("Hello " "Dave ") + "my " + "dear " + "friend"
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList = '("Hello " "Dave ")
  myString = "my dear friend"
  for each word in:
  ﹍﹍myList + myString
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList ='
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun =:
  ﹍console print word
  myList =:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"


  # ---------------------------------------------------------------------------
  # in this case "myList =..." causes an evaluation which ends up returning just
  # "Hello "
  """
  codeToBeRun ='
  ﹍console print word
  myList = ("Hello " "Dave " "my " "dear " "friend")
  console print "myList: " + myList
  """
  "! exception: message was not understood: ( TOKEN:Dave  TOKEN:my  TOKEN:dear  TOKEN:friend )"

  # ---------------------------------------------------------------------------
  # in this case "myList" ends up being a wrapped list i.e. ((wrapped))
  # so, when the right-side is evaluated, it ends up being the normal
  # un-wrapped contents, so it all works out without the ' after the =
  """
  codeToBeRun ='
  ﹍console print word
  myList =
  ﹍'("Hello " "Dave " "my " "dear " "friend")
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  # in this case "myList" ends up being a wrapped list i.e. ((wrapped))
  # so, when the right-side is evaluated, it ends up being the normal
  # un-wrapped contents, so it all works out without the ' after the =
  """
  codeToBeRun ='
  ﹍console print word
  myList = '
  ﹍"Hello " "Dave " "my " "dear " "friend"
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in:
  ﹍﹍'(1 2 3 4)
  ﹍do:
  ﹍﹍acc += number
  console print acc
  """
  "10"


  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in:
  ﹍﹍1 2 3 4
  ﹍do:
  ﹍﹍acc += number
  console print acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in:
  ﹍﹍(1 2 3 4)
  ﹍do:
  ﹍﹍acc += number
  console print acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList = 9
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\"; console print someException"
  "my custom error"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    try: ( console print 1; someException )\
    catch someException: ( console print \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; someException )\
    catch someException: ( console print \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # wrong way to raise exceptions, they must be thrown
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; someException )\
    catch someOtherException: ( console print \" caught the error I wanted\" )"
  "1"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    try: ( console print 1; throw someException; console print 2 )\
    catch someException: ( console print \" caught the error I wanted\" )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  try:
  ﹍console print 1
  ﹍throw someException
  ﹍console print 2
  catch someException:
  ﹍console print " caught the error I wanted"
  console print ". the end."
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; throw someException; console print 2 )\
    catch someException: ( console print \" caught the error I wanted\" )"
  "1 caught the error I wanted"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print 1
  ﹍throw someException
  ﹍console print 2
  catch someException:
  ﹍console print " caught the error I wanted"
  console print ". the end."
  """
  "1 caught the error I wanted. the end."

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; throw someException; console print 2 )\
    catch someOtherException: ( console print \" caught the error I wanted\" )"
  "1! exception: my custom error"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  # also note that the thrown exceptions is thrown right up to
  # the workspace, the ". the end." is not printed
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print 1
  ﹍throw someException
  ﹍console print 2
  catch someOtherException:
  ﹍console print " caught the error I wanted"
  console print ". the end."  
  """
  "1! exception: my custom error"

  # ---------------------------------------------------------------------------
  # thrown exception, note how the statement after the throw is not executed
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; throw someOtherException; console print 2 )\
    catch someOtherException: ( console print \" caught the error the first time around\")\
    catch someException: ( console print \" caught the error the second time around\")"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print 1
  ﹍throw someOtherException
  ﹍console print 2
  catch someOtherException:
  ﹍console print " caught the error the first time around"
  catch someException:
  ﹍console print " caught the error the second time around"
  console print ". the end."
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; throw someException; console print 2 )\
    catch someOtherException: ( console print \" caught the error the first time around\")\
    catch someException: ( console print \" caught the error the second time around\")"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print 1
  ﹍throw someException
  ﹍console print 2
  catch someOtherException:
  ﹍console print " caught the error the first time around"
  catch someException:
  ﹍console print " caught the error the second time around"
  console print ". the end."
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 1
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; throw someOtherException; console print 2 )\
    catch someOtherException: ( console print \" caught the error the first time around\")\
    catch someException: ( console print \" caught the error the second time around\")\
    catch all: (console print \" catch all branch\")"
  "1 caught the error the first time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print 1
  ﹍throw someOtherException
  ﹍console print 2
  catch someOtherException:
  ﹍console print " caught the error the first time around"
  catch someException:
  ﹍console print " caught the error the second time around"
  catch all:
  ﹍console print " catch all branch"
  console print ". the end."
  """
  "1 caught the error the first time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 2
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    try: ( console print 1; throw someException; console print 2 )\
    catch someOtherException: ( console print \" caught the error the first time around\")\
    catch someException: ( console print \" caught the error the second time around\")\
    catch all: (console print \" catch all branch\")"
  "1 caught the error the second time around"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  try:
  ﹍console print 1
  ﹍throw someException
  ﹍console print 2
  catch someOtherException:
  ﹍console print " caught the error the first time around"
  catch someException:
  ﹍console print " caught the error the second time around"
  catch all:
  ﹍console print " catch all branch"
  console print ". the end."
  """
  "1 caught the error the second time around. the end."

  # ---------------------------------------------------------------------------
  # catch-all case 3
  "'someException ← Exception new initWith \"my custom error\";\
    'someOtherException ← Exception new initWith \"my other custom error\";\
    'yetAnotherException ← Exception new initWith \"another custom error that is only caught by the catch all branch\";\
    try: ( console print 1; throw yetAnotherException; console print 2 )\
    catch someOtherException: ( console print \" caught the error the first time around\")\
    catch someException: ( console print \" caught the error the second time around\")\
    catch all: (console print \" catch all branch\")"
  "1 catch all branch"

  # ---------------------------------------------------------------------------
  """
  someException = Exception new initWith "my custom error"
  someOtherException = Exception new initWith "my other custom error"
  yetAnotherException = Exception new initWith "another custom error that is only caught by the catch all branch"
  try:
  ﹍console print 1
  ﹍throw yetAnotherException
  ﹍console print 2
  catch someOtherException:
  ﹍console print " caught the error the first time around"
  catch someException:
  ﹍console print " caught the error the second time around"
  catch all:
  ﹍console print " catch all branch"
  console print ". the end."
  """
  "1 catch all branch. the end."

  # ---------------------------------------------------------------------------
  """
  foo = 3
  things =' ()
  things = things+3
  things = things+"hello"
  console print things
  """
  "( 3 \"hello\" )"

  # ---------------------------------------------------------------------------
  """
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  console print myList[0]
  console print myList[1+1]
  """
  "Hello my "

  # ---------------------------------------------------------------------------
  """
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[1+1] = "oh "
  console print myList
  """
  "( \"Hello \" \"Dave \" \"oh \" \"dear \" \"friend\" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " "my " "dear " "friend")
  myList[numbers[1+1]] = "oh "
  console print myList
  """
  "( \"Hello \" \"Dave \" \"oh \" \"dear \" \"friend\" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  console print numbers[0]+numbers[1]
  """
  "12"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  console print myList[numbers[2]]
  """
  "( \"oh \" \"so \" )"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  myObject = MyClass new
  console print myObject.someField
  console print myObject.someOtherField
  myObject.someField =' (9 3 15 5 7)
  myObject.someField[1+1] = 1+1
  myObject.someOtherField =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  console print myObject.someOtherField[myObject.someField[1+1]]

  """
  "nilnil( \"oh \" \"so \" )"

  # ---------------------------------------------------------------------------
  """
  numbers =' (9 3 2 5 7)
  myList =' ("Hello " "Dave " ("oh " "so ") "dear " "friend")
  console print myList[numbers[1+1]][0+1]
  """
  "so "

  # ---------------------------------------------------------------------------
  """
  things =' (false true)
  console print things[0] or things[1]
  """
  "true"

  # ---------------------------------------------------------------------------
  """
  foo = 3
  things =' (foo bar 2)
  console print things[0]
  console print things[1]
  console print things[2]
  console print things
  """
  "3bar2( 3 bar 2 )"

  # ---------------------------------------------------------------------------
  """
  things1 =' (my little list)
  things2 = things1
  console print things1
  console print things2
  things1[0] = 'your
  things2[1] = 'big
  console print things1
  console print things2
  things1 = " no more a list "
  console print things1
  console print things2
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
  ﹍﹍getYourself (param)
  ﹍by:
  ﹍﹍param
  myObject = MyClass new
  myObject getYourself
  ﹍﹍2
  ﹍postfixPrint
  """
  "2"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍getYourself (param)
  ﹍by:
  ﹍﹍param
  myObject = MyClass new
  myObject getYourself
  ﹍﹍2
  ﹍console print 1
  """
  "! exception: message was not understood: ( console print 1 )"

  # careful! here is the ...3 postfixPrint that ends up
  # running!
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍getYourself (param)
  ﹍by:
  ﹍﹍param
  myObject = MyClass new
  myObject getYourself 3 postfixPrint
  """
  "3"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍getYourself (param)
  ﹍by:
  ﹍﹍param
  myObject = MyClass new
  (myObject getYourself 3) postfixPrint
  """
  "3"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍getYourself (param)
  ﹍by:
  ﹍﹍param
  myObject = MyClass new
  myObject getYourself 3
  console print 1
  """
  "1"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍console print "hey I'm new!"
  ﹍﹍self
  myObject = MyClass new
  console print " ...done!"
  """
  "hey I'm new! ...done!"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍console print "hey I'm new!"
  ﹍﹍@
  myObject = MyClass new
  console print " ...done!"
  """
  "hey I'm new! ...done!"

  # ---------------------------------------------------------------------------

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍2
  ﹍﹍self
  myObject = MyClass new
  console print 1
  """
  "1"


  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍2
  ﹍﹍@
  myObject = MyClass new
  console print 1
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
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍2
  myObject = MyClass new
  console print myObject
  """
  "2"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍console print "hey I'm new!"
  ﹍﹍self
  MyClass answer:
  ﹍﹍initWith (param)
  ﹍by:
  ﹍﹍console print param
  ﹍﹍self
  myObject = MyClass new initWith " hello again! I am... "
  console print myObject
  """
  "hey I'm new! hello again! I am... [object of class \"MyClass\"]"


  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍console print "hey I'm new!"
  ﹍﹍@
  MyClass answer:
  ﹍﹍initWith (param)
  ﹍by:
  ﹍﹍console print param
  ﹍﹍@
  myObject = MyClass new initWith " hello again! I am... "
  console print myObject
  """
  "hey I'm new! hello again! I am... [object of class \"MyClass\"]"

  # ---------------------------------------------------------------------------
  """
  // a comment here
  MyClass = Class new
  MyClass answer:
  ﹍﹍whenNew
  // another comment here
  ﹍by:
  ﹍﹍2
  myObject = MyClass new
  console print myObject
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
  ﹍﹍console print argument
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
  ﹍﹍﹍﹍console print argument
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
  ﹍﹍﹍﹍console print argument
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
  ﹍﹍﹍﹍﹍﹍﹍﹍﹍console print argument
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
  ﹍﹍﹍﹍console print argument
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍printthree (argument)
  ﹍by:
  ﹍﹍﹍console print argument
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
  ﹍﹍﹍﹍console print argument
  myObject = MyClass new
  myObject printthree "hello"
  """
  "hello"

  """
  MyClass = Class new
  MyClass answer:
  ﹍﹍﹍printthree (argument)
  ﹍﹍by:
  ﹍﹍﹍console print argument
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
  ﹍﹍a=a - 1
  console print a
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
  ﹍﹍﹍a=a - 1
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList = '(1 2 3 4)
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "1234"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList = 9
  for each word in:
  ﹍﹍myList
  ﹍do:
  ﹍﹍codeToBeRun eval
  """
  "! exception: for...each expects a list"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  myObject = MyClass new
  console print myObject.someField
  myObject.someField = 2
  console print myObject.someField
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
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍self.instantiationsCounter increment
  ﹍﹍self

  MyClass answer:
  ﹍﹍getCount
  ﹍by:
  ﹍﹍self.instantiationsCounter.counter

  console print MyClass getCount

  myObject = MyClass new
  console print MyClass getCount
  console print myObject getCount

  myObject2 = MyClass new
  console print MyClass getCount
  console print myObject getCount
  console print myObject2 getCount

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
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍@instantiationsCounter increment
  ﹍﹍@

  MyClass answer:
  ﹍﹍getCount
  ﹍by:
  ﹍﹍@instantiationsCounter.counter

  console print MyClass getCount

  myObject = MyClass new
  console print MyClass getCount
  console print myObject getCount

  myObject2 = MyClass new
  console print MyClass getCount
  console print myObject getCount
  console print myObject2 getCount

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
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍self.instantiationsCounter increment
  ﹍﹍self

  MyClass answer:
  ﹍﹍getCount
  ﹍by:
  ﹍﹍self.instantiationsCounter.counter

  console print MyClass getCount
  console print myObject getCount

  myObject2 = MyClass new
  console print MyClass getCount
  console print myObject getCount
  console print myObject2 getCount

  myObject2.fieldAddedToObject2 = 2

  console print MyClass.fieldAddedToObject2
  console print myObject.fieldAddedToObject2
  console print myObject2.fieldAddedToObject2

  MyClass.fieldAddedToClass = 3
  console print MyClass.fieldAddedToClass
  console print myObject.fieldAddedToClass
  console print myObject2.fieldAddedToClass

  myObject.fieldAddedToClass = 4
  console print MyClass.fieldAddedToClass
  console print myObject.fieldAddedToClass
  console print myObject2.fieldAddedToClass

  myObject2.fieldAddedToClass = 5
  console print MyClass.fieldAddedToClass
  console print myObject.fieldAddedToClass
  console print myObject2.fieldAddedToClass


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
  ﹍﹍whenNew
  ﹍by:
  ﹍﹍@instantiationsCounter increment
  ﹍﹍@

  MyClass answer:
  ﹍﹍getCount
  ﹍by:
  ﹍﹍@instantiationsCounter.counter

  console print MyClass getCount
  console print myObject getCount

  myObject2 = MyClass new
  console print MyClass getCount
  console print myObject getCount
  console print myObject2 getCount

  myObject2.fieldAddedToObject2 = 2

  console print MyClass.fieldAddedToObject2
  console print myObject.fieldAddedToObject2
  console print myObject2.fieldAddedToObject2

  MyClass.fieldAddedToClass = 3
  console print MyClass.fieldAddedToClass
  console print myObject.fieldAddedToClass
  console print myObject2.fieldAddedToClass

  myObject.fieldAddedToClass = 4
  console print MyClass.fieldAddedToClass
  console print myObject.fieldAddedToClass
  console print myObject2.fieldAddedToClass

  myObject2.fieldAddedToClass = 5
  console print MyClass.fieldAddedToClass
  console print myObject.fieldAddedToClass
  console print myObject2.fieldAddedToClass


  """
  "00111nilnil2333343345"


  # ---------------------------------------------------------------------------
  # compound assignments operators
  # ---------------------------------------------------------------------------

  """
  a = 1
  a += a
  console print a
  """
  "2"

  """
  a = 1
  b = 2
  a += b
  console print a
  """
  "3"

  """
  a = 1
  b = 2
  a += b+1
  console print a
  """
  "4"

  # trick question
  """
  a = 1
  b = 2
  a += console print b
  """
  "2"

  """
  a = 1
  b = 2
  console print a += b
  """
  "3"

  """
  a = 1
  a *= 1
  console print a
  """
  "1"

  """
  a = 1
  a *= 2
  console print a
  """
  "2"


  # ---------------------------------------------------------------------------
  # increment/decrement operators
  # ---------------------------------------------------------------------------

  """
  a = 1
  a++
  console print a
  """
  "2"

  """
  a = 1
  a++ + 1
  console print a
  """
  "2"

  """
  a = 1
  a = a++ + 1
  console print a
  """
  "3"

  """
  a = 1
  console print a++
  """
  "2"

  """
  a = 1
  a++ ++
  console print a
  """
  "2"

  """
  a = 1
  console print a++ ++
  """
  "3"


  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField += 2
  console print myObject.someField
  """
  "4"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  console print myObject.someField += 2
  """
  "4"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  myObject.someField++
  console print myObject.someField
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  console print myObject.someField++
  """
  "3"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject.someField = 2
  console print myObject.someField++ ++
  console print myObject.someField
  """
  "43"

  """
  myArray = '(1 2 3)
  myArray[0]++
  console print myArray
  """
  "( 2 2 3 )"

  """
  myArray = '(1 2 3)
  console print myArray[0]++ ++
  console print myArray
  """
  "3( 2 2 3 )"

  """
  myArray = '(1 2 3)
  console print myArray[0] += myArray[1]+myArray[2]
  console print myArray
  """
  "6( 6 2 3 )"

  """
  myArray = '(1 2 3)
  console print myArray[0]++
  """
  "2"

  """
  myArray = '(1 2 3)
  console print myArray[0]++ ++
  console print myArray[0]
  """
  "32"

  """
  a = '()
  a[4] = 1
  console print a
  """
  "( nil nil nil nil 1 )"

  # this shows how the ++ operator
  # CREATES a new object, so it creates
  # an entry in the object if it wasn't there
  """
  MyClass = Class new
  MyClass.count = 0

  myObject = MyClass new
  myObject2 = MyClass new

  console print MyClass.count // 0
  console print myObject.count // 0
  console print myObject2.count // 0

  MyClass.count++

  console print MyClass.count // 1
  console print myObject.count // 1
  console print myObject2.count // 1

  myObject.count++

  console print MyClass.count // 1
  console print myObject.count // 2
  console print myObject2.count // 1

  myObject2.count++
  myObject2.count++

  console print MyClass.count // 1
  console print myObject.count // 2
  console print myObject2.count // 3

  MyClass.count++

  console print MyClass.count // 2
  console print myObject.count // 2
  console print myObject2.count // 3

  """
  "000111121123223"

  # ---------------------------------------------------------------------------
  # running with empty signature
  # FLTO

  "to sayHello: () do: (console print \"Hello\"); sayHello;"
  "Hello"

  # ---------------------------------------------------------------------------
  #    emojis!
  # ---------------------------------------------------------------------------
  "😁 = 4; console print 😁"
  "4"

  # ---------------------------------------------------------------------------
  "😁 =4;console print 😁"
  "4"

  # ---------------------------------------------------------------------------
  "😁=4;console print 😁"
  "4"

  # ---------------------------------------------------------------------------
  # here "print😁" is a single token, so there is no print happening
  "😁=4;console print😁"
  "! exception: message was not understood: ( print😁 )"

  # ---------------------------------------------------------------------------
  # FLTO

  # "nothing" signature
  """
  to 🚀:
  ﹍console print "launch!"
  🚀
  """
  "launch!"

  """
  to 🚀:
  ﹍console print "launch!"
  (🚀)
  """
  "launch!"

  """
  to 🚀:
  ﹍console print "launch!"
  ((((🚀))))
  """
  "launch!"

  # ---------------------------------------------------------------------------
  # you can assign arbitrary things to any token e.g. strings or numbers,
  # including objects which take the empty message
  # FLTO

  """
  to "🚀":
  ﹍﹍withAParameter
  ﹍do:
  ﹍﹍console print "running with a param."

  "🚀" withAParameter

  to "🚀":
  ﹍console print "running without params."

  "🚀"
  "🚀" withAParameter

  """
  "running with a param.running without params.running with a param."

  # ---------------------------------------------------------------------------
  # string concatenation also with type conversion
  # ---------------------------------------------------------------------------
  "console print \"Hello \" + \"world!\""
  "Hello world!"

  "console print \"Hello \" + \"world!\" + 2"
  "Hello world!2"

  "console print '(1+1)"
  "( 1 + 1 )"

  # here there is a concatenation of lists
  "console print '(1+1)+1"
  "( 1 + 1 1 )"

  # here there is a concatenation of strings
  "console print '(1+1) toString + 1"
  "( 1 + 1 )1"

  # it's the Javascript runtime doing this sum between number and boolean
  "console print 1 + true"
  "2"

  # ---------------------------------------------------------------------------
  # return
  # ---------------------------------------------------------------------------

  """
  to testingReturn:
  ﹍console print "start - "
  ﹍return 1+1
  ﹍console print "never reached"
  console print testingReturn
  """
  "start - 2"

  """
  to testingReturn:
  ﹍console print "start - "
  ﹍return 1+1
  ﹍console print "never reached"
  testingReturn + 1
  """
  "start - "

  """
  to testingReturn:
  ﹍console print "start - "
  ﹍return 1+1
  ﹍console print "never reached"
  console print (testingReturn) + 1
  """
  "start - 3"

  """
  to testingReturn:
  ﹍console print "start - "
  ﹍return
  ﹍console print "never reached"
  console print testingReturn
  """
  "start - nil"

  """
  to testingReturn:
  ﹍console print "start - "
  ﹍return
  ﹍console print "never reached"
  (testingReturn 1 + 1) postfixPrint
  """
  "start - ! exception: message was not understood: ( 1 + 1 )"

  """
  to testingReturn:
  ﹍repeat 2:
  ﹍﹍console print 1
  ﹍﹍console print 2
  testingReturn
  console print " the end."
  """
  "1212 the end."

  """
  to testingReturn:
  ﹍repeat 2:
  ﹍﹍console print 1
  ﹍﹍return
  ﹍﹍console print 2
  testingReturn
  console print " the end."
  """
  "1 the end."

  """
  nil 1 + 1
  """
  "! exception: message was not understood: ( 1 + 1 )"

  # ---------------------------------------------------------------------------
  # (in)equality comparisons
  # ---------------------------------------------------------------------------

  """
  console print 1 == 0
  """
  "false"

  """
  console print 1 == 1
  """
  "true"

  """
  console print 1.0 == 1
  """
  "true"

  """
  console print 0 == 0.0
  """
  "true"

  """
  console print 0.0 == 0.0
  """
  "true"

  """
  console print 1 == "hello"
  """
  "false"

  """
  console print "hello" == "hello"
  """
  "true"

  """
  console print "hello" == "world"
  """
  "false"

  """
  console print "hello" == true
  """
  "false"

  """
  console print false == false
  """
  "true"

  """
  console print false == 0
  """
  "false"

  """
  console print true == 0
  """
  "false"

  """
  console print true == 1
  """
  "false"

  """
  console print true == 1.0
  """
  "false"

  """
  console print true == 2
  """
  "false"

  """
  console print nil == nil
  """
  "true"

  """
  myList = '(1 2 3)
  myList2 = '(1 2 3)
  console print myList == myList
  console print myList == myList2
  """
  "truefalse"

  """
  MyClass = Class new
  myObject = MyClass new
  myObject2 = MyClass new
  console print myObject == myObject
  console print myObject == myObject2
  """
  "truefalse"

  # ---------------------------------------------------------------------------
  # linked list
  # ---------------------------------------------------------------------------

  """
  console print console.nonExisting == nil
  """
  "true"


  """
  Node = Class new

  Node answer:
  ﹍﹍initWith (item) (next)
  ﹍by:
  ﹍﹍@item = item
  ﹍﹍console print " adding item: " + @item
  ﹍﹍@next = next
  ﹍﹍@

  LinkedList = Class new

  LinkedList answer:
  ﹍﹍isEmpty
  ﹍by:
  ﹍﹍console print " list is empty now? " + @head == nil
  ﹍﹍@head == nil

  LinkedList answer:
  ﹍﹍append (item)
  ﹍by:
  ﹍﹍node = Node new initWith item nil
  ﹍﹍console print " 0 node is: " + node
  ﹍﹍console print " 0 node has item: " + node.item
  ﹍﹍if @tail != nil:
  ﹍﹍﹍console print " 1 node is: " + node
  ﹍﹍﹍console print " 1 node has item: " + node.item
  ﹍﹍﹍@tail.next = node
  ﹍﹍﹍console print " 2 node is: " + node
  ﹍﹍﹍console print " 2 node has item: " + node.item
  ﹍﹍if @ isEmpty:
  ﹍﹍﹍console print " 3 node is: " + node
  ﹍﹍﹍console print " 3 node has item: " + node.item
  ﹍﹍﹍@head = node
  ﹍﹍if @ isEmpty:
  ﹍﹍﹍console print " this list should NOT be empty"
  ﹍﹍@tail = node

  myLinkedList = LinkedList new

  myLinkedList append "Hello "
  if myLinkedList isEmpty:
  ﹍console print " this list should NOT be empty"

  myLinkedList append "World"

  console print " list contents: "
  console print myLinkedList.head.item
  console print myLinkedList.head.next.item
  """
  " adding item: Hello  0 node is: [object of class \"Node\"] 0 node has item: Hello  1 node is: [object of class \"Node\"] 1 node has item: Hello  2 node is: [object of class \"Node\"] 2 node has item: Hello  list is empty now? true 3 node is: [object of class \"Node\"] 3 node has item: Hello  list is empty now? false list is empty now? false adding item: World 0 node is: [object of class \"Node\"] 0 node has item: World 1 node is: [object of class \"Node\"] 1 node has item: World 2 node is: [object of class \"Node\"] 2 node has item: World list is empty now? false list is empty now? false list contents: Hello World"


# ---------------------------------------------------------------------------
  """
  evaluationsCounter
  """
  "EvaluationsCounter running the \"empty\" method // "

  # the \"empty\" method is invoked multiple times as
  # the evaluationsCounter comes out as the
  # result of each parens...
  """
  (evaluationsCounter)
  """
  "EvaluationsCounter running the \"empty\" method // EvaluationsCounter running the \"empty\" method // "

  # the "empty" method is invoked multiple times as
  # the evaluationsCounter comes out as the
  # result of each parens...
  """
  ((((evaluationsCounter))))
  """
  "EvaluationsCounter running the \"empty\" method // EvaluationsCounter running the \"empty\" method // EvaluationsCounter running the \"empty\" method // EvaluationsCounter running the \"empty\" method // EvaluationsCounter running the \"empty\" method // "

# ---------------------------------------------------------------------------

  """
  console print 8 % 2
  """
  "0"

  """
  console print 7 % 2
  """
  "1"

# ---------------------------------------------------------------------------

  # floor division operator à la python
  # (in python it's // but we use that for comments)

  """
  console print 9/_2
  """
  "4"

  """
  console print 9.0/_2.0
  """
  "4"

  """
  console print (0-11)/_3
  """
  "-4"

  """
  console print (0-11.0)/_3
  """
  "-4"


# ---------------------------------------------------------------------------

  # Collatz
  """
  startingNumber = 97
  steps = 0

  n = startingNumber

  repeat forever:
  ﹍console print n + "-"
  ﹍if n==1:
  ﹍﹍break
  ﹍else:
  ﹍﹍if 0==n%2:
  ﹍﹍﹍n=n/2
  ﹍﹍else:
  ﹍﹍﹍n=1+n*3
  ﹍﹍steps++

  console print " steps: " + steps

  """
  "97-292-146-73-220-110-55-166-83-250-125-376-188-94-47-142-71-214-107-322-161-484-242-121-364-182-91-274-137-412-206-103-310-155-466-233-700-350-175-526-263-790-395-1186-593-1780-890-445-1336-668-334-167-502-251-754-377-1132-566-283-850-425-1276-638-319-958-479-1438-719-2158-1079-3238-1619-4858-2429-7288-3644-1822-911-2734-1367-4102-2051-6154-3077-9232-4616-2308-1154-577-1732-866-433-1300-650-325-976-488-244-122-61-184-92-46-23-70-35-106-53-160-80-40-20-10-5-16-8-4-2-1- steps: 118"

# ---------------------------------------------------------------------------

  # 20 digits of pi using Jeremy Gibbons's unbounded spigot
  # streaming algorithm. Can't go beyond 20 because
  # Javascript's Number precision. (only a bigint
  # representation could go on "forever")

  """
  q = 1
  r = 0
  t = 1
  k = 1
  n = 3
  l = 3
  repeat 82:
  ﹍if ((r-t)+4*q) < (n*t):
  ﹍﹍console print n
  ﹍﹍nr = 10*(r-n*t)
  ﹍﹍n = ((10*(r+3*q)) /_ t) - 10*n
  ﹍﹍q *= 10
  ﹍﹍r = nr
  ﹍else:
  ﹍﹍nr = (r+2*q) * l
  ﹍﹍nn = ((q*(2+7*k))+r*l) /_ (t*l)
  ﹍﹍q *= k
  ﹍﹍t *= l
  ﹍﹍l += 2
  ﹍﹍k += 1
  ﹍﹍n = nn
  ﹍﹍r = nr
  """
  "31415926535897932384"

# ---------------------------------------------------------------------------
# ranges

  """
  for each number in:
  ﹍﹍3...10
  ﹍do:
  ﹍﹍console print number
  """
  "3456789"

  """
  for each number in:
  ﹍﹍10...3
  ﹍do:
  ﹍﹍console print number
  """
  "10987654"

  """
  for each number in:
  ﹍﹍3...3
  ﹍do:
  ﹍﹍console print number
  console print "the end."
  """
  "the end."

# ---------------------------------------------------------------------------
# homoiconicity

  """
  codeToBeRun ='
  ﹍console print 1+2
  codeToBeRun eval
  """
  "3"

  """
  codeToBeRun ='
  ﹍console print 1+2
  console print codeToBeRun[3]
  """
  "+"

  """
  codeToBeRun ='
  ﹍console print 1+2
  codeToBeRun[3] = '-
  codeToBeRun eval
  """
  "-1"

  """
  codeToBeRun ='
  ﹍console print 1+2

  MyClass=Class new
  MyClass.counter = nil
  MyClass answer:
  ﹍﹍printOperation
  ﹍by:
  ﹍﹍codeToBeRun eval
  myObject=MyClass new
  myObject printOperation
  codeToBeRun[3] = '-
  myObject printOperation
  """

  "3-1"


  # ---------------------------------------------------------------------------
  # signatures in "answer" and "to" are not evaluated,
  # so they can't be closed in read-only mode (see closures)
  # so there can't be nasty "substitutions" in the signatures

  """
  //withName = 2
  name = "Flora"

  MyClass = Class new
  MyClass answer:
  ﹍﹍withName (name)
  ﹍by:
  ﹍﹍console print "Hello "
  ﹍﹍console print name
  myObject = MyClass new
  myObject withName "Dave"
  """

  "Hello Dave"


  """
  withName = 2
  name = "Flora"

  MyClass = Class new
  MyClass answer:
  ﹍﹍withName (name)
  ﹍by:
  ﹍﹍console print "Hello "
  ﹍﹍console print name
  myObject = MyClass new
  myObject withName "Dave"
  """

  "Hello Dave"


  """
  //withName = 2
  name = "Flora"
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍console print "Hello "
  ﹍﹍console print name
  sayHello withName "Dave"
  """
  "Hello Dave"

  """
  withName = 2
  name = "Flora"
  to sayHello:
  ﹍﹍withName (name)
  ﹍do:
  ﹍﹍console print "Hello "
  ﹍﹍console print name
  sayHello withName "Dave"
  """
  "Hello Dave"

  # ---------------------------------------------------------------------------
  # class names

  """
  console print "a String object".class
  """
  "[class \"String\" (an object of class Class)]"

  """
  console print "a String object".class.class
  """
  "[class \"Class\" (an object of class Class)]"

  """
  console print "a String object".class.class.class
  """
  "[class \"Class\" (an object of class Class)]"

  """
  console print "a String object".class.class.class.class.class.class.class.class
  """
  "[class \"Class\" (an object of class Class)]"

  """
  console print String == "a String object".class
  """
  "true"

  """
  console print Number == "a String object".class
  """
  "false"

  """
  console print String == 9.class
  """
  "false"

  """
  console print Number == 9.class
  """
  "true"

  """
  console print String == ('(some list items)).class
  """
  "false"

  """
  console print List == ('(some list items)).class
  """
  "true"

  """
  MyClass1 = Class new
  MyClass2 = Class new

  console print MyClass1 == MyClass2
  """
  "false"

  """
  MyClass1 = Class new
  MyClass2 = Class new

  console print MyClass1 == MyClass1
  """
  "true"

  """
  MyClass1 = Class new
  MyClass2 = Class new

  console print MyClass2 == MyClass2
  """
  "true"

  """
  MyClass1 = Class new
  myObject1 = MyClass1 new

  console print MyClass1 == myObject1.class
  """
  "true"

  """
  MyClass1 = Class new
  myObject1 = MyClass1 new

  MyClass2 = Class new
  myObject2 = MyClass2 new

  console print MyClass1 == myObject2.class
  """
  "false"

  """
  MyClass1 = Class new
  myObject1 = MyClass1 new

  MyClass2 = Class new
  myObject2 = MyClass2 new

  console print MyClass1 == myObject2.class
  """
  "false"

  """
  MyClass1 = Class new
  myObject1 = MyClass1 new

  console print myObject1.class == myObject1.class
  """
  "true"

  """
  MyClass1 = Class new
  myObject1 = MyClass1 new

  MyClass2 = Class new
  myObject2 = MyClass2 new

  console print myObject1.class == myObject2.class
  """
  "false"

  """
  console print Number.class
  """
  "[class \"Class\" (an object of class Class)]"

  """
  console print Number == "a String object".class
  """
  "false"

  """
  console print Number.class == "a String object".class.class
  """
  "true"

  """
  console print Number.class.class == "a String object".class.class.class
  """
  "true"

  """
  console print Number.class.class.class.class == "a String object".class.class.class.class.class
  """
  "true"

  # ---------------------------------------------------------------------------
  # primitive types checks

  """
  MyClass = Class new
  myObject = MyClass new

  console print 6 isPrimitiveType
  console print 6.class isPrimitiveType
  console print true isPrimitiveType
  console print true.class isPrimitiveType
  console print "hey" isPrimitiveType
  console print "hey".class isPrimitiveType
  console print myObject isPrimitiveType
  console print myObject.class isPrimitiveType
  console print MyClass isPrimitiveType
  console print MyClass.class isPrimitiveType
  """
  "truetruetruetruetruetruefalsetruetruetrue"

  # ---------------------------------------------------------------------------
  # calling an object with empty message, when the object doesn't respond to
  # empty message: the following statements are executed
  """
  to 🚀:
  ﹍﹍withAParameter
  ﹍do:
  ﹍﹍console print "running with a param."
  🚀
  console print 1+1
  console print 🚀
  """
  "2[object of class \"Class_of_🚀\"]"

  # ---------------------------------------------------------------------------
  # factorial using FLTo

  """
  to factorial:
  ﹍﹍(n)
  ﹍do:
  ﹍﹍if n == 0:
  ﹍﹍﹍return 1
  ﹍﹍else:
  ﹍﹍﹍return n * factorial (n - 1)

  console print factorial 3
  """
  "6"

  # ---------------------------------------------------------------------------
  # factorial using FLTo and using "if" as an expression

  """
  to factorial:
  ﹍﹍(n)
  ﹍do:
  ﹍﹍if n == 0:
  ﹍﹍﹍1
  ﹍﹍else:
  ﹍﹍﹍n * factorial (n - 1)

  console print factorial 3
  """
  "6"

  # ---------------------------------------------------------------------------
  """
  Number answer:
  ﹍﹍factorial
  ﹍by:
  ﹍﹍if self == 0:
  ﹍﹍﹍return 1
  ﹍﹍else:
  ﹍﹍﹍(self - 1) factorial * self
  console print 3 factorial
  """
  "6"

  """
  Number answer:
  ﹍﹍factorial
  ﹍by:
  ﹍﹍if self == 0:
  ﹍﹍﹍return 1
  ﹍﹍else:
  ﹍﹍﹍return (self - 1) factorial * self
  console print 3 factorial
  """
  "6"

  """
  Number answer:
  ﹍﹍factorial
  ﹍by:
  ﹍﹍if self == 0:
  ﹍﹍﹍1
  ﹍﹍else:
  ﹍﹍﹍(self - 1) factorial * self
  console print 3 factorial
  """
  "6"


  # ---------------------------------------------------------------------------
  # override class default name. class names are really just for more
  # meaningful printouts.
  """
  MyClass = Class new named "My Class"
  console print MyClass
  myObject = MyClass new
  console print myObject
  """
  "[class \"My Class\" (an object of class Class)][object of class \"My Class\"]"

  # ---------------------------------------------------------------------------
  # pythagorean triplets
  """
  for each c in: (1...10) do:
  ﹍for each b in: (1...c) do:
  ﹍﹍for each a in: (1...b) do:
  ﹍﹍﹍if ((a * a) + (b * b)) == (c * c):
  ﹍﹍﹍﹍console print "a: " + a + " b: " + b + " c: " + c
  """
  "a: 3 b: 4 c: 5"

  # ---------------------------------------------------------------------------
  # fizzbuzz
  """
  for each i in: (1...100) do:
  ﹍if 0 == i % 15:
  ﹍﹍console print "FizzBuzz "
  ﹍else if 0 == i % 3:
  ﹍﹍console print "Fizz "
  ﹍else if 0 == i % 5:
  ﹍﹍console print "Buzz "
  ﹍else:
  ﹍﹍console print i + " "
  """
  "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz Fizz 52 53 Fizz Buzz 56 Fizz 58 59 FizzBuzz 61 62 Fizz 64 Buzz Fizz 67 68 Fizz Buzz 71 Fizz 73 74 FizzBuzz 76 77 Fizz 79 Buzz Fizz 82 83 Fizz Buzz 86 Fizz 88 89 FizzBuzz 91 92 Fizz 94 Buzz Fizz 97 98 Fizz "

  # ---------------------------------------------------------------------------
  # a macro
  """
  a = '( (1...3) (console print x + y + z) x y z)
  console print a length
  numParams = a length - 2
  console print numParams

  bodies = '()

  for each number in:
  ﹍﹍0...numParams
  ﹍do:
  ﹍﹍bodies[number] = '()
  ﹍﹍bodies[number] = bodies[number] + 'for + 'each + a[2+number] + 'in + ': + a[0]
  ﹍﹍bodies[number] = bodies[number] + 'do + ':

  bodies[numParams-1] = bodies[numParams-1] + a[1]
  console print bodies

  console print " ---------- "
  for each number in:
  ﹍﹍numParams...1
  ﹍do:
  ﹍﹍bodies[number-2] = bodies[number-2] + bodies[number-1]

  console print " ---- "
  console print bodies

  toRun = bodies[0]
  console print " ---- "
  console print toRun

  toRun eval
  """
  '53( ( for each x in : ( 1 ... 3 ) do : ) ( for each y in : ( 1 ... 3 ) do : ) ( for each z in : ( 1 ... 3 ) do : ( [object of class "Console"] print x + y + z ) ) ) ----------  ---- ( ( for each x in : ( 1 ... 3 ) do : ( for each y in : ( 1 ... 3 ) do : ( for each z in : ( 1 ... 3 ) do : ( [object of class "Console"] print x + y + z ) ) ) ) ( for each y in : ( 1 ... 3 ) do : ( for each z in : ( 1 ... 3 ) do : ( [object of class "Console"] print x + y + z ) ) ) ( for each z in : ( 1 ... 3 ) do : ( [object of class "Console"] print x + y + z ) ) ) ---- ( for each x in : ( 1 ... 3 ) do : ( for each y in : ( 1 ... 3 ) do : ( for each z in : ( 1 ... 3 ) do : ( [object of class "Console"] print x + y + z ) ) ) )34454556'

  # ---------------------------------------------------------------------------
  # same macro, used more cleanly as a keyword

  """
  to nestedRepeat:
  ﹍﹍(rangeBodyAndVars)
  ﹍do:
  ﹍﹍accessUpperContext
  ﹍﹍numParams = rangeBodyAndVars length - 2
  ﹍﹍body = rangeBodyAndVars[1]
  ﹍﹍range =  rangeBodyAndVars[0]
  ﹍﹍
  ﹍﹍bodies = '()
  ﹍﹍
  ﹍﹍for each number in:
  ﹍﹍﹍﹍0...numParams
  ﹍﹍﹍do:
  ﹍﹍﹍﹍bodies[number] = '()
  ﹍﹍﹍﹍bodies[number] = bodies[number] + 'for + 'each + rangeBodyAndVars[2+number] + 'in + ': + range
  ﹍﹍﹍﹍bodies[number] = bodies[number] + 'do + ':
  ﹍﹍
  ﹍﹍bodies[numParams-1] = bodies[numParams-1] + body
  ﹍﹍
  ﹍﹍for each number in:
  ﹍﹍﹍﹍(numParams-1)...0
  ﹍﹍﹍do:
  ﹍﹍﹍﹍bodies[number-1] = bodies[number-1] + bodies[number]
  ﹍﹍
  ﹍﹍bodies[0] eval

  nestedRepeat '( (1...3) (console print x + y + z) x y z)
  """
  "34454556"


  # ---------------------------------------------------------------------------
  """
  to aToObjectFunction:
  ﹍for each word in:
  ﹍﹍﹍'(1 + 1)
  ﹍﹍do:
  ﹍﹍﹍console print word

  aToObjectFunction
  """
  "1+1"


]

###
# You can't mention a "@" (or "self") in this way, you'll
# get an infinite loop, as "@" (or "self") will be evaluated and
# run the empty method which will mention "@" (or "self"), which
# will be evaluated... forever in this case.
"""
to 🚀:
﹍console print "launch!"
﹍@
🚀
"""
"launch!"
###

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
console print things
things[0] print
" // " print
things =' ()
things = things+'foo
console print things
things[0] print
" // " print
things =' ()
things = things+'('foo)
console print things
things[0] print
"""
"( 3 )3 // ( foo )3 // ( ( ' foo ) )( ' foo )"
###

###
tests = [
]
###

Fizzylogo.init()
OKs = 0
FAILs = 0

for i in [0...tests.length] by 2

    # use reset() instead of quickReset()
    # every now and then to
    # check that the tests still work when
    # there is a deeper clean of the
    # environment
    #reset()
    quickReset()

    [testBody, testResult] = tests[i .. i + 1]

    testBodyMultiline = testBody.replace /\n/g, ' ⏎ '
    log "starting test: " + (i/2+1) + ": " + testBodyMultiline
    
    run testBody

    log "final return: " + outerMostContext.returned?.value
    if rWorkspace.environmentPrintout + rWorkspace.environmentErrors == testResult
      OKs++
      log "...test " + (i/2+1) + " OK, obtained: " + rWorkspace.environmentPrintout + rWorkspace.environmentErrors
    else
      FAILs++
      log "...test " + (i/2+1) + " FAIL, test: " + testBodyMultiline + " obtained: " + rWorkspace.environmentPrintout + rWorkspace.environmentErrors + " expected: " + testResult

log "all tests done. obtained " + OKs + " OKs and " + FAILs + " FAILs"
