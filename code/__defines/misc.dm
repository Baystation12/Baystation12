#define DEBUG
// Turf-only flags.
#define TURF_FLAG_NOJAUNT FLAG(0) // This is used in literally one place, turf.dm, to block ethereal jaunt.
#define TURF_FLAG_NORUINS FLAG(1)

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.
#define RUIN_MAP_EDGE_PAD 15
#define LANDING_ZONE_RADIUS 15 // Used for autoplacing landmarks on exoplanets

// Invisibility constants.
#define INVISIBILITY_LIGHTING    20
#define INVISIBILITY_LEVEL_ONE   35
#define INVISIBILITY_LEVEL_TWO   45
#define INVISIBILITY_OVERMAP     50
#define INVISIBILITY_OBSERVER    60
#define INVISIBILITY_EYE         61
#define INVISIBILITY_SYSTEM      99
#define INVISIBILITY_ABSTRACT   101	// special: this can never be seen, regardless of see_invisible

#define SEE_INVISIBLE_LIVING     25
#define SEE_INVISIBLE_NOLIGHTING 15
#define SEE_INVISIBLE_LEVEL_ONE  INVISIBILITY_LEVEL_ONE
#define SEE_INVISIBLE_LEVEL_TWO  INVISIBILITY_LEVEL_TWO
#define SEE_INVISIBLE_CULT       INVISIBILITY_OBSERVER
#define SEE_INVISIBLE_OBSERVER   INVISIBILITY_EYE
#define SEE_INVISIBLE_SYSTEM     INVISIBILITY_SYSTEM

#define SEE_IN_DARK_DEFAULT 2

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100

// Some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26 // Used to trigger removal from a processing list.

// For secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define      HEALTH_HUD 1 // A simple line rounding the mob's number health.
#define      STATUS_HUD 2 // Alive, dead, diseased, etc.
#define          ID_HUD 3 // The job asigned to your ID.
#define      WANTED_HUD 4 // Wanted, released, paroled, security status.
#define    IMPLOYAL_HUD 5 // Loyality implant.
#define     IMPCHEM_HUD 6 // Chemical implant.
#define    IMPTRACK_HUD 7 // Tracking implant.
#define SPECIALROLE_HUD 8 // AntagHUD image.
#define  STATUS_HUD_OOC 9 // STATUS_HUD without virus DB check for someone being ill.
#define 	  LIFE_HUD 10 // STATUS_HUD that only reports dead or alive

// Shuttle moving status.
#define SHUTTLE_IDLE      0
#define SHUTTLE_WARMUP    1
#define SHUTTLE_INTRANSIT 2

// Autodock shuttle processing status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

// Setting this much higher than 1024 could allow spammers to DOS the server easily.
#define MAX_MESSAGE_LEN       1024
#define MAX_PAPER_MESSAGE_LEN 6144
#define MAX_BOOK_MESSAGE_LEN  18432
#define MAX_LNAME_LEN         64
#define MAX_NAME_LEN          26
#define MAX_DESC_LEN          256
#define MAX_TEXTFILE_LENGTH 128000		// 512GQ file

// Event defines.
#define EVENT_LEVEL_MUNDANE  1
#define EVENT_LEVEL_MODERATE 2
#define EVENT_LEVEL_MAJOR    3
#define EVENT_LEVEL_EXO      4

//General-purpose life speed define for plants.
#define HYDRO_SPEED_MULTIPLIER 1

#define DEFAULT_JOB_TYPE /datum/job/assistant

//Area flags, possibly more to come
#define AREA_FLAG_RAD_SHIELDED         FLAG(0)  // shielded from radiation, clearly
#define AREA_FLAG_EXTERNAL             FLAG(1)  // External as in exposed to space, not outside in a nice, green, forest
#define AREA_FLAG_ION_SHIELDED         FLAG(2)  // shielded from ionospheric anomalies as an FBP / IPC
#define AREA_FLAG_IS_NOT_PERSISTENT    FLAG(3)  // SSpersistence will not track values from this area.
#define AREA_FLAG_NO_MODIFY            FLAG(4)  // turf in this area cannot be dismantled.
#define AREA_FLAG_HIDE_FROM_HOLOMAP    FLAG(5) // if we shouldn't be drawn on station holomaps

//Map template flags
#define TEMPLATE_FLAG_ALLOW_DUPLICATES    FLAG(0)  // Lets multiple copies of the template to be spawned
#define TEMPLATE_FLAG_SPAWN_GUARANTEED    FLAG(1)  // Makes it ignore away site budget and just spawn (only for away sites)
#define TEMPLATE_FLAG_CLEAR_CONTENTS      FLAG(2)  // if it should destroy objects it spawns on top of
#define TEMPLATE_FLAG_NO_RUINS            FLAG(3)  // if it should forbid ruins from spawning on top of it
#define TEMPLATE_FLAG_NO_RADS             FLAG(4)  // Removes all radiation from the template after spawning.

//Ruin map template flags
#define TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED FLAG(5)  // Ruin is not available during spawning unless another ruin permits it.

// Convoluted setup so defines can be supplied by Bay12 main server compile script.
// Should still work fine for people jamming the icons into their repo.
#ifndef CUSTOM_ITEM_CONFIG
#define CUSTOM_ITEM_CONFIG "config/custom_items/"
#endif
#ifndef CUSTOM_ITEM_SYNTH_CONFIG
#define CUSTOM_ITEM_SYNTH_CONFIG "config/custom_sprites.txt"
#endif
#ifndef CUSTOM_ITEM_OBJ
#define CUSTOM_ITEM_OBJ 'icons/obj/unused.dmi'
#endif
#ifndef CUSTOM_ITEM_MOB
#define CUSTOM_ITEM_MOB 'icons/obj/unused.dmi'
#endif
#ifndef CUSTOM_ITEM_SYNTH
#define CUSTOM_ITEM_SYNTH 'icons/obj/unused.dmi'
#endif

#define WALL_CAN_OPEN 1
#define WALL_OPENING 2

#define BOMBCAP_RADIUS (config.max_explosion_range * 1.75)
									// NTNet module-configuration values. Do not change these. If you need to add another use larger number (5..6..7 etc)
#define NTNET_SOFTWAREDOWNLOAD 1 	// Downloads of software from NTNet
#define NTNET_PEERTOPEER 2			// P2P transfers of files between devices
#define NTNET_COMMUNICATION 3		// Communication (messaging)
#define NTNET_SYSTEMCONTROL 4		// Control of various systems, RCon, air alarm control, etc.

// NTNet transfer speeds, used when downloading/uploading a file/program.
#define NTNETSPEED_LOWSIGNAL 0.5	// GQ/s transfer speed when the device is wirelessly connected and on Low signal
#define NTNETSPEED_HIGHSIGNAL 1	// GQ/s transfer speed when the device is wirelessly connected and on High signal
#define NTNETSPEED_ETHERNET 2		// GQ/s transfer speed when the device is using wired connection
#define NTNETSPEED_DOS_AMPLIFICATION 5	// Multiplier for Denial of Service program. Resulting load on NTNet relay is this multiplied by NTNETSPEED of the device

// Program bitflags
#define PROGRAM_CONSOLE       FLAG(0)
#define PROGRAM_LAPTOP        FLAG(1)
#define PROGRAM_TABLET        FLAG(2)
#define PROGRAM_TELESCREEN    FLAG(3)
#define PROGRAM_PDA           FLAG(4)
#define PROGRAM_NO_KILL       FLAG(5) //Not included in PROGRAM_ALL
#define PROGRAM_ALL ( PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_TELESCREEN | PROGRAM_PDA )

#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2

#define PROG_MISC  		"Miscellaneous"
#define PROG_ENG  		"Engineering"
#define PROG_OFFICE  	"Office Work"
#define PROG_COMMAND  	"Command"
#define PROG_SUPPLY  	"Supply and Shuttles"
#define PROG_ADMIN  	"NTNet Administration"
#define PROG_UTIL 		"Utility"
#define PROG_SEC 		"Security"
#define PROG_MONITOR	"Monitoring"

// Caps for NTNet logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NTNET_LOGS 500
#define MIN_NTNET_LOGS 10

// Special return values from bullet_act(). Positive return values are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flying after calling bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a miss (suppresses attack and admin logs) - only applies to mobs.

//Camera capture modes
#define CAPTURE_MODE_REGULAR 0 //Regular polaroid camera mode
#define CAPTURE_MODE_ALL 1 //Admin camera mode
#define CAPTURE_MODE_PARTIAL 3 //Simular to regular mode, but does not do dummy check

//objectives
#define CONFIG_OBJECTIVE_NONE 2
#define CONFIG_OBJECTIVE_VERB 1
#define CONFIG_OBJECTIVE_ALL  0

// How many times an AI tries to connect to APC before switching to low power mode.
#define AI_POWER_RESTORE_MAX_ATTEMPTS 3

// AI power restoration routine steps.
#define AI_RESTOREPOWER_FAILED -1
#define AI_RESTOREPOWER_IDLE 0
#define AI_RESTOREPOWER_STARTING 1
#define AI_RESTOREPOWER_DIAGNOSTICS 2
#define AI_RESTOREPOWER_CONNECTING 3
#define AI_RESTOREPOWER_CONNECTED 4
#define AI_RESTOREPOWER_COMPLETED 5


// Values represented as Oxyloss. Can be tweaked, but make sure to use integers only.
#define AI_POWERUSAGE_LOWPOWER 1
#define AI_POWERUSAGE_RESTORATION 2
#define AI_POWERUSAGE_NORMAL 5
#define AI_POWERUSAGE_RECHARGING 7

// Above values get multiplied by this when converting AI oxyloss -> watts.
// For now, one oxyloss point equals 10kJ of energy, so normal AI uses 5 oxyloss per tick (50kW or 70kW if charging)
#define AI_POWERUSAGE_OXYLOSS_TO_WATTS_MULTIPLIER 10000

//Grid for Item Placement
#define CELLS 16                         //Amount of cells per row/column in grid
#define CELLSIZE (world.icon_size/CELLS) //Size of a cell in pixels

#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32

#define DEFAULT_SPAWNPOINT_ID "Default"

//Virus badness defines
#define VIRUS_MILD			1
#define VIRUS_COMMON		2	//Random events don't go higher (mutations aside)
#define VIRUS_ENGINEERED	3
#define VIRUS_EXOTIC		4	//Usually adminbus only

//Error handler defines
#define ERROR_USEFUL_LEN 2

#define RAD_LEVEL_LOW 1 // Around the level at which radiation starts to become harmful
#define RAD_LEVEL_MODERATE 25
#define RAD_LEVEL_HIGH 40
#define RAD_LEVEL_VERY_HIGH 100

#define RADIATION_THRESHOLD_CUTOFF 0.1	// Radiation will not affect a tile when below this value.

#define LEGACY_RECORD_STRUCTURE(X, Y) GLOBAL_LIST_EMPTY(##X);/datum/computer_file/data/##Y/var/list/fields[0];/datum/computer_file/data/##Y/New(){..();GLOB.##X.Add(src);}/datum/computer_file/data/##Y/Destroy(){. = ..();GLOB.##X.Remove(src);}

#define SUPPLY_SECURITY_ELEVATED 1
#define SUPPLY_SECURITY_HIGH 2

// secure gun authorization settings
#define UNAUTHORIZED      0
#define AUTHORIZED        1
#define ALWAYS_AUTHORIZED 2

// wrinkle states for clothes
#define WRINKLES_DEFAULT	0
#define WRINKLES_WRINKLY	1
#define WRINKLES_NONE		2

//detergent states for clothes
#define SMELL_DEFAULT	0
#define SMELL_CLEAN		1
#define SMELL_STINKY	2

//Shuttle mission stages
#define SHUTTLE_MISSION_PLANNED  1
#define SHUTTLE_MISSION_STARTED  2
#define SHUTTLE_MISSION_FINISHED 3
#define SHUTTLE_MISSION_QUEUED   4

//Built-in email accounts
#define EMAIL_DOCUMENTS "document.server@internal-services.net"
#define EMAIL_SYSADMIN  "admin@internal-services.net"
#define EMAIL_BROADCAST "broadcast@internal-services.net"

//Stats for department goals etc
#define STAT_XENOPLANTS_SCANNED  "xenoplants_scanned"
#define STAT_XENOFAUNA_SCANNED  "xenofauna_scanned"
#define STAT_FLAGS_PLANTED  "planet_flags"

//Number of slots a modular computer has which can be tweaked via gear tweaks.
#define TWEAKABLE_COMPUTER_PART_SLOTS 7

//Lying animation
#define ANIM_LYING_TIME 2

//Planet habitability class
#define HABITABILITY_IDEAL  1
#define HABITABILITY_OKAY  2
#define HABITABILITY_BAD  3

#ifndef WINDOWS_HTTP_POST_DLL_LOCATION
#define WINDOWS_HTTP_POST_DLL_LOCATION "lib/byhttp.dll"
#endif

#ifndef UNIX_HTTP_POST_DLL_LOCATION
#define UNIX_HTTP_POST_DLL_LOCATION "lib/libbyhttp.so"
#endif

#ifndef HTTP_POST_DLL_LOCATION
#define HTTP_POST_DLL_LOCATION (world.system_type == MS_WINDOWS ? WINDOWS_HTTP_POST_DLL_LOCATION : UNIX_HTTP_POST_DLL_LOCATION)
#endif

//Misc text define. Does 4 spaces. Used as a makeshift tabulator.
#define FOURSPACES "&nbsp;&nbsp;&nbsp;&nbsp;"

#define INCREMENT_WORLD_Z_SIZE world.maxz++; if (length(SSzcopy.zlev_maximums)) { SSzcopy.calculate_zstack_limits() }

//-- Masks for /atom/var/init_flags --
//- machinery
#define INIT_MACHINERY_START_PROCESSING FLAG(0)
//--


// Options for /obj/item/device/soulstone/var/owner_flag
#define SOULSTONE_OWNER_CULT   "cult"   /// The soulstone is owned by the cult faction.
#define SOULSTONE_OWNER_WIZARD "wizard" /// The soulstone is owned by a wizard.
#define SOULSTONE_OWNER_PURE   "pure"   /// The soulstone has been purified.


// Severities for emp_act()
#define EMP_ACT_HEAVY 1
#define EMP_ACT_LIGHT 2


// Severities for ex_act()
#define EX_ACT_DEVASTATING 1 // Within devastation range - Destructive/deadly, unlikely to survive.
#define EX_ACT_HEAVY 2 // Within heavy range - Heavy damage, very dangerous
#define EX_ACT_LIGHT 3 // Within light range - Minor damage.

#define EX_ACT_TO_STRING(X) (X == EX_ACT_DEVASTATING ? "Devastating" : X == EX_ACT_HEAVY ? "Heavy" : "Light")


// Atom layering/visibility levels on turfs. See `/atom/var/level`.
#define ATOM_LEVEL_UNDER_TILE 1 // Hidden under floor tiles, visible on plating
#define ATOM_LEVEL_OVER_TILE 2 // Visible on all turf tiles


// Atom flourescence
#define ATOM_FLOURESCENCE_NONE 0 // Not flourescent
#define ATOM_FLOURESCENCE_INACTIVE 1 // Flourescent but not actively lit
#define ATOM_FLOURESCENCE_ACTVE 2 // Flourescent and actively lit. Helps prevent repeated processing on a flourescent atom by multiple UV lights


// Helper macro for generating stringified name text for IDs located inside objects, i.e. PDAs or wallets. Used for feedback and interaction messages.
#define GET_ID_NAME(ID, HOLDER) (ID == HOLDER ? "\the [ID]" : "\the [ID] in \the [HOLDER]")


// Flags for `use_sanity_check()`
/// Do not display user feedback messages.
#define SANITY_CHECK_SILENT FLAG(0)
/// Verify the tool can be unequipped from user. Ignored if the tool is not an item.
#define SANITY_CHECK_TOOL_UNEQUIP FLAG(1)
/// Verify the target can be unequipped from user. Includes `target.loc == src` check to allow items the user isn't holding.
#define SANITY_CHECK_TARGET_UNEQUIP FLAG(2)
/// Verify the target and tool are adjacent to eachother. Ignored if there is no tool or if tool is held by user.
#define SANITY_CHECK_BOTH_ADJACENT FLAG(3)
/// Verify the tool is in the user's active hand. Ignored if the tool is not an item.
#define SANITY_CHECK_TOOL_IN_HAND FLAG(4)
/// Check `CanInteractWith(target, user)`. Only use this for Topic() revalidation. Functionally exclusive with `SANITY_CHECK_TOPIC_PHYSICALLY_INTERACT`.
#define SANITY_CHECK_TOPIC_INTERACT FLAG(5)
/// Check `CanPhysicallyInteractWith(target, user)`. Only use this for Topic() revalidation. Functionally exclusive with `SANITY_CHECK_TOPIC_INTERACT`.
#define SANITY_CHECK_TOPIC_PHYSICALLY_INTERACT FLAG(6)

#define SANITY_CHECK_DEFAULT (SANITY_CHECK_TOOL_IN_HAND | SANITY_CHECK_BOTH_ADJACENT)
