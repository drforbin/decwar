/*
   Copyright (c) 2016-2017, Johnny Eriksson
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
   COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
   AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
   OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
   THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
   DAMAGE.
*/


/*
 *  Things to do:
 *
 *  -- fix code to talk to an actual tape drive directly.
 *
 *  -- implement a way to control overwriting of existing disk files.
 *
 *  -- general clean up.
 */


/*
   This is a re-write/merge of backup.c (various versions) and backwr.c
   (creates tape images).  It is based on the original version(s) of the
   code, including random patches that has been floating around the net
   in the numerous years.

   People involved include:

   Johnny Eriksson
   Phil Budne
   Eric Smith
   ...

*/

#include <ctype.h>
#include <dirent.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/utsname.h>
#include <time.h>
#include <unistd.h>
#include <utime.h>

#include "back10.h"

/*
 *  Data types:
 */

typedef unsigned long long w36;	/* 36-bit word. */
#define C36(arg) arg##LLU	/* 36-bit constant. */

struct i2s {			/* int <--> string mapping. */
  u_int i;
  char* s;
};

typedef struct regitem {	/* Make it possible to have several -R args. */
  struct regitem* re_next;	/*   Next in list. */
  regex_t re_regex;		/*   Actual expression. */
} regitem;

enum {				/* Disk file format: */
  DF_NONE,			/*   None given so far. */
  DF_ASCII,			/*   Ascii. */
  DF_BINARY,			/*   Binary. */
  DF_COREDUMP,			/*   Core Dump. */
  DF_HIGHDENS,			/*   High density. */
  DF_INDUSTRY,			/*   Industry compatible. */
};

enum {				/* What action we are to perform: */
  ACT_NONE,			/*   None given so far. */
  ACT_CREATE,			/*   Create tape (-c). */
  ACT_LIST,			/*   List tape files (-l). */
  ACT_PEEK,			/*   Peek at tape (-p). */
  ACT_STRUCT,			/*   Show tape structure (-s). */
  ACT_TYPE,			/*   Type tape contents (-t). */
  ACT_EXTRACT,			/*   Extract files (-x). */
};

enum {				/* Tape format. */
  TF_NONE,			/*   None (placeholder). */
  TF_E11,			/*   .e11 format. */
  TF_PHY,			/*   Physical tape. */
  TF_RAW,			/*   Raw data. */
  TF_TAP,			/*   .tap format. */
  TF_TPC,			/*   .tpc format. */
};

enum {				/* Types of "objects" from tape: */
  TP_BOT,			/*   Beginning of tape. */
  TP_DATA,			/*   Data, length kept separate.  */
  TP_MARK,			/*   Tape mark. */
  TP_EOF,			/*   Soft EOF (two tape marks). */
  TP_GAP,			/*   Gap (need to find out what it is). */
  TP_EOT,			/*   Physical EOF, i.e. EOT. */
};

enum {				/* Type of data: */
  DT_NONE,			/*   Unknown type. */
  DT_ANSILBL,			/*   Ansi label. */
  DT_BACKUP,			/*   Backup-10 record. */
  DT_COREDUMP,			/*   Core dump record. */
  DT_DUMPER,			/*   Dumper record. */
  DT_FAILSAFE,			/*   Failsafe record. */
};

enum {				/* Saveset format of data on tape: */
  SF_NONE,			/*   None set. */
  SF_BACKUP,			/*   Backup-10. */
  SF_DUMPER,			/*   Dumper-20. */
  SF_FAILSAFE,			/*   Failsafe. */
};

enum {				/* Sub-types of ansi labels: */
  AL_NONE,			/*   Unknown. */
  AL_VOL,			/*   Volume header. */
  AL_HDR,			/*   File header. */
  AL_EOV,			/*   End-of-volume header. */
  AL_EOF,			/*   End-of-file header. */
  AL_UVL,			/*   User volume header. */
  AL_UHL,			/*   User file header. */
  AL_UTL,			/*   User file trailer. */
};

/* Types of DUMPER records: */

#define D_DATA    0		/* Data, file page. */
#define D_TPHD    1		/* Saveset header. */
#define D_FLHD    2		/* File header. */
#define D_FLTR    3		/* File trailer. */
#define D_TPTR    4		/* Tape trailer. */
#define D_USR     5		/* User directory info. */
#define D_CTPH    6		/* Continued saveset header. */
#define D_FILL    7		/* Filler record. */

/* Types of FAILSAFE records: (internal codes) */

enum {
  F_BEGIN,			/* Begin saveset. */
  F_END,			/* End saveset. */
  F_FILE,			/* Begin file. */
  F_DATA,			/* File data. */
};

/*
 *  variables:
 */

char* programname;		/* What we were called as. */

int tapeaction = ACT_NONE;	/* No action given yet. */
int tapeformat = TF_NONE;	/* No tape format set. */
int tapeobject = TP_BOT;	/* Initially at start of tape. */
int prevobject = TP_BOT;	/* Previous tape object. */

int taperecnum = 0;		/* Tape record number. */
int subrecnum;			/* Number of current sub-record. */
int tapereclen;			/* For TP_DATA records, actual length. */
int taperectype = DT_NONE;	/* For TP_DATA records, data type. */
int datarectype;		/* Subtype of data record, depends on type. */

int ssformat = SF_NONE;		/* Saveset format. */

int argcount;			/* Count of arguments to worker. */
char** arglist;			/* List of arguments to worker. */

regitem* reghead = NULL;	/* Head of regex list. */
regitem* regtail = NULL;	/* Tail of regex list. */

int extracting = 0;		/* Non-zero if we are extracting this file. */
int insaveset = 0;		/* Non zero if we are inside a saveset. */
int infile = 0;			/* Non-zero if we are inside a file. */

int buildtree = 0;		/* (-b) Build file tree. */
int nodevice = 0;		/* (-d) Omit device from file tree. */
int interchange = 0;		/* (-i) Interchange flag. */

int quiet = 0;			/* (-q) Quiet flag. */
int verbose = 0;		/* (-v) Verbose level. */
int debug = 0;			/* (-D) debugging flag. */

char* tapename = NULL;		/* (-f) tape file name. */

/*
 *  Parameters we use when writing tapes:
 */

int apr = 4097;			/* (xx) Processor serial number. */
char* bpi = "1600";		/* (xx) Density (BPI) of tape. */
char* dev = "MTA0";		/* (xx) Device name. */
char* reel = "";		/* (xx) Reel name. */

char* sysname = NULL;		/* (-M) System name. */
char* ssname = NULL;		/* (-S) SaveSet name. */

/*
 *  p_word control bits etc:
 */

u_int pw_number = 0;		/* (-n) Number of words to print. */

int pw_raw = 0;			/* Use raw buffer. */
int pw_hex = 0;			/* Hex. */
int pw_hword = 1;		/* Halfwords. */
int pw_7bit = 1;		/* 7-bit bytes. */
int pw_text = 1;		/* Text. */
int pw_sixbit = 1;		/* Sixbit. */
int pw_instr = 0;		/* Instructions. */

FILE* tapefile;		 	/* Tape file we operate on. */

FILE* diskfile;			/* Disk file we operate on. */
off_t filelength;		/*   Length, in octets. */
time_t filetime;		/*   Time last modified. */
mode_t filemode;		/*   Mode of file (protection). */

u_char diskbuffer[5*512];	/* Disk file buffer. */
u_int diskcount;		/*   Amount of data in above. */
u_int dataoffset;		/*   Data offset. */

int diskformat = DF_NONE;	/* Disk file format. */
int bpw = 40;			/* Bits/word in current format. */
int opw = 5;			/* Octets/word in current format. */

u_int seq;			/* Sequence number. */

int gmtoffset;			/* GMT offset. */

#define DEFBLKF  4		/* Default blocking factor. */
#define MAXBLKF 96		/* Max blocking factor we handle. */
#define MAXDATA (128 * MAXBLKF)	/* Max data (words) we handle. */
#define TPBUFSZ (32 + MAXDATA)	/* Total tape buffer size. */
#define RAWBUFSZ (5 * TPBUFSZ)	/* Total raw buffer size. */

w36 tapebuffer[TPBUFSZ];	/* Tape buffer. */
w36* bckhdr = &tapebuffer[0];	/*   Start of header (backup fmt). */
w36* bckdata = &tapebuffer[32];	/*   Start of data area (backup fmt). */

u_char rawbuffer[RAWBUFSZ];	/* Raw tape data. */

w36 namechecksum;		/* For each file, csm of the O$NAME block. */

int dlevel = 0;			/* Directory level. */

#define STRSIZE 256		/* Size of strings we collect from tape. */

char t_sysname[STRSIZE];	/* System name. */
char t_ssname[STRSIZE];		/* SaveSet name. */

/* File name elements: */

char f_device[STRSIZE];		/* Device. */
char f_ufd   [STRSIZE];		/* Directory. */
char f_name  [STRSIZE];		/* File name. */
char f_ext   [STRSIZE];		/* Extension. */
char f_sfd[6][STRSIZE];		/* SFDs. (0 unused) */

/* File name variants: */

char iname   [STRSIZE];		/* Interchange name. */
char cname   [STRSIZE];		/* Canonical name. */
char oname   [STRSIZE];		/* Output name. */
char tname   [STRSIZE];		/* Tree name. */

w36  f_attrs [LN_AFH];		/* File attributes. */
char a_cusr  [STRSIZE];		/*   Creator. */

w36  f_rdtime;			/* File read (access) time. */
w36  f_wrtime;			/* File write time. */

struct i2s name_density[] = {
  { 1,  "200" },
  { 2,  "556" },
  { 3,  "800" },
  { 4, "1600" },
  { 5, "6250" },
  { 0, NULL },
};

struct i2s name_ostype[] = {
  { 1, "TOPS-10" },
  { 2, "TENEX" },
  { 3, "ITS" },
  { 4, "TOPS-20" },
  { 5, "TYMCOM-X" },
  { 0, NULL },
};

struct i2s name_rectype[] = {
  { T_LABEL, "label" },
  { T_BEGIN, "begin" },
  { T_END,   "end" },
  { T_FILE,  "file" },
  { T_UFD,   "ufd" },
  { T_EOV,   "eov" },
  { T_COMM,  "comment" },
  { T_CONT,  "continuation" },
  { 0, NULL },
};

struct i2s name_sfformat[] = {
  { SF_BACKUP,    "backup" },
  { SF_DUMPER,    "dumper" },
  { SF_FAILSAFE,  "failsafe" },
  { 0, NULL },
};

struct i2s name_tpformat[] = {
  { TF_E11, "e11" },
  { TF_RAW, "raw" },
  { TF_TAP, "tap" },
  { TF_TPC, "tpc" },

  { TF_TAP, "simh" },
  { 0, NULL },
};

struct i2s name_lbltype[] = {
  { AL_VOL, "VOL" },
  { AL_HDR, "HDR" },
  { AL_EOV, "EOV" },
  { AL_EOF, "EOF" },
  { AL_UVL, "UVL" },
  { AL_UHL, "UHL" },
  { AL_UTL, "UTL" },
  { 0, NULL },
};

struct i2s name_dumper_rectype[] = {
  { D_DATA, "file data" },
  { D_TPHD, "saveset" },
  { D_FLHD, "file header" },
  { D_FLTR, "file trailer" },
  { D_TPTR, "tape trailer" },
  { D_USR,  "user directory" },
  { D_CTPH, "cont. saveset" },
  { D_FILL, "fill" },
  { 0, NULL },
};

struct i2s name_failsafe_rectype[] = {
  { F_BEGIN, "begin" },
  { F_END,   "end" },
  { F_FILE,  "file" },
  { F_DATA,  "data" },
  { 0, NULL },
};

char* opcode[0700] = {
  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,	/* 0... */
  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,	/* 20... */

  0,        "init",   0,        0,			/* 40... */
  0,        0,        0,        "calli",
  "open",   "ttcall", 0,        0, 			/* 50... */
  0,        "rename", "in",     "out",
  "setsts", "stato",  "getsts", "statz",		/* 60... */
  "inbuf",  "outbuf", "input",  "output",
  "close",  "releas", "mtape",  "ugetf",		/* 70... */
  "useti",  "useto",  "lookup", "enter",

  "ujen",   0,        "gfad",   "gfsb",			/* 100... */
  "jsys",   "adjsp",  "gfmp",   "gfdv",
  "dfad",   "dfsb",   "dfmp",   "dfdv",			/* 110... */
  "dadd",   "dsub",   "dmul",   "ddiv",
  "dmove",  "dmovn",  "fix",    "extend",		/* 120... */
  "dmovem", "dmovnm", "fixr",   "fltr",
  "ufa",    "dfn",    "fsc",    "ibp",			/* 130... */
  "ildb",   "ldb",    "idbp",   "dpb",	

  "fad",    "fadl",   "fadm",   "fadb",			/* 140... */
  "fadr",   "fadri",  "fadrm",  "fadrb",
  "fsb",    "fsbl",   "fsbm",   "fsbb", 		/* 150... */
  "fsbr",   "fsbri",  "fsbrm",  "fsbrb",
  "fmp",    "fmpl",   "fmpm",   "fmpb",			/* 160... */
  "fmpr",   "fmpri",  "fmprm",  "fmprb",
  "fdv",    "fdvl",   "fdvm",   "fdvb", 		/* 170... */
  "fdvr",   "fdvri",  "fdvrm",  "fdvrb",

  "move",   "movei",  "movem",  "moves",		/* 200... */
  "movs",   "movsi",  "movsm",  "movss",		/* 204... */
  "movn",   "movni",  "movnm",  "movns",		/* 210... */
  "movm",   "movmi",  "movmm",  "movms",		/* 214... */
  "imul",   "imuli",  "imulm",  "imulb",		/* 220... */
  "mul",    "muli",   "mulm",   "mulb",			/* 224... */
  "idiv",   "idivi",  "idivm",  "idivb",		/* 230... */
  "div",    "divi",   "divm",   "divb",			/* 234... */
  "ash",    "rot",    "lsh",    "jffo",			/* 240... */
  "ashc",   "rotc",   "lshc",   0,			/* 244... */
  "exch",   "blt",    "aobjp",  "aobjn",		/* 250... */
  "jrst",   "jfcl",   "xct",    "map",			/* 254... */
  "pushj",  "push",   "pop",    "popj",			/* 260... */
  "jsr",    "jsp",    "jsa",    "jra",			/* 264... */
  "add",    "addi",   "addm",   "addb",			/* 270... */
  "sub",    "subi",   "subm",   "subb",			/* 274... */

  "cai",    "cail",   "caie",   "caile",		/* 300... */
  "caia",   "caige",  "cain",   "caig",			/* 304... */
  "cam",    "caml",   "came",   "camle",		/* 310... */
  "cama",   "camge",  "camn",   "camg",			/* 314... */
  "jump",   "jumpl",  "jumpe",  "jumple",		/* 320... */
  "jumpa",  "jumpge", "jumpn",  "jumpg",		/* 324... */
  "skip",   "skipl",  "skipe",  "skiple",		/* 330... */
  "skipa",  "skipge", "skipn",  "skipg",		/* 334... */
  "aoj",    "aojl",   "aoje",   "aojle",		/* 340... */
  "aoja",   "aojge",  "aojn",   "aojg",			/* 344... */
  "aos",    "aosl",   "aose",   "aosle",		/* 350... */
  "aosa",   "aosge",  "aosn",   "aosg",			/* 354... */
  "soj",    "sojl",   "soje",   "sojle",		/* 360... */
  "soja",   "sojge",  "sojn",   "sojg",			/* 364... */
  "sos",    "sosl",   "sose",   "sosle",		/* 370... */
  "sosa",   "sosge",  "sosn",   "sosg",			/* 374... */

  "setz",   "setzi",  "setzm",  "setzb",		/* 400... */
  "and",    "andi",   "andm",   "andb",			/* 404... */
  "andca",  "andcai", "andcam", "andcab",		/* 410... */
  "setm",   "setmi",  "setmm",  "setmb",		/* 414... */
  "andcm",  "andcmi", "andcmm", "andcmb",		/* 420... */
  "seta",   "setai",  "setam",  "setab",		/* 424... */
  "xor",    "xori",   "xorm",   "xorb",			/* 430... */
  "ior",    "iori",   "iorm",   "iorb",			/* 434... */
  "andcb",  "andcbi", "andcbm", "andcbb",		/* 440... */
  "eqv",    "eqvi",   "eqvm",   "eqvb",			/* 444... */
  "setca",  "setcai", "setcam", "setcab",		/* 450... */
  "orca",   "orcai",  "orcam",  "orcab",		/* 454... */
  "setcm",  "setcmi", "setcmm", "setcmb",		/* 460... */
  "orcm",   "orcmi",  "orcmm",  "orcmb",		/* 464... */
  "orcb",   "orcbi",  "orcbm",  "orcbb",		/* 470... */
  "seto",   "setoi",  "setom",  "setob",		/* 474... */

  "hll",    "hlli",   "hllm",   "hlls",			/* 500... */
  "hrl",    "hrli",   "hrlm",   "hrls",			/* 504... */
  "hllz",   "hllzi",  "hllzm",  "hllzs",		/* 510... */
  "hrlz",   "hrlzi",  "hrlzm",  "hrlzs",		/* 514... */
  "hllo",   "hlloi",  "hllom",  "hllos",		/* 520... */
  "hrlo",   "hrloi",  "hrlom",  "hrlos",		/* 524... */
  "hlle",   "hllei",  "hllem",  "hlles",		/* 530... */
  "hrle",   "hrlei",  "hrlem",  "hrles",		/* 534... */
  "hrr",    "hrri",   "hrrm",   "hrrs",			/* 540... */
  "hlr",    "hlri",   "hlrm",   "hlrs",			/* 544... */
  "hrrz",   "hrrzi",  "hrrzm",  "hrrzs",		/* 550... */
  "hlrz",   "hlrzi",  "hlrzm",  "hlrzs",		/* 554... */
  "hrro",   "hrroi",  "hrrom",  "hrros",		/* 560... */
  "hlro",   "hlroi",  "hlrom",  "hlros",		/* 564... */
  "hrre",   "hrrei",  "hrrem",  "hrres",		/* 570... */
  "hlre",   "hlrei",  "hlrem",  "hlres",		/* 574... */

  "trn",    "tln",    "trne",   "tlne",			/* 600... */
  "trna",   "tlna",   "trnn",   "tlnn",			/* 604... */
  "tdn",    "tsn",    "tdne",   "tsne",			/* 610... */
  "tdna",   "tsna",   "tdnn",   "tsnn",			/* 614... */
  "trz",    "tlz",    "trze",   "tlze",			/* 620... */
  "trza",   "tlza",   "trzn",   "tlzn",			/* 624... */
  "tdz",    "tsz",    "tdze",   "tsze",			/* 630... */
  "tdza",   "tsza",   "tdzn",   "tszn",			/* 634... */
  "trc",    "tlc",    "trce",   "tlce",			/* 640... */
  "trca",   "tlca",   "trcn",   "tlcn",			/* 644... */
  "tdc",    "tsc",    "tdce",   "tsce",			/* 650... */
  "tdca",   "tsca",   "tdcn",   "tscn",			/* 654... */
  "tro",    "tlo",    "troe",   "tloe",			/* 660... */
  "troa",   "tloa",   "tron",   "tlon",			/* 664... */
  "tdo",    "tso",    "tdoe",   "tsoe",			/* 670... */
  "tdoa",   "tsoa",   "tdon",   "tson",			/* 674... */
};

/***********************************************************************/

/* General helper routines: */

/*
 *  Map an integer to a string:
 */

char* map_i2s(u_int i, struct i2s* x, char* dflt)
{
  while (x->s != NULL) {
    if (x->i == i)
      return x->s;
    x++;
  }
  return dflt;
}

/*
 *  Map a string to an integer:
 */

u_int map_s2i(char* s, struct i2s* x, u_int dflt)
{
  while (x->s != NULL) {
    if (strcmp(s, x->s) == 0)
      return x->i;
    x++;
  }
  return dflt;
}

/*
 *  Routines to manipulate/create 36-bit words:
 */

w36 xwd(u_int l, u_int r)
{
  w36 w;

  w = l;
  w <<= 18;
  w += r;
  return w;
}

void dpb(u_int fld, u_char size, w36* w, u_char pos)
{
  w36 mask;

  mask = ((1 << size) - 1) << (36 - pos);
  *w &= ~mask;
  *w |= mask & (fld << (36 - pos));
}

u_int ldb(u_char size, w36 w, u_char pos)
{
  w >>= (35 - pos);
  w &= ((1 << size) - 1);

  return w;
}

u_int lhalf(w36 w)
{
  return w >> 18;
}

u_int rhalf(w36 w)
{
  return w & 0777777;
}

/*
 *  Turn an ascii string into a 36-bit word, like the ASCII pseudo-op.
 */

w36 ascii(char name[])
{
  int i;
  char c;
  w36 w;

  w = 0;
  c = '*';

  for (i = 0; i < 5; i += 1) {
    if (c != (char) 0) {
      c = name[i];
    }
    w <<= 7;
    w += c;
  }
  w <<= 1;
  return w;
}

/*
 *  Turn an ascii string into a 36-bit word, like the SIXBIT pseudo-op.
 */

w36 sixbit(char name[])
{
  int i;
  char c;
  w36 w;

  w = 0;
  c = '*';

  for (i = 0; i < 6; i += 1) {
    if (c != (char) 0) {
      c = name[i];
    }
    if (c != (char) 0) {
      if ((c >= 'a') && (c <= 'z')) {
        c = c - 'a' + 'A';
      }
      c -= 32;
    }
    w <<= 6;
    w += c;
  }
  return w;
}

/*
 *  time2udt() converts a unix time_t to a 36-bit tops UDT.
 */

w36 time2udt(time_t t)
{
  int days, seconds;

  t += gmtoffset;

  days = t / 86400;
  seconds = t - days * 86400;

  days += 0117213;
  seconds *= 2048;
  seconds /= 675;

  return xwd(days, seconds);
}

/*
 *  udt2time() converts a 36-bit tops UDT to a time_t.  If the UDT
 *  is zero (i.e. missing), return zero.  If the UDT is before 1970,
 *  return one.  This will result in the earliest date we know.
 *
 *  We should possibly worry about dates that overflow a time_t...
 */

time_t udt2time(w36 udt)
{
  int days, seconds;

  if (udt == 0)
    return 0;

  if (udt < xwd(1,0))
    return 1;

  udt -= (gmtoffset << 11) / 675;

  days = lhalf(udt) - 0117213;
  if (days < 0)
    return 1;

  seconds = (rhalf(udt) * 675) >> 11;

  return days * 86400 + seconds;
}

/*
 *  Get current time in UDT format.
 */

w36 getnow(void)
{
  return time2udt(time(NULL));
}

/*
 *  Replace all underscore characters in string with comma.
 */

void ununderscore(char* str)
{
  for (;;) {
    str = strchr(str, '_');
    if (str == NULL)
      return;
    *str = ',';
  }
}

/*
 *  Convert string to all lowercase.
 */

void downcase(char* str)
{
  for (; *str != 0; str++) {
    if (isupper(*str))
      *str = tolower(*str);
  }
}

/*
 *  Convert string to all uppercase.
 */

void upcase(char* str)
{
  for (; *str != 0; str++) {
    if (islower(*str))
      *str = toupper(*str);
  }
}

/*
 *  Put a sixbit word as ASCII into a string.
 */

void six2asc(char* str, w36 w, int len)
{
  int i;
  char c;

  for (i = 0; i < len; i += 1) {
    c = ldb(6, w, 5);
    if (c == 0) {
      *str = 0;
      return;
    }
    *str++ = c + 32;
    w <<= 6;
  }
}

/*
 *  Construct our full file names.
 */

void buildnames(void)
{
  int i, pos;

  cname[0] = 0;
  iname[0] = 0;

  if (f_name[0] == 0)		/* Got a file name at all? */
    return;			/*  No, can't do anything. */

  /* Always include the dot in the tops-style file name. */

  snprintf(iname, STRSIZE, "%s.%s", f_name, f_ext);

  pos = 0;

  if (f_device[0] != 0)
    pos += snprintf(&cname[pos], (STRSIZE - pos), "%s:", f_device);

  if (f_ufd[0] != 0) {
    pos += snprintf(&cname[pos], (STRSIZE - pos), "[%s", f_ufd);
    for (i = 1; i <= 5; i += 1) {
      if (f_sfd[i][0] != 0)
	pos += snprintf(&cname[pos], (STRSIZE - pos), ",%s", f_sfd[i]);
      else
	i = 5;
    }
    pos += snprintf(&cname[pos], (STRSIZE - pos), "]");
  }

  pos += snprintf(&cname[pos], (STRSIZE - pos), "%s", iname);
}

/*
 *  Check if the current file matches any argument.
 */

int checkarg(void)
{
  regitem* reg;
  int i;

  if (argcount == 0 && reghead == NULL)
    return 1;

  for (i = 0; i < argcount; i += 1) {
    if (strstr(cname, arglist[i]) != NULL)
      return 1;
  }

  for (reg = reghead; reg != NULL; reg = reg->re_next) {
    if (regexec(&reg->re_regex, cname, 0, NULL, 0) == 0)
      return 1;
  }

  return 0;
}

/*
 *  Try to interpret an A$PROT sub-field.  Returns printable character.
 *
 *  Code from Phil Budne, modified.  (The code, that is).
 */

char prot(u_char fld)
{
  if (fld & 0x80)		/* Special? */
    return '!';

  switch (fld) {		/* Try canned values. */
  case 0x6e:
    return '0';			/* change protection */
  case 0x7e:
    return '1';			/* rename */
  case 0x2e:
    return '2';			/* write */
  case 0x2a:
    return '3';			/* update */
  case 0x26:
    return '4';			/* append */
  case 0x22:
    return '5';			/* read */
  case 0x11:
    return '6';			/* execute */
  case 0x10:
    return '7';			/* no access */
  case 0:
    return '*';			/* for interchange?? */
  }

  /* Try field-by-field: */

  switch (fld & 0x03) {
  case 0:
    return '7';
  case 1:
    return '6';
  }

  switch ((fld >> 2) & 0x03) {
  case 0:
    return '5';
  case 1:
    return '4';
  case 2:
    return '3';
  }

  switch ((fld >> 4) & 0x07) {
  case 2:
    return '2';
  case 6:
    return '1';
  case 7:
    return '0';
  }

  return '?';
}

/*
 *  Try to map a file name to a file format, i.e. "foo.tap" maps
 *  to TF_TAP, and so on.  Return format, or TF_NONE if we fail.
 */

u_int map_ext2tf(char* arg)
{
  u_int fmt;

  arg = strrchr(arg, '.');
  if (arg == NULL)
    return TF_NONE;

  arg = strdup(++arg);
  if (arg == NULL)
    return TF_NONE;

  downcase(arg);

  fmt = map_s2i(arg, name_tpformat, TF_NONE);

  free(arg);

  return fmt;
}

/***********************************************************************/

/*
 *  Printing and formatting routines:
 */

/*
 *  Print a tops-10 UDT in human-readable format.
 *
 *  The following code (mis)uses, amongst other things, the fact that
 *  the year 1858 (base year of UDT) aligns with 1970 (base of time_t)
 *  with regard to leap years.  We do some heavy lifting first, then
 *  let gmtime() handle the gruesome fine details.
 *
 *  The leap year thing above is almost correct.  The year 1900 was
 *  NOT a leap year, but we adjust for that and hope that no one has
 *  created a tops-10 file before that.  The year 2100 will also not
 *  be a leap year, the code will need a bug fix by then.
 */

void p_udt(w36 udt)
{
  u_int days, frac;
  struct tm* tm;
  time_t part;

  static char* month[] = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  };

  days = lhalf(udt);
  frac = rhalf(udt);

  /* Adjust to beginning of 1858, and make 1900 a leap year: */

  days += 320 + 1;
  
  /*
   *  Below, 1461 is 4*365 + 1, i.e. four years and one leap day.
   *
   *  The fractional part is: fraction * 86400 / 2^18, modified to
   *  stay below 2^32 during calculation.
   */

  part = ((days % 1461) * 86400) + ((frac * 675) >> 11);

  /* Now part is in the range 1970..1973, inclusive. */

  tm = gmtime(&part);

  /* 1788 = 1900 - 1970 + 1858 */

  printf("%2d-%s-%4d %02d:%02d:%02d",
	 tm->tm_mday, month[tm->tm_mon],
	 tm->tm_year + 1788 + ((days / 1461) << 2),
	 tm->tm_hour, tm->tm_min, tm->tm_sec);
}

/*
 *  Print a word formatted as a version number.
 */

void p_vers(w36 w)
{
  u_int who, ver, min, edt;

  who = ldb(3, w, 2);
  ver = ldb(9, w, 11);
  min = ldb(6, w, 17);
  edt = rhalf(w);

  printf("%o", ver);
  if (min != 0) {
    if (min > 26) {
      putchar('A' + (min/26) - 1);
      min %= 26;
    }
    putchar('A' + min - 1);
  }
  printf("(%o)", edt);
  if (who != 0) {
    printf("-%o", who);
  }
}

/*
 *  Print a char as itself (if printable) or as a space.
 */

void p_pchar(char c)
{
  if ((c < ' ') || (c == 0177))
    c = ' ';
  putchar(c);
}

/*
 *  Print a newline.
 */

void p_nl(void)
{
  printf("\n");
}

/*
 *  Print a word as SIXBIT.
 */

void p_sixbit(w36 word)
{
  char ch;

  for (;;) {
    ch = (word >> 30) & 0x3f;
    if (ch == 0)
      return;
    putchar(ch + 32);
    word <<= 6;
  }
}

/*
 *  Print a word as an instruction, if we know the opcode.
 */

void p_instr(w36 w)
{
  u_int op, ac, xr;

  op = ldb(9, w, 8);
  ac = ldb(4, w, 12);
  xr = ldb(4, w, 17);

  if (op >= 0700) {
    return;			/* I/O instr.  Not yet done. */
  } else {
    if (opcode[op] == 0)	/* Know the opcode? */
      return;

    printf("  %s %o,", opcode[op], ac);
    if (lhalf(w) & 020)
      putchar('@');
    printf("%o", rhalf(w));
    if (xr != 0)
      printf("(%o)", xr);
  }
}

/*
 *  Print a word, in several formats:
 */

void p_word(u_int offset)
{
  w36 w = tapebuffer[offset];
  u_char* rp = &rawbuffer[offset * 5];

  if (pw_hex) {
    if (pw_raw) {
      printf("  %02x%02x%02x%02x%02x", rp[0], rp[1], rp[2], rp[3], rp[4]);
    } else {
      printf("  %9llx", w);
    }
  }

  if (pw_hword) {
    printf("  %06o,,%06o", lhalf(w), rhalf(w));
  }

  if (pw_7bit) {
    printf("  %3o %3o %3o %3o %3o %1o",
	   ldb(7, w, 6),
	   ldb(7, w, 13),
	   ldb(7, w, 20),
	   ldb(7, w, 27),
	   ldb(7, w, 34),
	   (u_int) w & 1);
  }

  if (pw_text) {
    printf("  \"");
    p_pchar(ldb(7, w, 6));
    p_pchar(ldb(7, w, 13));
    p_pchar(ldb(7, w, 20));
    p_pchar(ldb(7, w, 27));
    p_pchar(ldb(7, w, 34));
    printf("\"");
  }

  if (pw_sixbit) {
    printf("  '%c%c%c%c%c%c'",
	   ldb(6, w,  5) + ' ',
	   ldb(6, w, 11) + ' ',
	   ldb(6, w, 17) + ' ',
	   ldb(6, w, 23) + ' ',
	   ldb(6, w, 29) + ' ',
	   ldb(6, w, 35) + ' ');
  }
  if (pw_instr) {
    p_instr(w);
  }
}

/*
 *  Print a saveset header/trailer.
 */

void p_saveset(int type)
{
  char* name = "?";

  switch (type) {
  case T_BEGIN: name = "start";            break;
  case T_END:   name = "end";      p_nl(); break;
  case T_CONT:  name = "continue"; p_nl(); break;
  }

  printf("Backup reel %u; %s save set: %s\n",
	 (u_int) bckhdr[G_RTNM],
	 name, t_ssname);
  printf("  by version "); p_vers(bckhdr[S_BVER]);
  printf(" at "); p_udt(bckhdr[S_DATE]); p_nl();
  printf("  written on "); p_sixbit(bckhdr[S_DEV]); printf(": ");
  if (bckhdr[S_RLNM] != 0) {
    printf("("); p_sixbit(bckhdr[S_RLNM]); printf(") ");
  }
  printf("on s/n %u at %s", (u_int) bckhdr[S_APR],
	 map_i2s(bckhdr[S_MTCH] & 7, name_density, "unknown density"));
  if (bckhdr[S_BLKF] != 0)
    printf("; blocking factor %u", (u_int) bckhdr[S_BLKF]);
  p_nl();
  if (t_sysname[0] != 0)
    printf("  under system %s\n", t_sysname);
  p_nl();
}

/*
    Listing contents of a tape (-t option), should produce something like
    the following output:

    Output from "dir mta0:" on a real system:

    Read Density:800  Parity:Odd  9-Track  Read only

    BACKUP reel number 1; start save set: 
      by version 3(411) at  0:30:03 on 10-Oct-01
      written on MTA0:, on S/N 4097 at 1600 9TK; Blocking factor 4
      under system: SunOS

      FILExx  EXT   123  <***>   10-Dec-17    4B(4711)-2

      [.....]

      Total of 12359 blocks in 120 files

    BACKUP reel number 1; end save set: 
      by version 3(411) at  0:30:05 on 10-Oct-01
      written on MTA0:, on S/N 4097 at 1600 9TK; Blocking factor 4
      under system: SunOS

*/

/*
 *  Print a common header for a data record, with some extra info.
 *  All on a single line.
 */

void p_recinfo(void)
{
  printf("record %04d Data (%d bytes)", taperecnum, tapereclen);
  switch (taperectype) {
  case DT_ANSILBL:
    printf(", ANSI label (%s%c)\n",
	   map_i2s(datarectype, name_lbltype, ""),
	   rawbuffer[3]);
    break;
  case DT_BACKUP:
    printf(", backup type %d (%s)\n",
	   datarectype, map_i2s(datarectype, name_rectype, ""));
    break;
  case DT_DUMPER:
    printf(", dumper type %d (%s)\n",
	   datarectype, map_i2s(datarectype, name_dumper_rectype, ""));
    break;
  case DT_FAILSAFE:
    printf(", failsafe %s record\n",
	   map_i2s(datarectype, name_failsafe_rectype, ""));
    break;
  default:
    p_nl();
    break;
  }
}

/***********************************************************************/

/*
 *  checksumdata() computes a checksum over a number of 36-bit words.
 *  the algorithm used is (in macro-10):
 * 
 *  CHKSUM: MOVEI  T1,0
 *          MOVSI  T2,-count
 *          HRRI   T2,data
 *  LOOP:   ADD    T1,(T2)
 *          ROT    T1,1
 *          AOBJN  T2,LOOP
 *          POPJ   P,
 */

w36 checksumdata(w36* data, u_int count)
{
  w36 sum;

  sum = 0;
  while (count-- > 0) {
    sum += *data++;
    if (sum & 0x800000000LL) {
      sum <<= 1;
      sum += 1;
      sum &= 0xfffffffffLL;
    } else {
      sum <<= 1;
    }
  }
  return sum;
}

/***********************************************************************/

/*
 *  Check if this tape record is an ANSI label, if so set up sub-type.
 */

u_int tp_id_ansi(void)
{
  char lname[4];
  int ltype;

  lname[0] = rawbuffer[0];
  lname[1] = rawbuffer[1];
  lname[2] = rawbuffer[2];
  lname[3] = 0;

  ltype = map_s2i(lname, name_lbltype, AL_NONE);
  if (ltype == AL_NONE)
    return 0;

  if (!isdigit(rawbuffer[3]))
    return 0;

  datarectype = ltype;
  return 1;
}

/*
 *  Check if this tape record is a backup record.
 */

u_int tp_id_backup(void)
{
  w36 type;

  if (tapereclen < 2720)
    return 0;

  if (tapereclen > ((MAXBLKF * 128 * 5) + 160))
    return 0;

  if ((tapereclen - 160) % 2560 != 0)
    return 0;

  type = bckhdr[G_TYPE];
  if (type < 1 || type > 010)
    return 0;
  
  datarectype = type;
  return 1;
}

/*
 *  Check if this tape record is one (or more) dumper records.
 */

u_int tp_id_dumper(void)
{
  w36 type;

  if (tapereclen < 2590)
    return 0;

  if (tapereclen > (15 * 2590))	/* Max blocking factor, 15. */
    return 0;

  if (tapereclen % 2590 != 0)
    return 0;

  type = tapebuffer[4];
  if (type == 0) {
    datarectype = 0;
    return 1;
  }

  if (lhalf(type) != 0777777)
    return 0;

  if (rhalf(type) <= 0777770)
    return 0;

  datarectype = 01000000 - rhalf(type);
  return 1;
}

/*
 *  Check if this is a failsafe record.
 */

u_int tp_id_failsafe(void)
{
  /*
   *  there are three header variants, first word:
   *
   *  vers,,len   -- saveset header/trailer.
   *    -1,,len   -- file (directory) header.
   *     0,,len   -- file data.
   *
   *  saveset records are:
   *     vers,,4
   *    '*fails'
   *    'afe',,tape seq (neg for tailer)
   *    date-and-time
   *    xwd 1,2  (ppn)
   */

  u_int type, wc;

  if (tapereclen > 2560)
    return 0;

  type = lhalf(tapebuffer[0]);
  wc = rhalf(tapebuffer[0]);
  
  if (wc > 0777)
    return 0;

  if ((wc + 1) * 5 != tapereclen)
    return 0;

  if (type == 0) {
    datarectype = F_DATA;
    return 1;
  }

  if (type == 0777777) {
    datarectype = F_FILE;
    return 1;
  }

  if (type > 0200)
    return 0;

  if (wc == 4) {
    /* begin or end. */
    if (tapebuffer[1] != sixbit("*fails"))
      return 0;
    datarectype = F_BEGIN;
    if (rhalf(tapebuffer[2]) & 0400000)
      datarectype = F_END;
    return 1;
  }

  return 0;
}

/*
 *  Try to identify type of data, based on size of tape record.
 */

u_int tp_ident(void)
{
  switch (ssformat) {
  case SF_BACKUP:
    if (tp_id_backup())
      return DT_BACKUP;
    break;
  case SF_DUMPER:
    if (tp_id_dumper())
      return DT_DUMPER;
    break;
  case SF_FAILSAFE:
    if (tp_id_failsafe())
      return DT_FAILSAFE;
    break;
  default:
    break;
  }

  switch (tapereclen) {
  case 80:
    if (tp_id_ansi())
      return DT_ANSILBL;
    if (tp_id_failsafe())
      return DT_FAILSAFE;
    return DT_NONE;
  case 2590:
    if (tp_id_dumper())
      return DT_DUMPER;
    return DT_NONE;
  case 2720:
    if (tp_id_backup())
      return DT_BACKUP;
    return DT_NONE;
  }

  if (tp_id_backup())
    return DT_BACKUP;

  if (tp_id_dumper())
    return DT_DUMPER;

  if (tp_id_failsafe())
    return DT_FAILSAFE;

  if (tapereclen == 2560)
    return DT_COREDUMP;

  return DT_NONE;
}

/*
 *  Skip a given number of bytes from the input (tape) file.
 */

void tp_skip(u_int bytes)
{
  u_char buf[512];

  while (bytes > 512) {
    (void) fread(buf, 1, 512, tapefile);
    bytes -= 512;
  }

  if (bytes > 0) {
    (void) fread(buf, 1, bytes, tapefile);
  }
}

/*
 *  Read a number of words into the tape buffer, at the given offset.
 *  If we have a record-structured input file  we limit ourselves to
 *  the amount of data in the current record.
 *
 *  The amount to read is given in bytes, since that is what we
 *  keep track of when handing tape data.
 */

void tp_read(u_int offset, u_int bytes)
{
  int words;
  w36 w;
  u_char buf[5*512];
  u_char* ptr = buf;

  while (bytes > (5*512)) {
    tp_read(offset, 5*512);
    bytes -= 5*512;
    offset += 512;
  }

  if (bytes == 0)		/* Anything left to do? */
    return;			/*   No, don't do it. */

  words = (bytes + 4) / 5;

  bzero(buf, sizeof(buf));
  (void) fread(buf, 1, bytes, tapefile);

  if (offset == 0) {
    bzero(rawbuffer, sizeof(rawbuffer));
    bcopy(buf, rawbuffer, bytes);
  }

  if (offset + words > TPBUFSZ) {
    words = TPBUFSZ - offset;	/* Stay within tape buffer, please. */
  }

  while (words-- > 0) {
    w = *ptr++;
    w <<= 8; w |= *ptr++;
    w <<= 8; w |= *ptr++;
    w <<= 8; w |= *ptr++;
    w <<= 4; w |= (*ptr++ & 0x0f);

    tapebuffer[offset++] = w;
  }
}

/*
 *  Start reading the next object from the source tape.  Return
 *  type.  If this is a data record, read it in.
 */

void tp_next(void)
{
  int c;
  int length;
  u_char header[4];

  prevobject = tapeobject;	/* Remember. */
  tapereclen = 0;		/* Default, not known. */

  switch (tapeformat) {
  case TF_PHY:			/* Physical tape. */
    /* Needs writing. */
    break;

  case TF_RAW:			/* Raw data. */
    c = fgetc(tapefile);
    if (c == EOF) {
      tapeobject = TP_EOT;
    } else {
      ungetc(c, tapefile);
      tp_read(0, 5*32);		/* Read in backup header. */

      length = lhalf(bckhdr[G_TBS]);
      if (length > 32)
	length -= 32;
      else
	length = 512;

      tp_read(32, 5 * length);	/* Read in data block. */
      tapereclen = 5 * (32 + length);
      tapeobject = TP_DATA;
    }
    break;

  case TF_E11:			/* .e11 format. */
  case TF_TAP:			/* .tap format. */
    length = fread(header, 1, 4, tapefile);
    if (length != 4) {
      /* XXX should examine further. */
      tapeobject = TP_EOT;
      break;
    }
    length = (header[3] << 24) + (header[2] << 16)
      + (header[1] << 8) + header[0];
    tapereclen = length;

    if (length == 0) {
      tapeobject = TP_MARK;
      break;
    }

    if (length == 0xffffffff ||
	length == 0xfffffffe ||
	length == 0xfffeffff) {
      tapeobject = TP_GAP;
      break;
    }

    tapeobject = TP_DATA;

    if (tapeformat == TF_TAP && length & 1)
      length += 1;
    tp_read(0, length);

    tp_skip(4);			/* Skip four-byte trailer. */
    break;

  case TF_TPC:			/* .tpc format. */
    length = fread(header, 1, 2, tapefile);
    if (length != 2) {
      /* XXX should examine further. */
      tapeobject = TP_EOT;
      break;
    }
    length = (header[1] << 8) + header[0];
    if (length == 0) {
      tapeobject = TP_MARK;
      break;
    }
    tapereclen = length;
    tapeobject = TP_DATA;

    if (length & 1)
      length += 1;
    tp_read(0, length);

    break;
  }

  switch (tapeobject) {
  case TP_MARK:
    if (prevobject == TP_MARK)
      tapeobject = TP_EOF;
    break;
  case TP_DATA:
    taperectype = tp_ident();
    break;
  }
}

/***********************************************************************/
/*
 *  The w_xxx routines below are all used to write backup format tapes.
 */

/*
 *  w_word() stores one word at the given address, and returns
 *  the updated address.
 */

w36* w_word(w36* pos, w36 word)
{
  *pos++ = word;

  return pos;
}

/*
 *  w_text() builds (and stores) a text sub-block at the given address.
 */

w36* w_text(w36* ptr, int type, int words, char* text)
{
  int bytes;

  bytes = strlen(text) + 1;
  if (words == 0) {
    words = (bytes + 4) / 5;
  }
  *ptr++ = xwd(type, words + 1);
  while (words-- > 0) {
    *ptr++ = ascii(text);
    bytes -= 5;
    if (bytes > 0) {
      text += 5;
    } else {
      text = "";
    }
  }
  return ptr;
}

/*
 *  w_ctext() writes text sub-blocks in header format.  (boo hiss)
 */

w36* w_ctext(w36* pos, int type, char* text)
{
  char buffer[STRSIZE + 10];
  int words;

  words = (strlen(text) + 2 + 4) / 5;

  bzero(buffer, sizeof(buffer));
  buffer[0] = type;
  buffer[1] = words;
  strcpy(&buffer[2], text);
  text = buffer;
  while (words-- > 0) {
    pos = w_word(pos, ascii(text));
    text += 5;
  }
  return pos;
}

/*
 *  Set up a tape record with the information common to all blocks.
 */

void setup_general(int blocktype)
{
  (void) bzero(tapebuffer, sizeof(tapebuffer));

  bckhdr[G_TYPE] = blocktype;	/* Block type. */
  bckhdr[G_SEQ] = ++seq;	/* Next sequence number. */
  bckhdr[G_RTNM] = 1;		/* Tape number, only one. */
  bckhdr[G_FLAGS] = 0;		/* No flags. */
}

/*
 *  Set up a BEGIN or END record.
 */

void setup_be(int blocktype)
{
  w36* ptr;

  setup_general(blocktype);

  bckhdr[S_DATE] = getnow();	/* (014) Date/time. */
  bckhdr[S_FMT] = 1;		/* (015) Format */
  bckhdr[S_BVER] = 0;		/* (016) Backup version. */
  bckhdr[S_MON] = 0;		/* (017) Unknown system type. */
  bckhdr[S_SVER] = 0;		/* (020) OS version. */
  bckhdr[S_APR] = apr;		/* (021) CPU serial number. */
  bckhdr[S_DEV] = sixbit(dev);	/* (022) Device. */
  bckhdr[S_MTCH] = map_s2i(bpi, name_density, 0);
				/* (023) 1600 bpi. */
  bckhdr[S_RLNM] = sixbit(reel);/* (024) Reel name. */
  ptr = &bckdata[0];

  ptr = w_text(ptr, O_SYSNAME, 6, sysname);

  //ptr = w_word(ptr, 0);

  bckhdr[G_LND] = 7;
}

/*
 *  Write out the tape buffer.
 */

void w_buffer(void)
{
  int i;
  w36 w;

  /* XXX use the actual amount of data? Do we handle non-standard blk size?*/

  bckhdr[G_CHECK] = 0;
  bckhdr[G_CHECK] = checksumdata(tapebuffer, 32 + 512);

  switch (tapeformat) {
  case TF_E11:
  case TF_TAP:
    fputc(0xa0, tapefile);
    fputc(0x0a, tapefile);
    fputc(0x00, tapefile);
    fputc(0x00, tapefile);
    break;
  case TF_TPC:
    fputc(0xa0, tapefile);
    fputc(0x0a, tapefile);
    break;
  case TF_RAW:
    break;
  case TF_PHY:
    /* Needs code. */
    break;
  }

  for (i = 0; i < 544; i += 1) {
    w = tapebuffer[i];
    fputc((w >> 28) & 0xff, tapefile);
    fputc((w >> 20) & 0xff, tapefile);
    fputc((w >> 12) & 0xff, tapefile);
    fputc((w >> 4) & 0xff, tapefile);
    fputc(w & 0x0f, tapefile);
  }

  switch (tapeformat) {
  case TF_E11:
  case TF_TAP:
    fputc(0xa0, tapefile);
    fputc(0x0a, tapefile);
    fputc(0x00, tapefile);
    fputc(0x00, tapefile);
    break;
  case TF_TPC:
    /* No trailing header. */
    break;
  case TF_RAW:
    break;
  case TF_PHY:
    /* Needs code. */
    break;
  }
}

/*
 *  Write a T_BEGIN record.
 */

void w_begin(void)
{
  setup_be(T_BEGIN);
  w_buffer();
}

/*
 *  Write a T_END record.
 */

void w_end(void)
{
  setup_be(T_END);
  w_buffer();
}

/*
 *  Write a T_UFD record.
 *
 *  level is 0 for device, 1 for UFD and 2..6 for SFD's.
 */

void w_ufd(u_int level)
{
  w36* pos;

  setup_general(T_UFD);

  /* fill in file name block. */

  pos = bckdata;
  pos = w_word(pos, xwd(O_NAME, 0200));
  pos = w_text(pos, _FCDEV, 0, f_device);
  pos = w_text(pos, _FCDIR, 0, f_ufd);
  if (level >= 2) pos = w_text(pos, _FCSF1, 0, f_sfd[1]);
  if (level >= 3) pos = w_text(pos, _FCSF2, 0, f_sfd[2]);
  if (level >= 4) pos = w_text(pos, _FCSF3, 0, f_sfd[3]);
  if (level >= 5) pos = w_text(pos, _FCSF4, 0, f_sfd[4]);
  if (level >= 6) pos = w_text(pos, _FCSF5, 0, f_sfd[5]);

  /* fill in file attribute block. */

  pos = &bckdata[0200];
  pos = w_word(pos, xwd(O_FATTR, 0200));
  pos[A_FHLN] = LN_AFH;
  pos[A_FLGS] = xwd(010000, 0);	/* Flags. */
  pos[A_WRIT] = 0;		/* Date. */
  pos[A_ALLS] = 0;		/* Allocated size. */
  pos[A_MODE] = 017;		/* Binary mode. */
  pos[A_LENG] = 0;		/* Actual length. */
  pos[A_BSIZ] = 36;		/* Byte size = 36. */
  pos[A_PROT] = 0;		/* Protection. */
  pos[A_REDT] = 0; /* ?? */
  pos[A_MODT] = 0; /* ?? */
  pos[A_ESTS] = 0; /* ?? */
  pos[A_MUSR] = 0;		/* byte ptr to creator id. */
  pos[A_FTYP] = 0;		/* (logged-in quota) */
  pos[A_FBSZ] = 0;		/* (logged-out quota) */
  pos[A_FFFB] = 0;		/* (blocks used for files) */

  /* fill in directory attr. block. */

  pos = &bckdata[0400];
  pos = w_word(pos, xwd(O_DATTR, 0200));
  pos[D_FHLN] = LN_DFH;
  pos[D_PROT] = C36(0xa00070505); /* Protection. <755>*/
  pos[D_LOGT] = 0;		/* Login date/time. */

  /* fill in ordinary header words. */

  bckhdr[G_LND] = 0600;
  bckhdr[D_PCHK] = checksumdata(bckdata, 0200);
  bckhdr[D_LVL] = level;
  (void) w_ctext(&bckhdr[D_STR], _FCDEV, f_device);

  if (debug)
    printf("  w_ufd: prot = %llx\n", pos[D_PROT]);

  w_buffer();
}

/*
 *  Write a tape mark.
 */

void w_mark(void)
{
  switch (tapeformat) {
  case TF_E11:
  case TF_TAP:
    fputc(0x00, tapefile);
    fputc(0x00, tapefile);
    fputc(0x00, tapefile);
    fputc(0x00, tapefile);
    break;
  case TF_TPC:
    fputc(0x00, tapefile);
    fputc(0x00, tapefile);
    break;
  case TF_RAW:
    break;
  case TF_PHY:
    /* Needs code. */
    break;
  }
}

/*
 *  Write and end-of-file marker.
 */

void w_eof(void)
{
  w_mark();
  w_mark();
}


/*
 *  Fill in the tape header F_PTH part from global variables.
 */

void mkheadpath(void)
{
  w36* pos;

  pos = &bckhdr[F_PTH];
  if (!interchange) {
    pos = w_ctext(pos, _FCDEV, f_device);
    pos = w_ctext(pos, _FCDIR, f_ufd);
    if (dlevel >= 2) {
      pos = w_ctext(pos, _FCSF1, f_sfd[1]);
      if (dlevel >= 3) {
	pos = w_ctext(pos, _FCSF1, f_sfd[2]);
      }
    }
  }
  pos = w_ctext(pos, _FCNAM, f_name);
  pos = w_ctext(pos, _FCEXT, f_ext);

  bckhdr[F_PCHK] = namechecksum;
}

/*
 *  binarydata() guesses if the input file is ASCII or binary on the
 *  TOPS side of the world.
 */

int binarydata(void)
{
  int i;

  switch (diskformat) {
  case DF_ASCII:
    return 0;
  case DF_COREDUMP:
  case DF_HIGHDENS:
  case DF_INDUSTRY:
    return 1;
  }

  /* If DF_BINARY, check B35 in all words: */

  for (i = 4; i < diskcount; i += 5) {
    if (diskbuffer[i] & 0x80) {
      return 1;
    }
  }
  return 0;
}

/*
 *  blockcount() returns a faked-up allocated size of a file.
 *  we bluntly assume a tops-10 cluster size of 5.
 */

u_int blockcount(void)
{
  int count;

  count = (filelength + opw - 1) / opw; /* Words for data. */
  count = (count + 127) / 128;	/* Blocks for data. */
  count = (count + 4 + 2) / 5;	/* Clusters, including two RIB blocks. */
  count = count * 5;		/* Blocks. */
  return count;
}

/*
 *  Store a sub-string.
 */

void fakestring(char* dst, char* name, int len)
{
  int pos;
  char c;

  bzero(dst, STRSIZE);

  pos = 0;
  while ((c = *name++) != 0) {
    if ((c >= 'a') && (c <= 'z')) {
      c = c - 'a' + 'A';
    }
    if (pos < len) {
      dst[pos] = c;
      pos += 1;
    }
  }
  dst[pos] = 0;
}

/*
 *  Fake up an SFD name.
 */

void fakesfd(u_int level, char* name)
{
  fakestring(f_sfd[level], name, 6);
}

/*
 *  Set up the tops-10 versions of NAME.EXT from the file name.
 */

void faketops(char* name)
{
  char* namepart;
  char* extpart;

  namepart = strrchr(name, '/');
  if (namepart == NULL) {
    namepart = name;
  } else {
    namepart++;
  }

  extpart = strrchr(namepart, '.');
  if (extpart != NULL)
    *extpart++ = 0;

  fakestring(f_name, namepart, 6);
  if (extpart != NULL) {
    fakestring(f_ext, extpart, 3);
  } else {
    bzero(f_ext, STRSIZE);
  }
}

/*
 *  Open disk file for reading.
 */

int openread(char* name)
{
  diskfile = fopen(name, "rb");
  if (diskfile == NULL) {
    fprintf(stderr, "Can't open %s for reading.\n", name);
    return 0;
  }

  /*
   *  If we are expanding newlines to <CR><LF>, we have to update
   *  the file length.
   */

  if (diskformat == DF_ASCII) {
    u_char buffer[512];
    int count;
    int i;

    while ((count = fread(buffer, 1, 512, diskfile)) > 0) {
      for (i = 0; i < count; i += 1) {
        if (buffer[i] == '\012') {
          filelength += 1;
        }
      }
    }
    rewind(diskfile);
  }

  dataoffset = 0;

  return 1;
}

/*
 *  Open disk file for writing.  The file name is taken from global
 *  variables.  Variants to be used are:
 *
 *  interchange:  name.ext
 *  canonical:    device:[directory]name.ext
 *  buildtree:    device/ufd/sfd/.../name.ext
 *                if -d is used, omit device level.
 *
 *  In all cases, the actual name/path used will be stored in oname.
 */

int makepath(char* path)
{
  struct stat statbuf;

  if (debug)
    fprintf(stderr, " -- trying to create '%s'\n", path);

  if (stat(path, &statbuf) != 0) {
    if (mkdir(path, 0777) != 0) {
      fprintf(stderr, "%s: can't create directory %s/\n", programname, path);
      return 0;
    }
  }

  return 1;
}

int openwrite(void)
{
  int pos = 0;
  int i;

  /*
   *  Needs work to handle dumper file names.
   */

  if (interchange) {
    bcopy(iname, oname, STRSIZE);
    goto work;
  }

  if (buildtree) {
    if (f_device[0] != 0 && !nodevice) {
      pos += snprintf(&oname[pos], (STRSIZE - pos), "%s", f_device);
      if (!makepath(oname))
	return 0;
      oname[pos++] = '/';
    }

    if (f_ufd[0] != 0) {
      pos += snprintf(&oname[pos], (STRSIZE - pos), "%s", f_ufd);
      if (!makepath(oname))
	return 0;
      oname[pos++] = '/';
    }

    for (i = 1; i <= 5; i += 1) {
      if (f_sfd[i][0] != 0) {
	pos += snprintf(&oname[pos], (STRSIZE - pos), "%s", f_sfd[i]);
	if (!makepath(oname))
	  return 0;
	oname[pos++] = '/';
      } else {
	i = 5;
      }
    }

    pos += snprintf(&oname[pos], (STRSIZE - pos), "%s", iname);
    goto work;
  }

  bcopy(cname, oname, STRSIZE);

 work:

  /*
   *  Check for existing file, and compare file dates.  Depending on
   *  settings, overwrite existing file or not.
   */

  diskfile = fopen(oname, "wb");
  if (diskfile == NULL) {
    fprintf(stderr, "%s: can't open %s for writing.\n", programname, oname);
    return 0;
  }
  
  return 1;
}

/*
 *  Close the disk file we just wrote, and fix the timestamps on it.
 */

void closewrite(void)
{
  struct utimbuf ut;

  fclose(diskfile);

  ut.actime = udt2time(f_rdtime);
  ut.modtime = udt2time(f_wrtime);
  (void) utime(oname, &ut);
}

/*
 *  Check if we have an open file, if so close it.
 */

void checkclose(void)
{
  if (extracting) {
    if (!quiet)
      p_nl();
    closewrite();
    extracting = 0;
  }
  infile = 0;
}

/*
 *  aread() does an fread(), expanding newlines to <CR><LF>.
 */

size_t aread(u_char* ptr, u_int size, u_int maxcount, FILE* f)
{
  static char buffer[512];
  static int bufpos = 0;
  static int bufcount = 0;
  static int lfflag = 0;

  int count = 0;
  char c;

  for (;;) {
    while ((bufpos < bufcount) || lfflag) {
      if (lfflag) {
        c = '\012';
        lfflag = 0;
      } else {
        c = buffer[bufpos++];
        if (c == '\012') {
          lfflag = 1;
          c = '\015';
        }
      }
      ptr[count++] = c;
      if (count >= maxcount)
	return count;
    }
    bufcount = fread(buffer, 1, sizeof(buffer), diskfile);
    bufpos = 0;
    if (bufcount == 0)
      return count;
  }
}

/*
 *  Fill in the disk buffer with data.
 */

void readdisk(void)
{
  (void) bzero(diskbuffer, sizeof(diskbuffer));

  switch (diskformat) {
  case DF_ASCII:
    diskcount = aread(diskbuffer, 1, 5*512, diskfile);
    break;
  case DF_NONE:
  case DF_BINARY:
  case DF_COREDUMP:
    diskcount = fread(diskbuffer, 1, 5*512, diskfile);
    break;
  case DF_HIGHDENS:
    diskcount = fread(diskbuffer, 1, 9*256, diskfile);
    break;
  case DF_INDUSTRY:
    diskcount = fread(diskbuffer, 1, 4*512, diskfile);
    break;
  }
}

/*
 *  Copy data from the disk buffer to the tape buffer.
 */

void copy2tape(u_int offset)
{
  w36 w;
  u_int wc = 0;
  u_int i = 0;

  while (i < diskcount) {
    switch (diskformat) {
    case DF_NONE:
    case DF_ASCII:
    case DF_BINARY:
      w  = (w36) (diskbuffer[i++] & 0x7f) << 29;
      w |= (w36) (diskbuffer[i++] & 0x7f) << 22;
      w |= (w36) (diskbuffer[i++] & 0x7f) << 15;
      w |= (w36) (diskbuffer[i++] & 0x7f) << 8;
      w |= (w36) (diskbuffer[i++] & 0x7f) << 1;
      if (diskbuffer[i+4] & 0x80) {
	w |= 1;
      }
      break;
    case DF_COREDUMP:
      w  = (w36) (diskbuffer[i++] & 0xff) << 28;
      w |= (w36) (diskbuffer[i++] & 0xff) << 20;
      w |= (w36) (diskbuffer[i++] & 0xff) << 12;
      w |= (w36) (diskbuffer[i++] & 0xff) << 4;
      w |= (w36) (diskbuffer[i++] & 0x0f);
      break;
    case DF_HIGHDENS:
      w  = (w36) (diskbuffer[i++] & 0xff) << 28;
      w |= (w36) (diskbuffer[i++] & 0xff) << 20;
      w |= (w36) (diskbuffer[i++] & 0xff) << 12;
      w |= (w36) (diskbuffer[i++] & 0xff) << 4;
      w |= (w36) (diskbuffer[i] & 0xf0) >> 4;
      bckdata[offset + wc++] = w;
      w  = (w36) (diskbuffer[i++] & 0x0f) << 32;
      w |= (w36) (diskbuffer[i++] & 0xff) << 24;
      w |= (w36) (diskbuffer[i++] & 0xff) << 16;
      w |= (w36) (diskbuffer[i++] & 0xff) << 8;
      w |= (w36) (diskbuffer[i++] & 0xff);
      break;
    case DF_INDUSTRY:
      w  = (w36) (diskbuffer[i++] & 0xff) << 28;
      w |= (w36) (diskbuffer[i++] & 0xff) << 20;
      w |= (w36) (diskbuffer[i++] & 0xff) << 12;
      w |= (w36) (diskbuffer[i++] & 0xff) << 4;
      break;
    }
    bckdata[offset + wc++] = w;
  }

  bckhdr[G_SIZE] = wc;
  dataoffset += wc;
}

/*
 *  Copy from the tape buffer to the (open) disk file.
 */

void copy2disk(u_int offset, u_int len, u_int eofflag)
{
  char buf[9];
  int amount;
  int format = diskformat;
  w36 w, w2;

  if (format == DF_NONE) {
    switch (taperectype) {
    case DT_BACKUP:
      format = DF_ASCII;
      break;
    case DT_DUMPER:
      /* select format from byte size, default to seven-bit bytes. */
      format = DF_BINARY;
      break;
    default:
      format = DF_ASCII;
      break;
    }
  }

  while (len-- > 0) {
    if (offset < TPBUFSZ)
      w = tapebuffer[offset++];

    switch (format) {
    case DF_ASCII:
    case DF_BINARY:
      buf[0] = (w >> 29) & 0177;
      buf[1] = (w >> 22) & 0177;
      buf[2] = (w >> 15) & 0177;
      buf[3] = (w >> 8) & 0177;
      buf[4] = (w >> 1) & 0177;
      if (w & 1) buf[4] |= 0200;
      amount = 5;
      if (len == 0) {		/* Last word of buffer? */
	if (eofflag) {		/*   End of file? */
	  if (format == DF_ASCII) {
	    amount = 1;
	    if (buf[1] != 0) amount = 2;
	    if (buf[2] != 0) amount = 3;
	    if (buf[3] != 0) amount = 4;
	    if (buf[4] != 0) amount = 5;
	  }
	}
      }
      break;
    case DF_COREDUMP:
      buf[0] = (w >> 28) & 0xff;
      buf[1] = (w >> 20) & 0xff;
      buf[2] = (w >> 12) & 0xff;
      buf[3] = (w >> 4) & 0xff;
      buf[4] = w & 0x0f;
      amount = 5;
      break;
    case DF_HIGHDENS:
      w2 = tapebuffer[offset++];
      len--;

      buf[0] = (w >> 28) & 0xff;
      buf[1] = (w >> 20) & 0xff;
      buf[2] = (w >> 12) & 0xff;
      buf[3] = (w >> 4) & 0xff;
      buf[4] = ((w << 4) & 0xf0) | ((w2 >> 32) & 0x0f);
      buf[5] = (w2 >> 24) & 0xff;
      buf[6] = (w2 >> 16) & 0xff;
      buf[7] = (w2 >> 8) & 0xff;
      buf[8] = w2 & 0xff;
      amount = 9;
      break;
    case DF_INDUSTRY:
      buf[0] = (w >> 28) & 0xff;
      buf[1] = (w >> 20) & 0xff;
      buf[2] = (w >> 12) & 0xff;
      buf[3] = (w >> 4) & 0xff;
      amount = 4;
      break;
    }
    (void) fwrite(buf, 1, amount, diskfile);
  }
}

/***********************************************************************/

/*
 *  Write one file to the tape.
 *
 *  Treat the following "names" as control flags setting modes:
 *
 *  -a  -- set ascii mode, i.e. expand <lf> to <cr><lf> from disk.
 *  -b  -- binary (default).
 *  -c  -- core dump mode.
 *  -h  -- high density mode.
 *  -i  -- industry mode.
 *
 *  -s <str> -- start a new saveset named <str>.
 */

void write_file(char* pfx, char* name)
{
  w36* pos;
  int more;
  DIR* dir;
  struct dirent* dp;
  struct stat statbuf;

  char fullname[STRSIZE + 1];

  if (pfx == NULL && name[0] == '-') {
    if (debug) {
      fprintf(stderr, "handling file option %s\n", name);
    }
    switch (name[1]) {
    case 'a':
    case 'A':
      diskformat = DF_ASCII;
      bpw = 40;
      opw = 5;
      break;
    case 'b':
    case 'B':
      diskformat = DF_BINARY;
      bpw = 40;
      opw = 5;
      break;
    case 'c':
    case 'C':
      diskformat = DF_COREDUMP;
      bpw = 40;
      opw = 5;
      break;
    case 'h':
    case 'H':
      diskformat = DF_HIGHDENS;
      bpw = 36;
      opw = 0;			/* XXX do this per two-word entity? */
      break;
    case 'i':
    case 'I':
      diskformat = DF_INDUSTRY;
      bpw = 32;
      opw = 4;
      break;
    case 's':
    case 'S':
      if (argcount-- > 0) {
	w_end();
	w_mark();
	ssname = *arglist++;
	seq = 0;
	w_begin();
      } else {
	fprintf(stderr, "SaveSet name missing.\n");
      }
      break;
    }
    return;
  }

  if (pfx != NULL) {
    snprintf(fullname, STRSIZE, "%s/%s", pfx, name);
  } else {
    strncpy(fullname, name, STRSIZE);
  }
  fullname[STRSIZE] = 0;

  if (debug) {
    printf("write_file: doing file %s...\n", fullname);
  }

  if (stat(fullname, &statbuf) != 0) {
    fprintf(stderr, "  ... stat() failed...\n");
    return;
  }

  if (S_ISDIR(statbuf.st_mode)) {
    if (interchange) {
      printf("  ignoring sub-dir %s\n", name);
      return;
    }

    if (dlevel >= 6) {		/* Handle at most 5 SFD's. */
      printf("  SFD nesting level too deep for %s\n", fullname);
      return;
    }

    printf("  doing sub-dir %s ...\n", fullname);
    dir = opendir(fullname);
    if (dir == NULL) {
      fprintf(stderr, "  ... opendir() failed...\n");
      return;
    }

    fakesfd(dlevel++, name);
    w_ufd(dlevel);

    while ((dp = readdir(dir)) != NULL) {
      if (dp->d_name[0] == '.')
	continue;
      write_file(fullname, dp->d_name);
    }

    (void) closedir(dir);

    dlevel--;
    
    return;
  }

  filelength = statbuf.st_size;
  filetime = statbuf.st_mtime;

  if (!openread(fullname))
    return;

  faketops(name);		/* Fake up NAME.EXT */
  readdisk();			/* Read in first chunk of data. */

  setup_general(T_FILE);	/* This is the first file block: */

  pos = bckdata;		/* Start here. */

  /* Build the file name block at 0000: */

  pos = w_word(pos, xwd(O_NAME, 0200));
  if (!interchange) {
    pos = w_text(pos, _FCDEV, 0, f_device);
    pos = w_text(pos, _FCDIR, 0, f_ufd);
    if (dlevel >= 2) pos = w_text(pos, _FCSF1, 0, f_sfd[1]);
    if (dlevel >= 3) pos = w_text(pos, _FCSF2, 0, f_sfd[2]);
    if (dlevel >= 4) pos = w_text(pos, _FCSF3, 0, f_sfd[3]);
    if (dlevel >= 5) pos = w_text(pos, _FCSF4, 0, f_sfd[4]);
    if (dlevel >= 6) pos = w_text(pos, _FCSF5, 0, f_sfd[5]);
  }
  pos = w_text(pos, _FCNAM, 0, f_name);
  pos = w_text(pos, _FCEXT, 0, f_ext);

  /* Build the file attribute block at 0200: */

  pos = &bckdata[0200];
  pos = w_word(pos, xwd(O_FATTR, 0200));

  pos[A_FHLN] = LN_AFH;
  pos[A_WRIT] = time2udt(filetime);
  pos[A_ALLS] = blockcount() * 128;
  if (binarydata()) {
    pos[A_MODE] = 016;
    pos[A_LENG] = (filelength + opw - 1) / opw;
    pos[A_BSIZ] = 36;
  } else {
    pos[A_MODE] = 0;
    pos[A_LENG] = filelength;
    pos[A_BSIZ] = 7;
  }

  if (!interchange) {
    pos[A_PROT] = C36(0xa007e2222); /* Protection. <155> */
    pos[A_ESTS] = (filelength + opw - 1) / opw;
    pos[A_REDT] = time2udt(filetime);
    pos[A_MODT] = time2udt(filetime);
  }

  bckhdr[G_LND] = 0400;	/* Two 0200-word blocks used. */

  namechecksum = checksumdata(bckdata, 0200);
  mkheadpath();			/* Fill in header path information. */

  if (diskcount <= (128 * opw)) {
    bckhdr[G_FLAGS] = xwd(GF_SOF+GF_EOF, 0);
    copy2tape(0400);
    more = 0;
  } else {
    bckhdr[G_FLAGS] = xwd(GF_SOF, 0);
    more = 1;
  }

  w_buffer();

  while (more) {
    setup_general(T_FILE);	/* One more file record. */
    mkheadpath();		/* Fill in header path information. */
    bckhdr[F_RDW] = dataoffset;
    copy2tape(0);
    readdisk();			/* Read more data. */
    if (diskcount == 0) {	/* Done? */
      bckhdr[G_FLAGS] = xwd(GF_EOF, 0);
      more = 0;
    }
    w_buffer();
  }

  (void) fclose(diskfile);
}

/*
 *  Here to write a tape.
 */

void do_write(void)
{
  if (tapename == NULL) {
    fprintf(stderr, "do_write: no output file name given\n");
    return;
  }

  if (strcmp(tapename, "-") == 0) {
    tapefile = stdout;
  } else {
    tapefile = fopen(tapename, "wb");
    if (tapefile == NULL) {
      fprintf(stderr, "do_write: can't open output file.\n");
      return;
    }
    if (tapeformat == TF_NONE) {
      tapeformat = map_ext2tf(tapename);
    }
  }

  if (tapeformat == TF_NONE) {
    tapeformat = TF_TAP;	/* For now. */
  }

  seq = 0;			/* (Re)set sequence number.  */

  if (debug)
    printf("writing tape header...\n");
  w_begin();

  if (!interchange) {
    w_ufd(0);
    w_ufd(1);
    dlevel = 1;
  }

  while (argcount-- > 0) {
    write_file(NULL, *arglist++);
  }

  if (debug)
    printf("writing tape trailer...\n");
  w_end();

  w_eof();

  (void) fclose(tapefile);
}

/***********************************************************************/
/*
 *  Routines to parse a tape record, and possibly handle the data inside.
 *
 */

void z_t_info(void)
{
  t_sysname[0] = 0;
  t_ssname[0] = 0;
}

void z_f_info(void)
{
  f_device[0] = 0;
  f_ufd   [0] = 0;
  f_name  [0] = 0;
  f_ext   [0] = 0;
  f_sfd[1][0] = 0;
  f_sfd[2][0] = 0;
  f_sfd[3][0] = 0;
  f_sfd[4][0] = 0;
  f_sfd[5][0] = 0;
  cname   [0] = 0;

  bzero(f_attrs, sizeof(f_attrs));

  f_rdtime = 0;
  f_wrtime = 0;
}

/*
 *  Extract a string from the tape data:
 *
 */

void pars_string(w36* base, u_int offset, int length, char* str)
{
  w36 w;

  if (debug)
    printf("      (string data, %d words)\n", length);

  if (length > (STRSIZE - 1) / 5)
    length = (STRSIZE - 1) / 5;

  while (length-- > 0) {
    w = base[offset++];
    *str++ = ldb(7, w, 6);
    *str++ = ldb(7, w, 13);
    *str++ = ldb(7, w, 20);
    *str++ = ldb(7, w, 27);
    *str++ = ldb(7, w, 34);
  }
  *str++ = 0;
}

/*
 *  Parse an o_name block
 *
 *  The block contains a number of name elements, each starting with
 *  a word with type in left half, and length, including itself, in
 *  the right halft, and then the data as an asciz string.
 *
 *  A word with type zero ends the list.
 */

void pars_name(u_int offset, int length)
{
  int itmlen;
  w36 w;
  int type;
  char* str;
  char dummy[STRSIZE];

  if (debug)
    printf("      (name block)\n");

  z_f_info();

  while (length > 0) {
    w = bckdata[offset++];
    type = lhalf(w);
    itmlen = rhalf(w);

    if (itmlen <= 0)
      goto done;

    length -= 1;
    itmlen -= 1;

    switch (type) {
    case _FCDEV:  str = f_device; break;
    case _FCNAM:  str = f_name;   break;
    case _FCEXT:  str = f_ext;    break;
    case _FCDIR:  str = f_ufd;    break;
    case _FCSF1:  str = f_sfd[1]; break;
    case _FCSF2:  str = f_sfd[2]; break;
    case _FCSF3:  str = f_sfd[3]; break;
    case _FCSF4:  str = f_sfd[4]; break;
    case _FCSF5:  str = f_sfd[5]; break;
    default:
      str = dummy;
      break;
    }

    pars_string(bckdata, offset, itmlen, str);

    length -= itmlen;
    offset += itmlen;
  };

 done:

  ununderscore(f_ufd);
  downcase(f_device);
  downcase(f_name);
  downcase(f_ext);
  downcase(f_sfd[1]);
  downcase(f_sfd[2]);
  downcase(f_sfd[3]);
  downcase(f_sfd[4]);
  downcase(f_sfd[5]);

  buildnames();
}

/*
 *  Parse a file attribute block.
 *
 *  Just copy away the main block to a more permanent place, and
 *  save the strings we might have.
 */

void pars_fattr(u_int offset, int length)
{
  if (debug)
    printf("      (fattr block)\n");

  bcopy(&bckdata[offset], f_attrs, sizeof(f_attrs));

  f_rdtime = f_attrs[A_REDT];
  f_wrtime = f_attrs[A_WRIT];

  /* save strings we want. */
}

/*
 *  Parse a directory attribute block.
 *
 *  At the moment we don't care about these.
 */

void pars_dattr(u_int offset, int length)
{
  if (debug)
    printf("      (dattr block)\n");
}

/*
 *  Parse all non-data blocks in record.
 *
 *  Length of data is in bckhdr[G_LND].
 *  data starts at offset 0, always.
 */

void pars_ndb(void)
{
  u_int offset = 0;
  int length;
  int itmlen;
  w36 w;
  int type;

  length = rhalf(bckhdr[G_LND]);
  if (length == 0)
    return;

  if (debug)
    printf("  ... parsing %d words of non-data...\n", length);

  if (length > 512)
    length = 512;		/* XXX Check against actual record length? */

  while (length > 0) {
    w = bckdata[offset++];
    type = lhalf(w);
    itmlen = rhalf(w);
    if (debug)
      printf("    ... item type %d, len %d ...\n", type, itmlen);

    if (itmlen <= 0)		/* Give up on bad data. */
      return;

    length -= 1;
    itmlen -= 1;

    if (itmlen > length)	/* Don't overrun. */
      itmlen = length;

    switch (type) {
    case O_NAME:
      pars_name(offset, itmlen);
      break;
    case O_FATTR:
      pars_fattr(offset, itmlen);
      break;
    case O_DATTR:
      pars_dattr(offset, itmlen);
      break;
    case O_SYSNAME:
      pars_string(bckdata, offset, itmlen, t_sysname);
      break;
    case O_SAVESET:
      pars_string(bckdata, offset, itmlen, t_ssname);
      break;
    }

    length -= itmlen;
    offset += itmlen;
  }
}

/*
 *  handle a label record.
 */

void bck_label(void)
{
  /* These are not generated by Tops-10 BACKUP. */

  /* Only list this if in -s mode. */
}

/*
 *  handle a begin record.
 */

void bck_begin(void)
{
  pars_ndb();

  switch (tapeaction) {
  case ACT_STRUCT:
    /* missing */
    break;
  case ACT_LIST:
    break;
  case ACT_TYPE:
    p_saveset(T_BEGIN);
    break;
  case ACT_EXTRACT:
    break;
  }
}

/*
 *  handle an end record.
 */

void bck_end(void)
{
  pars_ndb();

  switch (tapeaction) {
  case ACT_STRUCT:
    /* missing */
    break;
  case ACT_LIST:
    break;
  case ACT_TYPE:
    p_saveset(T_END);
    break;
  case ACT_EXTRACT:
    break;
  }
}

/*
 *  handle a file record.
 */

void bck_file(void)
{
  u_int flags;

  flags = lhalf(bckhdr[G_FLAGS]);

  if (flags & GF_SOF) {

    /* we are supposed to be outside of a file here. */

    infile = 1;

    pars_ndb();

    switch (tapeaction) {
    case ACT_STRUCT:
      /* missing */
      break;
    case ACT_LIST:
      if (!checkarg())
	break;
      /* fall through */
    case ACT_TYPE:
      /*
       *  We should print out size in blocks, size in words or bytes
       *  plus unit, protection, and possibly only print file date if
       *  not in verbose mode.
       */
      printf("  ");
      p_udt(f_wrtime);
      printf("  <%c%c%c>",
	     prot(ldb(8, f_attrs[A_PROT], 19)),
	     prot(ldb(8, f_attrs[A_PROT], 27)),
	     prot(ldb(8, f_attrs[A_PROT], 35)));
      printf("  %s\n", cname);
      break;
    case ACT_EXTRACT:
      if (checkarg()) {
	if (openwrite()) {
	  extracting = 1;
	  if (!quiet) {
	    printf("  %s", cname);
	    if (verbose)
	      printf(" -> %s", oname);
	  }
	}
      }
      break;
    }
  }

  /* Here we should be infile. */

  if (extracting) {
    copy2disk(bckhdr[G_LND] + 32, bckhdr[G_SIZE],
	      lhalf(bckhdr[G_FLAGS]) & GF_EOF);
  }

  if (flags & GF_EOF) {

    /* we are supposed to be inside of a file here. */

    if (extracting) {
      if (!quiet)
	p_nl();
      closewrite();
      extracting = 0;
    }
    infile = 0;
  }
}

/*
 *  handle an ufd record.
 */

void bck_ufd(void)
{
  pars_ndb();

  /* can have O_NAME, O_FATTR and O_DATTR non-data blocks. */

  /* Ignore in -t and -s modes. */
}

/*
 *  handle an eov (end-of-volume) record.
 */

void bck_eov(void)
{
  /* seems to have no data at all.  Ignore? */

  /* Next: [tape mark] CONT */

  /* If -t mode, print something? */
}

/*
 *  handle a comment record.
 */

void bck_comment(void)
{
  /* These are not generated by Tops-10 BACKUP. */

  /* no idea what these look like.  Ignore them for now. */
}

/*
 *  handle a continuation record.
 */

void bck_cont(void)
{
  pars_ndb();

  switch (tapeaction) {
  case ACT_STRUCT:
    /* missing */
    break;
  case ACT_LIST:
    break;
  case ACT_TYPE:
    p_saveset(T_CONT);
    break;
  }
}

/*
 *  backup: handle a general record.
 */

void bck_record(void)
{
  switch (datarectype) {
  case T_LABEL:
    bck_label();
    break;
  case T_BEGIN:
    bck_begin();
    break;
  case T_END:
    bck_end();
    break;
  case T_FILE:
    bck_file();
    break;
  case T_UFD:
    bck_ufd();
    break;
  case T_EOV:
    bck_eov();
    break;
  case T_COMM:
    bck_comment();
    break;
  case T_CONT:
    bck_cont();
    break;
  default:
    break;			/* Ignore this record type. */
  }
}

/***********************************************************************/
/*
 *  Handle dumper records, according to type:
 */

/*
 *  dumper: handle a tape header.
 */

void dmp_tphd(w36* data)
{
  int offset = data[1];
  
  pars_string(data, offset, 0200, t_ssname);

  switch (tapeaction) {
  case ACT_STRUCT:
    printf(" \"%s\"\n", t_ssname);
    break;
  case ACT_LIST:
    break;
  case ACT_TYPE:
    printf("Saveset '%s'\n", t_ssname);
    printf("  Written on ");
    p_udt(data[2]);
    p_nl();
    p_nl();
    break;
  case ACT_EXTRACT:
    break;
  }
}

/*
 *  dumper: handle a tape trailer.
 */

void dmp_tptr(w36* data)
{
}

/*
 *  dumper: handle a file header.
 */

void dmp_flhd(w36* data)
{
  char filename[STRSIZE];
  char* semi;
  w36* fdb = &data[0200];
  u_int prot;
  u_int bsize;
  u_int pcount;
  u_int bcount;

  pars_string(data, 0, 0200, filename);
  strncpy(cname, filename, STRSIZE);
  downcase(cname);
  semi = strchr(cname, ';');
  if (semi != NULL)
    *semi = 0;

  prot = rhalf(fdb[4]);
  bsize = ldb(6, fdb[011], 11);
  pcount = rhalf(fdb[011]);
  bcount = fdb[012];

  f_wrtime = fdb[014];
  f_rdtime = fdb[015];

  infile = 1;
  
  switch (tapeaction) {
  case ACT_STRUCT:
    if (subrecnum > 1)
      printf("  ");
    printf(" \"%s\"\n", filename);
    break;
  case ACT_LIST:
    if (!checkarg())
      break;
    /* fall through */
  case ACT_TYPE:
    /*
     * ---    1     1515  7 775252 Oct  2 05:15:12 1985 bv:bugs..7
     */
    printf("%6u %7u %2u %06o ", pcount, bcount, bsize, prot);
    p_udt(f_wrtime);
    printf(" %s\n", cname);
    break;
  case ACT_EXTRACT:
    if (checkarg()) {
      if (openwrite()) {
	extracting = 1;
	if (!quiet) {
	  printf("  %s", cname);
	  if (verbose)
	    printf(" -> %s", oname);
	}
      }
    }
    break;
  }
}

/*
 *  dumper: handle a data record.
 */

void dmp_data(w36* data)
{
  if (extracting) {
    copy2disk((data - tapebuffer), 512, 0);
  }
}

/*
 *  dumper: handle a file trailer.
 */

void dmp_fltr(w36* data)
{
  if (extracting) {
    if (!quiet)
      p_nl();
    closewrite();
    extracting = 0;
  }
  infile = 0;
}

/*
 *  dumper: handle a user directory record.
 */

void dmp_usr(w36* data)
{
}

/*
 *  dumper: handle a continuation record.
 */

void dmp_ctph(w36* data)
{
}

/*
 *  dumper: handle a filler record.
 */

void dmp_fill(w36* data)
{
  /*
   *  Just ignore this.
   */
}

/*
 *  dumper: handle a general record set.
 */

void dmp_record(void)
{
  w36* data = tapebuffer;
  int type;
  int i;

  subrecnum = 0;

  for (i = tapereclen; i > 0; i -= 2590) {
    type = - data[4];
    data += 6;

    if (tapeaction == ACT_STRUCT) {
      if (subrecnum++ > 0) {
	printf("  sub-record %d, dumper type %d (%s)\n",
	       subrecnum, type, map_i2s(type, name_dumper_rectype, ""));
      }
    }

    switch (type) {
    case D_DATA:
      dmp_data(data);
      break;
    case D_TPHD:
      dmp_tphd(data);
      break;
    case D_FLHD:
      dmp_flhd(data);
      break;
    case D_FLTR:
      dmp_fltr(data);
      break;
    case D_TPTR:
      dmp_tptr(data);
      break;
    case D_USR:
      dmp_usr(data);
      break;
    case D_CTPH:
      dmp_ctph(data);
      break;
    case D_FILL:
      dmp_fill(data);
      break;
    default:
      break;
    }

    data += 512;
  }
}

/***********************************************************************/
/*
 *  Handle failsafe records, according to type:
 */

/*
 *  failsafe: handle a begin or end record.
 */

void fsf_begend(void)
{
  u_int vers = lhalf(tapebuffer[0]);
  u_int reel = rhalf(tapebuffer[2]);
  u_int date;
  u_int time;
  u_int h, m, s, d, y;

  static char* month[] = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  };

  switch (tapeaction) {
  case ACT_EXTRACT:
    checkclose();
    break;
  case ACT_TYPE:
    if (reel & 0400000)
      reel = 01000000 - reel;

    switch (datarectype) {
    case F_BEGIN:
      printf("Failsafe begin reel %d, version %o,", reel, vers);
      break;
    case F_END:
      printf("\nFailsafe end reel %d,", reel);
      break;
    }

    date = ldb(15, tapebuffer[3], 35);
    time = ldb(17, tapebuffer[3], 20);

    h = time / 3600;
    s = time % 3600;
    m = s / 60;
    s = s % 60;

    printf(" %02d:%02d:%02d", h, m, s);

    y = date / (12*31);
    d = date % (12*31);
    m = d / 31;
    d = d % 31;

    printf(" %02d-%s-%04d", d+1, month[m], y + 1964);

    p_nl();
    p_nl();
    break;
  }
}

/*
 *  failsafe: handle a file record.
 */

void fsf_file(void)
{
  /*
   *  record is header word, 42 words of file name and metadata,
   *  possibly followed by file data.  If the extension is UFD,
   *  we just ignore it.
   */

  w36 ppn;
  u_int prot;
  u_int ufd = 0;
  u_int len;

  checkclose();

  six2asc(f_device, tapebuffer[1], 6);
  six2asc(f_name,   tapebuffer[4], 6);
  six2asc(f_ext,    tapebuffer[5], 3);

  ppn = tapebuffer[3];
  snprintf(f_ufd, STRSIZE, "%o,%o", lhalf(ppn), rhalf(ppn));

  prot = ldb(9, tapebuffer[6], 8);

  downcase(f_device);
  downcase(f_name);
  downcase(f_ext);

  if (strcmp(f_ext, "ufd") == 0) {
    ufd = 1;
    ppn = tapebuffer[4];
    snprintf(f_name, STRSIZE, "[%o,%o]", lhalf(ppn), rhalf(ppn));
  }

  buildnames();

  switch (tapeaction) {
  case ACT_STRUCT:
    printf("  \"%s\"\n", cname);
    break;
  case ACT_LIST:
    if (!checkarg())
      break;
    /* fall through */
  case ACT_TYPE:
    printf("  ");
    p_udt(tapebuffer[037]);
    printf("  <%03o>  %s\n", prot, cname);
    break;
  case ACT_EXTRACT:
    if (checkarg() && !ufd) {
      if (openwrite()) {
	extracting = 1;
	if (!quiet) {
	  printf("  %s", cname);
	  if (verbose)
	    printf(" -> %s", oname);
	}
      }
    }
    break;
  }

  if (extracting) {
    len = rhalf(tapebuffer[0]);
    copy2disk(043, len - 042, (len < (0777 - 042)));
  }
}

/*
 *  failsafe: handle a data record.
 */

void fsf_data(void)
{
  u_int len;

  if (extracting) {
    len = rhalf(tapebuffer[0]);
    copy2disk(1, len, (len < 0777));
  }
}

/*
 *  failsafe: handle a general record.
 */

void fsf_record(void)
{
  switch (datarectype) {
  case F_BEGIN:
  case F_END:
    fsf_begend();
    break;
  case F_FILE:
    fsf_file();
    break;
  case F_DATA:
    fsf_data();
    break;
  default:
    break;
  }
}

/***********************************************************************/
/*
 *  Handle a general data record.
 */

void do_data(void)
{
  u_int i, last, max;

  if (tapeaction == ACT_PEEK) {
    p_recinfo();

    last = (tapereclen + 4) / 5;
    max = 16;
    if (pw_number > 0)
      max = pw_number;
    if (verbose)
      max = last;

    if (last > max)
      last = max;

    for (i = 0; i < last; i += 1) {
      printf("  %04o:  ", i);
      p_word(i);
      p_nl();
    }
    return;
  }

  if (tapeaction == ACT_STRUCT) {
    p_recinfo();

    if (verbose) {
      switch (taperectype) {

      case DT_ANSILBL:
	printf(" \"");
	for (i = 4; i < 80; i += 1)
	  p_pchar(rawbuffer[i]);
	printf("\"\n");
	break;

      case DT_BACKUP:
	bck_record();
	break;

      case DT_DUMPER:
	dmp_record();
	break;

      default:
	break;
      }
    }

    return;
  }

  switch (taperectype) {
  case DT_BACKUP:
    bck_record();
    break;
  case DT_DUMPER:
    dmp_record();
    break;
  case DT_FAILSAFE:
    fsf_record();
    break;
  default:
    break;
  }
}

void do_mark(void)
{
  switch (tapeaction) {
  case ACT_LIST:
  case ACT_TYPE:
  case ACT_EXTRACT:
    break;

  case ACT_STRUCT:
  case ACT_PEEK:
    printf("record %04d MARK\n", taperecnum);
    break;
  }
}

void do_eof(void)
{
  switch (tapeaction) {
  case ACT_LIST:
  case ACT_TYPE:
  case ACT_EXTRACT:
    break;

  case ACT_STRUCT:
  case ACT_PEEK:
    printf("record %04d EOF\n", taperecnum);
    break;
  }
}

void do_gap(void)
{
  switch (tapeaction) {
  case ACT_LIST:
  case ACT_TYPE:
  case ACT_EXTRACT:
    break;

  case ACT_STRUCT:
  case ACT_PEEK:
    printf("record %04d GAP (%08x)\n", taperecnum, tapereclen);
    break;
  }
}

void do_eot(void)
{
  switch (tapeaction) {
  case ACT_LIST:
  case ACT_TYPE:
  case ACT_EXTRACT:
    break;

  case ACT_STRUCT:
  case ACT_PEEK:
    printf("record %04d EOT\n", taperecnum);
    break;
  }
}

/***********************************************************************/

/*
 *  Here to read a tape (various functions).  We open the tape for
 *  reading, then loop over all records until end-of-tape.
 */

void do_read(void)
{
  if (tapename == NULL) {
    fprintf(stderr, "No input file name given\n");
    return;
  }

  if (strcmp(tapename, "-") == 0) {
    tapefile = stdin;
  } else {
    tapefile = fopen(tapename, "rb");
    if (tapefile == NULL) {
      fprintf(stderr, "can't open %s for input\n", tapename);
      return;
    }
    if (tapeformat == TF_NONE) {
      tapeformat = map_ext2tf(tapename);
    }
  }

  if (tapeformat == TF_NONE) {
    tapeformat = TF_TAP;	/* For now. */
  }

  while (tapeobject != TP_EOT) {
    tp_next();
    taperecnum += 1;
    switch (tapeobject) {
    case TP_DATA:
      do_data();
      break;
    case TP_MARK:
      do_mark();
      break;
    case TP_EOF:
      do_eof();
      break;
    case TP_GAP:
      do_gap();
      break;
    case TP_EOT:
      do_eot();
      break;
    }
  }

  if (extracting) {
    if (!quiet)
      p_nl();
    closewrite();
    printf("last file was not properly terminated.\n");
  }

  (void) fclose(tapefile);
}

/***********************************************************************/

/*
 *  Add a regular expression to match:
 */

void addregex(char* str)
{
  regitem* r;
  int ret;
  char errbuf[STRSIZE];

  r = malloc(sizeof(*r));
  if (r == NULL) {
    fprintf(stderr, "addregex: malloc failed.\n");
    exit(1);
  }

  r->re_next = NULL;

  ret = regcomp(&r->re_regex, str, REG_EXTENDED | REG_NOSUB);
  if (ret != 0) {
    (void) regerror(ret, &r->re_regex, errbuf, STRSIZE);
    fprintf(stderr, "regexp '%s' error: %s\n", str, errbuf);
    free(r);
    exit(1);
  }

  if (reghead == NULL) {
    reghead = r;
    regtail = r;
  } else {
    regtail->re_next = r;
    regtail = r;
  }
}

/*
 *  Set the saveset format.
 */

void setssfmt(char* arg)
{
  static 

  u_int fmt;

  downcase(arg);
  fmt = map_s2i(arg, name_sfformat, SF_NONE);
  if (fmt == SF_NONE) {
    fprintf(stderr, "Unknown saveset type '%s'\n", arg);
    exit(1);
  }

  ssformat = fmt;
}

/*
 *  Set the tape container format.
 */

void settpfmt(char* arg)
{
  u_int fmt;

  downcase(arg);

  fmt = map_s2i(arg, name_tpformat, TF_NONE);

  if (fmt == TF_NONE) {
    fprintf(stderr, "Unknown tape container format '%s'\n", arg);
    exit(1);
  }

  tapeformat = fmt;
}

/*
 *  Set general options.
 */

void opt_apr(char* arg, int xarg)
{
  apr = strtoul(arg, NULL, 10);
}

void opt_bpi(char* arg, int xarg)
{
  int i;

  i = map_s2i(arg, name_density, 0);
  if (i == 0) {
    fprintf(stderr, "Illegal value (%s) for option bpi.\n", arg);
    exit(1);
  }
  bpi = arg;
}

void opt_dev(char* arg, int xarg)
{
  dev = arg;
}

void opt_reel(char* arg, int xarg)
{
  reel = arg;
}

void setoption(char* arg)
{
  char* opt = arg;
  int i;

  static struct {
    char* opt;
    int argflag;
    int xarg;
    void (*handler)(char* arg, int xarg);
  } opts[] = {
    { "apr",  1, 0, opt_apr },
    { "bpi",  1, 0, opt_bpi },
    { "dev",  1, 0, opt_dev },
    { "reel", 1, 0, opt_reel },
    { NULL },
  };

  arg = strchr(arg, '=');
  if (arg != NULL)
    *arg++ = 0;

  for (i = 0; opts[i].opt != NULL; i += 1) {
    if (strcmp(opt, opts[i].opt) == 0) {
      if (arg == NULL && opts[i].argflag) {
	fprintf(stderr, "argument needed for option '%s'\n", opt);
	exit(1);
      }
      (*opts[i].handler)(arg, opts[i].xarg);
      return;
    }
  }

  fprintf(stderr, "Unknown option '%s'\n", opt);
  exit(1);
}

/*
 *  Set print control bits.
 */

void setpbits(char* arg)
{
  int bit = 1;
  char c;

  while ((c = *arg++) != 0) {
    switch (c) {
    case '+':
      bit = 1;
      break;
    case '-':
      bit = 0;
      break;
    case '7':			/* 7-bit bytes. */
      pw_7bit = bit;
      break;
    case 'h':			/* Halfword */
      pw_hword = bit;
      break;
    case 'i':			/* Instr. */
      pw_instr = bit;
      break;
    case 'r':			/* Raw data flag. */
      pw_raw = bit;
      break;
    case 's':			/* Sixbit. */
      pw_sixbit = bit;
      break;
    case 't':			/* Text. */
      pw_text = bit;
      break;
    case 'x':			/* Hex. */
      pw_hex = bit;
      break;
    default:			/* Unknown, complain. */
      fprintf(stderr, "Unknown print control bit '%c'\n", c);
      exit(1);
    }
  }
}

/*
 *  Set device and UFD info for writing.
 */

void setufd(char* arg)
{
  char* ufd;
  char delim, last;
  unsigned int p, pn;
  int count;

  if (arg[0] == ':')
    goto error;

  ufd = strchr(arg, ':');
  if (ufd == NULL)
    goto error;

  *ufd++ = 0;
  count = sscanf(ufd, "%o%c%o%c", &p, &delim, &pn, &last);

  if (count != 3)
    goto error;
  if (strlen(arg) > 6)
    goto error;
  if (p > 0777777 || pn > 0777777)
    goto error;

  switch (delim) {
  case ',':
  case '.':
  case '_':
    strncpy(f_device, arg, STRSIZE);
    upcase(f_device);
    sprintf(f_ufd, "%o_%o", p, pn);
    interchange = 0;
    return;
  };

 error:
  fprintf(stderr, "Bad format for device and/or directory\n");
  exit(1);
}

/*
 *  The old usage string.
 */

void usage(int fullflag)
{
  if (!fullflag) {
    fprintf(stderr, "Type %s -h for help.\n", programname);
    exit(1);
  }
  
  printf("Usage: %s [action] [options] [args]\n", programname);
  printf(
"\n"
"    Action is one of the following:\n"
"\n"
"    -c           -- create a backup tape containing the files in arglist.\n"
"\n"
"    -l           -- list files on tape.\n"
"    -p           -- peek at tape data.\n"
"    -s           -- show the structure of the tape.\n"
"    -t           -- type file list as .DIR MTA0: does.\n"
"    -x           -- extract files matching any of the args in arglist,\n"
"                    or any regexp given to a -R option.\n"
"\n"
"    Options are:\n"
"\n"
"    -b           -- build tree of output files.  (extract)\n"
"    -d           -- omit device from output tree.  (extract)\n"
"    -f <file>    -- operate on tape file for input/output.\n"
"                    \"-\" means stdin/stdout.\n"
"    -h           -- print help text.\n"
"    -i           -- interchange flag.\n"
"    -n           -- number of items to print.  (peek)\n"
"    -q           -- quiet (extract)\n"
"    -v           -- increase verbose mode.\n"
"\n"
"    -A           -- set disk mode to ascii.\n"
"    -B           -- set disk mode to binary.\n"
"    -C           -- set disk mode to core-dump.\n"
"    -D           -- turn on debugging.\n"
"    -H           -- set disk mode to high-density.\n"
"    -I           -- set disk mode to industri-standard.\n"
"    -M <str>     -- set system name.  (write)\n"
"    -O opt=val   -- set option to value.\n"
"    -P <bits>    -- set/clear print control bits.  (peek)\n"
"    -R <exp>     -- set regexp of files to match.  (extract, list)\n"
"    -S <str>     -- set SaveSet name.  (write)\n"
"    -T <fmt>     -- set tape container format.\n"
"                    format is raw, tap, e11 or tpc.\n"
"                    default is tap.\n"
"    -U <str>     -- set device and UFD. (write)\n"
"                    format is \"device:p,pn\".\n"
	 );
  exit(0);
}

/*
 *  Main program.
 */

int main(int argc, char* argv[])
{
  time_t now;
  struct tm* tm;
  struct utsname me;

  int ch;

  /* Set up some global variables: */

  /* XXX should this be done in a sys dependent module? */

  now = time(NULL);		/* Get current time. */
  tm = localtime(&now);		/* Break it apart, - */
  gmtoffset = tm->tm_gmtoff;	/*  and get our offset. */

  if (uname(&me) == 0) {
    sysname = me.nodename;
  }

  programname = argv[0];	/* Keep for later. */

  while ((ch = getopt(argc, argv,
		      "ABCDF:HIM:O:P:R:S:T:U:bcdf:hiln:pqstvx")) != -1) {
    switch (ch) {
    case 'A':
      diskformat = DF_ASCII;	/* Ascii disk format. */
      opw = 5;
      bpw = 40;
      break;
    case 'B':
      diskformat = DF_BINARY;	/* Binary disk format. */
      opw = 5;
      bpw = 40;
      break;
    case 'C':			/* Core-dump disk format. */
      diskformat = DF_COREDUMP;
      opw = 5;
      bpw = 40;
      break;
    case 'D':			/* Debug flag on. */
      debug = 1;
      break;
    case 'F':			/* Set saveset format. */
      setssfmt(optarg);
      break;
    case 'H':			/* High density mode. */
      diskformat = DF_HIGHDENS;
      opw = 0;			/* XXX do this per two-word entity? */
      bpw = 36;
      break;
    case 'I':			/* Industry-standard disk format. */
      diskformat = DF_INDUSTRY;
      opw = 4;
      bpw = 32;
      break;
    case 'M':			/* Machine. */
      sysname = optarg;
      break;
    case 'O':			/* Option(s). */
      setoption(optarg);
      break;
    case 'P':			/* Print control bits. */
      setpbits(optarg);
      break;
    case 'R':			/* Regexp. */
      addregex(optarg);
      break;
    case 'S':			/* SaveSet name. */
      ssname = optarg;
      break;
    case 'T':			/* Tape format. */
      settpfmt(optarg);
      break;
    case 'U':			/* UFD. */
      setufd(optarg);
      break;
    case 'b':
      buildtree = 1;
      break;
    case 'c':
      tapeaction = ACT_CREATE;
      if (f_device[0] == 0)
	interchange = 1;
      break;
    case 'd':
      nodevice = 1;
      break;
    case 'f':
      tapename = optarg;
      break;
    case 'h':
      usage(1);
      /* Does not return, but... */
      break;
    case 'i':
      interchange = 1;
      break;
    case 'l':
      tapeaction = ACT_LIST;
      break;
    case 'n':
      pw_number = strtoul(optarg, NULL, 0);
      break;
    case 'p':
      tapeaction = ACT_PEEK;
      break;
    case 'q':
      quiet = 1;
      break;
    case 's':
      tapeaction = ACT_STRUCT;
      break;
    case 't':
      tapeaction = ACT_TYPE;
      break;
    case 'v':			/* More verbose, please. */
      verbose += 1;
      break;
    case 'x':
      tapeaction = ACT_EXTRACT;
      break;
    default:
      usage(0);
      /* Does not return, but... */
      break;
    }
  }

  /*
   *  Now the rest of the arguments are file names to handle.
   */
  
  argcount = argc - optind;	/* Set up argument list for  our workers. */
  arglist = &argv[optind];

  if (tapeaction == ACT_PEEK && interchange) {
    pw_instr = 1;
  }

  switch (tapeaction) {
  case ACT_NONE:
    fprintf(stderr, "No action given, nothing to do.\n");
    break;
  case ACT_CREATE:
    do_write();
    break;
  case ACT_LIST:
  case ACT_PEEK:
  case ACT_STRUCT:
  case ACT_TYPE:
    do_read();
    break;
  case ACT_EXTRACT:
    if (argcount == 0) {
      fprintf(stderr, "No files to extract, nothing to do.\n");
      break;
    }
    do_read();
    break;
  default:
    /* internal error */
    break;
  }

  return 0;
}
