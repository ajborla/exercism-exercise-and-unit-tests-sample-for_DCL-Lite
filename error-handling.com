$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: error-handling
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject both missing (or empty) argument, and too many arguments (1 expected)
$ if P1 .EQS. "" .OR. P2 .NES. ""
$ then
$   write Sys$Output "USAGE: @error-handling person"
$! Error condition signalled using hexadecimal 'ABORT' code
$   exit %X2A
$ else
$   write Sys$Output "Hello, " + P1
$ endif

