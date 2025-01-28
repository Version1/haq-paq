//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Benchmark Utilities                             //


/ Log the stats of a function's runtime
/ @param func (Symbol) Function name
/ @param args (List) Function input(s) as a list
.bench.logBench:{[func;args]
  `.bench.BenchRunTime upsert`runtime`function`args`time`space!.z.p,func,(`$.Q.s1[args]),first .Q.ts[func;args]
 };

/ Table for tracking function runtimes
.bench.BenchRunTime:flip`runtime`function`args`time`space!"pssjj"$\:();
/ Table for tracking each line's runtime in a function
.bench.BenchEachStep:flip`function`section`datetime!"ssp"$\:();

/ Basic upsert which records the time when a section of a function was executed
/ @param func (Symbol) Function name
/ @param sect (Symbol) Section of function (some symbol name identifier to identify function section)
.bench.logStep:{[func;sect]
  `.bench.BenchEachStep upsert (func;sect;.z.P)
 };

/ @param func (Symbol) Function name
/ @return (Table) Table containing time taken to execute section
/ @see .bench.BenchEachStep
.bench.returnTimeStep:{[func]
  update diff:-':[`time$first datetime;`time$datetime] from select from .bench.BenchEachStep where function=func
 };
