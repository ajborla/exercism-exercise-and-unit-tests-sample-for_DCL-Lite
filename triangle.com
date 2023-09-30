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
$ TriangleTypeError:
$   Msg = "ERROR: Invalid triangle type. "
$ ErrorExit:
$   Usage = "USAGE: @triangle " + -
            "equilateral|isosceles|scalene A B C"
$   write Sys$Output (Msg + Usage)
$   exit %X2A

