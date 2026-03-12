GLOBAL_LIST_INIT_STEP(index_to_flag, 0)
	index_to_flag = new (MAX_FLAG_INDEX)
	for (var/i = 1 to MAX_FLAG_INDEX)
		index_to_flag[i] = RFLAG(i)

#if DM_VERSION >= 516
GLOBAL_ALIST_INIT_STEP(flag_to_index, 0)
	flag_to_index = alist()
	for (var/i = 1 to MAX_FLAG_INDEX)
		flag_to_index[RFLAG(i)] = i
#endif

#define CLOSET_HAS_LOCK         FLAG_01
#define CLOSET_CAN_BE_WELDED    FLAG_02

#define CLOSET_STORAGE_MISC          FLAG_01
#define CLOSET_STORAGE_ITEMS         FLAG_02
#define CLOSET_STORAGE_MOBS          FLAG_03
#define CLOSET_STORAGE_STRUCTURES    FLAG_04
#define CLOSET_STORAGE_ALL           (CLOSET_STORAGE_MISC | CLOSET_STORAGE_ITEMS | CLOSET_STORAGE_MOBS | CLOSET_STORAGE_STRUCTURES)

// Flags bitmasks.

// NOTE: We declare ATOM_FLAG_INITIALIZED earlier, in __initialization.dm, as FLAG_01
#define ATOM_FLAG_CHECKS_BORDER          FLAG_02  // If a dense atom (potentially) only blocks movements from a given direction, i.e. window panes
#define ATOM_FLAG_NO_BLOOD               FLAG_03  // Used for items if they don't want to get a blood overlay.
#define ATOM_FLAG_NO_REACT               FLAG_04  // Reagents don't react inside this container.
#define ATOM_FLAG_OPEN_CONTAINER         FLAG_05  // Is an open container for chemistry purposes.
#define ATOM_FLAG_CLIMBABLE              FLAG_06  // This object can be climbed on
#define ATOM_FLAG_NO_TEMP_CHANGE         FLAG_07  // Reagents do not cool or heat to ambient temperature in this container.
#define ATOM_FLAG_CAN_BE_PAINTED         FLAG_08  // Can be painted using a paint sprayer or similar.
#define ATOM_FLAG_ADJACENT_EXCEPTION     FLAG_09  // Skips adjacent checks for atoms that should always be reachable in window tiles
#define ATOM_FLAG_NO_TOOLS               FLAG_10  // Blocks tool interactions.
#define ATOM_AWAITING_OVERLAY_UPDATE     FLAG_11

/// This atom requires proximity checking in `Enter()`.
#define MOVABLE_FLAG_PROXMOVE         FLAG_01
/// `use_tool()` and `attack_hand()` should be relayed through ladders and open spaces.
#define MOVABLE_FLAG_Z_INTERACT       FLAG_02
/// This atom is effect that should move.
#define MOVABLE_FLAG_EFFECTMOVE       FLAG_03
/// This atom should call `post_movement()` after moving across turfs.
#define MOVABLE_FLAG_POSTMOVEMENT     FLAG_04

#define OBJ_FLAG_ANCHORABLE     FLAG_01  // This object can be stuck in place with a tool
#define OBJ_FLAG_CONDUCTIBLE    FLAG_02  // Conducts electricity. (metal etc.)
#define OBJ_FLAG_ROTATABLE      FLAG_03  // Can be rotated with alt-click
#define OBJ_FLAG_NOFALL		    FLAG_04  // Will prevent mobs from falling
/// Can be click+dragged onto a table, rack, etc
#define OBJ_FLAG_CAN_TABLE      FLAG_05
/// Can receive objects with the `OBJ_FLAG_CAN_TABLE` flag
#define OBJ_FLAG_RECEIVE_TABLE  FLAG_06

/// Whether this object is offset onto a wall
#define OBJ_FLAG_WALL_MOUNTED FLAG_07

//Flags for items (equipment)
#define ITEM_FLAG_NO_BLUDGEON               FLAG_01  // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define ITEM_FLAG_PHORONGUARD               FLAG_02  // Does not get contaminated by phoron.
#define ITEM_FLAG_NO_PRINT                  FLAG_03  // This object does not leave the user's prints/fibres when using it
#define ITEM_FLAG_INVALID_FOR_CHAMELEON     FLAG_04  // Chameleon items cannot mimick this.
#define ITEM_FLAG_THICKMATERIAL             FLAG_05  // Prevents syringes, reagent pens, and hyposprays if equiped to slot_suit or slot_head.
#define ITEM_FLAG_AIRTIGHT                  FLAG_07  // Functions with internals.
#define ITEM_FLAG_NOSLIP                    FLAG_08  // Prevents from slipping on wet floors, in space, etc.
#define ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT    FLAG_09  // Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define ITEM_FLAG_FLEXIBLEMATERIAL          FLAG_10  // At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ITEM_FLAG_PREMODIFIED               FLAG_11 // Gloves that are clipped by default
#define ITEM_FLAG_IS_BELT                   FLAG_12 // Items that can be worn on the belt slot, even with no undersuit equipped
#define ITEM_FLAG_SILENT                    FLAG_13 // sneaky shoes
#define ITEM_FLAG_NOCUFFS                   FLAG_14 // Gloves that have this flag prevent cuffs being applied
#define ITEM_FLAG_CAN_HIDE_IN_SHOES         FLAG_15 // Items that can be hidden in shoes that permit it
#define ITEM_FLAG_WASHER_ALLOWED            FLAG_16 // Items that can be washed in washing machines
#define ITEM_FLAG_IS_CHAMELEON_ITEM         FLAG_17 // Setups the chameleon extension on init. Throws an exception if there is no compatible extension subtype.

// Flags for pass_flags.
#define PASS_FLAG_TABLE     FLAG_01
#define PASS_FLAG_GLASS     FLAG_02
#define PASS_FLAG_GRILLE    FLAG_03

// Flags for gas tanks
#define TANK_FLAG_WELDED     FLAG_01
#define TANK_FLAG_FORCED     FLAG_02
#define TANK_FLAG_LEAKING    FLAG_03
#define TANK_FLAG_WIRED      FLAG_04

// Flags for beds/chairs
/// The bed/chair cannot be dismantled with a wrench.
#define BED_FLAG_CANNOT_BE_DISMANTLED FLAG_02
/// The bed/chair cannot be padded with material.
#define BED_FLAG_CANNOT_BE_PADDED FLAG_03
/// The bed/chair cannot be made into an electric chair with a shock kit. Only applies to `/obj/structure/bed/chair` subtypes.
#define BED_FLAG_CANNOT_BE_ELECTRIFIED FLAG_04

/// Whether or not this sector is a starting sector. Z levels contained in this sector are added to station_levels
#define OVERMAP_SECTOR_BASE         FLAG_01
/// Makes the sector show up on nav computers
#define OVERMAP_SECTOR_KNOWN        FLAG_02
/// If the sector can be accessed by drifting off the map edge
#define OVERMAP_SECTOR_IN_SPACE     FLAG_03
/// If the sector is untargetable by missiles.
#define OVERMAP_SECTOR_UNTARGETABLE FLAG_04


/// For mob/living/ignore_hazard_flags. When set, shards do not damage the mob.
var/global/const/HAZARD_FLAG_SHARD = FLAG_01
