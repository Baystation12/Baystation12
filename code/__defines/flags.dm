GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

#define CLOSET_HAS_LOCK         FLAG(0)
#define CLOSET_CAN_BE_WELDED    FLAG(1)

#define CLOSET_STORAGE_MISC          FLAG(0)
#define CLOSET_STORAGE_ITEMS         FLAG(1)
#define CLOSET_STORAGE_MOBS          FLAG(2)
#define CLOSET_STORAGE_STRUCTURES    FLAG(3)
#define CLOSET_STORAGE_ALL           (CLOSET_STORAGE_MISC | CLOSET_STORAGE_ITEMS | CLOSET_STORAGE_MOBS | CLOSET_STORAGE_STRUCTURES)

// Flags bitmasks.

#define ATOM_FLAG_CHECKS_BORDER          FLAG(0)  // If a dense atom (potentially) only blocks movements from a given direction, i.e. window panes
#define ATOM_FLAG_CLIMBABLE              FLAG(1)  // This object can be climbed on
#define ATOM_FLAG_NO_BLOOD               FLAG(2)  // Used for items if they don't want to get a blood overlay.
#define ATOM_FLAG_NO_REACT               FLAG(3)  // Reagents don't react inside this container.
#define ATOM_FLAG_OPEN_CONTAINER         FLAG(4)  // Is an open container for chemistry purposes.
#define ATOM_FLAG_INITIALIZED            FLAG(5)  // Has this atom been initialized
#define ATOM_FLAG_NO_TEMP_CHANGE         FLAG(6)  // Reagents do not cool or heat to ambient temperature in this container.
#define ATOM_FLAG_CAN_BE_PAINTED         FLAG(7)  // Can be painted using a paint sprayer or similar.
#define ATOM_FLAG_ADJACENT_EXCEPTION     FLAG(8)  // Skips adjacent checks for atoms that should always be reachable in window tiles

#define MOVABLE_FLAG_PROXMOVE       FLAG(0)  // Does this object require proximity checking in Enter()?
#define MOVABLE_FLAG_Z_INTERACT     FLAG(1)  // Should attackby and attack_hand be relayed through ladders and open spaces?
#define MOVABLE_FLAG_EFFECTMOVE     FLAG(2)  // Is this an effect that should move?
#define MOVABLE_FLAG_DEL_SHUTTLE    FLAG(3)  // Shuttle transistion will delete this.

#define OBJ_FLAG_ANCHORABLE     FLAG(0)  // This object can be stuck in place with a tool
#define OBJ_FLAG_CONDUCTIBLE    FLAG(1)  // Conducts electricity. (metal etc.)
#define OBJ_FLAG_ROTATABLE      FLAG(2)  // Can be rotated with alt-click
#define OBJ_FLAG_NOFALL		    FLAG(3)  // Will prevent mobs from falling

//Flags for items (equipment)
#define ITEM_FLAG_NO_BLUDGEON               FLAG(0)  // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define ITEM_FLAG_PHORONGUARD               FLAG(1)  // Does not get contaminated by phoron.
#define ITEM_FLAG_NO_PRINT                  FLAG(2)  // This object does not leave the user's prints/fibres when using it
#define ITEM_FLAG_INVALID_FOR_CHAMELEON     FLAG(3)  // Chameleon items cannot mimick this.
#define ITEM_FLAG_THICKMATERIAL             FLAG(4)  // Prevents syringes, reagent pens, and hyposprays if equiped to slot_suit or slot_head.
#define ITEM_FLAG_AIRTIGHT                  FLAG(6)  // Functions with internals.
#define ITEM_FLAG_NOSLIP                    FLAG(7)  // Prevents from slipping on wet floors, in space, etc.
#define ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT    FLAG(8)  // Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define ITEM_FLAG_FLEXIBLEMATERIAL          FLAG(9)  // At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ITEM_FLAG_PREMODIFIED               FLAG(10) // Gloves that are clipped by default
#define ITEM_FLAG_IS_BELT                   FLAG(11) // Items that can be worn on the belt slot, even with no undersuit equipped
#define ITEM_FLAG_SILENT                    FLAG(12) // sneaky shoes
#define ITEM_FLAG_NOCUFFS                   FLAG(13) // Gloves that have this flag prevent cuffs being applied
#define ITEM_FLAG_CAN_HIDE_IN_SHOES         FLAG(14) // Items that can be hidden in shoes that permit it
#define ITEM_FLAG_WASHER_ALLOWED            FLAG(15) // Items that can be washed in washing machines

// Flags for pass_flags.
#define PASS_FLAG_TABLE     FLAG(0)
#define PASS_FLAG_GLASS     FLAG(1)
#define PASS_FLAG_GRILLE    FLAG(2)

// Flags for gas tanks
#define TANK_FLAG_WELDED     FLAG(0)
#define TANK_FLAG_FORCED     FLAG(1)
#define TANK_FLAG_LEAKING    FLAG(2)
#define TANK_FLAG_WIRED      FLAG(3)
