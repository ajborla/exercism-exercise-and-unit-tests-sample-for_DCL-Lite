$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: isogram
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Empty string input is considered an isogram
$ if P1 .EQS. "" then goto TrueTest

$! Filter out all characters except lowercase letters, and collect occurrence
$!  counts in the AlphabetCounts variable.
$ N = F$LENGTH(P1) - 1
$ I = -1
$ AlphabetCounts := "00000000000000000000000000"
$!
$ Loop:
$   I = I + 1
$   if I .GT. N then goto Done
$   Char = F$EXTRACT(I,1,P1)
$   CharCode = F$CVUI(0,8,Char)
$! Convert any uppercase character to lowercase
$   if CharCode .GT. 64 .AND. CharCode .LT. 91 then CharCode = CharCode + 32
$   if CharCode .GT. 96 .AND. CharCode .LT. 123
$   then
$     Offset = CharCode - 97
$     Count = F$INTEGER(F$EXTRACT(Offset,1,AlphabetCounts))
$     Count = Count + 1
$     if Count .GT. 1 then goto FalseTest
$     AlphabetCounts[Offset,1] := &Count
$   endif
$   goto Loop
$!
$ Done:
$! Each letter will have been used 0 or 1 times, so is an isogram
$   goto TrueTest

$! Normal handlers
$ TrueTest:
$   write Sys$Output "true"
$   exit 0
$ FalseTest:
$   write Sys$Output "false"
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @isogram string"
$   exit %X2A

