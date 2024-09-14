    DECWAR GAME INSTRUCTIONS                                  Page 1
    
    
                 DECWAR Version 2.3, November 20, 1981
    
    
    Introduction and Overview of the Game of DECWARs.
    
         DECWAR is a real time space  battle  game  designed  to  be
    played  by  from  1  to 10 people.  The object of the game is to
    destroy all  enemy  bases  and  ships,  and  capture  all  enemy
    planets,  before  the  enemy  does the same to you.  Each person
    plays on a separate terminal, and enters the game by selecting
    
                   8 DECWAR (on the MultiPlayer Host)
    
    Players are free to enter and leave the game as  desired,  since
    each  has  his  own  job  and therefore won't interfere with the
    other players  (the  jobs  interact  through  a  shareable  high
    segment).
    
    
         Besides the enemy (Federation or Empire), the following may
    also be a threat to your well being.
    
         1.  Romulans are nasty beasts that beginners are better off
             without.   However,  if you're the only person playing,
             the Romulan is your only competition.  Romulans tend to
             make  for  shorter  games  but when there are 3 or less
             players a Romulan will be included.  After  the  fourth
             player joins the game, a Romulan will not be re-created
             once he is destroyed.  include Romulans in the game.
    
         2.  Black holes are annoying, since if  you  are  displaced
             into  one,  you're  dead.   They also tend to gobble up
             stray torpedos.  There is a 25% chance of  black  holes
             being included in the game.
    
    
         There are two primary opposing  forces  in  the  galaxy  --
    Humans  (Federation)  and  Klingons  (Empire).  As you enter the
    game for the first time, you get to  choose  which  side  you'll
    join  (unless there is a large imbalance in the team sizes).  If
    you are subsequently destroyed and later reenter the  game,  you
    automatically rejoin your old team.
    
         You get to select the ship you want to control from a  list
    of  remaining  ships  on  your  side.  There are 5 ships on each
    side:
    
                 Federation ships               Empire ships
                 ----------------               ------------
                    Lexington                     Cobra
                    Nimitz                        Demon
                    Savannah                      Hawk
                    Vulcan                        Jackal
                    Yorktown                      Wolf
    
    DECWAR GAME INSTRUCTIONS                                  Page 2
    
    
         Due to continuous espionage activities, present  front-line
    ships  of the Federation and the Klingon Empire are identical in
    strength and weaponry.  These ships  can  move  from  sector  to
    sector  using  either  warp or impulse engines, can attack enemy
    installations  and  ships  using  either  photon  torpedoes   or
    phasers,  and  can  defend  themselves against such attack using
    their deflector  shields.   All  ships  also  possess  sub-space
    radios  which  keep  them  in  touch with friendly starbases and
    other ships.
    
    
         The various devices of a ship are subject to damage.   This
    damage  may  be  due  to  enemy  attack  or  to over use.  These
    damages, unlike total ship damage (see ship  attributes  below),
    may  be  repaired while underway.  If damage on a device is less
    than 300 units, its performance is degraded.  If damage  is  300
    or  more units, the device is inoperative.  A ship possesses the
    following devices:
    
         1.  Warp Engines -- These engines are the  normal  mode  of
             travel for starships.  The maximum speed is warp factor
             6, with warps 5 and 6 risking potential damage  to  the
             engines.   If  warp  engines are damaged (less than 300
             units) the maximum speed is warp factor 3.
    
    
                                      NOTE
    
                 One warp unit is equivalent to  one  horizontal
                 or  one  vertical  grid  movement.   A diagonal
                 movement is equivalent to the hypotenuse of the
                 horizontal and vertical sides.
    
    
    
         2.  Impulse Engines --  These  engines  are  basically  for
             emergency  use  while  the  warp engines are critically
             damaged.  Impulse engines move the ship at warp  factor
             1.
    
         3.  Photon Torpedo Tubes -- Used to fire photon  torpedoes.
             If  these  tubes  are  damaged, the accuracy of torpedo
             bursts is impaired.  The maximum torpedo  range  is  10
             sectors.
    
         4.  Phaser Banks -- Each ship possesses two  phaser  banks,
             with  a  single  phaser control.  Damage to this phaser
             control or to the ship's computer reduces the  strength
             of the phaser hit.
    
         5.  Deflector Shields -- The deflector shields  of  a  ship
             protect  it  from damage from phaser and photon torpedo
             hits, and shield it from the  energy  released  when  a
             star  goes nova.  The percent shield strength indicates
             the  percent  of  the  incoming  hit  which   will   be
             nullified.   In  addition, strong deflector shields may
             deflect photon torpedoes  with  little  or  no  damage.
    DECWAR GAME INSTRUCTIONS                                  Page 3
    
    
             NOTE:  If a ship's shields are up, the amount of energy
             expended during movement is doubled.
    
         6.  Computer -- The ship's computer is  used  for  computed
             firing,  computation  during  ship  movement,  and  for
             phaser  control.   If  the  computer  is   inoperative,
             navigation  during  warp  and  impulse movement becomes
             inexact.
    
         7.  Life Support -- If the life support units of a starship
             are  inoperative,  the  ship  must  either  repair this
             damage or dock within 5  stardates.   If  this  is  not
             accomplished, the crew will die.
    
         8.  Sub-Space Radio --  The  sub-space  radio  is  used  to
             communicate  with  other  ships, of either side.  Bases
             under attack also use the sub-space radio to  call  for
             help   and   notify   their   team's   ships  of  their
             destruction.
    
         9.  Tractor  Beam  --  The  ship's  tractor  beam  is  used
             primarily  to  tow  damaged  friendly  ships  away from
             danger.  The beam can not be  used  unless  both  ships
             have lowered their shields.
    
    
         In addition to the individual devices  discussed  above,  a
    newly  commissioned  ship (or a fully repaired and rearmed older
    ship) possesses the following attributes:
    
         1.  5000 units of ship energy.  Ship energy is used  during
             movement  and phaser firing.  It is also decreased each
             time  the  ship  gets  hit  with  phasers   or   photon
             torpedoes.   If  this  quantity  ever reaches zero, the
             ship is dead.  A ship possessing  1000  units  of  ship
             energy  or less automatically goes to yellow alert, and
             a warning bell sounds after every move.
    
         2.  2500 units of shield energy.  This energy is stored  in
             the  ship's  shields  (whether  up  or  down),  and  is
             separate from the ship energy.  However, energy may  be
             transferred   between  these  two  energy  reserves  as
             needed.  If shields are up, their energy  is  decreased
             each time the ship gets hit.
    
         3.  Zero units of  ship  damage.   During  battle,  a  ship
             collects  hits  from enemy installations and ships.  If
             these accumulated hits ever reach 2500 units of  damage
             or  greater, the ship is destroyed.  Ship damage may be
             reduced only by docking.
    
    
         The galaxy is arranged in a  grid  of  75  by  75  sectors.
    Players  can  move  freely  throughout  the  galaxy in search of
    enemies, which come in several categories:
    DECWAR GAME INSTRUCTIONS                                  Page 4
    
    
         1.  Romulan.  This can be the most dangerous thing to  come
             up  against,  and  fortunately  there is a maximum of 1
             Romulan in the game at any  given  time.   The  Romulan
             moves  around concealed by his cloaking device until he
             comes across a suitable target  (Federation  or  Empire
             ship  or base) which he immediately proceeds to attack.
             An infinite supply of torpedoes and energy make  him  a
             formidable   foe.    If  you  kill  one,  another  will
             eventually appear somewhere in the galaxy.
    
         2.  Enemy ship.  This is the second most dangerous thing to
             come  across, since all enemy ships are backed by human
             intelligence.  All ships are created equal, and so  the
             outcome  of a clash between two ships is usually due to
             skill  on  its  captain's  part,  although  some  other
             factors do come into play.
    
         3.  Enemy base.  These aren't  dangerous  unless  you  come
             within  range  (4 sectors) since they are immobile.  If
             you ARE foolish enough to get  within  range,  however,
             their  overwhelming phaser power will quickly pound you
             into rubble!  Destroying a  base  is  useful  primarily
             because  this  removes it from use by your enemy (bases
             are used as supply stations and as a refuge in times of
             stress).   A  damaged starbase will slowly build itself
             back  to  full  strength  if  it  is   not   completely
             destroyed.
    
         4.  Enemy planet.  These are just like enemy bases,  except
             that  they  are  weaker (how much weaker depends on how
             many fortifications the enemy has built on  them),  and
             they  can  be captured.  Their firing range is only two
             sectors, and they can re-supply the enemy less  rapidly
             than can a base.
    
         5.  Neutral planet.  While these aren't strictly classified
             as  enemies,  they  will  take  pot shots at you (their
             range is also 2 sectors), so be wary of them.  You  can
             capture neutral planets and win them over to your side.
    
    
    
         When playing the game, all commands can be abbreviated to 2
    characters,  and some can be abbreviated to 1 character (you can
    use the shortest  unambiguous  abbreviation).   For  a  list  of
    commands type
    
             HELP *
    
    and for a description of an individual command type
    
             HELP command
    
    The help on individual commands will be read from this help file
    (that's  what  the  periods  in  column  1  are  for in the long
    description of each command).  The legal commands are:
    DECWAR GAME INSTRUCTIONS                                  Page 5
    
    
         1.  BASES -- List information on friendly and  known  enemy
             bases.
    
         2.  BUILD  --  Develop  installations  on  a  planet,   and
             eventually build it into a base.  The planet must first
             be captured.
    
         3.  CAPTURE -- Win a neutral or enemy planet over  to  your
             side.
    
         4.  DAMAGES --  List  damaged  devices  and  their  current
             status.
    
         5.  DOCK -- Dock at  an  adjacent  base  or  planet.   This
             increases  your  energy,  replenishes  your  torpedoes,
             repairs your ship  a  little,  and  reduces  your  ship
             damage.
    
         6.  ENERGY -- Transfer energy between two ships.
    
         7.  GRIPE -- Record bugs, comments,  suggestion,  etc.   in
             the file GAM:DECWAR.GRP, which is periodically reviewed
             by the implementors.
    
         8.  HELP -- List or describe the legal commands.
    
         9.  IMPULSE -- Move using impulse engines.
    
        10.  LIST -- List various information  about  ships,  bases,
             and planets.
    
        11.  MOVE -- Move using warp engines.
    
        12.  NEWS -- Tell about any  new  features  or  enhancements
             described in the file GAM:DECWAR.NWS.
    
        13.  PHASERS -- Fire phasers at a target.
    
        14.  PLANETS -- List information on friendly and known enemy
             and neutral planets.
    
        15.  POINTS -- List your score breakdown so far.
    
        16.  QUIT -- Get out of the game.
    
        17.  RADIO -- Turn ship's sub-space radio on or off;  ignore
             or restore communications from individual ships.
    
        18.  REPAIR -- Repair your damaged devices a little.
    
        19.  SCAN -- Display the galaxy with the default  range  set
             to  maximum  (10  sectors  in  each direction from your
             ship).
    
        20.  SET -- Set various input and output defaults.
    DECWAR GAME INSTRUCTIONS                                  Page 6
    
    
        21.  SHIELDS -- Transfer energy to  or  from  your  shields;
             raise or lower your shields.
    
        22.  SRSCAN -- Display the galaxy with a default range of  7
             sectors (1 greater than the maximum warp factor).
    
        23.  STATUS -- List your ship's current  status  and  supply
             levels.
    
        24.  SUMMARY -- List various information  on  ships,  bases,
             and planets.
    
        25.  TARGETS -- List  targets  (enemies  within  range)  and
             their current locations.
    
        26.  TELL  --  Send  messages  to  other  ships  using   the
             sub-space radio.
    
        27.  TIME -- List information on run time and elapsed time.
    
        28.  TORPEDOES -- Fire photon torpedoes at a target.
    
        29.  TRACTOR -- Use tractor beam to tow friendly ships.
    
        30.  TYPE  --  List  current   input,   output,   and   game
             characteristics.
    
        31.  USERS -- List the names  and  other  information  known
             about the players currently in the game.
    
    
    
    DECWAR GAME INSTRUCTIONS                                  Page 7
    
    
    General INPUT information
    
    - Only the first 5 characters of each  input  word  are  stored.
    Any characters beyond that are ignored.
      - Input words may be separated by spaces, tabs, or commas.
      - The input line can be terminated with <CR>, <LF>, <VT>,  <FF>,
        <ESC>, or ^Z.
      - ^G toggles echo.  At the beginning of each input line, echoing
        is  turned  on.   Typing ^G turns it off, the next ^G turns it
        back on, etc.  Echoing is always turned back on at the end  of
        an input line, or if ^U is typed.
      - Multiple commands may be given on a  single  command  line  by
        separating  the  commands with / (slash).  If the TELL command
        is given, it must be last on the line.
      - Anything after ;  (semicolon) is treated as a comment  and  is
        ignored  (but  TELL  rescans the line and takes the text after
        the first ;  as the message to send).
    - <ESC> (escape, or altmode) entered as the first  character  in
      response  to  the  command  prompt (even before ^H, ^U, or ^R)
      repeats the previous command.  This is useful when building  a
      planet,  docking,  repairing,  firing torpedoes, etc.  Altmode
      can't be used to repeat a TELL command.
    
      - Any ship name can be abbreviated to 1 character.
          - Any command or  keyword  can  be  shortened  to  the  shortest
            unambiguous   abbreviation,   which   is  never  more  than  2
            characters.
    
          - Many commands require a coordinate as  an  argument  (PHASERS,
            TORPEDOES,  CAPTURE, BUILD, etc.).  The required coordinate(s)
            can be specified in one of three ways:
            Absolute - the default coordinate input type, which is  simply
            an  absolute  vertical  position  followed  by  an  absolute
            horizontal position.  The coordinate may be preceded by  the
            keyword  ABSOLUTE,  but  this  isn't  necessary  unless  the
            default coordinate input type has been changed by SET  ICDEF
            RELATIVE.
            Relative -  the  keyword  RELATIVE,  followed  by  a  relative
            vertical  distance  and  a  relative horizontal distance.  A
            positive distance is either up or  right,  and  negative  is
            either down or left.  The absolute coordinate is computed by
            adding the relative distances to your current position.  The
            keyword  RELATIVE  isn't  needed  if  the default coordinate
            input type has been changed by SET ICDEF RELATIVE.
            Computed - the keyword COMPUTED followed by a ship name.   The
            coordinate  used  is  the  location of the given ship.  This
            type of coordinate computation is available only to captains
            controlling  their  ships  through  slow  terminals  (< 1200
            baud), and requires an operational computer.
            The keyword ABSOLUTE, RELATIVE, or COMPUTED is only given  one
            time  for  each set of coordinates.  For instance, the TORPEDO
            command can accept  up  to  3  coordinates,  but  the  keyword
            describing  the  coordinate input type is given only once, and
            all coordinates must be of the same type.
    
    
    DECWAR GAME INSTRUCTIONS                                  Page 8
    
    
    General OUTPUT information
    
    The SET OUTPUT LONG/MEDIUM/SHORT command controls the length  of
    text output throughout the game.  In particular, Medium or Short
    hit messages received  during  battle  are  greatly  reduced  in
    length  when  compared to the Long format.  Unfortunately, these
    shorter forms are not as self-explanatory as the Long form.  The
    following  are  some  equivalent  Long,  Medium  and  Short  hit
    messages:
    
    - Goblin @22-31, +83.6%  makes 285.3 unit torpedo hit on
    Vulcan displaced to 20-31, +72.1%
    
    G @22-31, +83.6%  285.3 unit T  V -->20-31, +72.1%
    
    G 22-31 +83  285T  V >20-31 +72
    
    
    - Emp planet(3) @15-16 makes 155.5 unit phaser hit on
    Buzzard @15-17, 66.8%
    
    -@3 @15-16  155.5 unit P  B @15-17, 66.8%
    
    -@3 15-16  155P  B 15-17 +66
    
    Note: The -@3 indicates an Empire planet built 3 times.
    
    
    - Star @22-31 +4,+2 makes 301.2 unit hit on
    Panther displaced to 20-31 +2,+2, -72.1%
    
      * @22-31 +4,+2  301.2 unit N  P -->20-31 +2,+2, -72.1%
    
      * 22-31 +4,+2  301N P >20-31 +2,+2, -72
    
    Note:  The relative coordinates appear due to a SET OCDEF BOTH
    command.  The Panther's shields are 72.1% of max strength, but
    down (-72.1%).
    
    
    The Decwar PRE-GAME feature
    
    DECWAR provides a Pre-game feature to allow:
    - New players to view the help file without entering the current
    game.
      - Experienced players to check the  status  of  a  current  game
        before choosing a side and ship.
      - Players to submit Gripes without entering the game.
    
    The commands currently active within the Pre-game section are:
    Activate  Gripe     Help      News      Points    Quit
    Summary   Time      Users
    
    The ACTIVATE command (valid only in the  pre-game)  is  used  to
    exit the pre-game section and enter the normal ship setup stage.
    The pre-game can be recognized from the 'PG>' command prompt.
    DECWAR GAME INSTRUCTIONS                                  Page 9
    
    
    Some general HINTS
    
    - When in doubt, use the on-line help system.  See the  help  on
    HELP for more information.
      - If the output starts piling up in the middle of a battle, type
        ^O  (CTL-O).   None  of  your  commands will be executed until
        output is finished, so it's sometimes better  just  to  ignore
        the  hit  messages  so  your  attack  or  run  commands can be
        executed immediately.
      - Use multiple commands per line  (separate  commands  with  /).
        Once  you're  in  a danger area, things can happen faster than
        you can react to them.  Plan your action ahead of time, before
        you enter a danger area.
      - If some unexpected action happens, such as  an  enemy  finding
        you,  and  you  have  several  stacked commands (either from a
        multiple command line or typing ahead), type ^C to  abort  all
        stacked  commands  (especially  if  it involves time consuming
        commands such as BUILD, or commands that  generate  a  lot  of
        output,  such  as  SCAN).   You can then proceed to remedy the
        situation by giving your unexpected visitor a good beating.
      - If you're on a slow terminal, use  computed  coordinates,  and
        move  around  a  lot  if  you're  fighting  someone  on a fast
        terminal.  Computed coordinates are the primary advantage slow
        terminals  have  over the fast ones (computed coordinates give
        slow  terminals  a  fantastic  tactical  advantage  over  fast
        terminals when used properly).
      - Use <ESC> to repeat commands (see the help on  ESCAPE).   It's
        just a convenience when building planets, etc., but in battle,
        and combined with multiple commands per line  and/or  computed
        coordinates  (such  as PH C B/M R 1 0  or  TO 1 32 45), it can
        make or break your career as a starship captain.
      - Don't get within range of an  enemy  base,  unless  you  enjoy
        being  pounded  into rubble.  You can kill a base just as well
        from 1 sector outside it's range (use the WARNING  keyword  on
        SCAN to see the range of an enemy base).
      - Don't waste your energy and torpedoes firing at friendly ships
        and  bases.   If you're not sure if it's friendly or not, type
        HELP SCAN for a list of what's what.  You  can  also  use  the
        TARGETS  command  to  see which enemies are lurking about (see
        the help on TARGETS and LIST).
      - Don't make it a  habit  of  sitting  next  to  stars;   photon
        torpedoes  can  turn  them  into  novas,  which  are extremely
        destructive.  Conversely, if you notice an enemy ship or  base
        adjacent to a star, take advantage of the situation!
      - One sure way to locate enemy  ships  is  to  watch  for  newly
        captured enemy planets by using the PLANETS or LIST command.
      - In general, don't waste photon torpedoes battering at a target
        with  85-100%  shields.   The  chances are good that they will
        just be deflected harmlessly away.  Use your phasers to weaken
        the  shields,  then  use torpedoes to finish him off.  This is
        especially true when attempting to destroy an enemy starbase.
      - Use the SET command in DECWAR.INI to personalize the output to
        your  own  tastes.   That way you'll be guaranteed to have the
        output set right each time you play a game.
      - To always see the range and direction of any object listed (in
        hit  messages,  output from the LIST command, etc.), SET OCDEF
        BOTH.  (The range is the magnitude of either delta v or  delta
      DECWAR GAME INSTRUCTIONS                                 Page 10
    
    
      h, whichever is larger.)
    
    
    Commands that take real time
    
    Many of the commands are designed to take a  certain  amount  of
    real  time.   This  is done to help equalize the game when there
    are different speed terminals and different speed typists in the
    game.   Some  commands  take a constant amount of time, and some
    are based on the speed of the slowest terminal in the game.
    
    BUILD           5 to 7 seconds
    CAPTURE         5 seconds + 1 second for each BUILD of enemy
                    planet
    DOCK            2 to 4 seconds
    IMPULSE         2 to 4 seconds
    MOVE            2 to 4 seconds
    REPAIR          (0.08 * repair size) seconds (* 0.5 if docked)
    
    You have 2 phaser banks, each of which must be cooled off  after
    it's  fired before it can be used again.  Each phaser bank takes
    3 to 6 seconds plus the amount of phaser damage /  100  to  cool
    off.   For  instance,  if  there  was a 300 baud terminal in the
    game, and your phasers had 200 units of  damage,  each  of  your
    phaser  banks  would  take  6  + 2 = 8 seconds to cool off after
    being fired.  Therefore, you could fire once every 4 seconds, or
    twice every 8 seconds.
    
    After each burst of torpedoes the tubes must be reloaded  before
    being  used  again.   It takes 2 to 4 seconds plus the amount of
    torpedo tube damage / 100 to load a torpedo.  For  instance,  if
    there  was  a  300 baud terminal in the game, your torpedoes had
    200 units of damage, and you had  just  fired  3  torpedoes,  it
    would  take  3  *  (4  +  2)  = 18 seconds before you could fire
    torpedoes again.
    
    
    Use of ^C
    
    If you're in command input wait (DECWAR is waiting  for  you  to
    type  a command), typing a ^C will abort the game and return you
    to monitor mode.  When you abort the game in this  manner,  your
    ship  is  returned  to the pool of available ships.  You will be
    able to continue unless a new player  has  taken  your  ship  or
    someone has moved into the spot you occupied.
    
    If you're not in a command input wait state when  you  type  ^C,
    any  stacked  commands (commands that you typed in ahead of time
    that haven't been executed yet) will be aborted, and a series of
    bells will be output.
    
    NOTE:  A ship under RED alert conditions can not be returned  to
    the monitor level except by using the QUIT command.
    DECWAR GAME INSTRUCTIONS                                 Page 11
    
    
    List various BASE information
    
    Syntax:  BAses [<keywords>]
    
    List location and shield percent of friendly bases;  location of
    known  enemy  bases;   or count of bases of either side within a
    specified range or the entire galaxy.  The default range is  the
    entire galaxy, and the default side is friendly bases only.  See
    the help for LIST for more information and the complete  set  of
    keywords that can be used to modify BASES output.
    
    Examples:
    
    BA              List location and shield percent of all friendly
                    bases.
    BA ENEMY        List location of all known enemy bases.
    BA SUM          Give summary of all friendly bases.
    BA ALL SUM      Give summary of all bases.
    BA CL           List the location and shield percent of the
                    closest friendly base.
    BA 34 26        List the location and shield percent of friendly
                    base at 34-26 (it doesn't have to be friendly,
                    but you can't see the shield percent of an out
                    of range enemy base).
    
    
    BUILD fortifications on a captured planet
    
    Syntax:  BUild [Absolute|Relative] <vpos> <hpos>
    
    A  fortified  planet  hits  harder  and  is  more  resistant  to
    destruction  by the enemy.  A planet can normally be built up to
    4 times.  As  your  team's  starbases  are  destroyed  by  enemy
    action,  a  fifth  build will complete the construction of a new
    starbase on the planet.  Only 10 starbases can be functional  at
    any one time.
    
    Examples:
    
    BU 32 12        Build the planet at sector 32-12.
    BU A 32 12      Equivalent to "BU 32 12"
    BU R 1 1        Build the planet at sector 32-12, if your
                    present location is 31-11.
    
    
    CAPTURE a neutral or enemy planet
    
    Syntax:  CApture [Absolute|Relative] <vpos> <hpos>
    
    At the start of the game, all planets are neutral (they fire  at
    everyone!).   Once  captured  by  either side, they fire only at
    enemy ships, and can be DOCKed at to refuel and rearm, just like
    a  base (except a planet can only supply half the resources that
    a  base  can).   Enemy  planets  can  also  be  captured.   When
    capturing an enemy planet, 1 second is added to the normal pause
    time of 5 seconds for each BUILD present.   Also,  50  units  of
    ship energy are lost for each build.
    DECWAR GAME INSTRUCTIONS                                 Page 12
    
    
    Examples:
    
    CA 12 32        Capture planet at 12-32.
    CA A 12 32      Equivalent to "CA 12 32".
    CA R 1 1        Capture planet at sector 12-32, if your present
                    location is 11-31.
    
    
    DAMAGE report
    
    Syntax:  DAmages [<device names>]
    
    List damaged ship devices and the amount of damage to each.  The
    condition  of  all  or  just  selected  devices may be examined.
    Total ship damage is not reported.
    
    Examples:
    
    DA              List all damaged devices and their current
                    damages.
    DA SH T         List damages for SHields and Torpedo tubes.
    DA PH RA C      List damages for PHasers, sub-space RAdio, and
                    Computer.
    
    
    DOCK at a friendly base or planet
    
    Syntax:  DOck [Status [<device names>]]
    
    Refuel, repair,  and  rearm  your  ship,  and  set  your  ship's
    condition  to green.  While docked, any repairs are accelerated,
    and you have an "infinite" supply of  torps.   If  you  have  no
    damages  and  are  completely refueled and rearmed, DOCKing will
    have no effect on your ship.  A STATUS  command  string  can  be
    appended to a DOCK order.  The following table lists the maximum
    resources available per move when DOCKing at a base or planet:
    
    Resource                        Base    Planet
    ----------------------------------------------
    Ship energy                    +1000      +500
    Shield energy                   +500      +250
    Photon Torpedoes                 +10        +5
    Life Support Reserves             +5        +5
    Ship Damage                     -100       -50
    Ship Damage, if already docked  -200      -100
    
    Examples:
    
    DO              Dock, no status report.
    DO ST           Dock, show ship's status AFTER docking.
    DO ST SH T      Dock, show ship's shield strength and number of
                    torpedos on board AFTER docking.
    
    
    Transfer ENERGY to a friendly ship
    
    Syntax:  Energy <ship name> <units of energy to transfer>
    DECWAR GAME INSTRUCTIONS                                 Page 13
    
    
    The receiving ship must be located in an adjacent  sector.   10%
    of  the  energy  transferred  will  be  lost  due  to  broadcast
    dissipation.  If you attempt to send more energy than the  other
    ship  can store (ie 5000 units), the transfer will automatically
    be reduced to the maximum possible.
    
    Example:
    
    E I 1000        Transfer 1000 units of energy to the Intrepid.
                    The Intrepid will receive 900 units of energy.
    
    
    Submit a GRIPE
    
    Syntax:  Gripe
    
    Add a comment, bug report, suggestion, etc.  to the top of  file
    GAM:DECWAR.GRP.   Type in your comments, then ^Z (CTL-Z) to exit
    and continue the game, or ^C (CTL-C) to abort and not  send  the
    gripe.   Each  gripe is preceded with a header that includes the
    version number, date, time, ship name,  user  name,  TTY  speed,
    PPN,  TTY number, job number, and whether or not Romulans and/or
    black holes are included in the game.  Unless you are  currently
    under  red  alert, GRIPE will protect you from enemy attack.  To
    view gripes not yet acted upon, type  the  file  GAM:DECWAR.GRP.
    To  view answered gripes, and see what action was taken on them,
    type the file GAM:DECWAR.FXD.
    
    
    Give HELP
    
    Syntax:  Help [*|<keywords>]
    
    Give general help info, a  list  of  available  commands,  or  a
    detailed description of a particular command or keyword.  Unless
    you are under red  alert,  HELP  will  protect  you  from  enemy
    attack.   The  following  conventions  are  used in the detailed
    descriptions:
    - The first line contains, in all caps, the keyword that help is
    being given for.
      - The syntax line (second line) lists the portion of the keyword
        required  to  make it unique in caps, and the remainder of the
        keyword in lower case, followed  by  any  parameters  (if  the
        keyword is a command).
      - A quantity to be filled in is lower case and  enclosed  in  <>
        (angle brackets).
      - Optional parameters are enclosed in [] (square brackets).
      - A choice (either or) is indicated by | (vertical bar).
      - Any parameter that must be typed in literally  is  started  in
        capital  letters  and continued in lower case.  The upper case
        letters signal  the  shortest  unambiguous  abbreviation  (the
        shortest   abbreviation  may  change  slightly,  depending  on
        context).
    
    Examples:
    
    H               Give general help info.
    DECWAR GAME INSTRUCTIONS                                 Page 14
    
    
    H *             List all available commands.
    H H             List this block of text.
    H SH            Give help for the SHIELDS command.
    H HI G          Give some general HINTS and a description of the
                    GRIPE command.
    
    
    Move using IMPULSE engines
    
    Syntax:  Impulse [Absolute|Relative] <vpos> <hpos>
    
    Move  one  sector  vertically,   horizontally,   or   diagonally
    (equivalent to warp factor 1).  Ship condition changes to green.
    
    Examples:
    
    I 37 45         Move to sector 37-45.
    I A 37 45       Equivalent to "I 37 45".
    I R 1 -1        Move to sector 37-45, if your ship's present
                    location is 36-46.
    
    
    LIST ship, base, and planet info
    
    Syntax:  List [<keywords>]
    
    The following information is available via the LIST command:
    - Name  of  any  ship  currently  in  the  game  (including  the
    Romulan).
      - Location and shield percent of any friendly ship, or any  ship
        within scan range (10 sectors).
      - Location and shield percent of any friendly base, or any  base
        within range.
      - Location of any known enemy base (any base that has previously
        been SCANned or LISTed by anyone on your team).
      - Location and number of builds of  any  known  planet,  or  any
        planet within range.
        The above information is also available, in whole  or  in  part,
        through the SUMMARY, BASES, PLANETS, and TARGETS commands.  Each
        command has it's own default range,  side  (Federation,  Empire,
        Romulan,  Neutral),  and object (ship, base, planet).  LIST (and
        SUMMARY) include everything  (infinite  range,  all  sides,  all
        objects)  by default.  On output, enemy objects are flagged with
      * (star) in column 1 unless the command is TARGETS.
    
    Keywords used with BASES, PLANETS, TARGETS,  LIST,  and  SUMMARY
    (not all keywords are legal for all commands):
    
    ship names      Include only specified ships (several ship names
    may be given, including Romulan).
    vpos hpos       List only the object at the location vpos-hpos.
    CLosest         List only the closest of the specified objects.
    
    SHips           Include only ships (Federation, Empire, or
    Romulan).
    BAses           Include only bases (Federation or Empire).
    PLanets         Include only planets (Federation, Empire, or
    DECWAR GAME INSTRUCTIONS                                 Page 15
    
    
                    Neutral).
    POrts           Include only bases and planets.  If no side is
                    specified (Federation, Empire, Neutral, or
                    Captured), include only friendly ports.
    
    FEderation      Include only Federation forces.
    HUman           Same as Federation.
    EMpire          Include only Empire forces.
    Klingon         Same as Empire.
    FRiendly        Include only friendly forces (Federation or
                    Empire).
    ENemy           Include only enemy forces (Empire or Federation
                    and Romulan).
    TArgets         Same as enemy.
    NEutral         Include only neutral planets.
    CAptured        Include only captured planets (Federation or
                    Empire).
    
    n               Include only objects within n sectors.
    ALl             Include all sides unless a side is explicitly
                    given.  Extend the range to infinity unless a
                    range is explicitly given.
    
    LIst            List individual items.  Turn off summary unless
                    command is SUMMARY or the keyword SUMMARY is
                    specified.
    SUmmary         List summary of all selected items.  Turn off
                    list unless command is LIST or the keyword LIST
                    is specified.  Extend the range to infinity
                    unless a range is explicitly given.
    
    And             Used to separate groups of keywords.
    &               Same as AND.
    
    Examples:
    
    LIST            List all information available on all ships,
                    bases, and planets.
    LIST SUM        List all available info plus a summary of the
                    number of each object in game.
    LI EN BA        List the location of all known enemy bases.
    LI SH           List all available info on all ships in the
                    game.
    LI CL PO        List closest friendly base or friendly or
                    neutral planet.
    LI 1 3 & 9 5    List the objects at locations 1-3 and 9-5.
    
    
    MOVE using warp drive
    
    Syntax:  Move [Absolute|Relative|Computed] <vpos> <hpos>
    
    Maximum speed is warp factor 6, which will move  you  6  sectors
    per  turn.  Maximum SAFE speed is warp factor 4;  warp factors 5
    and 6 risk potential warp engine damage.  Energy consumption per
    move  is  proportional to the square of the warp factor.  If the
    ship's  shields  are  up  during  this  movement,   the   energy
    DECWAR GAME INSTRUCTIONS                                 Page 16
    
    
    consumption is doubled.  Moving changes your ship's condition to
    green.
    
    Examples:
    
    M 37 45         Move to sector 37-45.
    M A 37 45       Equivalent to "M 37 45".
    M R 4 -5        Move to sector 37-45, if your present location
                    is 33-50 (move up 4 sectors and left 5 sectors).
    M C W           "Ram" the Wolf.  No actual collision occurs, but
                    your ship ends up adjacent to the Wolf's current
                    position.
    
    
    Display the NEWS file
    
    Syntax:  NEws
    
    Display the file which contains information on any new features,
    enhancements, bug fixes, etc for each version of DECWAR.
    
    
    Fire PHASERS at an enemy ship, base, or planet
    
    Syntax:  PHasers  [Absolute|Relative|Computed]  [energy]  <vpos>
    <hpos>
    
    Phasers must be directed at a  specific  target,  and  only  one
    target may be specified per command.  Obstacles seemingly in the
    path of the phaser blast are unaffected, since the energy ray is
    not  a  line-of- sight weapon.  The size of the hit is inversely
    proportional to the distance from the target.  Maximum range  is
    10 sectors vertically, horizontally, or diagonally.  Each phaser
    blast consumes 200 units  of  ship  energy,  unless  a  specific
    amount  of energy is given (the specified energy must be between
    50 and 500 units, inclusive).  The phaser banks have  roughly  a
    5%  chance  of  damage with a default (200 unit) blast, with the
    probability of damage reaching nearly 65% with  a  maximum  (500
    unit)  blast.   The  severity  of  the  resulting damage is also
    dependant on the size  of  the  blast.   Also,  if  your  ship's
    shields  are  up, a high-speed shield control is used to quickly
    lower and then  restore  the  shields  during  the  fire.   This
    procedure  consumes  another  200  units  of  ship  energy.  The
    weapons officer on board your ship will cancel all phaser blasts
    directed  against  friendly  ships,  bases,  or planets.  Firing
    phasers (or getting hit by  phasers)  puts  you  on  red  alert.
    NOTE:  Although phasers can damage enemy planetary installations
    (BUILDs), they can NOT destroy the planet itself.
    
    Examples:
    
    PH 12 32        Phaser target at sector 12-32.
    PH A 12 32      Equivalent to "PH 12 32".
    PH R 2 -3       Phaser target at sector 12-32, if your location
                    is 10-35.
    PH C BUZZARD    Phaser the Buzzard (if in range).
    PH C B          Same as PH C BUZZARD (ship names can be
    DECWAR GAME INSTRUCTIONS                                 Page 17
    
    
                    abbreviated to 1 character).
    PH 300 12 32    Phaser target at sector 12-32, using 300 units
                    of energy.
    
    
    List various PLANET information
    
    Syntax:  PLanets [<keywords>]
    
    List location and number of builds for all known planets, and  a
    summary  of  planets  within  a  specified  range  or the entire
    galaxy.  The default range is 10 sectors, and the  default  side
    is  every  side.  See the help for LIST for more information and
    the complete set of keywords that can be used to modify  PLANETS
    output.
    
    Examples:
    
    PL              List all planets within 10 sectors.
    PL SUM          Give summary of all planets in game.
    PL ALL NEU      List all known neutral planets.
    PL ALL CAP      List all known captured planets.
    PL ALL 20       List all known planets within a radius of 20
                    sectors.
    
    
    List POINTS scored so far this game
    
    Syntax:                                                   POints
    [Me|I|Federation|Human|Empire|Klingon|Romulan|All]
    
    Itemize  the  current  point  breakdown.   Information  can   be
    obtained  concerning  the points scored by your individual ship,
    your team, the opposition, the romulans, or any  combination  of
    the  above.   If the Romulan Empire is not involved in the game,
    the ROMULAN keyword will be ignored.
    
    Categories in POINTS breakdown:
    - Damage to enemies.
      - Enemies destroyed (500 points each).
      - Damage to bases.
      - Planets captured (100 points each).
      - Bases built (1000 points each).
      - Romulans damaged/destroyed.
      - Stars destroyed (-50 points each).
      - Planets destroyed (-100 points each).
    
      - Total points scored.
      - Total number of ships commissioned.
      - Total score / number of players.
      - Total score / stardates.
    
    Examples:
    
    PO              List points for your ship.
    PO ME           Equivalent to "PO".
    PO KLI FED      List the score of the two teams.
    DECWAR GAME INSTRUCTIONS                                 Page 18
    
    
    PO ALL          List all the scoring information available.
    
    
    QUIT the game
    
    Syntax:  Quit
    
    Quit the game before normal end of execution and return  to  the
    monitor.   Your  ship  is  released  for  use by another player,
    you're chalked up as just  one  more  casualty,  and  you  can't
    CONTINUE  the game.  If you want to rejoin the game, you'll have
    to wait 2 minutes, and then either START or RUN  the  game.   If
    you  want  to exit the game temporarily (to answer SENDS, etc.),
    type ^C (CTL-C), and you'll usually be able to CONTINUE.   NOTE:
    If  you're  under  red alert, you won't be able to ^C out of the
    game;  you'll have to use the QUIT command.
    
    
    Turn sub-space RADIO on or off, or
    set to ignore or restore communications from individual ships
    
    Syntax:  RAdio ON|OFf  or  RAdio Gag|Ungag <ship name>
    
    Turn your ship's sub-space radio on  or  off,  thus  controlling
    whether  or  not you'll receive any messages from other ships or
    your bases;  or suppress or restore  messages  originating  from
    specific ships.
    
    Examples:
    
    RA ON           Turn sub-space radio ON.
    RA OFF          Turn sub-space radio OFF.
    RA G L          Suppress all radio messages sent by the
                    Lexington.
    RA U W          Allow radio messages sent by the Wolf to be
                    received.
    
    
    REPAIR device damage
    
    Syntax:  REpair [<units>]
    
    Repair damaged ship devices.  If a ship suffers a  critical  hit
    to  a  device,  REPAIR can be used to restore the device to full
    (or partial) working order.   A  REPAIR  removes  the  specified
    units  of  damage  from  each damaged device, in addition to the
    normal repair rate of 30 units per turn.  If the ship is DOCKED,
    the  pause  time  for the specified REPAIR is reduced by half of
    that needed  while  in  flight.   If  the  repair  size  is  not
    specified,  REPAIR  defaults to a 4 second repair (50 units + 50
    more if docked).  REPAIR does NOT reduce the SHIP damage.
    
    Examples:
    
    RE 100          Remove up to 100 units of device damage.
    RE              Same as "RE 100" if DOCKED, else same as "RE
                    50".
    DECWAR GAME INSTRUCTIONS                                 Page 19
    
    
    Full range SCAN
    
    Syntax:  SCan [Up|Down|Right|Left|Corner] [<range>|<vr><hr>] [W]
    
    Display a selected portion of the nearby universe.  If no  range
    is  specified,  SCAN  defaults  to  a  square  scan range of ten
    sectors from the present ship location.  The keywords UP,  DOWN,
    RIGHT,  LEFT, and CORNER modify this to include only the part of
    this original square specified  (relative  to  the  ship).   The
    maximum  scan  range  is 10 sectors, and larger specified ranges
    are  reduced  to  this  value.   If  individual   vertical   and
    horizontal  ranges  are  specified,  the  scanning field will be
    shaped accordingly.  The WARNING keyword if added to the end  of
    a  SCAN  command string will flag the empty sectors within range
    of an enemy base or planet with !'s instead of . 's.   The  SCAN
    symbols and their meanings are:
    
    L, N, S, V, Y   Federation warships
    C, D, H, J, W   Empire warships
            ??        Romulan warship
            <>        Federation starbase
            )(        Empire starbase
             @        Neutral planet
            @F        Federation planet
            @E        Empire planet
             *        Star
                      Black hole
             .        Empty sector
             !        Empty sector within range of enemy port (only
                      when using WARNING keyword)
    
    Examples:
    
      SC              Scan universe within a radius 10 sectors.
      SC 10           Equivalent to "SC".
      SC 13           Equivalent to "SC 10" or "SC".
      SC 4            Scan universe within 4 sectors.
      SC 4 4          Equivalent to "SC 4".
      SC 2 8          Scan up to 5 rows and 17 columns, centered on
                      the present ship location.
      SC U 4 7        Show only upper half of normal "SC 4 7" scan.
      SC C -5 -5      Scan the region bounded by the present ship
                      location and the location (-5,-5) sectors away
                      (puts ship in upper right corner of the scan).
      SC W            Same as "SC", plus shows danger zones around
                      enemy bases and planets.
    
    
    SET input and output parameters
    
    Syntax:  SEt <keyword> <value>
    
    Keyword Value    Description
    ------- -----    -----------
    Name    name     Change name (shows in USERS).
    Output  Long     Default.  Use longest output format.
            Medium   Use medium output format.
    DECWAR GAME INSTRUCTIONS                                 Page 20
    
    
            Short    Use short (cryptic) output format.
    Scan    Long     Default.  Use long format scans.
            Short    Use 1 character symbols instead of 2.
    Prompt  Normal   Default.  Use "COMMAND:  " prompt.
            Informative Use "> " for prompt.  Precede the ">" with:
                     S if shields are down or < 10%.
                     E if ship energy < 1000 (yellow alert).
                     D if ship damage > 2000.
                     nL if life support is critically damaged (n
                     stardates of reserves).  Ttytype CRT, ADM-3a,
                     ADM-2, SOROC, BEEHIVE, ACT-IV, ACT-V Doesn't do
                     anything yet.
    OCdef   Absolute Default.  Display all coordinates in absolute
                     format (vpos-hpos).
            Relative Display coordinates relative to your location
                     (dv,dh).
            Both     Display coordinates in both absolute and
                     relative form.
    Icdef   Absolute Default.  All input coordinates default to
                     absolute.
            Relative Input coordinates default to relative.
    
    Examples:
    
    SE PR I         Switch to informative prompt.
    SE OU S         Set output format to short.
    SE N THOR       Change your name in USERS to THOR.
    
    
    SHIELD control
    
    Syntax:  SHields Up|Down  or  SHields Transfer <energy>
    
    Raise or lower ship shields, or transfer energy between ship and
    shield  energy  reserves.  Raising shields consumes 100 units of
    ship energy, lowering them  or  transfering  energy  is  "free".
    NOTE:   Shield  condition is displayed as +n% for shields up, n%
    of full strength, or -n%, for shields down, n% of full strength.
    
    Examples:
    
    SH U            Raise shields.
    SH D            Lower shields.
    SH T 500        Transfer 500 units of energy TO shields
    SH T -500       Transfer 500 units of energy FROM shields
    
    
    Short Range SCAN
    
    Syntax:  SRscan  [Up|Down|Right|Left|Corner]  [<range>|<vr><hr>]
    [W]
    
    Equivalent to SCAN, but with a default scan range of 7  sectors.
    For complete information on sensor scans, see the help on SCAN.
    
    
    Show ship STATUS
    DECWAR GAME INSTRUCTIONS                                 Page 21
    
    
    Syntax:
    STatus
    [Condition|Location|Torpedoes|Energy|Damage|Shields|Radio]
    
    Show the current stardate, plus the status of any  of  the  ship
    attributes:   ship  condition,  location,  number of torps, ship
    energy, ship damage, shield energy, and radio  condition.   Ship
    condition  can  be  green,  yellow  (low  on energy), or red (in
    battle).  Radio condition is either on or off.
    
    Examples:
    
    ST              Give full status report.
    ST T            Report how many torpedos remain on board.
    ST E D SH       Report the ship energy, the ship damage, and the
                    shield condition (energy, %, up/down).
    ST L            Report the current ship location.
    
    
    Give SUMMARY on number of ships, bases, and planets
    
    Syntax:  SUmmary [<keywords>]
    
    Give any of the information available from the LIST command, but
    give  only  a summary by default.  See the help on LIST for more
    information and the complete set of keywords that can be used to
    modify SUMMARY output.
    
    Examples:
    
    SUM             Tell how many ships, bases, and planets are in
                    the game (broken down into friendly, enemy, and
                    neutral categories).
    SUM EN          Tell how many enemies are in the game (number of
                    Romulans, enemy ships, enemy bases, and enemy
                    planets).
    
    List information on TARGETS
    
    Syntax:  TArgets [<keywords>]
    
    Primarily for locating targets during battle, when a SCAN  would
    be  too time consuming.  List location and shield percent of any
    enemy ship, base, or planet in range;  name of any enemy ship in
    game  (including the Romulan);  or location and number of builds
    of any known enemy planet.  TARGETS  is  equivalent  to  a  LIST
    command with a default range of 10 sectors and a default side of
    enemy.
    
    Examples:
    
    TA              List all targets within 10 sectors.
    TA 10           Equivalent to "TA".
    TA 5            List all targets within 5 sectors.
    
    
    TELL another ship something using the sub-space radio
    DECWAR GAME INSTRUCTIONS                                 Page 22
    
    
    Syntax:                                                     TEll
    All|FEderation|HUman|EMpire|Klingon|ENemy|FRiendly|        <ship
    names>;<msg>
    
    Send messages to one or several of the players currently in  the
    game,  with  no range limitation.  Players who have turned their
    radios off, or have a critically damaged sub-space radio can not
    be  sent  to.   The  TELL  command can not be repeated using the
    ESCAPE key (no junk mail!).
    
    Examples:
    
    TE V;Hello!     Send "Hello!"  to the Vulcan.
    TE KL;DROP DEAD Send "DROP DEAD" to all Klingons.
    TE V,E;HELP ME  Send "HELP ME" to the Vulcan and Excalibur.
    
    
    List various TIMEs
    
    Syntax:  TIme
    
    List time since game started;  time since your ship entered  the
    game;   run  time for your job so far this game;  total run time
    since login;  and current time of day.
    
    
    Fire photon TORPEDO burst
    
    Syntax:
    TOrpedo  [Absolute|Relative|Computed]   n   <v1><h1>   [<v2><h2>
    [<v3><h3>]]
    
    A photon torpedo is aimed along a path in physical  space,  thus
    any  object  lying  along  its  path will intercept the torpedo.
    One, two, or three torpedoes may be fired with one command,  and
    the torpedoes may be individually targeted, or fired at a common
    location.  The minimum range of a torpedo is 8 sectors, but some
    will  travel  10 sectors before self-destructing.  Torpedoes may
    be deflected from the desired track by  a  number  of  different
    factors,  including  your  ship's  shield strength, computer and
    torpedo tube damage, and torpedo misfires.   A  torpedo  misfire
    also  aborts  the  remainder of the burst, and sometimes damages
    the torpedo tubes as well.  Torpedoes  can  cause  stars  to  go
    nova,  and  can  also destroy planets (if no enemy installations
    remain intact).  "Accidental" hits on friendly ships, bases,  or
    planets  are automatically neutralized.  A torpedo burst uses no
    ship energy.  Firing torpedoes (or getting hit by one) puts  you
    on red alert.
    
    Examples:
    
    TO 1 12 24        Fire one torpedo at sector 12-24.
    TO 3 12 24        Fire three torpedoes at sector 12-24.
    TO 3 6 7 8 7 9 12 Fire one torpedo at sector 6-7, one at 8-7,
                      and one at 9-12.
    TO 3 12 24 13 39  Fire one torpedo at sector 12-24, and two at
                      sector 13-39.
    DECWAR GAME INSTRUCTIONS                                 Page 23
    
    
    TO A 3 12 24      Equivalent to "TO 3 12 24".
    TO R 2 2 -5       Fire two torpedoes at sector 22-25, assuming
                      your location is 20-30.
    TO C 3 BUZZARD    Fire three torpedoes at the Buzzard.
    TO C 1 E          Fire one torpedo at the Excalibur.
    
    
    TRACTOR beam
    
    Syntax:  TRactor <ship name>  or  TRactor Off
    
    Tow another ship of the  same  team.   The  two  ships  must  be
    located  in  adjacent  sectors  and  both  ships must have their
    shields lowered.  Once such a beam is applied, either  ship  can
    pull  the other behind it using warp or impulse engines.  Energy
    consumption for the towing ship is 3 times the normal  rate  for
    movement  with  the shields down.  The ship being towed will end
    the  move  trailing  the  lead  ship.   If  either  ship  raises
    deflector  shields,  the tractor beam is automatically cut.  The
    tractor beam will also be broken if either  ship  is  hit  by  a
    torpedo or damaged by a nova.
    
    Examples:
    
    TR              Break any existing tractor beam.
    TR OFF          Equivalent to "TR".
    TR B            Apply tractor beam to the Buzzard.
    
    
    TYPE game, input, and output settings
    
    Syntax:  TYpe OPtion|OUtput
    
    Type the current game OPTION and OUTPUT settings.
    The OPTION settings are:
    - The version number and date of implementation,
      - Whether there are Romulans in the game,
      - and whether there are Black Holes in the game.
        The OUTPUT settings are:
      - SHORT, MEDIUM, or LONG output,
      - NORMAL or INFORMATIVE command prompt,
      - SHORT or LONG sensor scans,
      - ABSOLUTE or RELATIVE default for coordinate input,
      - ABSOLUTE, RELATIVE, or BOTH for coordinate output,
      - and the current TTYTYPE.
    
    Examples:
    
    TY OP           List the option settings.
    TY OU           List the output settings.
    
    
    List USERS
    
    Syntax:  Users
    
    List all ships  currently  in  the  game.   Include  ship  name,
    DECWAR GAME INSTRUCTIONS                                 Page 24
    
    
    captain  (may  be  changed  by  SET  NAME),  TTY speed, PPN, TTY
    number, and job number.  If the output format is set  to  medium
    or short, omit the TTY and job numbers.  If the output format is
    set to short, omit the TTY speed and PPN (include only the  ship
    name and captain).
    INDEX                                                    Page 25
    
    
    BASES  . . . . . . . . . . . . . 11
    BUILD  . . . . . . . . . . . . . 11
    
    CAPTURE  . . . . . . . . . . . . 11
    CTL-C  . . . . . . . . . . . . . 10
    
    DAMAGES  . . . . . . . . . . . . 12
    DOCK . . . . . . . . . . . . . . 12
    
    ENERGY . . . . . . . . . . . . . 12
    
    GRIPE  . . . . . . . . . . . . . 13
    
    HELP . . . . . . . . . . . . . . 13
    HINTS  . . . . . . . . . . . . . 9
    
    IMPULSE  . . . . . . . . . . . . 14
    INPUT  . . . . . . . . . . . . . 7
    INTRODUCTION . . . . . . . . . . 1
    
    LIST . . . . . . . . . . . . . . 14
    
    MOVE . . . . . . . . . . . . . . 15
    
    NEWS . . . . . . . . . . . . . . 16
    
    OUTPUT . . . . . . . . . . . . . 8
    
    PAUSES . . . . . . . . . . . . . 10
    PHASERS  . . . . . . . . . . . . 16
    PLANETS  . . . . . . . . . . . . 17
    POINTS . . . . . . . . . . . . . 17
    PREGAME  . . . . . . . . . . . . 8
    
    QUIT . . . . . . . . . . . . . . 18
    
    RADIO  . . . . . . . . . . . . . 18
    REPAIR . . . . . . . . . . . . . 18
    
    SCAN . . . . . . . . . . . . . . 19
    SET  . . . . . . . . . . . . . . 19
    SHIELDS  . . . . . . . . . . . . 20
    SRSCAN . . . . . . . . . . . . . 20
    STATUS . . . . . . . . . . . . . 20
    SUMMARY  . . . . . . . . . . . . 21
    SYMBOLS USED . . . . . . . . . . 19
    
    TARGETS  . . . . . . . . . . . . 21
    TELL . . . . . . . . . . . . . . 21
    TIME . . . . . . . . . . . . . . 22
    TORPEDOES  . . . . . . . . . . . 22
    TRACTOR  . . . . . . . . . . . . 23
    TYPE . . . . . . . . . . . . . . 23
    
    USERS  . . . . . . . . . . . . . 23
    
