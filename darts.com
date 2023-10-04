$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: darts
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 2)
$ if P3 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" .OR. P2 .EQS. "" then goto ArgError

$! Reject non-numeric input
$ Input = F$INTEGER(P1)
$ FirstChar = F$EDIT(F$EXTRACT(0,1,P1),"COLLAPSE,UPCASE")
$ if (Input .EQ. 0) .AND. (FirstChar .NES. "0") -
                    .AND. (F$LOCATE(".",P1) .GE. F$LENGTH(P1)) then -
    goto TypeError
$ if (Input .EQ. 1) .AND. -
     ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then goto TypeError

$ Input = F$INTEGER(P2)
$ FirstChar = F$EDIT(F$EXTRACT(0,1,P2),"COLLAPSE,UPCASE")
$ if (Input .EQ. 0) .AND. (FirstChar .NES. "0") -
                    .AND. (F$LOCATE(".",P2) .GE. F$LENGTH(P2)) then -
    goto TypeError
$ if (Input .EQ. 1) .AND. -
     ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then goto TypeError

$! Compute (square of) distance from dart board centre, but do so differently
$!  for floats and integer arguments. So, is either argument a float ?
$ if (F$LOCATE(".",P1) .LT. F$LENGTH(P1)) .OR. -
     (F$LOCATE(".",P2) .LT. F$LENGTH(P2))
$ then
$! Use host shell to compute a floating point result. Note the result is
$!  rounded to the nearest integer value.
$   shell rm -f RESULT_*
$! Result is rounded by adding 0.5 to floating point result, then lopping off decimal
$!  portion. NOTE: Scale increased (by multiplying squares by 10) to improve accuracy.
$   shell echo 10 \* &P1 \* &P1 + 10 \* &P2 \* &P2 + 0.5 | bc -l | xargs -I% touch RESULT_%
$   Distance_Squared = F$ELEMENT(0,".",F$ELEMENT(1,"_",F$ELEMENT(1,"]",F$SEARCH("RESULT_*.*",1))))
$   shell rm -f RESULT_*
$!...
$ else
$! No, we have integers, so our calculation is simple:
$   Distance_Squared = 10 * P1 * P1 + 10 * P2 * P2
$ endif

$! Use Boolean flag to skip conditional tests, so avoiding complex
$!  IF-ELSE logic.
$ Is_Distance_Set = 0

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .GT. 1000
$ then
$   Score = 0
$   Is_Distance_Set = 1
$ endif

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .GT. 250
$ then
$   Score = 1
$   Is_Distance_Set = 1
$ endif

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .GT. 10
$ then
$   Score = 5
$   Is_Distance_Set = 1
$ endif

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .LE. 10
$ then
$   Score = 10
$   Is_Distance_Set = 1
$ endif

$! Return score, and exit cleanly with return code
$ write Sys$Output Score
$ exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @darts x y"
$   exit %X2A
$ TypeError:
$   write Sys$Output "ERROR: Only numeric values allowed. USAGE: @darts x y"
$   exit %X2A

