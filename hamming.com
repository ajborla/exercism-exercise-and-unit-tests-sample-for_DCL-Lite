$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: hamming
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 2)
$ if P3 .NES. "" then goto ArgError

$! Zero Hamming Distance if both strands are empty
$ if P1 .EQS. "" .AND. P2 .EQS. "" then goto EmptyStrands

$! Reject different length strands
if F$LENGTH(P1) .NE. F$LENGTH(P2) then goto LengthError

$! Call subroutine to compute distance, emit result. Note:
$! - IN     -> &P1 &P2
$! - RESULT -> Hamming_Distance (a global variable created via a `==` assignment)
$ Hamming_Distance == 0
$ call Hamming_Distance &P1 &P2
$ write Sys$Output Hamming_Distance

$! Ensure normal exit status returned
$ exit 0

$! Normal handlers
$ EmptyStrands:
$   write Sys$Output 0
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @hamming strand1 strand2"
$   exit %X2A
$ LengthError:
$   write Sys$Output -
          "ERROR: Strands should be of equal length. USAGE: @hamming strand1 strand2"
$   exit %X2A

$!
$! Subroutines
$!
$ Hamming_Distance: subroutine
$   N = F$LENGTH(P1) - 1
$   I = -1
$   Distance = 0

$ Loop:
$   I = I + 1
$   if I .GT. N then goto Done
$! Compute Hamming Distance of corresponding nucleotides
$   if F$EDIT(F$EXTRACT(I,1,P1),"UPCASE") .NES. -
       F$EDIT(F$EXTRACT(I,1,P2),"UPCASE") then Distance = Distance + 1
$   goto Loop

$ Done:
$! Careful to update the return distance
$   Hamming_Distance == Distance
$   exit 0
$ endsubroutine

