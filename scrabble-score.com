$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: scrabble-score
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. ""
$ then
$   write Sys$Output -
          "ERROR: Invalid arguments. USAGE: @scrabble-score letters"
$   exit %X2A
$ else

$! Missing or empty argument accepted, zero score emitted
$   if P1 .EQS. ""
$   then
$     write Sys$Output 0
$   else

$! Normalize letters, call subroutine to score them, emit result. Note:
$! - IN     -> &P1
$! - RESULT -> Scabble_Score (a global variable created via a `==` assignment)
$     Scrabble_Score == 0
$     call Scrabble_Score &P1
$     write Sys$Output Scrabble_Score
$   endif

$! Ensure normal exit status returned
$   exit 0
$ endif

$!
$! Subroutines
$!
$ Scrabble_Score: subroutine
$   N = F$LENGTH(P1) - 1
$   I = -1
$   Score = 0

$ Loop:
$! Ensure loop increment located here since this label is the goto target from
$!  each successful score test
$   I = I + 1
$   if I .GT. N then goto Done

$! Ensure letter is uppercased (P1 passed as lowercase even if first converted)
$   Letter = F$EDIT(F$EXTRACT(I,1,P1),"UPCASE")

$! Letter score tests
$   if Letter .EQS. "Q" .OR. Letter .EQS. "Z"
$   then
$     Score = Score + 10
$     goto Loop
$   endif
$   if Letter .EQS. "J" .OR. Letter .EQS. "X"
$   then
$     Score = Score + 8
$     goto Loop
$   endif
$   if Letter .EQS. "K"
$   then
$     Score = Score + 5
$     goto Loop
$   endif
$   if Letter .EQS. "F" .OR. Letter .EQS. "H" .OR. -
       Letter .EQS. "V" .OR. Letter .EQS. "W" .OR. Letter .EQS. "Y"
$   then
$     Score = Score + 4
$     goto Loop
$   endif
$   if Letter .EQS. "B" .OR. Letter .EQS. "C" .OR. -
       Letter .EQS. "M" .OR. Letter .EQS. "P"
$   then
$     Score = Score + 3
$     goto Loop
$   endif
$   if Letter .EQS. "D" .OR. Letter .EQS. "G"
$   then
$     Score = Score + 2
$     goto Loop
$   endif
$   if Letter .EQS. "A" .OR. Letter .EQS. "E" .OR. -
       Letter .EQS. "I" .OR. Letter .EQS. "O" .OR. Letter .EQS. "U" .OR. -
       Letter .EQS. "L" .OR. Letter .EQS. "N" .OR. -
       Letter .EQS. "R" .OR. Letter .EQS. "S" .OR. Letter .EQS. "T"
$   then
$     Score = Score + 1
$   endif

$! Simply ignore non-letters, go check next character
$   goto Loop

$ Done:
$! Careful to update the return score
$   Scrabble_Score == Score
$   exit 0
$ endsubroutine

