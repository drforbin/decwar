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

/* Record types: */

#define T_LABEL     1		/* Label. */
#define T_BEGIN     2		/* Start of SaveSet. */
#define T_END       3		/* End of SaveSet. */
#define T_FILE      4		/* File data. */
#define T_UFD       5		/* UFD data. */
#define T_EOV       6		/* End of volume. */
#define T_COMM      7		/* Comment. */
#define T_CONT    010		/* Continuation. */

/* Common offsets into header block: */

#define G_TYPE      0		/* Record type. */
#define G_SEQ       1		/* Sequence #. */
#define G_RTNM      2		/* Relative tape #. */
#define G_FLAGS     3		/* Flags: */
#define   GF_EOF  0400000	/*   End of file. */
#define   GF_RPT  0200000	/*   Repeat of last record. */
#define   GF_NCH  0100000	/*   Ignore checksum. */
#define   GF_SOF  0040000	/*   Start of file. */
#define G_CHECK     4		/* Checksum. */
#define G_SIZE      5		/* Size of data in this block. */
#define G_LND       6		/* Length of non-data block. */
#define G_TBS       7		/* Tape block size: */
				/*   Left half = size of tape block. */
				/*   Right half = disk blocks/tape blocks. */
#define G_CUST    013		/* Customer word. */

/* Offsets into T_LABEL header blocks: */

#define L_DATE    014		/* Date/time in UTC format. */
#define L_FMT     015		/* Tape format (constant, = 1). */
#define L_BVER    016		/* Backup version (.JBVER format). */
#define L_MON     017		/* Monitor type (%CNMNT). */
#define L_SVER    020		/* System version (%CNDVN). */
#define L_APR     021		/* Apr serial number. */
#define L_DEV     022		/* Device name (sixbit). */
#define L_MTCH    023		/* Tape parameters. */
#define L_RLNM    024		/* Reel name. */
#define L_DSTR    025		/* Date/time for destruction. */

/* Offsets into T_BEGIN, T_END & T_CONT header blocks: */

#define S_DATE    014		/* Date/time in UTC format. */
#define S_FMT     015		/* Tape format (constant, = 1). */
#define S_BVER    016		/* Backup version (.JBVER format). */
#define S_MON     017		/* Monitor type (%CNMNT). */
#define S_SVER    020		/* System version (%CNDVN). */
#define S_APR     021		/* Apr serial number. */
#define S_DEV     022		/* Device name (sixbit). */
#define S_MTCH    023		/* Tape parameters. */
#define S_RLNM    024		/* Reel name. */
#define S_LBLT    025		/* Label type. */
#define S_BLKF    026		/* Blocking factor. */

#define S_CUST    037		/* Customer word. */

/* Offsets into T_FILE header blocks: */

#define F_PCHK    014		/* Checksum of the O_NAME block. */
#define F_RDW     015		/* Relative data word of file. */
#define F_PTH     016		/* Start of path block. */
#define   LN_PTH    014		/*   Length of path block. */

/* Data types: */

#define _FCDEV      1
#define _FCNAM      2
#define _FCEXT      3
#define _FCVER      4
#define _FCGEN      5
#define _FCDIR    040
#define _FCSF1    041
#define _FCSF2    042
#define _FCSF3    043
#define _FCSF4    044
#define _FCSF5    045

/* Offsets into T_UFD header blocks: */

#define D_PCHK    014		/* Checksum of the O_NAME block. */
#define D_LVL     015		/* UFD level. */
#define D_STR     016		/* Structure of UFD. */

/* Non-data block types: (lives in data part of record) */

#define O_NAME      1		/* File name. */
#define O_FATTR     2		/* File attributes. */
#define O_DATTR     3		/* Directory attributes. */
#define O_SYSNAME   4		/* System name block. */
#define O_SAVESET   5		/* SaveSet name block. */

/* Offsets in file attribute block: */

#define A_FHLN	    0		/* header length word */
#define A_FLGS	    1		/* flags */
#define A_WRIT	    2		/* creation date/time */
#define A_ALLS	    3		/* allocated size */
#define A_MODE	    4		/* mode */
#define A_LENG	    5		/* length */
#define A_BSIZ	    6		/* byte size */
#define A_VERS	    7		/* version */
#define A_PROT	  010		/* protection */
#define A_ACCT	  011		/* byte pointer account string */
#define A_NOTE	  012		/* byte pointer to anonotation string */
#define A_CRET	  013 		/* creation date/time of this generation */
#define A_REDT	  014		/* last read date/time of this generation */
#define A_MODT	  015 		/* monitor set last write date/time */
#define A_ESTS	  016 		/* estimated size in words */
#define A_RADR	  017		/* requested disk address */
#define A_FSIZ	  020		/* maximum file size in words */
#define A_MUSR	  021		/* byte ptr to id of last modifier */
#define A_CUSR	  022		/* byte ptr to id of creator */
#define A_BKID	  023		/* byte ptr to save set of previous backup */
#define A_BKDT	  024 		/* date/time of last backup */
#define A_NGRT	  025		/* number of generations to retain */
#define A_NRDS	  026		/* nbr opens for read this generation */
#define A_NWRT	  027		/* nbr opens for write this generation */
#define A_USRW	  030		/* user word */
#define A_PCAW	  031		/* privileged customer word */
#define A_FTYP	  032		/* file type and flags */
#define A_FBSZ	  033		/* byte sizes */
#define A_FRSZ	  034		/* record and block sizes */
#define A_FFFB	  035		/* application/customer word */

#define LN_AFH    036		/* length of f. attr. block. */

/* Offsets in directory attribute block: */

#define D_FHLN      0		/* header length word */
#define D_FLGS      1		/* directory flags */
#define D_ACCT      2		/* account number */
#define D_PROT      3		/* directory protection */
#define D_FPRT      4		/* default file protection */
#define D_LOGT      5		/* login date/time */
#define D_GENR      6		/* number generations to keep */
#define D_QTF       7		/* logged-in quota */
#define D_QTO     010		/* logged-out quota */
#define D_ACSL    011		/* access list */
#define D_USRL    012		/* user list */
#define D_PRVL    013		/* privilege list */
#define D_PSWD    014		/* password */

#define LN_DFH    015		/* length of d. attr. block. */
