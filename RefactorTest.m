BeginPackage["RefactorTest`"]

refactorTest::usage = 
"RefactorTest[{oldCode, newCode}, options...]
A utility for testing refactored code.
Runs both oldCode and newCode but only returns oldCode.
Issues a report if the results are not the same.
Assumes code is pure (stateless) so that the results can be compared.";

refactorTest::invalid = 
"refactorTest was given invalid arguments";

Begin["Private`"]

Options[refactorTest] = { 
  "ID" :> "",
  "Notes" :> "",
  "FailReport" :> (Print["Refactor Test Failure:\n" <> TextString[#]] &),
  "SameTest" :> SameQ,
  "Active" :> True,
  "CleanUp" :> (Nothing;),
  "TimingReport" :> (Nothing;),
  "AllowedTimingSlowdown":> 4,
  "TimeConstraint"-> 60};

SetAttributes[refactorTest, HoldFirst];

refactorTest[{oldCode_, newCode_}, OptionsPattern[]] :=
	refactorTestInternal[
		{oldCode, newCode}, 
		OptionValue[{"Active", "ID", "Notes", "SameTest", "FailReport", "CleanUp", "TimingReport", "AllowedTimingSlowdown", "TimeConstraint"}]];
	
refactorTest[else__] := Message[refactorTest::invalid];	
	
SetAttributes[refactorTestInternal, HoldFirst];	
(* Unactive *)
refactorTestInternal[{oldCode_, newCode_}, {(*active*) False, ___}]:=
	oldCode;
	
(* Active *)	
refactorTestInternal[
	{oldCode_, newCode_}, 
	{(*active*) True, id_, notes_, sameTest_, failReport_, cleanUp_, timingReport_, allowedTimingSlowdown_, timeConstraint_}]:=
 		Module[{oldCodeValue, newCodeValue, oldCodeTiming, newCodeTiming},
		 	(* Evaluate Both VSersions *)
		   	{newCodeTiming, newCodeValue} = TimeConstrained[AbsoluteTiming[newCode], timeConstraint, {Infinity, "Did not finish in TimeConstraint"}];
		   	cleanUp;
		   	{oldCodeTiming, oldCodeValue} = AbsoluteTiming[oldCode];
		   	
		   	(* Call Report Functions If Needed *)
		   	With[{reportContent = 
		   		<|"ID" -> id,
		   		  "SameTest" -> sameTest,
		   		  "Notes" -> notes,
			      "OldCode" -> Hold[oldCode],
			      "NewCode" -> Hold[newCode],
			      "TimingInfo" -> <|"OldCode" -> oldCodeTiming, "NewCode" -> newCodeTiming|>|>},
		   	
			   	timingReport[reportContent];
			   	
			   	If[TrueQ[Not@TrueQ@sameTest[oldCodeValue, newCodeValue]],
			    	failReport@Append[reportContent, "FailCause" ->  "Results Unsame"]];
				
				If[TrueQ[allowedTimingSlowdown * newCodeTiming > oldCodeTiming],
					failReport@Append[reportContent, "FailCause" ->  "Evaluation Timing Slower"]];
			   	];
		   	oldCodeValue
		 ];
Protect[refactorTestInternal];

End[]

EndPackage[]
