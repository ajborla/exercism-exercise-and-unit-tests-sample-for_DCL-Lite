$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: acronym
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Empty sentence is simply returned
$ if P1 .EQS. "" then goto EmptySentence

$! Sanitize input sentence
$ P1 = P1 - "'"
$ P1 = P1 - ","
$ P1 = P1 - "__"
$ P1 = P1 - "*"
$ P1 = P1 - "\"
$ P1 = P1 - """

$! Replace hyphens with spaces
$ Sentence := &P1
$ N = F$LENGTH(Sentence) - 1
$ I = -1
$ LoopHyphen:
$   I = I + 1
$   if I .GT. N then goto DoneHyphen
$   if F$EXTRACT(I,1,Sentence) .EQS. "-" then Sentence[I,1] := " "
$   goto LoopHyphen
$ DoneHyphen:
$   Sentence = " " + F$EDIT(Sentence,"COMPRESS,UPCASE")

$! Traverse sentence, build acronym, and emit it
$ Acronym = ""
$ I = -1
$ LoopAcronym:
$   I = I + 1
$   Word = F$ELEMENT(I," ",Sentence)
$   if Word .EQS. " " then goto DoneAcronym
$   Acronym = Acronym + F$EXTRACT(0,1,Word)
$   goto LoopAcronym
$ DoneAcronym:
$   write Sys$Output Acronym
$   exit 0

$! Normal handlers
$ EmptySentence:
$   write Sys$Output ""
$   exit 0

$! Error handlers
$ ArgError:
$   write Sys$Output "ERROR: Invalid arguments. USAGE: @acronym sentence"
$   exit %X2A

