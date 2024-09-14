| => indicates appropriate alterations have been made.
* => can't be done
x => don't do
? => questionable

===================================================================

?  1.  Flash for a week or so after every new version.
x  2.  NOTE command:
x	NOTE INSERT/ADD; txt
x	NOTE DELETE nn/*
x	NOTE PRINT/LIST nn/*
|  3. SET command:
?	SET LOCATION/LOOK?/APPROXIMATE? y,x
|  4. Allow commands before player is actually in the game:
|	HELP
|	NEWS
|	USERS
|	GRIPE
|	PASSWORD
|	SET NAME/OUTPUT/PROMPT/TTYTYPE
    Allow commands before entry into game if password is set:
	SET LOCATION
	SCAN
*  5. Get speed of controlling TTY if logged on to PTY.
*  6. Fix game to delete itself if it's run from a project number > 1000.
   7. Extension of LIST command:
	record with each planet the time it was captured
	record with each base the time it was built
	record with each ship the time it entered the game (already there?)
	allow selection of objects by time:
		SINCE hh:mm
		BEFORE hh:mm
|	LIST FEDERATION SHIPS {WITHIN} 10 {SECTORS}
	LIST ENEMY PLANETS {CAPTURED} SINCE 23:54
	LIST ENEMY SHIPS {CREATED?} BEFORE 23
|	LIST SUMMARY {OF} ENEMY BASES
	LIST ENEMY BASES {BUILT} SINCE -0:5
   8. Add records for highest score, etc., and add ratings for individual
      players.
?  9. Implement probation period.
  10. Change program to
	DW-{F/E}{TI/RN/SL}
  11. ^C during HIBER (especially long ones) can exceed max allowable
      ^C count and abort.
  12. Check for time limit error, and set CCFLG (and maybe reset
      the time limit to 5 seconds or so).  Time limit will now be set
      when a line is hung up instead of immediate disconnect!  On ALL
      input, if CCFLG is set afterwards, you should ALWAYS either
      return to either monitor mode or command mode.  CCFLG can be
      set if
	ER.ICC	^C	(usually the case)
	ER.TLC	time limit or hang up
? 13. Allow Ramming between ships.
  14. 'Beam' scans.
  15. Check out end-game (# of planets, bases).
