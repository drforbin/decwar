# remember

on raspi side.

    ./kermit/wermit
    C-Kermit>set transfer mode manual
    C-Kermit>set file type binary
    C-Kermit>set host localhost 2010 /raw-socket
    C-Kermit>c

on tops10 side.

    .r kermit
    Kermit-10>set file byte-size 36-bit
    Kermit-10>server

ctrl-\c back over to raspi side.

# fortran continuation line issue

seems the beginning line preceding a continuation line needs to end with a space character. examples from hiseg.for and lowseg.for

	common /hiseg/
     +	hfz, shpcon, shpdam, base, nbase, board, locpln, locr, 

    common /lowseg/
     +	lfz, ntok, tknlst, vallst, typlst, ptrlst, who, iwhat, 

if there's a space char right after '/' in the beginning line, they work. another example from captur.for needs a space after 'Vloc,'

	if (.not. ldis(shpcon(who,KVPOS), shpcon(who,KHPOS), Vloc,
     +	Hloc, 1))  goto 500			!adjacent to sector specified?

if the three examples above are fixed with spaces at the end of their beginning lines, then captur.for compiles ok.

ending space is stripped off by kermit, learned that for certain the hard way. if we could stop kermit from stripping off end spaces, it'd be huge. we've got 'properly fixed' files on raspi, just need to get them onto tops10 without 'unfixing by stripping'.

# kermit fix

got it! at last! this works, major celebration. on raspi side need to set kermit to transfer mode manual and then file type binary

     C-Kermit>set transfer mode manual
     C-Kermit>set file type binary
     C-Kermit>send LOWSEG.FOR
     C-Kermit>send HISEG.FOR
     C-Kermit>send CAPTUR.FOR

on raspi side.

     set transfer mode manual
     set file type binary

on tops10 side.

    set file byte-size 36-bit

and confirmed that git is not stripping the end spaces. can fix in the git repo, and now can kermit them to tops10.

# success

fixed all continuation beginning lines with an ending space character in git. used kermit properly to move them from raspi to tops10. successful build!
