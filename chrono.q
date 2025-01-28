//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Chrono Utilities                                //


/ Return the date at the start of the month
/ @param date (Date) Any date
/ @return (Date) First day of given month
.chrono.getMonthStart:{[date]
  `date$`month$date
 };

/ Return the date at the end of the month
/ @param date (Date) Any date
/ @return (Date) Last day of given month
.chrono.getMonthEnd:{[date]
  (`date$1+`month$date)-1
 };

/ Return the date at the start of the week
/ @param date (Date) Any date
/ @return (Date) First day of given week
.chrono.getWeekStart:{[date]
  `week$date
 };

/ Return the date at the end of the week
/ @param date (Date) Any date
/ @return (Date) Last day of given week
.chrono.getWeekEnd:{[date]
  6+`week$date
 };

/ Return the date at the start of the year
/ @param date (Date) Any date
/ @return (Date) First date of given year
.chrono.getYearStart:{[date]
  "D"$string[`year$date],".01.01"
 };

/ Return the date at the end of the year
/ @param date (Date) Any date
/ @return (Date) Last date of given year
.chrono.getYearEnd:{[date]
  "D"$string[`year$date],".12.31"
 };

/ Return most recent weekday
/ @param date (Date) Any date
/ @return (Date) Most recent weekday
.chrono.getPrevWeekday:{[date]
  date-m*3>m:1+date mod 7
 };

/ Return a list of previous non Saturday/Sunday dates from given date
/ @param date (Date) Return previous weekdays as of this date
/ @param num (Int|Long) Number of dates to return
/ @return (DateList) List of weekdays
.chrono.getWeekDays:{[date;num]
  l:date-til 7*1+num div 5;
  num sublist l where not(l mod 7)in 0 1
 };

/ Convert second-based Unix timestamp to kdb timestamp
/ @param seconds (Long) Second-based Unix timestamp
/ @return (Timestamp) kdb timestamp
.chrono.unixToQ:{[seconds]
  "p"$("j"$1970.01.01D00:00)+seconds*1e9
 };

/ Convert kdb timestamp to second-based Unix timestamp (equivalent to date +%s)
/ @param timestamp (Timestamp) kdb timestamp
/ @return (Long) Second-based Unix timestamp
.chrono.qToUnix:{[timestamp]
  floor(("j"$timestamp)-"j"$1970.01.01D00:00)%1e9
 };

/ Convert millisecond-based Unix timestamp to kdb timestamp
/ @param milliseconds (Long) Millisecond-based Unix timestamp
/ @return (Timestamp) kdb timestamp
.chrono.unixToQMS:{[milliseconds]
  1970.01.01+0D00:00:00.001*milliseconds
 };

/ Convert kdb timestamp to millisecond-based Unix timestamp (equivalent to date +%s%3N)
/ @param timestamp (Timestamp) kdb timestamp
/ @return (Long) Millisecond-based Unix timestamp
.chrono.qToUnixMS:{[timestamp]
  "j"$(timestamp-1970.01.01D0)%0D00:00:00.001
 };

/ Modify date format.
/ Example: {@code .chrono.formatDate[`d`m`y;.z.d;"-"]}
/ @param format (SymbolList) Date format to return, accepts {@code `d`m`y`y2}
/ @param date (Date) Any date
/ @param delim (Char|String) Delimiter
.chrono.formatDate:{[format;date;delim]
  d:"0"^-2$k!string(`d`m!`dd`mm)[k:format except`y`y2]$date;
  d:d,(format inter`y`y2)!enlist $[`y2 in format;{-2$string x};string]`year$date;
  delim sv d format
 };
