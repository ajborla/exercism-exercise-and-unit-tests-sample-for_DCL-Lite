$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: leap
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

$! OK, a valid year, so compute remainder values for P1 using divisors of
$!  400, 100, and 4, respectively, and condtionally test, reporting result
$ Q400 = P1 / 400
$ R400 = P1 - 400 * Q400
$ if R400 .EQ. 0 then goto TrueTest
$ Q100 = P1 / 100
$ R100 = P1 - 100 * Q100
$ Q4 = P1 / 4
$ R4 = P1 - 4 * Q4
$ if (R4 .EQ. 0) .AND. (R100 .NE. 0) then goto TrueTest
$ goto FalseTest

$! Normal handlers
$ TrueTest:
$   write Sys$Output "true"
$   exit 0
$ FalseTest:
$   write Sys$Output "false"
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @leap year"
$   exit %X2A
$ TypeError:
$   write Sys$Output "ERROR: Only positive numbers allowed. USAGE: @leap year"
$   exit %X2A

