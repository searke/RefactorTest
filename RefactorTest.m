nPackage["RefactorTest`"]

RefactorTest::usage = ""

Begin["Private`"]

Options[refactorTest] = { 
  "ID" :> "",
  "Notes" :> "",
  "Report" :> (Print["Refactor Test Failure:\n" <> TextString[#]] &),
  "SameTest" :> SameQ,
  "Active" :> True,
  "CleanUp" :> Nothing
  }

SetAttributes[refactorTest, HoldFirst];

refactorTest[{oldCode_, newCode_}, OptionsPattern[]] :=
 
 Module[{oldCodeValue, newCodeValue, oldCodeTiming, newCodeTiming},
  If[TrueQ[Not@OptionValue["Active"]],
   	oldCode,
   (*If Active*)
   	{oldCodeTiming, oldCodeValue} = 
    AbsoluteTiming[oldCode];
   	{newCodeTiming, newCodeValue} = AbsoluteTiming[newCode];
   	If[TrueQ[
     Not@OptionValue["SameTest"][oldCodeValue, newCodeValue]],
    	OptionValue["Report"][
     	{"ID" -> OptionValue["ID"], 
      	"Notes" -> OptionValue["Notes"],
      	"OldCode" -> Hold[oldCode],
      	"NewCode" -> Hold[newCode],
      	"SameTest" -> OptionValue["SameTest"],
      	"TimingInfo" -> {"OldCode" -> oldCodeTiming, 
        "NewCode" -> newCodeTiming}
      	}
     	]
    	];
   	OptionValue["CleanUp"];
   	oldCodeValue
   ]
  ];

Protect[refactorTest];

End[]

EndPackage[]
