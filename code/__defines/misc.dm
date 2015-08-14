#define DEBUG
// Turf-only flags.
#define NOJAUNT 1 // This is used in literally one place, turf.dm, to block ethereal jaunt.

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.

// Invisibility constants.
#define INVISIBILITY_LIGHTING             20
#define INVISIBILITY_LEVEL_ONE            35
#define INVISIBILITY_LEVEL_TWO            45
#define INVISIBILITY_OBSERVER             60
#define INVISIBILITY_EYE		          61

#define SEE_INVISIBLE_LIVING              25
#define SEE_INVISIBLE_NOLIGHTING 15
#define SEE_INVISIBLE_LEVEL_ONE           35
#define SEE_INVISIBLE_LEVEL_TWO           45
#define SEE_INVISIBLE_CULT		          60
#define SEE_INVISIBLE_OBSERVER            61

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100

// Some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26 // Used to trigger removal from a processing list.

// Age limits on a character.
#define AGE_MIN 17
#define AGE_MAX 85

#define MAX_GEAR_COST 5 // Used in chargen for accessory loadout limit.

// Preference toggles.
#define SOUND_ADMINHELP 1
#define SOUND_MIDI      2
#define SOUND_AMBIENCE  4
#define SOUND_LOBBY     8
#define CHAT_OOC        16
#define CHAT_DEAD       32
#define CHAT_GHOSTEARS  64
#define CHAT_GHOSTSIGHT 128
#define CHAT_PRAYER     256
#define CHAT_RADIO      512
#define CHAT_ATTACKLOGS 1024
#define CHAT_DEBUGLOGS  2048
#define CHAT_LOOC       4096
#define CHAT_GHOSTRADIO 8192
#define SHOW_TYPING     16384
#define CHAT_NOICONS    32768

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_ATTACKLOGS|CHAT_LOOC)

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

//some colors
#define COLOR_RED    "#FF0000"
#define COLOR_GREEN  "#00FF00"
#define COLOR_BLUE   "#0000FF"
#define COLOR_CYAN   "#00FFFF"
#define COLOR_PINK   "#FF00FF"
#define COLOR_YELLOW "#FFFF00"
#define COLOR_ORANGE "#FF9900"
#define COLOR_WHITE  "#FFFFFF"
#define COLOR_BLACK  "#000000"

//	Shuttles.

// These define the time taken for the shuttle to get to the space station, and the time before it leaves again.
#define SHUTTLE_PREPTIME                300 // 5 minutes = 300 seconds - after this time, the shuttle departs centcom and cannot be recalled.
#define SHUTTLE_LEAVETIME               180 // 3 minutes = 180 seconds - the duration for which the shuttle will wait at the station after arriving.
#define SHUTTLE_TRANSIT_DURATION        300 // 5 minutes = 300 seconds - how long it takes for the shuttle to get to the station.
#define SHUTTLE_TRANSIT_DURATION_RETURN 120 // 2 minutes = 120 seconds - for some reason it takes less time to come back, go figure.

// Shuttle moving status.
#define SHUTTLE_IDLE      0
#define SHUTTLE_WARMUP    1
#define SHUTTLE_INTRANSIT 2

// Ferry shuttle processing status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

// Setting this much higher than 1024 could allow spammers to DOS the server easily.
#define MAX_MESSAGE_LEN       1024
#define MAX_PAPER_MESSAGE_LEN 3072
#define MAX_BOOK_MESSAGE_LEN  9216
#define MAX_LNAME_LEN         64
#define MAX_NAME_LEN          26

// Event defines.
#define EVENT_LEVEL_MUNDANE  1
#define EVENT_LEVEL_MODERATE 2
#define EVENT_LEVEL_MAJOR    3

//General-purpose life speed define for plants.
#define HYDRO_SPEED_MULTIPLIER 1

#define DEFAULT_JOB_TYPE /datum/job/assistant

//Area flags, possibly more to come
#define RAD_SHIELDED 1 //shielded from radiation, clearly

// Custom layer definitions, supplementing the default TURF_LAYER, MOB_LAYER, etc.
#define DOOR_OPEN_LAYER 2.7		//Under all objects if opened. 2.7 due to tables being at 2.6
#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed
#define LIGHTING_LAYER 11
#define HUD_LAYER 20			//Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define OBFUSCATION_LAYER 21	//Where images covering the view for eyes are put
#define SCREEN_LAYER 22			//Mob HUD/effects layer

// Convoluted setup so defines can be supplied by Bay12 main server compile script.
// Should still work fine for people jamming the icons into their repo.
#ifndef CUSTOM_ITEM_OBJ
#define CUSTOM_ITEM_OBJ 'icons/obj/custom_items_obj.dmi'
#endif
#ifndef CUSTOM_ITEM_MOB
#define CUSTOM_ITEM_MOB 'icons/mob/custom_items_mob.dmi'
#endif
#ifndef CUSTOM_ITEM_SYNTH
#define CUSTOM_ITEM_SYNTH 'icons/mob/custom_synthetic.dmi'
#endif

#define WALL_CAN_OPEN 1
#define WALL_OPENING 2

#define DEFAULT_TABLE_MATERIAL "plastic"
#define DEFAULT_WALL_MATERIAL "steel"

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define MATERIAL_UNMELTABLE 1
#define MATERIAL_BRITTLE 2
#define MATERIAL_PADDING 4

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

#define BOMBCAP_DVSTN_RADIUS (max_explosion_range/4)
#define BOMBCAP_HEAVY_RADIUS (max_explosion_range/2)
#define BOMBCAP_LIGHT_RADIUS max_explosion_range
#define BOMBCAP_FLASH_RADIUS (max_explosion_range*1.5)

// Special return values from bullet_act(). Positive return values are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flying after calling bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a miss (suppresses attack and admin logs) - only applies to mobs.
