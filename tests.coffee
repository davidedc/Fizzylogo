tests = [
  # ---------------------------------------------------------------------------
  # surprise! this language "chains" to the right
  # so "streams" of things are run right to left. 
  "console print 2 * 3 + 1"
  "8"

  # ---------------------------------------------------------------------------
  "console print (2 * 3) + 1"
  "7"

  # ---------------------------------------------------------------------------
  "console print (1.2 * 3.4) + 5.6"
  "9.68"

  # ---------------------------------------------------------------------------

  "console print 1+1;Number answer:(+(operandum))by:(console print self;console print \"+\";console print operandum);2+3;Number answer:(+(operandum))by:(self $plus_binary operandum);"
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
  # this is what happens here: "a" is sent the message "b".
  # "a" doesn't know what to do with it, so it returns itself
  # and "b" remains unconsumed.
  # So the assignment will assign "a" to a, then it will mandate
  # a new receiver. The new receiver will be "b. console print a" (the
  # semicolon separating the statements
  # comes from the linearisation), which was still
  # there to be consumed. "b." will just return itself and do nothing,
  # so then "console print a" will be run, which results in "a"
  """
  a = "a" "b"
  console print a
  """
  """
  a
  """

  # ---------------------------------------------------------------------------
  "nonExistingObject"
  ""

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
  "true⇒(console print 1)"
  "1"

  # Boolean's "⇒" message cannot evaluate
  # its argument automatically (because if it's
  # false obviously it can't evaluate it), so this means
  # it must pick the true branch literally, which means it
  # must be in parens. Here "console" is picked, then the
  # "remaing part" of the message is considered to be the
  # false brench and is hence discarded.
  "true⇒console print 1"
  ""

  # ---------------------------------------------------------------------------
  "false⇒(console print 1)console print 2"
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
  "console print (8 minus 1)"
  "7"

  "console print 8 minus 1"
  "7"

  # ---------------------------------------------------------------------------
  # can't remove those parens!
  "true⇒(console print 1)console print 2"
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
  "console print 0 factorial"
  "1"

  # ---------------------------------------------------------------------------
  "console print 1 factorial"
  "1"

  # ---------------------------------------------------------------------------
  "console print 2 factorial"
  "2"

  # ---------------------------------------------------------------------------
  "console print 7 factorial"
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
  "'a←5;repeat1((a==0)⇒(done)'a←a minus 1);console print a"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done)a=a minus 1);console print a"
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  
  console print a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  'a←5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  ;console print a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5
  repeat1
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
  ;console print a
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  'a←5

  repeat forever:
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍'a←a minus 1
  console print a
  """
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  a=5

  repeat forever:
  ﹍(a==0)⇒
  ﹍﹍done
  ﹍a=a minus 1
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
  ﹍﹍a=a minus 1
  console print a
  """
  "0"

  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍break
  ﹍else:
  ﹍﹍a=a minus 1
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
  ﹍﹍j=j minus 1
  ﹍﹍repeat forever:
  ﹍﹍﹍console print " i/j: " + j
  ﹍﹍﹍console print " i/k: " + k
  ﹍﹍﹍if k==0:
  ﹍﹍﹍﹍break
  ﹍﹍﹍else:
  ﹍﹍﹍﹍k=k minus 1
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
  ﹍﹍a=a minus 1
  console print a
  """
  "0"

  # ---------------------------------------------------------------------------
  """
  a=5

  repeat 2:
  ﹍a=a minus 1
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
  ﹍a=a minus 1
  ﹍b = 0
  ﹍c = 0
  console print a
  console print b
  console print c
  """
  "5nil300"


  # ---------------------------------------------------------------------------
  "'a←5;console print repeat1((a==0)⇒(done)'a←a minus 1)"
  "Done_object"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;console print repeat1((a==0)⇒(done)a=a minus 1)"
  "Done_object"

  # ---------------------------------------------------------------------------
  # "done" stop the execution from within a loop,
  # nothing is executed after them
  "'a←5;repeat1((a==0)⇒(done; console print 2)'a←a minus 1);console print a"
  "0"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;repeat1((a==0)⇒(done; console print 2)a=a minus 1);console print a"
  "0"

  # ---------------------------------------------------------------------------
  "'a←5;console print repeat1\
    ((a==0)⇒(done with a+1)'a←a minus 1)"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "a=5;console print repeat1\
    ((a==0)⇒(done with a+1)a=a minus 1)"
  "1"

  # ---------------------------------------------------------------------------
  "console print Class"
  "Class_object"

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
    MyClass answer:(printtwo)by'(console print self);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(console print self);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  "'MyClass←Class new;\
    MyClass answer:(printtwo)by:(console print @);\
    'myObject←MyClass new;myObject printtwo"
  "object_from_a_user_class"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo
  by:
  ﹍console print self
  myObject = MyClass new
  myObject printtwo
  """
  "object_from_a_user_class"

  """
  MyClass = Class new
  MyClass answer:
  ﹍printtwo
  by:
  ﹍console print @
  myObject = MyClass new
  myObject printtwo
  """
  "object_from_a_user_class"

  # ---------------------------------------------------------------------------
  "'false←true;false⇒(console print 1)console print 2"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "false=true;false⇒(console print 1)console print 2"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;false⇒(console print 1)console print 2"
  "1"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;false⇒(console print 1)console print 2"
  "1"

  # ---------------------------------------------------------------------------
  "'temp←true;'true←false;'false←temp;true⇒(console print 1)console print 2"
  "2"

  # -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  "temp=true;true=false;false=temp;true⇒(console print 1)console print 2"
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
  ﹍1
  to
  ﹍10
  :
  ﹍console print k
  console print "done"
  """
  "12345678910done"

  # ---------------------------------------------------------------------------
  """
  console print localTemp
  for k from
  ﹍1
  to
  ﹍1
  :
  ﹍localTemp = " - local temp"
  ﹍console print localTemp
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
  ﹍setCounterToTwo
  by:
  ﹍self.counter = 2
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
  ﹍setCounterToTwo
  by:
  ﹍@counter = 2
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
  ﹍console print (op1+op2)
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
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
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
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject's counter
  in
  ﹍myObject
  do
  ﹍self's counter = 3
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
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject.counter
  in
  ﹍myObject
  do
  ﹍self.counter = 3
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
  ﹍setCounterToTwo
  by:
  ﹍codeToBeRun eval
  myObject=MyClass new
  myObject setCounterToTwo
  console print myObject.counter
  in
  ﹍myObject
  do
  ﹍@counter = 3
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
  ﹍printtwo (argument)
  by:
  ﹍console print argument
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
  ﹍console print argument
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
  """
  for each word in '
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍console print word
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍console print word
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
  ﹍console print word
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  for each word in:
  ﹍"Hello " "Dave " "my " "dear " "friend"
  do:
  ﹍codeToBeRun eval
  """
  "Hello Dave my dear friend"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
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
  ﹍console print word
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
  ﹍console print word
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
  ﹍console print word
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
  console print acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in '
  ﹍1 2 3 4
  do:
  ﹍acc += number
  console print acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  acc = 0
  for each number in:
  ﹍1 2 3 4
  do:
  ﹍acc += number
  console print acc
  """
  "10"

  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
  myList = 9
  for each word in
  ﹍myList
  do:
  ﹍codeToBeRun
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
  "1"

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
  console print 1
  """
  "! exception: message was not understood: ( console print 1 )"

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
  console print 1
  """
  "1"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print "hey I'm new!"
  ﹍self
  myObject = MyClass new
  console print " ...done!"
  """
  "hey I'm new! ...done!"

  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print "hey I'm new!"
  ﹍@
  myObject = MyClass new
  console print " ...done!"
  """
  "hey I'm new! ...done!"

  # ---------------------------------------------------------------------------
  # in this case the assignment
  # consumes up to
  #    myObject = MyClass new
  # and then it breaks the chain
  # and lets "console print 1" loose
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍2
  ﹍self
  myObject = MyClass new console print 1
  """
  "1"

  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍2
  ﹍@
  myObject = MyClass new console print 1
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
  console print myObject
  """
  "2"

  # ---------------------------------------------------------------------------
  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print "hey I'm new!"
  ﹍self
  MyClass answer:
  ﹍initWith (param)
  by:
  ﹍console print param
  ﹍self
  myObject = MyClass new initWith " hello again! I am... "
  console print myObject
  """
  "hey I'm new! hello again! I am... object_from_a_user_class"

  """
  MyClass = Class new
  MyClass answer:
  ﹍whenNew
  by:
  ﹍console print "hey I'm new!"
  ﹍@
  MyClass answer:
  ﹍initWith (param)
  by:
  ﹍console print param
  ﹍@
  myObject = MyClass new initWith " hello again! I am... "
  console print myObject
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

  # ---------------------------------------------------------------------------
  # particularly useful extra indentation for repeat
  """
  a=5

  repeat forever:
  ﹍if a==0:
  ﹍﹍done
  ﹍else:
  ﹍﹍a=a minus 1
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
  ﹍﹍﹍a=a minus 1
  console print a
  """
  "0"


  # ---------------------------------------------------------------------------
  """
  codeToBeRun ='
  ﹍console print word
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
  ﹍whenNew
  by:
  ﹍self.instantiationsCounter increment
  ﹍self

  MyClass answer:
  ﹍getCount
  by:
  ﹍self.instantiationsCounter.counter

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
  ﹍whenNew
  by:
  ﹍@instantiationsCounter increment
  ﹍@

  MyClass answer:
  ﹍getCount
  by:
  ﹍@instantiationsCounter.counter

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
  ﹍whenNew
  by:
  ﹍self.instantiationsCounter increment
  ﹍self

  MyClass answer:
  ﹍getCount
  by:
  ﹍self.instantiationsCounter.counter

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
  ﹍whenNew
  by:
  ﹍@instantiationsCounter increment
  ﹍@

  MyClass answer:
  ﹍getCount
  by:
  ﹍@instantiationsCounter.counter

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
  # running with empty signature (which unfortunately is not really empty)
  # FLTO

  "to sayHello: ($nothing$) do: (console print \"Hello\"); sayHello;"
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
  """
  to 🚀:
  ﹍$nothing$
  do:
  ﹍console print "launch!"
  🚀
  """
  "launch!"

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
  # you can assign arbitrary things to a string token, including
  # objects which take the empty message
  # FLTO
  """
  to "🚀":
  ﹍$nothing$
  do:
  ﹍console print "launch!"
  "🚀"
  """
  "launch!"

  """
  to "🚀":
  ﹍console print "launch!"
  "🚀"
  """
  "launch!"

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
  "start - nil"

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
  " adding item: Hello  0 node is: object_from_a_user_class 0 node has item: Hello  1 node is: object_from_a_user_class 1 node has item: Hello  2 node is: object_from_a_user_class 2 node has item: Hello  list is empty now? true 3 node is: object_from_a_user_class 3 node has item: Hello  list is empty now? false list is empty now? false adding item: World 0 node is: object_from_a_user_class 0 node has item: World 1 node is: object_from_a_user_class 1 node has item: World 2 node is: object_from_a_user_class 2 node has item: World list is empty now? false list is empty now? false list contents: Hello World"

# ---------------------------------------------------------------------------
  """
  evaluationsCounter
  """
  "EvaluationsCounter running $nothing$ // "

  # $nothing$ is invoked multiple times as
  # the evaluationsCounter comes out as the
  # result of each parens...
  """
  (evaluationsCounter)
  """
  "EvaluationsCounter running $nothing$ // EvaluationsCounter running $nothing$ // "

  # $nothing$ is invoked multiple times as
  # the evaluationsCounter comes out as the
  # result of each parens...
  """
  ((((evaluationsCounter))))
  """
  "EvaluationsCounter running $nothing$ // EvaluationsCounter running $nothing$ // EvaluationsCounter running $nothing$ // EvaluationsCounter running $nothing$ // EvaluationsCounter running $nothing$ // "

]

###
# You can't mention a "@" (or "self") in this way, you'll
# get an infinite loop, as "@" (or "self") will be evaluated and
# run $nothing$ which will mention "@" (or "self"), which
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
      "break", FLBreak.createNew()
      "return", FLReturn.createNew()

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

      "evaluationsCounter", FLEvaluationsCounter.createNew()

      "nil", FLNil.createNew()

      "console", FLConsole.createNew()

      "'", FLQuote.createNew()
      ":", FLQuote.createNew()
    ]

    for keywords in [0...keywordsAndTheirInit.length] by 2
      [keyword, itsInitialisation] = keywordsAndTheirInit[keywords .. keywords + 1]
      outerMostContext.tempVariablesDict[ValidIDfromString keyword] = itsInitialisation

    messageLength = parsed.length()
    console.log "evaluation " + indentation() + "messaging workspace with " + parsed.flToString()

    # now we are using the message as a list because we have to evaluate it.
    # to evaluate it, we treat it as a list and we send it the empty message
    # note that "self" will remain the current one, since anything that
    # is in here will still refer to "self" as the current self in the
    # overall message.
    
    yieldMode = false
    #yieldMode = true
    if yieldMode
      gen = parsed.eval outerMostContext, parsed
      until (ret = gen.next()).done
        if ret.value?
          console.log "obtained: " + ret.value
        console.log "obtained: yieldingfromtoplevel"
      outerMostContext.returned = ret.value
    else
      outerMostContext.returned = parsed.eval outerMostContext, parsed

    console.log "evaluation " + indentation() + "end of workspace evaluation"

    if !outerMostContext.returned?
      if outerMostContext.unparsedMessage?
        unparsedPartOfMessage = " was sent message: " + outerMostContext.unparsedMessage.flToString()
      else
        unparsedPartOfMessage = ""
      console.log "evaluation " + indentation() + "no meaning found for: " + rWorkspace.lastUndefinedArom.value + unparsedPartOfMessage
      environmentErrors += "! no meaning found for: " + rWorkspace.lastUndefinedArom.value + unparsedPartOfMessage
      rWorkspace.lastUndefinedArom
    else
      if outerMostContext.throwing and outerMostContext.returned.flClass == FLException
        console.log "evaluation " + indentation() + "exception: " + outerMostContext.returned.value
        environmentErrors += "! exception: " + outerMostContext.returned.value


    console.log "final return: " + outerMostContext.returned?.value
    if environmentPrintout + environmentErrors == testResult
      OKs++
      console.log "...test " + (i/2+1) + " OK, obtained: " + environmentPrintout + environmentErrors
    else
      FAILs++
      console.log "...test " + (i/2+1) + " FAIL, test: " + testBodyMultiline + " obtained: " + environmentPrintout + environmentErrors + " expected: " + testResult

console.log "all tests done. obtained " + OKs + " OKs and " + FAILs + " FAILs"
