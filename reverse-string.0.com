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
$ I = -1
$ J = F$LENGTH(P1)

$ Loop:
$   I = I + 1
$   J = J - 1
$   if I .GT. J then goto Done
$   LChar = F$EXTRACT(I,1,P1)
$   RChar = F$EXTRACT(J,1,P1)
$   P1[I,1] := &RChar
$   P1[J,1] := &LChar
$   goto Loop

$ Done:
$! String should now be reversed (but case is not preserved !)
$   write Sys$Output P1
$   exit 0

$! Normal handlers
$ EmptyString:
$   write Sys$Output ""
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @reverse-string string"
$   exit %X2A

