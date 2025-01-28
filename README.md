# haq-paq

The haq-paq General Utilities Library from Version 1 allows developers to get a head start on writing many of the basic utility functions found across q codebases. The library is split across themed packages with each package existing as an independent, easily loadable q script.

For documentation on how to use the functions, click [here](https://version1.github.io/haq-paq/).

## Unit Tests

These libraries (except the benchmark library) have unit tests which are stored in a private repository.

## Maths Library
Covers a wide range of functionality that is normally found in other packages for languages (such as Python's NumPy).
This package includes prime number calculation, list creation functions similar to those that exist in NumPy (such as linspace), calculating modal values and rounding functionality.

## Chrono Library
Has a variety of useful functions to assist when working with dates or timestamps in q.
This package includes getting start/end dates of a week/month, returning only weekdays from a range
of dates or converting timestamps between Unix and q .

## Format Library
Useful for formatting information into strings, such as making numbers human readable,
adding comma separators and replacing text tokens (similar to `format()` in Python).

## Log Library
A basic standardized way to write messages, errors and memory stats to log files.

## Benchmark Library
Simple ways of benchmarking execution times for subsections of functions.

## Table Library
Contains a wide variety of helpful functionality for dealing with tables.
This ranges from fixing issues with splayed tables on disk to using integer partitioning.

## Miscellaneous library
Includes extra utility functions such as efficiently counting a sym file's length and generically typed dictionary creation.

## Contributors

* Kyle Bonnes
* Conor Swain
* Samantha Devlin
* Chris Murphy
* Michal Hasson
* Chris Foster
* Sean Hehir
* Carlos Sanchez
* Brooke Hopley
* Thomas Smyth
