//--------------------------------------------------------------------------//
//                          Version 1 Genernal Utilities                    //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Table Utilities                                 //


/ Return resolved table if a reference to a table is passed
/ @param tblOrSym (Table|Symbol) Table or reference to a table to resolve
/ @return (Table) Resolved table
.tbl.resolve:{[tblOrSym]
  $[-11h=type tblOrSym;value;]tblOrSym
 };

/ Denumerate table or reference to a table
/ @param tblOrSym (Table|Symbol) Table or reference to a table to resolve
/ @return (Table) Denumerated table
/ @see .tbl.resolve
.tbl.denum:{[tblOrSym]
  enumCols:where (type each flip res:0!.tbl.resolve tblOrSym)within 20 76h;
  keys[tblOrSym]xkey ![res;();0b;enumCols!value ,/:enumCols]
 };

/ Create a pivot table dynamically 
/ @param tbl (Table) table 
/ @param g (Symbol) column to group by
/ @param c (Symbol) column to become the key of pivot table
/ @param v (Symbol) column which becomes the values in the pivot table
/ @return (Table) Pivot table
.tbl.createPivot:{[tbl;g;c;v]
  s:asc?[tbl;();();(distinct;c)];
  ?[tbl;();enlist[g]!enlist g;](#;enlist s;(!;c;v))
 };

/ Multi pivot for x columns
/ @param tbl (Table) table 
/ @param g (Symbol) column to group by
/ @param c (Symbol) column to become the key of pivot table
/ @param vl (SymbolList) column(s) which becomes the values in the pivot table
/ @return (Table) Pivot table
/ @see .tbl.createPivot
.tbl.createMultiPivot:{[tbl;g;c;vl]
  raze{[tbl;g;c;v](`ky,g) xkey update ky:v from .tbl.createPivot[tbl;g;c;v]}[tbl;g;c]each vl
 };

/ Convert from a pivot table to a normal kdb table
/ @param tbl (Table) Pivot table 
/ @param g (Symbol) column which is grouped
/ @param c (Symbol) column which is the key of the pivot table
/ @param v (Symbol) column which becomes the values in the pivot table
/ @return (Table) normal table
.tbl.convertFromPivot:{[tbl;g;c;v]
  tbl:0!tbl;
  cls:cols[tbl]except g;
  flip (g;c;v)!raze each(count[cls]#enlist ?[tbl;();();g];count[tbl]#/:cls;tbl cls)
 };

/ Create link(s) between a table of data and x other tables
/ @param tbl (Table) Table of data to add links
/ @param lnkTbl (SymbolList) Global table names which will be linked to the data
/ @return (Table) The first table input with the links added from the global tables
.tbl.link:{[tbl;lnkTbl]
  tbl lj k xkey?[lnkTbl;();0b;](k,lower lnkTbl)!(k:keys lnkTbl),enlist(!;enlist lnkTbl;`i)
 }/;

/ Relink data to a table which has a link and the static(ish) table has been updated
/ @param tbl (Table) the update of the link reference table 
/ @param gt (Symbol) Global table
/ @param lt (Symbol) Linked table
/ @return (Symbol) name of updated table.
/ @see .tbl.link
.tbl.relink:{[tbl;gt;lt]
  ky:keys tbl;
  tbl:?[gt;;0b;()]enlist(in;(flip;(!;enlist ky;enlist,ky));key tbl);
  gt upsert .tbl.link[tbl;lt]
 };

/ Check which tables are linked to the input 
/ @param tblName (Symbol) table name 
/ @return (SymbolList) list of tables that have the input linked to them
.tbl.isLinked:{[tblName]
  where tables[]!{x in fkeys y}[tblName]each tables`
 };

/ Resave the splay table with all columns truncated to the length of the shortest one
/ <br> In the event of columns of a splay having different lengths </br>
/ @param dir (Symbol) Directory where splay table is stored
.tbl.fixSplayCnt:{[dir]
  m:min count each c:get each `$(string[dir],"/"),/:string cols dir;
  (hsym `$string[dir],"/") set flip cols[dir]!m#/:c
 };

/ Output csv as a table of strings without the need for the number of columns to be known
/ @param file (Symbol) filename
/ @return (Table) Table of strings from input csv
.tbl.loadCsvWithStrings:{[file]
  n:1+sum ","=first c:read0 file;
  (n#"*";enlist",")0:c
 };

/ Output csv as a table conforming to a given table's column-types
/ @param file (Symbol) csv file 
/ @param tbl (Table|Symbol) raw table or table name as a symbol 
/ @return (Table) Table with data from csv and column types from tbl
.tbl.loadCsvWithSchema:{[file;tbl]
  (upper (0!meta tbl)`t;enlist",")0:file
 };

/ Check if a table is keyed or not
/ @param tbl (Table|Symbol) table or table name 
/ @return (Boolean) True/false depending on if table is keyed/unkeyed
.tbl.isKeyed:{[tbl]
  0<count keys tbl
 };
 
/ Run a comparison between 2 tables for the columns in those tables
/ <br>If the table is keyed will only consider the keyed columns </br>
/ @param f (Function) function to do comparison, example inter, except, etc
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @return (Table) Subset of data depending on the function
/ @see .tbl.isKeyed
.tbl.comparison:{[f;tbl1;tbl2]
  b1:$[.tbl.isKeyed tbl1;keys;cols] tbl1;
  b2:$[.tbl.isKeyed tbl2;keys;cols] tbl2;
  cls:b1 inter b2;
  (f). ?[;();0b;cls!cls]each(tbl1;tbl2)
 };

/ Projection of comparison for just except
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @return (Table) Subset of data after applying except
/ @see .tbl.comparison
.tbl.compExcept:.tbl.comparison[except];

/ Projection of comparison for just inter
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @return (Table) Subset of data after applying inter 
/ @see .tbl.comparison
.tbl.compInter:.tbl.comparison[inter];

/ Compare 2 tables for a specific check
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @param check (Symbol) 3 types of checks `identical/`count/`subset
/ @return (Boolean) True/false depending on if check is passed/failed
.tbl.tabCompare:{[tbl1;tbl2;check]
  if[check~`identical;:(~).-8!/:(tbl1;tbl2)];
  if[check~`count;:count[tbl1]~count tbl2];
  if[check~`subset;:0=count tbl2 except tbl1]
 };

/ Rename columns in a table using a map (for pre3.6 versions of kdb+)
/ @param dict (Dict) dictionary to rename cols
/ @param tbl (Table) table
/ @return (Table) table with renamed columns specified in the dictionary
.tbl.renameColumns:{[dict;tbl]
  {y^x y}[dict;cols tbl] xcol tbl
 };

/ Efficiently union join over a given list of tables
/ @param tbls (List) list of tables to union join together
/ @return (Table) Result of appling union join over tbls input 
.tbl.optimalUnionOver:{[tbls]
  (uj/) raze each tbls group cols each tbls
 };

/ Create an integer partition database to store a table on disk
/ @param path (String) directory path
/ @param partName (Symbol) partition name
/ @param tblName (Symbol) table name
/ @param tbl (Table) table to save to disk
.tbl.createIntPart:{[path;partName;tblName;tbl]
  .Q.ens[p:hsym`$path;;`intMap]([]id:(),partName);
  hsym[`$path,"/",string[intMap?partName],"/",string[tblName],"/"]set .Q.en[p;tbl];
 };
 
/ Save or updates a table to an integer partition database.
/ <br>Note you need to have a reference on intMap in memory otherwise will default to .tbl.createIntPart</br>
/ @param path (String) directory path
/ @param partName (Symbol) partition name
/ @param tblName (Symbol) table name
/ @param tbl (Table) table to save to disk
/ @see .tbl.createIntPart
.tbl.saveDataToIntPart:{[path;partName;tblName;tbl]
   if[intMap in value"\\v";
     if[tblName in intMap;
	    tbl:.Q.en[p:hsym`$path;tbl];
	    :hsym[`$path,"/",string[intMap?partName],"/",string[tblName],"/"]upsert tbl
	   ];	 
	];
  .tbl.createIntPart[path;partName;tblName;tbl]
 };

/ Selectively ungroup a table by a subset of columns
/ @param tbl (Table) Unkeyed table to ungroup
/ @param columns (SymbolList) Column(s) to ungroup by
/ @return (Table) Ungrouped table
.tbl.ungroupBy:{[tbl;columns]
  if[0=count columns;:tbl];
  raze{enlist[x]cross ungroup enlist y}'[tbl;((),columns)#tbl]
 };

/ Return size of file in bytes
/ @param filePath (Symbol)  path to the file we want to know the size of
/ @return (Long)            size of files on disk in bytes
.tbl.getFileSizeOnDisk:{[filePath]
  zstats:-21!filePath:hsym filePath;
  $[count zstats;
    zstats[`compressedLength];
    hcount filePath
  ]
 };

/ Return top-level contents of a HDB with references in par.txt resolved
/ @param hdbDir (Symbol)  path to segmented or partitioned db
/ @return (Symbol List)   path of each partition in the db
.tbl.getTopLevelDBContents:{[hdbDir]
  $[`par.txt in k:key hdbDir;
    {` sv/:raze x,/:'key each x}[hsym`$read0` sv hdbDir,`par.txt];
    ` sv/:hdbDir,/:k
  ]
 };

/ Given a directory and a table name in that directory, return as a list
/ <br> the paths to the individual columns of a table if splayed or
/ <br> the path to the table if it is a flat file
/ @param dir (Symbol) directory path
/ @param tblName (Symbol) table in dir that we want to expand the contents of
/ @return (SymbolList) One of Path to the table (if a flat file), paths to table columns (if splayed), empty list if no match found for tblName
.tbl.getOnDiskContents:{[dir;tblName]
  dir:hsym dir;
  k:(),key dir;
  if[not (tblName in ` vs dir) or any raze tblName=` vs/:k;
    :`$()
  ];
  if[dir ~ k;
    :k
  ];
  if[tblName in k;
    :{$[x~key x;(),x;` sv/:x,/:key x]}[` sv dir,tblName]
  ];
  if[tblName in ` vs dir;
    :` sv/:dir,/:k
  ];
  `$()
 };

/ Get the size of tables on disk
/ @param path (Symbol) path to hdb
/ @param tblName (Symbol) table name
/ @return (Table) Size of table under each partition
/ @see .tbl.getFileSizeOnDisk
/ @see .tbl.getTopLevelDBContents
/ @see .tbl.getOnDiskContents
.tbl.getTableSizeOnDisk:{[hdbDir;tblName]
  if[not count key hdbDir;'"hdb not populated"];
  dbContents:.tbl.getTopLevelDBContents[hdbDir];
  files:.tbl.getOnDiskContents[;tblName] each dbContents;
  w:where 0<count each files;
  partitionType:"DMJJ"[10 7 4?count string last ` vs first dbContents];
  files:files[w];
  dbContentsSplit:` vs/:dbContents[w];
  sizes:sum each .tbl.getFileSizeOnDisk''[files];
  ([]
    path:first each dbContentsSplit;
    part:partitionType$string last each dbContentsSplit;
    tblName;
    fileSizeBytes:sizes
  )
 };

/ Get a breakdown of the total DB size on a per-file basis
/ @param path (Symbol) path to hdb
/ @return (Table) Size of each entity below the given directory
/ @see .tbl.getFileSizeOnDisk
/ @see .tbl.getTopLevelDBContents
.tbl.getTotalDBSizeOnDiskByFile:{[hdbDir]
  if[not count key hdbDir;'"hdb not populated"];
  dbContents:.tbl.getTopLevelDBContents[hdbDir];
  allFiles:raze {if[x~k:key x;:(),x]; raze .z.s each ` sv/:x,/:k} each dbContents;
  ([] path:allFiles; fileSizeBytes:sum each .tbl.getFileSizeOnDisk each allFiles)
 };
