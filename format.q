//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Formatting Utilities                            //


/ Format a number with k/M to denote thousand/million. 
/ Example: {@code .format.formatNum[0;1213000]}
/ @param decplaces (Int|Long) Number of decimal places 
/ @param num (Short|Int|Long|Float) Number to format
/ @return (String) Formatted number string
.format.formatNum:{[decplaces;num]
  dict:(`s#0 4 7 10!" kMB");
  trim ($[decplaces=0;-1_;].Q.f[decplaces;num%10 xexp 3*(c-1)div 3]),dict c:count string floor abs num
 };

/ Format a number with commas
/ @param num (Int|Long) Number to format
/ @param incDec (Bool) whether to include the decimal values
/ @return (String) Formatted number string
.format.commaSepNum:{[num;incDec]
  res:reverse","sv 3 cut reverse $[ne:num<0;1_;]string`long$num;
  if[incDec&"."in string num;res:res,".",last "."vs string num];
  $[ne;"-",;]res
 };

/ Substitute values into a string, mapping using input dictionary
/ @param msg (String) String including tokens ({@code $key1, $key2,...}) that are keys of &nbsp {@code dict}. Example:&nbsp {@code msg:"The count is $cnt, the overall value is $val and the user is $u"}
/ @param dict (Dict) Dictionary mapping tokens to the atomic values to replace them with. Example:{@code dict:`cnt`val`u!(10;1500f;`chris)}
/ @return (String) Formatted string
.format.customSSR:{[msg;dict]
  s:"$",'string k:desc key dict;
  ssr/[msg;s;string dict k]
 };

/ Substitute values into a string, mapping using the order of input list
/ @param msg (String) String including token ({@code $0, $1,...}) values to be replaced. Example:&nbsp {@code "The count is $0, the overall value is $1 and the user is $2"}
/ @param list (List) Atomic values to replace tokens with. Example:{@code list:(10;1500f;`chris)}
/ @return (String) Formatted string
.format.customSSRByOrder:{[msg;list]
  s:"$",'string til count list;
  ssr/[msg;s;string list]
 };
