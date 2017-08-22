#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

// Security levels.
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_BLUE  1
#define SEC_LEVEL_RED   2
#define SEC_LEVEL_DELTA 3

#define BE_PLANT "BE_PLANT"
#define BE_SYNTH "BE_SYNTH"
#define BE_PAI   "BE_PAI"

// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB        0x1 // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB        0x2 // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT     0x4 // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME         0x8 // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     0x10 // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         0x20 // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         0x40 // Generates a leader antagonist.
#define ANTAG_HAS_NUKE           0x80 // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN         0x100 // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE           0x200 // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE    0x400 // Causes antagonists to use an appearance modifier on spawn.
#define ANTAG_RANDOM_EXCEPTED   0x800 // If a game mode randomly selects antag types, antag types with this flag should be excluded.

// Mode/antag template macros.
#define MODE_BORER "borer"
#define MODE_XENOMORPH "xeno"
#define MODE_LOYALIST "loyalist"
#define MODE_MUTINEER "mutineer"
#define MODE_COMMANDO "commando"
#define MODE_DEATHSQUAD "deathsquad"
#define MODE_ERT "ert"
#define MODE_ACTOR "actor"
#define MODE_MERCENARY "mercenary"
#define MODE_NINJA "ninja"
#define MODE_RAIDER "raider"
#define MODE_WIZARD "wizard"
#define MODE_CHANGELING "changeling"
#define MODE_CULTIST "cultist"
#define MODE_MONKEY "monkey"
#define MODE_RENEGADE "renegade"
#define MODE_REVOLUTIONARY "revolutionary"
#define MODE_LOYALIST "loyalist"
#define MODE_MALFUNCTION "malf"
#define MODE_TRAITOR "traitor"
#define MODE_DEITY "deity"
#define MODE_GODCULTIST "god cultist"
#define MODE_INNIE "insurrection"
#define MODE_INNIE_TRAITOR "innie sympathiser"

#define DEFAULT_TELECRYSTAL_AMOUNT 130

/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		0x1		//can a ghost cast it?
#define NEEDSCLOTHES	0x2		//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		0x4		//does it require the caster to be human?
#define Z2NOCAST		0x8		//if this is added, the spell can't be cast at centcomm
#define STATALLOWED		0x10	//if set, the user doesn't have to be conscious to cast. Required for ghost spells
#define IGNOREPREV		0x20	//if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		0x40	//does the spell include the caster in its target selection?
#define SELECTABLE		0x80	//can you select each target for the spell?
//AOE spells
#define IGNOREDENSE		0x40	//are dense turfs ignored in selection?
#define IGNORESPACE		0x80	//are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	0x100	//used by construct spells - checks for nullrods
#define NO_BUTTON		0x200	//spell won't show up in the HUD with this

//invocation
#define SpI_SHOUT	"shout"
#define SpI_WHISPER	"whisper"
#define SpI_EMOTE	"emote"
#define SpI_NONE	"none"

//upgrading
#define Sp_SPEED	"speed"
#define Sp_POWER	"power"
#define Sp_TOTAL	"total"

//casting costs
#define Sp_RECHARGE	"recharge"
#define Sp_CHARGES	"charges"
#define Sp_HOLDVAR	"holdervar"

#define INITIALIZATION_NOW 1
#define INITIALIZATION_HAS_BEGUN 2
#define INITIALIZATION_COMPLETE 4
#define INITIALIZATION_NOW_AND_COMPLETE (INITIALIZATION_NOW|INITIALIZATION_COMPLETE)
