expect "\r\n." send -t after=100k "login 10,7\r"; continue
expect "\r\n." send "r credir\r"; continue
expect "Create directory:" send "[,,ftn10]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10,doc]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10,run]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10,tests]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10,compiler]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10,forots]/prot:755\r"; continue
expect "Create directory:" send "[,,ftn10,tools]/prot:755\r"; continue
expect "Create directory:" send "\3"; continue
expect "\r\n." send "r backup\r"; at %TAP%0 -r tapes/BB-D480F-SB_FORTRAN10_V10.tap;  continue
expect "\r\n/" send "tape mta0:\r"; continue
expect "\r\n/" send "rewind\r"; continue
expect "\r\n/" send "inter\r"; continue
expect "\r\n/" send "files\r"; continue
expect "\r\n/" send "rest [,,ftn10,doc]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10,run]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10,tests]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10,forots]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10,compiler]*.*=*.*\r"; continue
expect "\r\n/" send "rest [,,ftn10,tools]*.*=*.*\r"; continue
expect "\r\n/" send "exit\r"; continue
expect "\r\n." send "k/f\r"; continue
expect "\r\n." send "login 1,2\r"; continue
expect "\r\n." send "r setsrc\r"; continue
expect "\r\n*" send "cp [10,7,FTN10,TOOLS]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "copy sys:=blis10.exe,blis10.err\r"; continue
expect "\r\n." send "copy hlp:=blis10.hlp\r"; continue
expect "\r\n." send "k/f\r"; continue
expect "\r\n." send "login 10,7\r"; continue
expect "\r\n." send "r setsrc\r"; continue
expect "\r\n*" send "cp [10,7,FTN10,compil]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "BUILD=BUILD.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "ERRTB3=ERRTB3.MAC\r"; continue
expect "\r\n*" send "QTAB1=QTAB1.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "BLIO=BLIO.BLI\r"; continue
expect "\r\n*" send "DEFLT=DEFLT.BLI\r"; continue
expect "\r\n*" send "ERROR0=ERROR0.BLI\r"; continue
expect "\r\n*" send "NUMIO1=NUMIO1.BLI\r"; continue
expect "\r\n*" send "OUTZ=OUTZ.BLI\r"; continue
expect "\r\n*" send "SCAN0=SCAN0.BLI\r"; continue
expect "\r\n*" send "SCNR=SCNR.BLI\r"; continue
expect "\r\n*" send "TBL=TBL.BLI\r"; continue
expect "\r\n*" send "TRACE1=TRACE1.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "BUILD/SAVE=QTAB1,BLIO,SCAN0,TRACE1,ERRTB3,ERROR0,SCNR,NUMIO1,DEFLT,TBL,OUTZ,BUILD/G\r"; continue
expect "\r\n." send "RUN DSK:BUILD\r"; continue
expect "\r\n*" send "META72.BLI,F72BNF.BLI_F72BNF.SYN\r"; continue
expect "START DETAILED TRACE AT META NO.(0=NONE)#" send "0\r"; continue
expect "IS A PLIT OF META NUMBERS NEEDED?(Y OR N):" send "N\r"; continue
expect "\r\n." send "RUN DSK:BUILD\r"; continue
expect "\r\n*" send "METAFM.BLI,FRMBNF.BLI_FRMBNF.SYN\r"; continue
expect "START DETAILED TRACE AT META NO.(0=NONE)#" send "0\r"; continue
expect "IS A PLIT OF META NUMBERS NEEDED?(Y OR N):" send "N\r"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "LEFT72=LEFT72.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "LEFTFM=LEFTFM.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "LEFT72/SAVE=QTAB1,BLIO,SCAN0,TRACE1,ERRTB3,ERROR0,SCNR,NUMIO1,DEFLT,TBL,OUTZ,LEFT72/G\r"; continue
expect "\r\n." send "RUN DSK:LEFT72\r"; continue
expect "\r\n*" send "3=LOOK72.BLI\r"; continue
expect "START TRACE AT NODE #(0=NONE):" send "0\r"; continue
expect "\r\n#" continue
expect "\r\n#" continue
expect "\r\n#" continue
expect "\r\n#" continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "LEFTFM/SAVE=QTAB1,BLIO,SCAN0,TRACE1,ERRTB3,ERROR0,SCNR,NUMIO1,DEFLT,TBL,OUTZ,LEFTFM/G\r"; continue
expect "\r\n." send "RUN DSK:LEFTFM\r"; continue
expect "\r\n*" send "3=LOOKFM.BLI\r"; continue
expect "START TRACE AT NODE #(0=NONE):" send "0\r"; continue
expect "\r\n#" continue
expect "\r\n#" continue
expect "\r\n#" continue
expect "\r\n#" continue
expect "\r\n." send "TECO F72BNF.BLI\r"; continue
expect "\r\n*" send "NLEFTBUILD\33JSBIND\033\060L.U0S;\033\060L\r<I!\033\060LQ0-.\"E0;'-L>\rNLEFTBUILD\033N\033-L.U0S;\033-L\r<I!\033\060LQ0-.\"E0;'-L>EX\033\033"; continue
expect "\r\n." send "DELETE F72BNF.BAK\r"; continue
expect "\r\n." send "TECO FRMBNF.BLI\r"; continue
expect "\r\n*" send "NLEFTBUILD\033JSBIND\033\060L.U0S;\033\060L\r<I!\033\060LQ0-.\"E0;'-L>EX\033\033"; continue
expect "\r\n." send "DELETE FRMBNF.BAK\r"; continue
expect "\r\n." send "COPY DBUGIT.REQ = TTY:\rBIND DBUGIT=0;         ! NO DEBUG CODE IN PHASE 1\r\032"; continue
expect "\r\n." send "COPY FT1SEG.REQ = TTY:\rGLOBAL BIND FT1SEG=0;          ! NOT SINGLE SEGMENT\r\032"; continue
expect "\r\n." send "COPY FTTENX.REQ = TTY:\rGLOBAL BIND FTTENEX=0; ! TOPS-10\r\032"; continue
expect "\r\n." send "COPY FTTENX.MAC = TTY:\rUNIVERSAL FTTENX\r       .DIRECTIVE .NOBIN\r       FTTENX==0               ; TOPS-10\r       END\r\032"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "FTTENX=FTTENX.MAC\r"; continue
expect "\r\n*" send "GFOPDF=GFOPDF.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "COMMAN=COMMAN.MAC\r"; continue
expect "\r\n*" send "ERR3=ERR3.MAC\r"; continue
expect "\r\n*" send "EXOSUP=EXOSUP.MAC\r"; continue
expect "\r\n*" send "JOBD=JOBD.MAC\r"; continue
expect "\r\n*" send "OWNDM=OWNDM.MAC\r"; continue
expect "\r\n*" send "REVHST=REVHST.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "ERROVA=ERROVA.BLI\r"; continue
expect "\r\n*" send "GLOBAL=GLOBAL.BLI\r"; continue
expect "\r\n*" send "INOUT=INOUT.BLI\r"; continue
expect "\r\n*" send "MAIN=MAIN.BLI\r"; continue
expect "\r\n*" send "UNEND=UNEND.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTRA.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DA.CMD\r"; continue
expect "\r\n." send "RENAME DORTRA.EXE=FORTRA.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@A.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTRA\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "CNSTCM=CNSTCM.MAC\r"; continue
expect "\r\n*" send "FLTGEN=FLTGEN.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "ARRXPN=ARRXPN.BLI\r"; continue
expect "\r\n*" send "DOXPN=DOXPN.BLI\r"; continue
expect "\r\n*" send "ERROUT=ERROUT.BLI\r"; continue
expect "\r\n*" send "ERROVB=ERROVB.BLI\r"; continue
expect "\r\n*" send "EXPRES=EXPRES.BLI\r"; continue
expect "\r\n*" send "FAZ1=FAZ1.BLI\r"; continue
expect "\r\n*" send "GNRCFN=GNRCFN.BLI\r"; continue
expect "\r\n*" send "SRCA=SRCA.BLI\r"; continue
expect "\r\n*" send "VLTPPR=VLTPPR.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "ACT0=ACT0.BLI\r"; continue
expect "\r\n*" send "ACT1=ACT1.BLI\r"; continue
expect "\r\n*" send "CODETA=CODETA.BLI\r"; continue
expect "\r\n*" send "DRIVER=DRIVER.BLI\r"; continue
expect "\r\n*" send "FORMAT=FORMAT.BLI\r"; continue
expect "\r\n*" send "LEXSUP=LEXSUP.BLI\r"; continue
expect "\r\n*" send "LISTNG=LISTNG.BLI\r"; continue
expect "\r\n*" send "STA0=STA0.BLI\r"; continue
expect "\r\n*" send "STA1=STA1.BLI\r"; continue
expect "\r\n*" send "STA2=STA2.BLI\r"; continue
expect "\r\n*" send "STA3=STA3.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "LEXICA=LEXICA.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTB.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DB.CMD\r"; continue
expect "\r\n." send "RENAME DORTB.EXE=FORTB.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@B.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTB\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "DOPT=DOPT.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "ERROVC=ERROVC.BLI\r"; continue
expect "\r\n*" send "GOPT2=GOPT2.BLI\r"; continue
expect "\r\n*" send "INPT=INPT.BLI\r"; continue
expect "\r\n*" send "MEMCMP=MEMCMP.BLI\r"; continue
expect "\r\n*" send "P2S1=P2S1.BLI\r"; continue
expect "\r\n*" send "SKSTMN=SKSTMN.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "DGCMN=DGCMN.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "CANNON=CANNON.BLI\r"; continue
expect "\r\n*" send "COMSUB=COMSUB.BLI\r"; continue
expect "\r\n*" send "GOPTIM=GOPTIM.BLI\r"; continue
expect "\r\n*" send "P2S2=P2S2.BLI\r"; continue
expect "\r\n*" send "PH2S=PH2S.BLI\r"; continue
expect "\r\n*" send "UTIL=UTIL.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTC.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DC.CMD\r"; continue
expect "\r\n." send "RENAME DORTC.EXE=FORTC.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@C.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTC\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "DNPT=DNPT.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "DEFPT=DEFPT.BLI\r"; continue
expect "\r\n*" send "ERROVD=ERROVD.BLI\r"; continue
expect "\r\n*" send "GCMNSB=GCMNSB.BLI\r"; continue
expect "\r\n*" send "GRAPH=GRAPH.BLI\r"; continue
expect "\r\n*" send "IOPT=IOPT.BLI\r"; continue
expect "\r\n*" send "MOVA=MOVA.BLI\r"; continue
expect "\r\n*" send "PHA2=PHA2.BLI\r"; continue
expect "\r\n*" send "PNROPT=PNROPT.BLI\r"; continue
expect "\r\n*" send "TSTR=TSTR.BLI\r"; continue
expect "\r\n*" send "VER5=VER5.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTD.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DD.CMD\r"; continue
expect "\r\n." send "RENAME DORTD.EXE=FORTD.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@D.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTD\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "ALCBLO=ALCBLO.BLI\r"; continue
expect "\r\n*" send "CMPBLO=CMPBLO.BLI\r"; continue
expect "\r\n*" send "CMPLEX=CMPLEX.BLI\r"; continue
expect "\r\n*" send "DATAST=DATAST.BLI\r"; continue
expect "\r\n*" send "DOALC=DOALC.BLI\r"; continue
expect "\r\n*" send "ERROVR=ERROVR.BLI\r"; continue
expect "\r\n*" send "OUTMOD=OUTMOD.BLI\r"; continue
expect "\r\n*" send "PH3G=PH3G.BLI\r"; continue
expect "\r\n*" send "REGAL2=REGAL2.BLI\r"; continue
expect "\r\n*" send "REGUTL=REGUTL.BLI\r"; continue
expect "\r\n*" send "RELBUF=RELBUF.BLI\r"; continue
expect "\r\n*" send "STREGA=STREGA.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTE.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DE.CMD\r"; continue
expect "\r\n." send "RENAME DORTE.EXE=FORTE.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@E.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTE\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "P3R=P3R.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTF.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DF.CMD\r"; continue
expect "\r\n." send "RENAME DORTF.EXE=FORTF.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@F.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTF\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "OPGNTA=OPGNTA.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "CGDO=CGDO.BLI\r"; continue
expect "\r\n*" send "CGEXPR=CGEXPR.BLI\r"; continue
expect "\r\n*" send "CGSTMN=CGSTMN.BLI\r"; continue
expect "\r\n*" send "DEBUG=DEBUG.BLI\r"; continue
expect "\r\n*" send "ERROVG=ERROVG.BLI\r"; continue
expect "\r\n*" send "LISTOU=LISTOU.BLI\r"; continue
expect "\r\n*" send "OPTAB=OPTAB.BLI\r"; continue
expect "\r\n*" send "PEEPOP=PEEPOP.BLI\r"; continue
expect "\r\n*" send "PHA3=PHA3.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "DELETE DORTG.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@DG.CMD\r"; continue
expect "\r\n." send "RENAME DORTG.EXE=FORTG.EXE\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@G.CMD\r"; continue
expect "\r\n." send "GET DSK:FORTG\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "COPY FT1SEG.BAK = FT1SEG.REQ\r"; continue
expect "\r\n." send "COPY FT1SEG.REQ = TTY:\rGLOBAL BIND FT1SEG = 1;        ! SINGLE SEGMENT\r\032"; continue
expect "\r\n." send "RUN SYS:BLIS10\r"; continue
expect "\r\n*" send "ONESEG=MAIN.BLI\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "COPY FT1SEG.REQ = FT1SEG.BAK\r"; continue
expect "\r\n." send "DELETE FT1SEG.BAK\r"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@ALL\r"; continue
expect "\r\n." send "GET DSK:SINGLE\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "k/f\r"; continue
expect "\r\n." send "login 1,2\r"; continue
expect "\r\n." send "r setsrc\r"; continue
expect "\r\n*" send "cp [10,7,FTN10,compil]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "copy sys:<055>=?ortra.exe,?ort?.exe\r"; continue
expect "\r\n." send "r setsrc\r"; continue
expect "\r\n*" send "cp [10,7,FTN10,doc]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "copy hlp:<055>=*.hlp\r"; continue
expect "\r\n." send "copy doc:<055>=*.doc\r"; continue
expect "\r\n." send "k/f\r"; continue
expect "\r\n." send "login 10,7\r"; continue
expect "\r\n." send "r setsrc\r"; continue
expect "\r\n*" send "cp [10,7,FTN10,forots]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "=M10REL.MAC,MTHPRM.MAC\r"; continue
expect "\r\n*" send "MTHTRP.REL=MTHTRP.MAC\r"; continue
expect "\r\n*" send "MTHSNG.REL=MTHSNG.MAC\r"; continue
expect "\r\n*" send "MTHDBL.REL=MTHDBL.MAC\r"; continue
expect "\r\n*" send "MTHGDB.REL=MTHGDB.MAC\r"; continue
expect "\r\n*" send "MTHCPX.REL=MTHCPX.MAC\r"; continue
expect "\r\n*" send "MTHCDX.REL=MTHCDX.MAC\r"; continue
expect "\r\n*" send "MTHCGX.REL=MTHCGX.MAC\r"; continue
expect "\r\n*" send "MTHMSG.REL=MTHMSG.MAC\r"; continue
expect "\r\n*" send "MTHDUM.REL=MTHDUM.MAC\r"; continue
expect "\r\n*" send "MTHARG.REL=MTHARG.MAC\r"; continue
expect "\r\n*" send "MTHCNV.REL=MTHCNV.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:MAKLIB\r"; continue
expect "\r\n*" send "@MTHLIB.CCL\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "FORPRM=F10REL.MAC,FORPRM.MAC\r"; continue
expect "\r\n*" send "FORBOT.REL=FORBOT.MAC\r"; continue
expect "\r\n*" send "FORCNV.REL=FORCNV.MAC\r"; continue
expect "\r\n*" send "FORCOM.REL=FORCOM.MAC\r"; continue
expect "\r\n*" send "FORCHR.REL=FORCHR.MAC\r"; continue
expect "\r\n*" send "FORDBM.REL=FORDBM.MAC\r"; continue
expect "\r\n*" send "FORDST.REL=FORDST.MAC\r"; continue
expect "\r\n*" send "FORDUM.REL=FORDUM.MAC\r"; continue
expect "\r\n*" send "FORERR.REL=FORERR.MAC\r"; continue
expect "\r\n*" send "FORFMT.REL=FORFMT.MAC\r"; continue
expect "\r\n*" send "FORHST.REL=FORHST.MAC\r"; continue
expect "\r\n*" send "FORINI.REL=FORINI.MAC\r"; continue
expect "\r\n*" send "FORIO.REL=FORIO.MAC\r"; continue
expect "\r\n*" send "FORMEM.REL=FORMEM.MAC\r"; continue
expect "\r\n*" send "FORMSC.REL=FORMSC.MAC\r"; continue
expect "\r\n*" send "FORMSG.REL=FORMSG.MAC\r"; continue
expect "\r\n*" send "FORNML.REL=FORNML.MAC\r"; continue
expect "\r\n*" send "FOROP.REL=FOROP.MAC\r"; continue
expect "\r\n*" send "FOROPN.REL=FOROPN.MAC\r"; continue
expect "\r\n*" send "FOROTS.REL=FOROTS.MAC\r"; continue
expect "\r\n*" send "FORPSE.REL=FORPSE.MAC\r"; continue
expect "\r\n*" send "FORPL2.REL=FORPL2.MAC\r"; continue
expect "\r\n*" send "FORRMS.REL=FORRMS.MAC\r"; continue
expect "\r\n*" send "FORRTF.REL=FORRTF.MAC\r"; continue
expect "\r\n*" send "FORSRT.REL=FORSRT.MAC\r"; continue
expect "\r\n*" send "FORXIT.REL=FORXIT.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:FORTRA\r"; continue
expect "\r\n*" send "FORPL1.RLR=FORPL1.FOR/OPT/NOWARN:CHO\r"; continue
expect "\r\n*" send "\032"; continue
expect "\r\n." send "RUN SYS:MAKLIB\r"; continue
expect "\r\n*" send "@F10LIB.CCL\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "RUN SYS:LINK\r"; continue
expect "\r\n*" send "@F10OTS.CCL\r"; continue
expect "\r\n." send "GET FORO10\r"; continue
expect "\r\n." send "CORE\r"; continue
expect "\r\n." send "RUN SYS:MACRO\r"; continue
expect "\r\n*" send "FORDDT=FDDT.MAC,FORDDT.MAC\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "k/f\r"; continue
expect "\r\n." send "login 1,2\r"; continue
expect "\r\n." send "r setsrc\r"; continue
expect "\r\n*" send "cp [10,7,FTN10,forots]\r"; continue
expect "\r\n*" send "\3"; continue
expect "\r\n." send "copy sys:<055>=forlib.rel,forddt.rel\r"; continue
expect "\r\n." send "copy sys:<055>=foro10.exe\r"; continue
expect "\r\n." send "k/f\r"; continue
