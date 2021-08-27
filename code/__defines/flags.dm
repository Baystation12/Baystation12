GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// Flag Utils
#define GET_FLAGS(field, mask)      ((field) & (mask))
#define HAS_FLAGS(field, mask)      (((field) & (mask)) == (mask))
#define SET_FLAGS(field, mask)      ((field) |= (mask))
#define CLEAR_FLAGS(field, mask)    ((field) &= ~(mask))
#define FLIP_FLAGS(field, mask)     ((field) ^= (mask))

#define CLOSET_HAS_LOCK  1
#define CLOSET_CAN_BE_WELDED 2

#define CLOSET_STORAGE_MISC       1
#define CLOSET_STORAGE_ITEMS      2
#define CLOSET_STORAGE_MOBS       4
#define CLOSET_STORAGE_STRUCTURES 8
#define CLOSET_STORAGE_ALL   (~0)

// Flags bitmasks.

#define ATOM_FLAG_CHECKS_BORDER          0x0001 // If a dense atom (potentially) only blocks movements from a given direction, i.e. window panes
#define ATOM_FLAG_CLIMBABLE              0x0002 // This object can be climbed on
#define ATOM_FLAG_NO_BLOOD               0x0004 // Used for items if they don't want to get a blood overlay.
#define ATOM_FLAG_NO_REACT               0x0008 // Reagents don't react inside this container.
#define ATOM_FLAG_OPEN_CONTAINER         0x0010 // Is an open container for chemistry purposes.
#define ATOM_FLAG_INITIALIZED            0x0020 // Has this atom been initialized
#define ATOM_FLAG_NO_TEMP_CHANGE         0x0040 // Reagents do not cool or heat to ambient temperature in this container.
#define ATOM_FLAG_CAN_BE_PAINTED         0x0080 // Can be painted using a paint sprayer or similar.
#define ATOM_FLAG_ADJACENT_EXCEPTION     0x0100 // Skips adjacent checks for atoms that should always be reachable in window tiles

#define MOVABLE_FLAG_PROXMOVE            0x0001 // Does this object require proximity checking in Enter()?
#define MOVABLE_FLAG_Z_INTERACT          0x0002 // Should attackby and attack_hand be relayed through ladders and open spaces?
#define MOVABLE_FLAG_EFFECTMOVE          0x0004 // Is this an effect that should move?
#define MOVABLE_FLAG_DEL_SHUTTLE         0x0008 // Shuttle transistion will delete this.

#define OBJ_FLAG_ANCHORABLE              0x0001 // This object can be stuck in place with a tool
#define OBJ_FLAG_CONDUCTIBLE             0x0002 // Conducts electricity. (metal etc.)
#define OBJ_FLAG_ROTATABLE               0x0004 // Can be rotated with alt-click
#define OBJ_FLAG_NOFALL		             0x0008 // Will prevent mobs from falling

//Flags for items (equipment)
#define ITEM_FLAG_NO_BLUDGEON            0x0001 // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define ITEM_FLAG_PHORONGUARD            0x0002 // Does not get contaminated by phoron.
#define ITEM_FLAG_NO_PRINT               0x0004 // This object does not leave the user's prints/fibres when using it
#define ITEM_FLAG_INVALID_FOR_CHAMELEON  0x0008 // Chameleon items cannot mimick this.
#define ITEM_FLAG_THICKMATERIAL          0x0010 // Prevents syringes, reagent pens, and hyposprays if equiped to slot_suit or slot_head.
#define ITEM_FLAG_AIRTIGHT               0x0040 // Functions with internals.
#define ITEM_FLAG_NOSLIP                 0x0080 // Prevents from slipping on wet floors, in space, etc.
#define ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT 0x0100 // Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define ITEM_FLAG_FLEXIBLEMATERIAL       0x0200 // At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ITEM_FLAG_PREMODIFIED            0x0400 // Gloves that are clipped by default
#define ITEM_FLAG_IS_BELT                0x0800 // Items that can be worn on the belt slot, even with no undersuit equipped
#define ITEM_FLAG_SILENT                 0x1000 // sneaky shoes
#define ITEM_FLAG_NOCUFFS                0x2000 // Gloves that have this flag prevent cuffs being applied
#define ITEM_FLAG_CAN_HIDE_IN_SHOES      0x4000 // Items that can be hidden in shoes that permit it
#define ITEM_FLAG_WASHER_ALLOWED         0x8000 // Items that can be washed in washing machines

// Flags for pass_flags.
#define PASS_FLAG_TABLE  0x1
#define PASS_FLAG_GLASS  0x2
#define PASS_FLAG_GRILLE 0x4

// Flags for gas tanks
#define TANK_FLAG_WELDED      0x000001
#define TANK_FLAG_FORCED      0x000002
#define TANK_FLAG_LEAKING     0x000004
#define TANK_FLAG_WIRED       0x000008
