# utexas primordial tape reconstruction

there were seven key 'non include' code files. the high.for and low.for are stubs, and somewhat likewise for msg.mac and setmsg.mac.
    
    DECWAR.FOR  FORTRAN source.
    WARMAC.MAC  MACRO source.
    SETUP.FOR   Once only code, deleted from core after initialization.
    HIGH.FOR    Used to force common block into high segment.
    LOW.FOR     Used to force common block into low segment.
    MSG.MAC     Output text source.
    SETMSG.MAC  Equivalent to MSG.MAC for SETUP text strings.

## teco scripts

six include files. five teco scripts in the tec folder originally were used to autogen five of the six.

    lowseg.tec -> lowseg.for
    hiseg.tec  -> hiseg.for
    param.tec  -> param.for
    extern.tec -> extern.for
    setext.tec -> setext.for
                  lstvar.for, this is also an include file, but without teco autogen

probably the scripts simply search through warmac.mac and pick out 'variables' that need to appear in the include for files. this can be done manually. if there's an update to warmac.mac, include for files can be manually updated. the teco scripts probably just automate this, generating the include for 'from scratch'. so it's not a 'must have'. can be done by hand. but possibly nice. and an interesting usage of teco.

at utexas the build was done in [10,30,decwar] and then deployed to gam: which was a 'logical device name' assigned to [5,30]. 10,30 seems to have been the 'dist' account, which is 10,7 for many simh scripts. let's just accept that dist is [10,7] now, not [10,30]. this allows leaving many simh scripts as is.

# notes

v2.2 31 commands - bases, build, capture, damages, dock, energy, gripe, help, impulse, list, move, news, planets, points, quit, radio, repair, scan, set, shields, srscan, status, summary, targets, tell, time, torpedoes, tractor, type, users

v2.3 31 commands - apparently, zeroth order, same as v2.2

there was a 'micro script' l.mic used to drive the linker. micro is evidently something inbetween teco and macro? any case, it seems a bit obscure for today, but the following is clearly the crucial parts for linking, these are linker commands, entered at the r link * prompt

    low/seg:low
    high/seg:hi
    decwar/seg:def
    msg
    warmac
    sys:forlib/sea/seg:def
    setup/seg:low
    setmsg
    sys:forlib/sea/seg:low
    decwar/ssave
    /g

this absolutely does work, after the little trick of first doing

    decwar/save

then the remainder from low/seg:low
