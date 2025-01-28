//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Log Utilities                                   //


/ Format memstats to write to log
/ @return (String) Pipe separated memory stats
.log.getMemStats:{[]
  "|" sv "=" sv/: string key[w],'value w:.Q.w[]
 };

/ Table storing error messages
.log.Error:flip`time`message!"ps"$\:()

/ Publish log message and memstats to stdout
/ @param msg (String) Log message
/ @see .log.getMemStats
.log.publishInfo:{[msg]
  -1 "INFO ",.log.getMemStats[]," ",msg;
 };

/ Publish error message and memstats to stderr
/ @param msg (String) Log message
/ @see .log.getMemStats
.log.publishError:{[msg]
  -2 "ERROR ",.log.getMemStats[]," ",msg;`.log.Error upsert (.z.p;`$msg)
 };
