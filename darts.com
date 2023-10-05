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

$! Scaling Factor
$ SCALING_FACTOR = 10

$! Compute (square of) distance from dart board centre, but do so differently
$!  for floats and integer arguments. So, is either argument a float ?
$ if (F$LOCATE(".",P1) .LT. F$LENGTH(P1)) .OR. -
     (F$LOCATE(".",P2) .LT. F$LENGTH(P2))
$ then
$! Use host shell to compute a floating point result. Note the result is
$!  rounded to the nearest integer value.
$   shell rm -f RESULT_* 2> /dev/null
$! Result is rounded by adding 0.5 to floating point result, then lopping off decimal
$!  portion. NOTE: Scale increased (by multiplying squares) to improve accuracy.
$   shell echo &SCALING_FACTOR \* &P1 \* &P1 + &SCALING_FACTOR \* &P2 \* &P2 + 0.5 | bc -l | xargs -I% touch RESULT_% 2> /dev/null
$   Distance_Squared = F$ELEMENT(0,".",F$ELEMENT(1,"_",F$ELEMENT(1,"]",F$SEARCH("RESULT_*.*",1))))
$   shell rm -f RESULT_* 2> /dev/null
$!...
$ else
$! No, we have integers, so our calculation is simple:
$   Distance_Squared = SCALING_FACTOR * P1 * P1 + SCALING_FACTOR * P2 * P2
$ endif

$ if Distance_Squared .GT. (100 * SCALING_FACTOR)
$ then
$   Score = 0
$   goto Done
$ endif

$ if Distance_Squared .GT. (25 * SCALING_FACTOR)
$ then
$   Score = 1
$   goto Done
$ endif

$ if Distance_Squared .GT. (1 * SCALING_FACTOR)
$ then
$   Score = 5
$   goto Done
$ endif

$ if Distance_Squared .LE. (1 * SCALING_FACTOR) then Score = 10

$! Return score, and exit cleanly with return code
$ Done:
$   write Sys$Output Score
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @darts x y"
$   exit %X2A
$ TypeError:
$   write Sys$Output "ERROR: Only numeric values allowed. USAGE: @darts x y"
$   exit %X2A

