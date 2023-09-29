$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: space-age
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 2)
$ if P3 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" .OR. P2 .EQS. "" then goto ArgError

$! Constants, lookup tables
$ EARTH_YEAR_SECONDS = 31557600
$ PLANETS = "mercury/venus  /earth  /mars   /jupiter/saturn /uranus /neptune/"
$ ORBITALS = "0.24084670/0.61519726/1.00000000/1.88081580/11.8626150/29.4474980/84.0168460/164.791320/"

$! Reject incorrect planet name
$ if F$LOCATE(P1,PLANETS) -
     .GE. F$LENGTH(PLANETS) then goto PlanetNameError

$! Reject non-positive integer value for seconds
$ Is_Integer_Value == 0
$ call Is_Integer_Value &P2
$ if Is_Integer_Value .EQ. 0 then goto TypeError
$ if P2 .LT. 1 then goto TypeError

$! Extract the orbital period (relative to Earth's period) for this planet
$ ORBITAL_PERIOD = F$ELEMENT(F$LOCATE(P1,PLANETS) / 8,"/",ORBITALS)

$! Compute age in years given planet, and age in seconds. Shell out to
$!  *NIX to perform required floatng point computation
$! Note replacement of "." in file name with "X", then its restoration for
$!  return result. Required because "." terminates the file name.
$ shell rm -f RESULT_* 2> /dev/null
$ shell echo &P2 \/ \(&EARTH_YEAR_SECONDS \* &ORBITAL_PERIOD\) | bc -l | xargs -n1 -I{} printf %.2f\\n {} | tr . X | xargs -n1 -I{} touch RESULT_{} 2> /dev/null
$ Result = F$ELEMENT(0,".",F$ELEMENT(1,"_",F$ELEMENT(1,"]",F$SEARCH("RESULT_*.*",1))))
$ Space_Age = F$ELEMENT(0,"X",Result) + "." + F$ELEMENT(1,"X",Result)

$! Emit age, cleanup, and exit
$ write Sys$Output F$STRING(Space_Age)
$ shell rm -f RESULT_* 2> /dev/null
$ exit 0

$! Error handlers
$ ArgError:
$   Msg = "ERROR: Invalid arguments. "
$   goto ErrorExit
$ TypeError:
$   Msg = "ERROR: Only positive numbers allowed. "
$   goto ErrorExit
$ PlanetNameError:
$   Msg = "ERROR: Invalid planet name. "

$ ErrorExit:
$   Usage = "USAGE: @space-age " + -
            "planet seconds"
$   write Sys$Output (Msg + Usage)
$   exit %X2A

$!
$! Subroutines
$!
$ Is_Integer_Value: subroutine
$   Input = F$INTEGER(P1)
$   FirstChar = F$EDIT(F$EXTRACT(0,1,P1),"COLLAPSE,UPCASE")
$   if (Input .EQ. 0) .AND. (FirstChar .NES. "0") then -
      goto Not_Integer_Value
$   if (Input .EQ. 1) .AND. -
       ((FirstChar .EQS. "Y") .OR. (FirstChar .EQS. "T")) then -
      goto Not_Integer_Value
$ Integer_Value:
$   Is_Integer_Value == 1
$   exit 0
$ Not_Integer_Value:
$   Is_Integer_Value == 0
$ endsubroutine

