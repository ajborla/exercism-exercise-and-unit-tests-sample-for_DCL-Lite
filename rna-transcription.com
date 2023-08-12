$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: rna-transcription
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Empty strand input returned unprocessed
$ if P1 .EQS. "" then goto EmptyStrand

$! Call subroutine to perform transcription, emit result. Note:
$! - IN     -> &P1
$! - RESULT -> Transcription (a global variable created via a `==` assignment)
$ Transcription == ""
$ call Transcription &P1
$ if F$LENGTH(Transcription) .LT. F$LENGTH(P1) then goto TypeError
$ write Sys$Output Transcription

$! Ensure normal exit status returned
$ exit 0

$! Normal handlers
$ EmptyStrand:
$   write Sys$Output ""
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @rna-transcription strand"
$   exit %X2A
$ TypeError:
$   write Sys$Output -
          "ERROR: Invalid nucleotide detected. USAGE: @rna-transcription strand"
$   exit %X2A

$!
$! Subroutines
$!
$ Transcription: subroutine
$   N = F$LENGTH(P1) - 1
$   I = -1
$   Nucleotide = ""
$   Strand = ""

$ Loop:
$   I = I + 1
$   if I .GT. N then goto Done
$   Nucleotide = F$EDIT(F$EXTRACT(I,1,P1),"UPCASE")
$   if Nucleotide .EQS. "A" then Strand = Strand + "U"
$   if Nucleotide .EQS. "C" then Strand = Strand + "G"
$   if Nucleotide .EQS. "G" then Strand = Strand + "C"
$   if Nucleotide .EQS. "T" then Strand = Strand + "A"
$   goto Loop

$ Done:
$   Transcription == Strand
$   exit 0
$ endsubroutine

