$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: reverse-string
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Empty string input returned unprocessed
$ if P1 .EQS. "" then goto EmptyString

$! Proceed to reverse the string
$ N = F$LENGTH(P1) - 1
$ I = -1
$ Reversed = ""

$ Loop:
$   I = I + 1
$   if I .GT. N then goto Done
$   Reversed = F$EXTRACT(I,1,P1) + Reversed
$   goto Loop

$ Done:
$! String should now be reversed
$   write Sys$Output Reversed
$   exit 0

$! Normal handlers
$ EmptyString:
$   write Sys$Output ""
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @reverse-string string"
$   exit %X2A

