$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: collatz-conjecture
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" then goto ArgError

$! Reject non-numeric, and non-positive, integer input
$ Input = F$INTEGER(P1)
$ FirstChar = F$EDIT(F$EXTRACT(0,1,P1),"COLLAPSE,UPCASE")
$ if (Input .EQ. 0) .AND. (FirstChar .NES. "0") then goto TypeError
$ if (Input .EQ. 1) .AND. -
     ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then goto TypeError

$! Check that P1 >= 1
$ if P1 .LT. 1 then goto TypeError

$! OK, now solve the conjecture by calling subroutine, and emit result
$! - IN     -> &P1
$! - RESULT -> Collatz_Conjecture (a global variable created via a `==` assignment)
$ Collatz_Conjecture == 0
$ call Collatz_Conjecture &P1
$ write Sys$Output Collatz_Conjecture
$ exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @collatz-conjecture n"
$   exit %X2A
$ TypeError:
$   write Sys$Output "ERROR: Only positive numbers allowed. USAGE: @collatz-conjecture n"
$   exit %X2A

$!
$! Subroutines
$!
$ Collatz_Conjecture: subroutine
$   N = P1
$   Steps = 0
$   if N .LE. 1 then goto Done
$ Loop:
$   Q2 = N / 2
$   R2 = N - 2 * Q2
$   if R2 .EQ. 0
$   then
$     N = Q2
$   else
$     N = N * 3 + 1
$   endif
$   Steps = Steps + 1
$   if N .NE. 1 then goto Loop
$ Done:
$   Collatz_Conjecture == Steps
$   exit 0
$ endsubroutine

