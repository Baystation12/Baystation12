#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

// Security levels.
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_BLUE  1
#define SEC_LEVEL_RED   2
#define SEC_LEVEL_DELTA 3

#define BE_TRAITOR    1
#define BE_OPERATIVE  2
#define BE_CHANGELING 4
#define BE_WIZARD     8
#define BE_MALF       16
#define BE_REV        32
#define BE_ALIEN      64
#define BE_AI         128
#define BE_CULTIST    256
#define BE_MONKEY     512
#define BE_NINJA      1024
#define BE_RAIDER     2048
#define BE_PLANT      4096
#define BE_MUTINEER   8192
#define BE_PAI        16384

var/list/be_special_flags = list(
	"Traitor"          = BE_TRAITOR,
	"Operative"        = BE_OPERATIVE,
	"Changeling"       = BE_CHANGELING,
	"Wizard"           = BE_WIZARD,
	"Malf AI"          = BE_MALF,
	"Revolutionary"    = BE_REV,
	"Xenomorph"        = BE_ALIEN,
	"Positronic Brain" = BE_AI,
	"Cultist"          = BE_CULTIST,
	"Monkey"           = BE_MONKEY,
	"Ninja"            = BE_NINJA,
	"Raider"           = BE_RAIDER,
	"Diona"            = BE_PLANT,
	"Mutineer"         = BE_MUTINEER,
	"pAI"              = BE_PAI
)

#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))


// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB        1 // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB        2 // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT     4 // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME         8 // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     16 // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         32 // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         64 // Generates a leader antagonist.
#define ANTAG_HAS_NUKE          128 // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN         256 // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE           512 // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE   1024 // Causes antagonists to use an appearance modifier on spawn.

// Mode/antag template macros.
#define MODE_BORER "borer"
#define MODE_XENOMORPH "xeno"
#define MODE_LOYALIST "loyalist"
#define MODE_MUTINEER "mutineer"
#define MODE_COMMANDO "commando"
#define MODE_DEATHSQUAD "deathsquad"
#define MODE_ERT "ert"
#define MODE_MERCENARY "mercenary"
#define MODE_NINJA "ninja"
#define MODE_RAIDER "raider"
#define MODE_WIZARD "wizard"
#define MODE_CHANGELING "changeling"
#define MODE_CULTIST "cultist"
#define MODE_HIGHLANDER "highlander"
#define MODE_MONKEY "monkey"
#define MODE_RENEGADE "renegade"
#define MODE_REVOLUTIONARY "revolutionary"
#define MODE_MALFUNCTION "malf"
#define MODE_TRAITOR "traitor"

/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		1	//can a ghost cast it?
#define NEEDSCLOTHES	2	//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		4	//does it require the caster to be human?
#define Z2NOCAST		8	//if this is added, the spell can't be cast at centcomm
#define STATALLOWED		16	//if set, the user doesn't have to be conscious to cast. Required for ghost spells
#define IGNOREPREV		32	//if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		64	//does the spell include the caster in its target selection?
#define SELECTABLE		128	//can you select each target for the spell?
//AOE spells
#define IGNOREDENSE		64	//are dense turfs ignored in selection?
#define IGNORESPACE		128	//are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	256	//used by construct spells - checks for nullrods
#define NO_BUTTON		512	//spell won't show up in the HUD with this

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