# RefactorTest

A simple tool based on [Github's Scientist library](https://github.com/github/scientist) for testing refactorings.

RefactorTest allows you to test your refactoring in production. It runs your old and new code side-by-side, reports when the new code behaves differently, and returns the old code's result.

## A Quick Example:
```Mathematica
result = RefactorTest[
                  myOldCode[input],
                  myNewCode[input]];
```
Assuming no side-effects, this is functionally the same as:
```
result = myOldCode[input];
```
If the old and new code return different values, RefactorTest will Print an error message with information about the difference. It will always return it's first input, which should be the old code.

### Options:

Refactor test is configurable with many options:

 * "ID" A string identifying the RefactorTest. By default, this is an empty String.
 * "Notes" A field for storing some values of interest. Notes is passed to the reporting function, so you can use it to record anything that might be relevant.
 * "Report" A function to report the failure if it should happen. This function is given a list of rules with relevant information. By default, "Report" is set to just Print a readable version of this list of information. The list of rules looks something like this:
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
Git
