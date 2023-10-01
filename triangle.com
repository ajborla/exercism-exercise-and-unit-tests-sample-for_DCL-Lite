$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: triangle
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 4)
$ if P5 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" .OR. P2 .EQS. "" then goto ArgError

$! Triangle types
$ Triangle_Equilateral = "equilateral"
$ Triangle_Isosceles = "isosceles
$ Triangle_Scalene = "scalene"

$! Reject invalid triangle type
$ if P1 .NES. Triangle_Equilateral .AND. -
     P1 .NES. Triangle_Isosceles .AND. -
     P1 .NES. Triangle_Scalene then goto TriangleTypeError

$! Reject non-numeric triangle sides
$ Is_Float_Value == 0
$!
$ call Is_Float_Value &P2
$ if Is_Float_Value .EQ. 1 then goto HandleFloats
$!
$ call Is_Float_Value &P3
$ if Is_Float_Value .EQ. 1 then goto HandleFloats
$!
$ call Is_Float_Value &P4
$ if Is_Float_Value .EQ. 1 then goto HandleFloats
$!
$ Is_Integer_Value == 0
$!
$ call Is_Integer_Value &P2
$ if Is_Integer_Value .EQ. 0 then goto TypeError
$!
$ call Is_Integer_Value &P3
$ if Is_Integer_Value .EQ. 0 then goto TypeError
$!
$ call Is_Integer_Value &P4
$ if Is_Integer_Value .EQ. 0 then goto TypeError

$! Core logic starts here - P2, P3, P4 are integer values
$ Main:

$! Ensure triangle side arguments are treated as integers, not strings
P2 = F$INTEGER(P2)
P3 = F$INTEGER(P3)
P4 = F$INTEGER(P4)

$! Reject non-positive values
$ if P2 .LT. 0 .OR. P3 .LT. 0 .OR. P4 .LT. 0 then goto FalseTest

$! Reject degenerate triangles
$ if (P2 + P3) .LE. P4 then goto FalseTest
$ if (P2 + P4) .LE. P3 then goto FalseTest
$ if (P3 + P4) .LE. P2 then goto FalseTest

$! Triangle type criteria checks
$ if P1 .EQS. Triangle_Equilateral
$ then
$    if P2 .EQS. P3 .AND. P2 .EQS. P4 then goto TrueTest
$ endif

$ if P1 .EQS. Triangle_Isosceles
$ then
$    if P2 .EQ. P3 .OR. P2 .EQ. P4 .OR. P3 .EQ. P4 then goto TrueTest
$ endif

$ if P1 .EQS. Triangle_Scalene
$ then
$    if P2 .NE. P3 .AND. P2 .NE. P4 .AND. P3 .NE. P4 then goto TrueTest
$ endif

$! Triangle does not meet any criterion
$ goto FalseTest

$! Normal handlers
$ HandleFloats:
$! Convert floats into integers by multiplying using a scaling factor, SF. Note, need to
$!  shell out to *NIX since operation involves floating point values which are not
$!  supported in DCL.
$   SF = 100
$   shell rm -f RESULT_* 2> /dev/null
$   shell final=""; for result in $(echo &SF \* &P2 | bc -l | tr . X) $(echo &SF \* &P3 | bc -l | tr . X) $(echo &SF \* &P4 | bc -l | tr . X) ; do final+="-"${result} ; done ; touch RESULT_${final} 2> /dev/null
$   RESULT = F$ELEMENT(0,".",F$ELEMENT(1,"_",F$ELEMENT(1,"]",F$SEARCH("RESULT_*.*",1))))
$   P2 = F$ELEMENT(0,"X",F$ELEMENT(1,"-",RESULT))
$   P3 = F$ELEMENT(0,"X",F$ELEMENT(2,"-",RESULT))
$   P4 = F$ELEMENT(0,"X",F$ELEMENT(3,"-",RESULT))
$   shell rm -f RESULT_* 2> /dev/null
$   goto Main
$!
$ TrueTest:
$   write Sys$Output "true"
$   exit 0
$!
$ FalseTest:
$   write Sys$Output "false"
$   exit 0

$! Error handlers
$ ArgError:
$   Msg = "ERROR: Invalid arguments. "
$   goto ErrorExit
$ TypeError:
$   Msg = "ERROR: Only positive numbers allowed. "
$   goto ErrorExit
$ TriangleTypeError:
$   Msg = "ERROR: Invalid triangle type. "
$ ErrorExit:
$   Usage = "USAGE: @triangle " + -
            "equilateral|isosceles|scalene A B C"
$   write Sys$Output (Msg + Usage)
$   exit %X2A

$!
$! Subroutines
$!
$ Is_Integer_Value: subroutine
$   Input = F$INTEGER(P1)
$   FirstChar = F$EDIT(F$EXTRACT(0,1,P1),"COLLAPSE,UPCASE")
$   if (Input .EQ. 0) .AND. (FirstChar .NES. "0") then -
      goto Not_Integer_Value
$   if (Input .EQ. 1) .AND. -
       ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then -
      goto Not_Integer_Value
$ Integer_Value:
$   Is_Integer_Value == 1
$   exit 0
$ Not_Integer_Value:
$   Is_Integer_Value == 0
$ endsubroutine
$!
$ Is_Float_Value: subroutine
$   if F$LOCATE(".",P1) .GE. F$LENGTH(P1) then goto Not_Float_Value
$   Whole = F$ELEMENT(0,".",P1)
$   Fract = F$ELEMENT(1,".",P1)
$   Is_Integer_Value == 0
$   call Is_Integer_Value &Whole
$   if Is_Integer_Value .EQ. 0 then goto Not_Float_Value
$   Is_Integer_Value == 0
$   call Is_Integer_Value &Fract
$   if Is_Integer_Value .EQ. 0 then goto Not_Float_Value
$ Float_Value:
$   Is_Float_Value == 1
$   exit 0
$ Not_Float_Value:
$   Is_Float_Value == 0
$ endsubroutine

