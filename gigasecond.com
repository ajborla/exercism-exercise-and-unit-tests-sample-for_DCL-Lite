$! ---------------------------------------------------------------------------
$! exercism.io
$! DCL-Lite Track Exercise: gigasecond
$! Contributed: Anthony J. Borla (ajborla@bigpond.com)
$! ---------------------------------------------------------------------------

$! Reject too many arguments (expecting only 1)
$ if P2 .NES. "" then goto ArgError

$! Reject missing input
$ if P1 .EQS. "" then goto ArgError

$! Reject non-ISO8601-formatted date string. Call subroutine
$!  to perform task, emit result. Note:
$! - IN     -> &P1
$! - RESULT -> IsISO8601Date (a global variable created via a `==` assignment)
$ IsISO8601Date == 0
$ call IsISO8601Date &P1
$ if IsISO8601Date .EQ. 0 then goto TypeError

$! Add gigasecond to input date, return in same format. Note:
$! - IN     -> &P1
$! - RESULT -> AddGigasecondToISO8601
$ AddGigasecondToISO8601 == ""
$ call AddGigasecondToISO8601 &P1
$ if AddGigasecondToISO8601 .EQS. "" then goto DateError

$! Emit date string, then cleanly exit
$ write Sys$Output AddGigasecondToISO8601
$ exit 0

$! Error handlers
$ ArgError:
$   Msg = "ERROR: Invalid arguments. "
$   goto ErrorExit
$ TypeError:
$   Msg = "ERROR: Only ISO-8601 format allowed. "
$   goto ErrorExit
$ DateError:
$   Msg = "ERROR: Date computation error occurred. "
$ ErrorExit:
$   Usage = "USAGE: @gigasecond " + -
            "date"
$   write Sys$Output (Msg + Usage)
$   exit %X2A

$!
$! Subroutines
$!
$ IsISO8601Date: subroutine
$! Perform rudimentary format checks on input, P1
$   if F$LENGTH(P1) .NE. 10 .AND. -
       F$LENGTH(P1) .NE. 19 then goto IsISO8601Date_FALSE
$   if F$EXTRACT(4,1,P1) .NES. F$EXTRACT(7,1,P1) .OR. -
       F$EXTRACT(4,1,P1) .NES. "-" then goto IsISO8601Date_FALSE
$   if F$LENGTH(P1) .GT. 10
$   then
$     if F$EXTRACT(13,1,P1) .NES. F$EXTRACT(16,1,P1) .OR. -
         F$EXTRACT(13,1,P1) .NES. ":" then goto IsISO8601Date_FALSE
$   endif
$!
$! Passes rudimentary format checks, so we assume it is acceptable
$!
$ IsISO8601Date_TRUE:
$   IsISO8601Date == 1
$   goto IsISO8601Date_DONE
$!
$ IsISO8601Date_FALSE:
$   IsISO8601Date == 0
$!
$ IsISO8601Date_DONE:
$ endsubroutine

$ AddGigasecondToISO8601: subroutine
$   shell rm -f RESULT_* 2> /dev/null
$   shell date -u -d &P1 +%s | xargs -n1 -I{} echo {} + 1000000000 | bc -l | xargs -n1 -I{} date -u -d @{} +%Y%m%d%H%M%S | xargs -n1 -I{} touch RESULT_{} 2> /dev/null
$   ymdhms == F$ELEMENT(0,".",F$ELEMENT(1,"_",F$ELEMENT(1,"]",F$SEARCH("RESULT_*.*",1))))
$   shell rm -f RESULT_* 2> /dev/null
$   year = F$EXTRACT(0,4,ymdhms)
$   month = F$EXTRACT(4,2,ymdhms)
$   day = F$EXTRACT(6,2,ymdhms)
$   hour = F$EXTRACT(8,2,ymdhms)
$   minute = F$EXTRACT(10,2,ymdhms)
$   second = F$EXTRACT(12,2,ymdhms)
$   AddGigasecondToISO8601 == year + "-" + month + "-" + day + "T" + -
                              hour + ":" + minute + ":" + second
$ endsubroutine

