$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: difference-of-squares
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 2)
$ if P3 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" .OR. P2 .EQS. "" then goto ArgError

$! Computation identifiers
$ Cmd_Sum_Of_Squares = "sum_of_squares"
$ Cmd_Square_Of_Sum = "square_of_sum
$ Cmd_Difference = "difference"

$! Reject invalid command
$ if P1 .NES. Cmd_Sum_Of_Squares .AND. -
     P1 .NES. Cmd_Square_Of_Sum  .AND. -
     P1 .NES. Cmd_Difference then goto CommandError

$! Reject non-numeric, and non-positive, integer input
$ Input = F$INTEGER(P2)
$ FirstChar = F$EDIT(F$EXTRACT(0,1,P2),"COLLAPSE,UPCASE")
$ if (Input .EQ. 0) .AND. (FirstChar .NES. "0") then goto TypeError
$ if (Input .EQ. 1) .AND. -
     ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then goto TypeError
$ if P2 .LT. 1 then goto TypeError

$! Common values
$ Sum_Of_Squares == 0
$ Square_Of_Sum == 0

$! Perform requested computation
$ if P1 .EQS. Cmd_Sum_Of_Squares
$ then
$   call Sum_Of_Squares &P2
$   Result = Sum_Of_Squares
$   goto Done
$ endif

$ if P1 .EQS. Cmd_Square_Of_Sum
$ then
$   call Square_Of_Sum &P2
$   Result = Square_Of_Sum
$   goto Done
$ endif

$ if P1 .EQS. Cmd_Difference
$ then
$   call Sum_Of_Squares &P2
$   call Square_Of_Sum &P2
$   Result = Square_Of_Sum - Sum_Of_Squares
$ endif

$! Return computation result, and exit cleanly with return code
$ Done:
$   write Sys$Output Result
$   exit 0

$! Error handlers
$ ArgError:
$   Msg = "ERROR: Invalid arguments. "
$   goto ErrorExit
$ TypeError:
$   Msg = "ERROR: Only positive numbers allowed. "
$   goto ErrorExit
$ CommandError:
$   Msg = "ERROR: Invalid command. "

$ ErrorExit:
$   Usage = "USAGE: @difference-of-squares " + -
            "sum_of_squares|square_of_sum|difference n"
$   write Sys$Output (Msg + Usage)
$   exit %X2A

$!
$! Subroutines
$!
$ Sum_Of_Squares: subroutine
$   Sum_Of_Squares == P1 * (P1 + 1) * (2 * P1 + 1) / 6
$ endsubroutine
$!
$ Square_Of_Sum: subroutine
$   Sum = P1 * (P1 + 1) / 2
$   Square_Of_Sum == Sum * Sum
$ endsubroutine

