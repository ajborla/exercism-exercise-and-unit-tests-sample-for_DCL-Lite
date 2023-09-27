$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: space-age
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 2)
$ if P3 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" .OR. P2 .EQS. "" then goto ArgError

$! Lookup tables
$ PLANETS = "mercury/venus  /earth  /mars   /jupiter/saturn /uranus /neptune/"
$ ORBITALS = "0.24084670/0.61519726/1.00000000/1.88081580/11.8626150/29.4474980/84.0168460/164.791320/"

$! Extract the orbital period (relative to Earth's period) for this planet
$ ORBITAL_PERIOD = F$ELEMENT(F$LOCATE(P1,PLANETS) / 8,"/",ORBITALS)

$! Compute age in years given planet, and age in seconds
$! ...
$ Space_Age = 0

$! Emit age, cleanup, and exit
$ write Sys$Output F$STRING(Space_Age)
$ exit 0

$! Error handlers
$ ArgError:
$   Msg = "ERROR: Invalid arguments. "
$ ErrorExit:
$   Usage = "USAGE: @space-age " + -
            "planet seconds"
$   write Sys$Output (Msg + Usage)
$   exit %X2A

