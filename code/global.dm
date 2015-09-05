//#define TESTING
#if DM_VERSION < 506
#warn This compiler is out of date. You may experience issues with projectile animations.
#endif

// Items that ask to be called every cycle.
var/global/obj/effect/datacore/data_core = null
var/global/list/all_areas                = list()
var/global/list/machines                 = list()
var/global/list/processing_objects       = list()
var/global/list/processing_power_items   = list()
var/global/list/active_diseases          = list()
var/global/list/med_hud_users            = list() // List of all entities using a medical HUD.
var/global/list/sec_hud_users            = list() // List of all entities using a security HUD.
var/global/list/hud_icon_reference       = list()

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
var/list/restricted_camera_networks = list("thunder","ERT","NUKE","Secret")

var/global/list/global_mutations  = list() // List of hidden mutation things.
var/global/defer_powernet_rebuild = 0      // True if net rebuild will be called manually after an event.

// The resulting sector map looks like:
//  ___ ___
// | 1 | 4 |
//  ---+---
// | 5 | 3 |
//  --- ---
//
// 1: SS13.
// 4: Derelict.
// 3: AI satellite.
// 5: Empty space.

var/global/datum/universal_state/universe = new

var/global/list/global_map = null
//var/global/list/global_map = list(list(1,5),list(4,3))

// Noises made when hit while typing.
var/list/hit_appends = list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")

var/list/paper_tag_whitelist = list(
	"center",  "p",     "div",   "span", "pre", "h1", "h2", "h3",  "h4",  "h5", "h6", "br", "hr",
	"big",     "small", "font",  "i",    "u",   "b",  "s",  "sub", "sup", "tt", "ol", "ul", "li",
	"caption", "col",   "table", "td",   "th",  "tr"
)
var/list/paper_blacklist = list(
	"java",        "onblur",    "onchange",    "onclick",    "ondblclick",  "onselect", "onfocus",
	"onsubmit",    "onreset",   "onload",      "onunload",   "onkeydown",   "onkeyup",  "onkeypress",
	"onmousedown", "onmouseup", "onmousemove", "onmouseout", "onmouseover",
)

// The way blocks are handled badly needs a rewrite, this is horrible.
// Too much of a project to handle at the moment, TODO for later.
var/BLINDBLOCK    = 0
var/DEAFBLOCK     = 0
var/HULKBLOCK     = 0
var/TELEBLOCK     = 0
var/FIREBLOCK     = 0
var/XRAYBLOCK     = 0
var/CLUMSYBLOCK   = 0
var/FAKEBLOCK     = 0
var/COUGHBLOCK    = 0
var/GLASSESBLOCK  = 0
var/EPILEPSYBLOCK = 0
var/TWITCHBLOCK   = 0
var/NERVOUSBLOCK  = 0
var/MONKEYBLOCK   = 27

var/BLOCKADD = 0
var/DIFFMUT  = 0

var/HEADACHEBLOCK      = 0
var/NOBREATHBLOCK      = 0
var/REMOTEVIEWBLOCK    = 0
var/REGENERATEBLOCK    = 0
var/INCREASERUNBLOCK   = 0
var/REMOTETALKBLOCK    = 0
var/MORPHBLOCK         = 0
var/BLENDBLOCK         = 0
var/HALLUCINATIONBLOCK = 0
var/NOPRINTSBLOCK      = 0
var/SHOCKIMMUNITYBLOCK = 0
var/SMALLSIZEBLOCK     = 0

var/skipupdate = 0

var/eventchance = 10 // Percent chance per 5 minutes.
var/event       = 0
var/hadevent    = 0
var/blobevent   = 0

var/diary          = null
var/href_logfile   = null
var/station_name   = "NSS Exodus"
var/game_version   = "Baystation12"
var/changelog_hash = ""
var/game_year      = (text2num(time2text(world.realtime, "YYYY")) + 544)

var/going             = 1.0
var/master_mode       = "extended" // "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/host = null
var/shuttle_frozen = 0
var/shuttle_left   = 0
var/shuttlecoming  = 0

var/list/jobMax        = list()
var/list/bombers       = list()
var/list/admin_log     = list()
var/list/lastsignalers = list() // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
var/list/reg_dna       = list()
//var/list/traitobj    = list()

var/mouse_respawn_time = 5 // Amount of time that must pass between a player dying as a mouse and repawning as a mouse. In minutes.

var/CELLRATE = 0.002 // Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
                     // It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
var/CHARGELEVEL = 0.0005 // Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)

var/shuttle_z        = 2  // Default.
var/airtunnel_start  = 68 // Default.
var/airtunnel_stop   = 68 // Default.
var/airtunnel_bottom = 72 // Default.

var/list/monkeystart     = list()
var/list/wizardstart     = list()
var/list/newplayer_start = list()

//Spawnpoints.
var/list/latejoin         = list()
var/list/latejoin_gateway = list()
var/list/latejoin_cryo    = list()
var/list/latejoin_cyborg  = list()

var/list/prisonwarp         = list() // Prisoners go to these
var/list/holdingfacility    = list() // Captured people go here
var/list/xeno_spawn         = list() // Aliens spawn at at these.
//var/list/mazewarp         = list()
var/list/tdome1             = list()
var/list/tdome2             = list()
var/list/tdomeobserve       = list()
var/list/tdomeadmin         = list()
var/list/prisonsecuritywarp = list() // Prison security goes to these.
var/list/prisonwarped       = list() // List of players already warped.
var/list/blobstart          = list()
var/list/ninjastart         = list()
//var/list/traitors         = list() // Traitor list.

var/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/datum/station_state/start_state = null
var/datum/configuration/config      = null
var/datum/sun/sun                   = null

var/list/combatlog = list()
var/list/IClog     = list()
var/list/OOClog    = list()
var/list/adminlog  = list()

var/list/powernets = list()

var/Debug  = 0 // Global debug switch.
var/Debug2 = 0
var/datum/debug/debugobj

var/datum/moduletypes/mods = new()

var/wavesecret    = 0
var/gravity_is_on = 1

var/join_motd = null
var/forceblob = 0

var/datum/nanomanager/nanomanager		= new() // NanoManager, the manager for Nano UIs.
var/datum/event_manager/event_manager	= new() // Event Manager, the manager for events.
var/datum/subsystem/alarm/alarm_manager	= new() // Alarm Manager, the manager for alarms.

var/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.

// MySQL configuration
var/sqladdress = "localhost"
var/sqlport    = "3306"
var/sqldb      = "tgstation"
var/sqllogin   = "root"
var/sqlpass    = ""

// Feedback gathering sql connection
var/sqlfdbkdb    = "test"
var/sqlfdbklogin = "root"
var/sqlfdbkpass  = ""
var/sqllogging   = 0 // Should we log deaths, population stats, etc.?

// Forum MySQL configuration. (for use with forum account/key authentication)
// These are all default values that will load should the forumdbconfig.txt file fail to read for whatever reason.
var/forumsqladdress = "localhost"
var/forumsqlport    = "3306"
var/forumsqldb      = "tgstation"
var/forumsqllogin   = "root"
var/forumsqlpass    = ""
var/forum_activated_group     = "2"
var/forum_authenticated_group = "10"

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon     = new() // Feedback    database (New database)
var/DBConnection/dbcon_old = new() // /tg/station database (Old database) -- see the files in the SQL folder for information on what goes where.

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
/var/list/tagger_locations = list()

// Added for Xenoarchaeology, might be useful for other stuff.
var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_phorochloride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional

// Used by robots and robot preferences.
var/list/robot_module_types = list(
	"Standard", "Engineering", "Construction", "Surgeon",  "Crisis",
	"Miner",    "Janitor",     "Service",      "Clerical", "Security",
	"Research"
)

// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Bomb cap!
var/max_explosion_range = 14

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/device/radio/intercom/global_announcer = new(null)

var/list/station_departments = list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Civilian")

var/global/const/TICKS_IN_DAY = 864000
var/global/const/TICKS_IN_SECOND = 10
