//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Mathematics Utilities                           //

/ Get an num-day average count for a table with x distinct dates in it (x>=num)
/ @param datecol (DateList) date column
/ @param num (Long) number of days before today to consider
/ @return (FloatList) average number of entries per date where records for date exist
.maths.avgCntForXDays:{[datecol;num]
  count[l]%count distinct l:datecol inter .z.d-til num
 };

/ Greatest common divisor of 2 integers
/ @param num1 (Long) number 
/ @param num2 (Long) number
/ @return (Long) greatest common divisor
.maths.gcd:{[num1;num2]
  $[num2=0;
    abs num1;
    .z.s[num2;num1 mod num2]
   ]
 };

/ Lowest common multiple of 2 integers
/ @param num1 (Long) number 
/ @param num2 (Long) number
/ @return (Long) lowest common multiple
/ @see .maths.gcd
.maths.lcm:{[num1;num2]
  abs(num1*num2)div .maths.gcd[num1;num2]
 };

/ Round num to decplaces decimal place
/ @param decplaces (Long) number of decimal places to round to
/ @param num (Float) number to round 
/ @return (Float) rounded number
.maths.round:{[decplaces;num]
  %[;dv]`long$num*dv:10 xexp decplaces
 };

/ Replicate Python functionality for linspace
/ <br> Return num evenly spaces samples, calculated over the interval [start,stop] </br>
/ @param start (Long|Float) number at beginning of range 
/ @param stop (Long|Float) number at end of range 
/ @param num (Long) count of range
/ @return (FloatList) evenly spaced list of count num, spanning [start,stop] (not including stop)
.maths.linspace:{[start;stop;num]
  start+til[num]*(stop-start)%num
 };

/ @param start (Long|Float) number at beginning of range 
/ @param stop (Long|Float) number at end of range 
/ @param num (Long) count of range
/ @return (FloatList) evenly spaced list of count num, spanning [start,stop] (including stop)
.maths.linspaceWithY:{[start;stop;num]
  start+til[num]*(stop-start)%num-1
 };

/ Return the discriminant of ax^2 + bx + c
/ @param a (Float) coefficient of x^2 
/ @param b (Float) coefficient of x
/ @param c (Float) constant of the quadratic
/ @return (Float) the discrimant of the quadratic 
.maths.getDiscriminant:{[a;b;c]
  (b*b)-4*a*c
 };

/ Return the solutions to ax^2 + bx + c = 0 (returns nulls for complex roots)
/ @param a (Float) coefficient of x^2 
/ @param b (Float) coefficient of x
/ @param c (Float) constant of the quadratic
/ @return (FloatList) returns roots of the quadratic
/ @see .maths.getDiscriminant
.maths.solveQuadratic:{[a;b;c]
  (1%a*2)*neg[b]+1 -1*sqrt .maths.getDiscriminant[a;b;c]
 };

/ Return the mode of a list
/ @param lst (List) list of numbers 
/ @return (List) mode of the list 
.maths.getListMode:{[lst]
  where max[c]=c:count each group lst
 };

/ Truncate (round towards 0) num to decplaces decimal places
/ @param decplaces (Long) number of decimals 
/ @param num (Float) number to be truncated
/ @return (Float) truncated float 
.maths.truncate:{[decplaces;num]
  $[decplaces=0;
    $[num<0;ceiling;floor]num;
    $[num<0;-1;1]*%[;dv] floor abs num*dv:10 xexp decplaces
   ]
 };

/ Return the factorial of a non-negative integer, num
/ @param num (Long) number
/ @return (Long) returns the factorial of the number 
.maths.factorial:{[num]
  prd 1+til num
 };

/ Return the num-th prime number
/ @param num (Long) number
/ @return (Long) the num-th prime number
/ @see .maths.getXPrimes
.maths.nthPrime:{[num]
  last .maths.getXPrimes num
 };

/ Return the first num prime numbers
/ @param num (Long) number
/ @return (LongList) list of first num prime numbers
.maths.getXPrimes:{[num]
  if[num<6;
    :num#2 3 5 7 11
  ];
  list:2_til ceiling num*log[num]+log log num;
  num sublist {x except 1_x where 0=x mod x y}/[list;til ceiling sqrt num]
 };

/ Return all prime numbers less than num
/ @param num (Long) number
/ @return (LongList) all prime numbers less than num
.maths.listPrimes:{[num]
  {x except 1_x where 0=x mod x y}/[2_til num;til "j"$sqrt num]
 };

/ Replicate pandas.DataFrame to a limited degree
/ @param r (SymbolList) list of rows
/ @param c (SymbolList) ist of cols
/ @param df (Table|Symbol) pivot table or ` (to return empty pivot table)
/ @return (Table) pivot of dimensions r and c 
.maths.createPandasDF:{[r;c;df]
  v:enlist count[r]#0f;
  pvt:1!flip(`index,c)!enlist[r],count[c]#v;
  if[df~`;:pvt];
  pvt upsert df
 };
