$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: pangram
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Empty string input is not considered a pangram
$ if P1 .EQS. "" then goto FalseTest

$! Filter out all characters except lowercase letters, and mark off each
$!  lowercase character, as used, by replacing it in the Alphabet variable,
$!  with a SPACE.
$ N = F$LENGTH(P1) - 1
$ I = -1
$ Alphabet := "abcdefghijklmnopqrstuvwxyz"
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
$     Alphabet[Offset,1] := " "
$   endif
$   goto Loop
$!
$ Done:
$! A pangram exists if the Alphabet variable (after all SPACES removed),
$!  has zero length.
$   if F$LENGTH(F$EDIT(Alphabet, "COLLAPSE")) .EQ. 0 then goto TrueTest
$   goto FalseTest

$! Normal handlers
$ TrueTest:
$   write Sys$Output "true"
$   exit 0
$ FalseTest:
$   write Sys$Output "false"
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @pangram string"
$   exit %X2A

