$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: darts
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 2)
$ if P3 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" .OR. P2 .EQS. "" then goto ArgError

$! Assume integer inputs
$ Input = F$INTEGER(P1)
$ Input = F$INTEGER(P2)

$! Compute (square of) distance from dart board centre
$  Distance_Squared = P1 * P1 + P2 * P2

$! Use Boolean flag to skip conditional tests, so avoiding complex
$!  IF-ELSE logic.
$ Is_Distance_Set = 0

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .GT. 100
$ then
$   Score = 0
$   Is_Distance_Set = 1
$ endif

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .GT. 25
$ then
$   Score = 1
$   Is_Distance_Set = 1
$ endif

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .GT. 1
$ then
$   Score = 5
$   Is_Distance_Set = 1
$ endif

$ if Is_Distance_Set .EQ. 0 .AND. Distance_Squared .LE. 1
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

