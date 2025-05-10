DECNWS.RNO ;RUNOFF source file for DECWAR.NWS document.
DECWAR.DIC ;Dictionary file for DECWAR documentation when using SPELL.
DECWAR.HLP ;Current DECWAR Help file CONTAINING SYSTEM COMMENTS.  Will
           ;be accessed by DECWAR player if he has Password set (instead
           ;of GAM: help file).  Should NOT be put on GAM:, if a new
           ;copy needed, use MAKHLP.
DECWAR.IMP ;RUNOFF source file for DECWAR implementation notes.
DECWAR.LTR ;RUNOFF source file for response letter to enquiries for
           ;the source.
DECWAR.NWS ;Current DECWAR News file (should also be on GAM:).
DECWAR.RNH ;RUNOFF source file for DECWAR.HLP document.
DEFINE.HLP ;Help text for defunct DEFINE command.  Probably will never
           ;be implemented again, but...
HLP   .COM ;DMS comment file for [10,30,DECWAR,HLP] SFD.
LICENS.MEM ;Decwar License agreement document.
LICENS.RNO ;RUNOFF source file for License agreement.
MAKHLP.MIC ;MICro to generate DECWAR.HLP files (either with or without
           ;'System' comments).
MAKNWS.MIC ;MICro to generate DECWAR.NWS file.
