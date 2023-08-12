$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: nucleotide-count
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Empty strand input returned unprocessed
$ if P1 .EQS. "" then goto EmptyStrand

$! Call subroutine to perform counting, emit result. Note:
$! - IN     -> &P1
$! - RESULT -> Counts (a global variable created via a `==` assignment)
$ Counts == ""
$ call Counts &P1
$ if Counts .EQ. -1 then goto TypeError
$ write Sys$Output Counts

$! Ensure normal exit status returned
$ exit 0

$! Normal handlers
$ EmptyStrand:
$   write Sys$Output "A: 0 C: 0 G: 0 T: 0"
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @nucleotide-count strand"
$   exit %X2A
$ TypeError:
$   write Sys$Output -
          "ERROR: Invalid nucleotide detected. USAGE: @nucleotide-count strand"
$   exit %X2A

$!
$! Subroutines
$!
$ Counts: subroutine
$   N = F$LENGTH(P1) - 1
$   I = -1
$   Nucleotide = ""
$   Nuc_A = 0
$   Nuc_C = 0
$   Nuc_G = 0
$   Nuc_T = 0
$   Nuc_Counts = 0

$ Loop:
$   I = I + 1
$   if I .GT. N then goto Done
$   Nucleotide = F$EDIT(F$EXTRACT(I,1,P1),"UPCASE")
$   if Nucleotide .EQS. "A" then Nuc_A = Nuc_A + 1
$   if Nucleotide .EQS. "C" then Nuc_C = Nuc_C + 1
$   if Nucleotide .EQS. "G" then Nuc_G = Nuc_G + 1
$   if Nucleotide .EQS. "T" then Nuc_T = Nuc_T + 1
$   goto Loop

$ Done:
$   Nuc_Counts = Nuc_A + Nuc_C + Nuc_G + Nuc_T
$   if Nuc_Counts .LT. F$LENGTH(P1)
$   then
$     Counts == -1
$   else
$     Counts == "A: " + F$STRING(Nuc_A) + " C: " +  F$STRING(Nuc_C) + -
               " G: " + F$STRING(Nuc_G) + " T: " +  F$STRING(Nuc_T)
$   endif
$   exit 0
$ endsubroutine

