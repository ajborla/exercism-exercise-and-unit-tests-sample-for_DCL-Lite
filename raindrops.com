$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: raindrops
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Assume 0 value for missing, or non-digit, input, or values less than 1
$ if P2 .NES. "" then goto ZeroValue
$ if P1 .EQS. "" then goto ZeroValue
$ Input = F$INTEGER(P1)
$ FirstChar = F$EDIT(F$EXTRACT(0,1,P1),"COLLAPSE,UPCASE")
$ if (Input .EQ. 0) .AND. (FirstChar .NES. "0") then goto ZeroValue
$ if (Input .EQ. 1) .AND. -
     ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then goto ZeroValue
$ if P1 .LT. 1 then goto ZeroValue

$! Compute remainders, build sounds on computed values, emit sounds
$ Q3 = P1 / 3
$ R3 = P1 - 3 * Q3
$ Q5 = P1 / 5
$ R5 = P1 - 5 * Q5
$ Q7 = P1 / 7
$ R7 = P1 - 7 * Q7

$ Sounds = ""
$ if R3 .EQ. 0 then Sounds = "Pling"
$ if R5 .EQ. 0 then Sounds = Sounds + "Plang"
$ if R7 .EQ. 0 then Sounds = Sounds + "Plong"
$ if Sounds .EQS. "" then Sounds = P1
$ write Sys$Output Sounds
$ exit 0

$ ZeroValue:
$   write Sys$Output 0
$   exit %X2A

