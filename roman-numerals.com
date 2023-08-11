$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: roman-numerals
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

$! Check that P1 >= 1 and P1 < 4000
$ if P1 .LT. 1 .OR. P1 .GT. 3999 then goto TypeError

$! Ensure we have four numeric values to correspond to
$ Digits = "000" + F$STRING(P1)
$ LastPos = F$LENGTH(Digits) - 1
$ M = F$EXTRACT(LastPos-3,1,Digits)
$ C = F$EXTRACT(LastPos-2,1,Digits)
$ X = F$EXTRACT(LastPos-1,1,Digits)
$ I = F$EXTRACT(LastPos,1,Digits)

$! Extract Romal Numeral for each positional value
$ M = F$ELEMENT(M," ",". M MM MMM")
$ C = F$ELEMENT(C," ",". C CC CCC CD D DC DCC DCCC CM")
$ X = F$ELEMENT(X," ",". X XX XXX XL L LX LXX LXXX XC")
$ I = F$ELEMENT(I," ",". I II III IV V VI VII VIII IX")

$! Build and emit the Roman Numeral
$ write Sys$Output (M - ".") + (C - ".") + (X - ".") + (I - ".")

exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @roman-numerals n"
$   exit %X2A
$ TypeError:
$   write Sys$Output "ERROR: Only positive numbers (1 - 3999) allowed. USAGE: @roman-numerals n"
$   exit %X2A

