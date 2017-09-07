BeginPackage["RefactorTest`"]

refactorTest::usage = 
"RefactorTest[{oldCode, newCode}, options...]
A utility for testing refactored code.
Runs both oldCode and newCode but only returns oldCode.
Issues a report if the results are not the same.
Assumes code is pure (stateless) so that the results can be compared."

Begin["Private`"]

Options[refactorTest] = { 
  "ID" :> "",
  "Notes" :> "",
  "Report" :> (Print["Refactor Test Failure:\n" <> TextString[#]] &),
  "SameTest" :> SameQ,
  "Active" :> True,
  "CleanUp" :> (Nothing;)};

SetAttributes[refactorTest, HoldFirst];

refactorTest[{oldCode_, newCode_}, OptionsPattern[]] :=
	refactorTestInternal[
		{oldCode, newCode}, 
		OptionValue[{"Active", "ID", "Notes", "SameTest", "Report", "CleanUp"}]];
	
SetAttributes[refactorTestInternal, HoldFirst];	
(* Unactive *)
refactorTestInternal[{oldCode_, newCode_}, {(*active*) False, ___}]:=
	oldCode;
	
(* Active *)	
refactorTestInternal[{oldCode_, newCode_}, {(*active*) True, id_, notes_, sameTest_, report_, cleanUp_}]:=
 Module[{oldCodeValue, newCodeValue, oldCodeTiming, newCodeTiming},
   	{oldCodeTiming, oldCodeValue} = AbsoluteTiming[oldCode];
   	{newCodeTiming, newCodeValue} = AbsoluteTiming[newCode];
   	If[TrueQ[Not@sameTest[oldCodeValue, newCodeValue]],
    	report[
	     	<|"ID" -> id, 
	      	"Notes" -> notes,
	      	"OldCode" -> Hold[oldCode],
	      	"NewCode" -> Hold[newCode],
	      	"SameTest" -> sameTest,
	      	"TimingInfo" -> <|"OldCode" -> oldCodeTiming, "NewCode" -> newCodeTiming|>|>
	]];
   	cleanUp;
   	oldCodeValue
   ];
Protect[refactorTestInternal];

End[]

EndPackage[]
