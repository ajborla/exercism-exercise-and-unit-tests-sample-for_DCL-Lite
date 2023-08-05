$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: two-fer
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Default message emitted if argument is missing, or is an empty string
$ if P1 .EQS. ""
$ then
$   write Sys$Output "One for you, one for me."
$ else
$   write Sys$Output "One for " + P1 + ", one for me."
$ endif

