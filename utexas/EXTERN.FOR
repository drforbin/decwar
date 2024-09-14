C	This file is part of Decwar.
C	Copyright 1979, 2011 Bob Hysick, Jeff Potter, The University of Texas
C	Computation Center and Harris Newman.

C	This program is free software; you can redistribute it and/or modify
C	it under the terms of the GNU General Public License as published by
C	the Free Software Foundation; either version 3, or (at your option)
C	any later version.

C	This program is distributed in the hope that it will be useful,
C	but WITHOUT ANY WARRANTY; without even the implied warranty of
C	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C	GNU General Public License for more details.

C	You should have received a copy of the GNU General Public License
C	along with this program; if not, write to the Free Software
C	Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
C	02110-1301, USA.  


	external absfrm !Absolute !
	external alldok !All devices functional.!
	external ambcom !Ambiguous command!
	external ambswi !!
			!Ambiguous switch for TYPE.!
	external begyrp !Beg your pardon, sir?  !
	external bthfrm !Both !
	external build1 !builds planet !
	external build2 ! into a !
	external build3 ! build!
	external build4 !!
			!All !
	external build5 !s still functional, captain.!
	external build7 !!
			!Planet not yet captured.!
	external captu0 !capturing !
	external captu1 !!
			!!
			!Science Officer:  Captain, that was a MOST illogical tactic.!
	external captu2 !!
			!!
			!First Officer:  Commander, because of your incompetence!
			!we must suffer the shame of DEFEAT!!!
	external captu4 !DESTROYED during capture of planet!!!
	external captu5 !not adjacent to planet.!
	external captu6 !!
			!Captain, are you feeling well?!
			!We are orbiting a FEDERATION planet!!
	external captu7 !!
			!Planet already captured, sir.!
	external captu8 !!
			!MESSAGE FROM PLANET:  Veer off you idiot!!
			!We are ALREADY part of the Klingon Empire!!
	external comlin !Command: !
	external coord1 !Coordinates: !
	external damcom !Computer inoperative.!
	external dmhdr1 !Device    !
	external dmhdr2 !Damage!
	external damrep !Damage Report for !
	external decver ![DECWAR Version 2.2, 25-Dec-79]!
	external destry !DESTROYED!!!
	external displc !displaced to !
	external dock01 ! not adjacent to base!!!
	external dockin !!
			!DOCKED.!
	external empire !    Empire!
	external empbas !Empire base!
	external emppln !Empire planet!
	external empshp !Empire ship!
	external endgm0 !THE WAR IS OVER!!!
			!!
	external endgm1 !The entire known galaxy has been depopulated.!
			!!
			!BOTH sides lose!!!
	external endgm3 !The Klingon Empire is VICTORIOUS!!!
			!!
	external endgm4 !The Federation has successfully repelled the Klingon hordes!!
			!!
	external endgm5 !Please proceed to the nearest Klingon slave planet.!
	external endgm6 !Congratulations.  Freedom again reigns the galaxy.!
	external endgm7 !The Empire salutes you.  Begin slave operations immediately.!
	external endgm8 !The Empire has fallen.  Initiate self-destruction procedure.!
	external ener1S !Ship, energy: !
	external ener1L !Destination ship name and energy to transfer: !
	external energ2 !Can not transfer energy to enemy ship.!
	external energ3 !Not adjacent to destination ship.!
	external ener4S !Insufficient ship energy.!
	external ener4L !Sir, our ship doesn't possess that much energy!!
	external energ5 !Transfer aborted.!
	external energ6 !Energy transferred, sir.!
	external energ7 !Transfer energy to US!?!!
	external energ8 !Illegal energy transfer.  !
	external engoff !Engineering Officer:  !
	external erloc1 !Wrong number of coordinates specified.!
	external erloc2 !Too many coordinates specified.!
	external erloc3 !Non-alpha ship name.!
	external erloc4 !Unrecognized ship name.!
	external erloc7 !Non-numeric coordinate.!
	external erloc8 !X coordinate lies outside galaxy.!
	external erloc9 !Y coordinate lies outside galaxy.!
	external error1 !ERROR detected by computer!!  You have attempted!
			!to use your present location.!
	external error2 !ERROR!  Own location used!!
	external federa !Federation!
	external fedbas !Federation base!
	external fedpln !Federation planet!
	external fedshp !Federation ship!
	external forhlp ! -- for help type HELP!
	external free01 !Sorry, but your ship is in use!!
	external free02 !Sorry, but your spot on the board is taken!!
	external impdam !Impulse engines damaged.!
	external inform !Informative !
	external ingame ! in game!
	external inrang ! in range!
	external inspra ! in specified range!
	external known !/!known/
	external lifdam !!
			!WARNING!!  Life Support damaged.!
			!Reserves of !
	external lngfrm !Long !
	external lsts01 !Null group illegal!
	external lsts02 !Illegal keyword !
	external lsts03 !Syntax error near keyword !
	external lsts04 !Illegal coordinate !
	external lstf01 !Sir, our sensors can't scan as far as !
	external lstf02 !No base !
	external lstf03 !No planet !
	external lstf04 !No target !
	external lstf05 !The Romulan is dead!
	external lstf06 !Sir, there are no!
	external lstf07 !No!
	external lstf08 ! neutral!
	external lstf09 ! Federation!
	external lstf10 ! Empire!
	external lstf11 ! captured!
	external lstf12 ! enemy!
	external lstf13 ! planets!
	external lstf14 ! bases!
	external lstf15 ! ships!
	external lstf16 ! ports!
	external lstf17 ! forces!
	external main02 !RUNS OUT OF ENERGY!!!
	external medfrm !Medium !
	external mess01 !!
			!Message from !
	external mess02 !to !
	external move1A !Captain, the impulse engines won't take it.  !
	external move1B !Maximum speed warp 1.!
	external move2L !Captain, our warp engines are damaged.  I can only give you warp 3.!
	external move2S !Engines damaged, warp 3 max.!
	external move3L !Engineering Officer:  The engines won't take it sir.!
			!I can only give you warp !
	external move3S !Maximum warp !
	external move5L !Captain, our engines are overheating!!
	external move5S !Engines overheating.!
	external move06 !EEEEERRRRRROOOOOOOMMMMMmmmmm!!!
			!Captain, the engines suffered !
	external move08 ! units of damage.!
	external move09 !Sir, repairs will take approximately !
	external move10 !!
			!Navigation Officer:  "Collision averted, sir!"!
	external neupln !neutral planet!
	external nocomp !Computed coordinates are not supported for fast terminals.!
	external noplnt !!
			!No planet at those coordinates, sir.!
	external normal !Normal !
	external noquit !Use QUIT to terminate while under RED alert.!
	external noship !Player not in game.!
	external nosur1 !!
			!But sir, he's already on our side!!
	external nosur2 !!
			!Sir, the enemy refuses our surrender ultimatum!!
	external nosur3 !!
			!Sir, the Romulan refuses to surrender!!
	external nosur4 !!
			!Capture THAT??  You have GOT to be kidding!!!
	external outh01 !novas!
	external outh02 !makes!
	external outh03 ! unit !
	external outh04 !hit on !
	external outh05 !torpedo hit on !
	external outh06 !phaser hit on !
	external outh07 !damaged !
	external outh08 !dam !
	external outh09 ! displaced by blast into BLACK HOLE!!
	external outh10 ! -> BH!
	external outh12 ! lost !
	external outh13 ! miss !
	external outh14 ! swallowed by black hole !
	external outh15 ! gulp !
	external outh16 ! is under attack, sir.!
	external outh17 ! attacked!
	external outh18 ! has been destroyed, sir.!
	external outh19 ! dead!
	external outh20 !detected!
	external outh21 ! transfers !
	external outh22 ! units of energy to the !
	external outh23 !!
			!Tractor beam activated, sir.!
	external outh24 !Trac. Beam on!
	external outh25 !!
			!Tractor beam broken, sir.!
	external outh26 !Trac. Beam off!
	external outh27 ! neutralized by friendly object !
	external outh28 ! neutralized !
	external outh29 !deflected T!
	external outh30 !has torpedo deflected by !
	external outh31 !Critical hit on starbase, shields down!!
	external outh32 !Starbase attempts to re-establish shields using emergency power!!
	external outh33 !Base shields RE-ESTABLISHED!!!
	external outh34 !Base FAILS to re-establish shields........BOOM!! !
	external phacn0 !Phasers critically damaged.!
	external phacn1 !Target out of range.!
	external phacn2 !High speed shield control activated.!
	external phacn3 !SHIELDS USE UP LAST OF ENERGY!!
	external phacn4 !WARNING! WARNING!  PHASERS OVERHEATING.!
	external phacn5 !********** CRACKLE! POP! SIZZLE! POOF! **********!
			!PHASERS DAMAGED.!
	external phacn7 !!
			!Phaser control unable to lock on target, sir.!
	external phacn8 !!
			!Weapons Officer:  Improper energy consumption for phaser hit, sir.!
	external phacn9 !!
			!Weapons Officer:  Attempting to hit friendly object, sir.!
	external poi03S !!
			!Tot Pts  !
	external poi03L !!
			!Total points:     !
	external poin04 !!
			!Incorrect input, POINTS aborted.!
	external poi05S !!
			!Pts / Pl !
	external poi05L !!
			!Pts. / player:    !
	external poi06S !!
			!Pts / SD !
	external poi06L !!
			!Pts. / stardate:  !
	external poi07S !!
			!# of shps!
	external poi07L !!
			!Number of ships:!
	external poi11S !Dam E's  !
	external poi11L !Damage to enemies !
	external poi12S !E's dest !
	external poi12L !Enemies destroyed !
	external poi13S !Dam B's  !
	external poi13L !Damage to bases   !
	external poi14S !@'s capt !
	external poi14L !Planets captured  !
	external poi15S !B's built!
	external poi15L !Bases built       !
	external poi16S !Dam ~~'s !
	external poi16L !Damage to Romulans!
	external poi17S !*'s dest !
	external poi17L !Stars destroyed   !
	external poi18S !@'s dest !
	external poi18L !Planets destroyed !
	external poin19 ! (-100)!
	external poin20 ! ( -50)!
	external poin21 ! ( 100)!
	external poin22 ! ( 500)!
	external poin23 ! (1000)!
	external radio0 !Turn radio ON or OFF, GAG or UNGAG individual ship?  !
	external radio1 !Radio		!
	external radio2 !Ship name:  !
	external radio3 !Radio  !
	external radgag !Radio gagged against !
	external radoff !Radio turned off, sir.!
	external radon0 !Radio turned on, sir.!
	external radung !Radio ungagged against !
	external relfrm !Relative !
	external romadv !advances to !
	external romula !  Romulans!
	external set001 !!
			!Name, Output, Ttytype, Prompt, Scans,!
			!Input or Output location defaults (ICDEF, OCDEF)? !
	external set002 !!
			!Desired name:  !
	external set003 !!
			!Short, Medium, or Long output? !
	external set004 !!
			!Normal or Informative command prompt? !
	external set005 !!
			!Short or Long scans? !
	external set006 !!
			!Absolute or Relative default for location input? !
	external set007 !!
			!Absolute, Relative, or Both for location output? !
	external set008 !Terminal type:  !
	external set009 !!
			!Ambiguous TTY type.  !
	external set010 !Supported TTY types are:!
	external setu06 !There are Romulans in this game.!
	external setu07 !There are Black holes in this game.!
	external shld01 !Transfer, Up, Down  ? !
	external shld02 !Units of energy to transfer to shields: !
	external shld03 !Transferring all ship energy to shields.  Confirm? !
	external shld04 !Energy NOT transferred.!
	external shld05 !Energy transferred, sir.!
	external shld06 !Shields raised, sir.!
	external shld07 !!
			!Shield control uses remaining ship energy!!
	external shld08 !Shields lowered, sir.!
	external shld09 !Sir, unable to raise shields due to critical damage.!
	external shtfrm !Short !
	external star02 ! UNAFFECTED by Photon Torpedo!!
	external stat2L !Stardate	!
	external stat2M !SDate  !
	external stat3L !Shields	        !
	external stat3M !Shlds  !
	external stat05 ! units!
	external stat6L !Location	!
	external stat6M !Loc    !
	external stat7L !Condition	!
	external stat7M !Cond   !
	external stat8L !Torpedoes	!
	external stat8M !Torps  !
	external stat9L !Energy left	!
	external stat9M !Ener   !
	external sta10L !Damage		!
	external sta10M !Dam    !
	external stat11 !damaged!
	external strdat ! stardates.!
	external sure00 !!
			!Do you really want to quit? !
	external syntax !%Syntax error!
	external tell01 !!
			!Sub-Space radio damaged.!
	external tell02 !!
			!To ship:  !
	external tell03 !!
			!Unrecognized player or group name:  !
	external tell04 !!
			!Ambiguous group name:  !
	external tell05 !!
			!Self excluded from message.!
	external tell06 !!
			!Player is not in the game:  !
	external tell07 !!
			!Communications:  Sir, we cannot raise the !
	external tell08 !!
			!No message sent.!
	external tell09 !!
			!Wake up, sir, I just sent that message!!
	external time01 !!
			!Game's elapsed time:  !
	external time02 !!
			!Ship's elapsed time:  !
	external time03 !!
			!Run time in game:     !
	external time04 !!
			!Job's total run time: !
	external time05 !!
			!Current time of day:  !
	external tormis !Weapons Officer:  Sir, torpedo !
	external torp00 !Torpedo tubes critically damaged.!
	external torp01 !You have already used your supply of torpedoes!!
	external torp02 !Number in burst (1-3) and !
	external torp03 !Insufficient torpedoes for burst!!
	external torp04 !Torpedo !
	external torp05 ! MISFIRES!!
	external torp06 !PHOTON TUBES DAMAGED!!
	external torp07 ! torpedoes left.!
	external tract1 !Ship to apply tractor beam to:  !
	external tract2 !Tractor beam not in operation at this time, sir.!
	external tract3 !Tractor beam already active, sir.!
	external tract4 !Beg your pardon, sir?  You want to apply a tractor!
			!beam to your own ship?!
	external tract5 !Can not apply tractor beam to enemy ship.!
	external tract6 !already has tractor beam active.!
	external tract7 !Can not apply tractor beam through shields, sir.!
	external tract8 !has his shields up.  Unable to apply tractor beam.!
	external ttys00 !ACT-IV     ADM-2      ADM-3a     DATAPOINT!
			!ACT-V      SOROC      BEEHIVE    CRT!
	external type01 !!
			!Do you wish to see the OUTPUT or OPTION switches? !
	external type02 !!
			!Current output switch settings:!
	external type03 !output format.!
	external type04 !command prompt.!
	external type05 !SCAN format.!
	external type06 !Romulans are NOT in this game.!
	external type07 !Black holes are NOT in this game.!
	external type08 !coordinates are default for input.!
	external type09 !coordinates are default for output.!
	external units1 ! units!
	external unkcom !Unknown command!
	external unkshp !Unknown ship name.!
	external unkswi !Unknown switch!
	external users1 !Ship        Captain    Speed     PPN   TTY Job!
	external users2 !  Location!
	external users3 !!
			!----        -------    -----     ---   --- ---!
	external users4 !  --------!
	external users5 !----!
	external wrpdam !Warp engines damaged.!



