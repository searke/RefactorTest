# refactorTest

A simple tool based on [Github's Scientist library](https://github.com/github/scientist) for testing refactorings.

refactorTest allows you to test your refactoring in production. It runs your old and new code side-by-side, reports when the new code behaves differently, and returns the old code's result.

## A Quick Example:
```Mathematica
result = refactorTest[
                  {myOldCode[input],
                   myNewCode[input]}];
```
Assuming no side-effects, this is functionally the same as:
```
result = myOldCode[input];
```
If the old and new code return different values, refactorTest will Print an error message with information about the difference. It will always return its first input, which should be the old code.

### Options:

refactorTest is configurable with many options:

 * "ID" A string identifying the refactorTest. By default, this is an empty String.
 * "Notes" A field for storing some values of interest. Notes is passed to the reporting function, so you can use it to record anything that might be relevant.
 * "FailReport" A function to report the failure if it should happen. This function is given a list of rules with relevant information. By default, "Report" is set to just Print a readable version of this list of information. The list of rules looks something like this:
```Mathematica
       {"ID" ->"theRefactorTestsID",
        "Notes" -> {whatever you gave notes},
        "OldCode" -> Hold[....],
        "NewCode" -> Hold[....],
        "SameTest" -> ....,
        "TimingInfo" -> {"OldCode" -> 1,  "NewCode" -> 2}
```
You may choose to replace "Report" with a function that logs this data to a Databin. Or maybe emails you. Or it could run VerificationTest to cause an error report in the test system.

 * "SameTest" A function to determine whether old and new code returned the same value. By default, this is SameQ. The function is ran with the old test as the first argument and the new test as a second argument.

 * "Active" A flag determining if the test should be ran. If set to False, RefactorTest will just run the old code and return its value. By default, this is True. You can use "Active" to run the test only under certain conditions. Or you can use it to run randomly choose to run the test some percentage of the time.

 * "CleanUp" Some code that should be ran between running the new and the old code. It is Nothing by default. This is used as a hack for when the function isn't pure and affects some global state. "CleanUp" can be used to revert any stateful changes made by the function. Since the "OldCode" is ran last, only its stateful changes should be preserved. 
 
 * "TimingReport" A function to apply to the timing data for both versions. This is Nothing by default, but is often used to log the timing data for later analysis.

 * "AllowedTimingSlowdown" How much slower the new function is allowed to run before it is considered a failure that should be reported to the Fail Reporter.

 * "TimeConstraint" How many seconds to allow for the new function to run before giving up. This isn't connected to "AllowedTimingSlowdown".

### Proposed Additions 

 * Memory consumption testing
 * Option to randomize order in which they're tested
 * Named Options for reporting to Databins
 * Catch Throws in New Code and generated messages and report failures when these differ
 * create a functional form where the function names can just be passed. 
```Mathematica
myFunction = RefactorTest[
                  {oldFunction,
                  newFunction}];
```
 * Create a more flexible system for user defined metrics like in [the Clojure version](https://github.com/yeller/laboratory)