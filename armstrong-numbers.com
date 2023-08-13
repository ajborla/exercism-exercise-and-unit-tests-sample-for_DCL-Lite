$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: armstrong-numbers
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

$! Weed out obvious non-candidates
$ if P1 .LT. 0 then goto FalseTest
$ if P1 .LT. 10 then goto TrueTest
$ if P1 .LT. 100 then goto FalseTest

$! Compute sum of each digit of P1 raised to number of digits in P1
$ Digits = F$LENGTH(P1)
$ Sum_Of_Digits_To_Power == 0
$ call Sum_Of_Digits_To_Power &P1 &Digits

$! Emit Armstrong Number status
$ if Sum_Of_Digits_To_Power .EQ. P1 then goto TrueTest
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
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @armstrong-numbers n"
$   exit %X2A
$ TypeError:
$   write Sys$Output "ERROR: Only integer values allowed. USAGE: @armstrong-numbers n"
$   exit %X2A

$!
$! Subroutines
$!
$ Sum_Of_Digits_To_Power: subroutine
$   N = P2 - 1
$   I = -1
$   Sum = 0
$ LoopDigits:
$   I = I + 1
$   if I .GT. N then goto DoneDigits
$   Digit = F$EXTRACT(I,1,P1)
$   J = 0
$   Power = 1
$   LoopPower:
$     J = J + 1
$     if J .GT. P2 then goto DonePower
$     Power = Power * Digit
$     goto LoopPower
$   DonePower:
$     Sum = Sum + Power
$     goto LoopDigits
$ DoneDigits:
$   Sum_Of_Digits_To_Power == Sum
$   exit 0
$ endsubroutine

