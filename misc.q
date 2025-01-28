//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Misc Utilities                                  //


/ create generically-typed version of a given dictionary
/ @param dict (Dict) Dictionary
/ @return (Dict) Dictionary of non-specified type
.misc.makeDictGenType:{[dict]
  (enlist[`]!enlist(::)),dict
 };

/ Index into list columns of a table
/ @param columns (SymbolList) Columns
/ @param booleans (BooleanList) Nested Boolean lists
/ @return (SymbolList) Columns
.misc.indexListColumns:{[columns;booleans]
  columns@'where each booleans
 };

/ Get count of sym file
/ @param sym (Symbol) Path to sym file
/ @return (Int) Count of sym file
.misc.getSymCount:{[sym]
  sum 0x00=8_read1 sym
 };
