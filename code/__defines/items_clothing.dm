#define HUMAN_STRIP_DELAY        40   // Takes 40ds = 4s to strip someone.

#define SHOES_SLOWDOWN          -1.0  // How much shoes slow you down by default. Negative values speed you up.

#define CANDLE_LUM 3 // For how bright candles are.

// Item inventory slot bitmasks.
#define SLOT_OCLOTHING  0x1
#define SLOT_ICLOTHING  0x2
#define SLOT_GLOVES     0x4
#define SLOT_EYES       0x8
#define SLOT_EARS       0x10
#define SLOT_MASK       0x20
#define SLOT_HEAD       0x40
#define SLOT_FEET       0x80
#define SLOT_ID         0x100
#define SLOT_BELT       0x200
#define SLOT_BACK       0x400
#define SLOT_POCKET     0x800  // This is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET 0x1000  // This is to  deny items with a w_class of 2 or 1 from fitting in pockets.
#define SLOT_TWOEARS    0x2000
#define SLOT_TIE        0x4000
#define SLOT_HOLSTER	0x8000 //16th bit - higher than this will overflow

#define ACCESSORY_SLOT_UTILITY  "Utility"
#define ACCESSORY_SLOT_HOLSTER  "Holster"
#define ACCESSORY_SLOT_ARMBAND  "Armband"
#define ACCESSORY_SLOT_RANK     "Rank"
#define ACCESSORY_SLOT_DEPT		"Department"
#define ACCESSORY_SLOT_DECOR    "Decor"
#define ACCESSORY_SLOT_MEDAL    "Medal"
#define ACCESSORY_SLOT_INSIGNIA "Insignia"
#define ACCESSORY_SLOT_ARMOR_C  "Chest armor"
#define ACCESSORY_SLOT_ARMOR_A  "Arm armor"
#define ACCESSORY_SLOT_ARMOR_L  "Leg armor"
#define ACCESSORY_SLOT_ARMOR_S  "Armor storage"
#define ACCESSORY_SLOT_ARMOR_M  "Misc armor"

// Flags bitmasks.
#define NOBLUDGEON         0x1   // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define CONDUCT            0x2   // Conducts electricity. (metal etc.)
#define ON_BORDER          0x4   // Item has priority to check when entering or leaving.
#define NOBLOODY           0x8   // Used for items if they don't want to get a blood overlay.
#define OPENCONTAINER      0x10  // Is an open container for chemistry purposes.
#define PHORONGUARD        0x20  // Does not get contaminated by phoron.
#define	NOREACT            0x40  // Reagents don't react inside this container.
#define PROXMOVE           0x80  // Does this object require proximity checking in Enter()?

//Flags for items (equipment)
#define THICKMATERIAL          0x1  // Prevents syringes, parapens and hyposprays if equiped to slot_suit or slot_head.
#define STOPPRESSUREDAMAGE     0x2  // Counts towards pressure protection. Note that like temperature protection, body_parts_covered is considered here as well.
#define AIRTIGHT               0x4  // Functions with internals.
#define NOSLIP                 0x8  // Prevents from slipping on wet floors, in space, etc.
#define BLOCK_GAS_SMOKE_EFFECT 0x10 // Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL       0x20 // At the moment, masks with this flag will not prevent eating even if they are covering your face.

// Flags for pass_flags.
#define PASSTABLE  0x1
#define PASSGLASS  0x2
#define PASSGRILLE 0x4

// Bitmasks for the flags_inv variable. These determine when a piece of clothing hides another, i.e. a helmet hiding glasses.
// WARNING: The following flags apply only to the external suit!
#define HIDEGLOVES      0x1
#define HIDESUITSTORAGE 0x2
#define HIDEJUMPSUIT    0x4
#define HIDESHOES       0x8
#define HIDETAIL        0x10

// WARNING: The following flags apply only to the helmets and masks!
#define HIDEMASK 0x1
#define HIDEEARS 0x2 // Headsets and such.
#define HIDEEYES 0x4 // Glasses.
#define HIDEFACE 0x8 // Dictates whether we appear as "Unknown".

#define BLOCKHEADHAIR   0x20    // Hides the user's hair overlay. Leaves facial hair.
#define BLOCKHAIR       0x40    // Hides the user's hair, facial and otherwise.

// Slots.
#define slot_first       1
#define slot_back        1
#define slot_wear_mask   2
#define slot_handcuffed  3
#define slot_l_hand      4
#define slot_r_hand      5
#define slot_belt        6
#define slot_wear_id     7
#define slot_l_ear       8
#define slot_glasses     9
#define slot_gloves      10
#define slot_head        11
#define slot_shoes       12
#define slot_wear_suit   13
#define slot_w_uniform   14
#define slot_l_store     15
#define slot_r_store     16
#define slot_s_store     17
#define slot_in_backpack 18
#define slot_legcuffed   19
#define slot_r_ear       20
#define slot_legs        21
#define slot_tie         22
#define slot_last        22

// Inventory slot strings.
// since numbers cannot be used as associative list keys.
//icon_back, icon_l_hand, etc would be much better names for these...
#define slot_back_str		"slot_back"
#define slot_l_hand_str		"slot_l_hand"
#define slot_r_hand_str		"slot_r_hand"
#define slot_w_uniform_str	"slot_w_uniform"
#define slot_head_str		"slot_head"
#define slot_wear_suit_str	"slot_suit"
#define slot_l_ear_str      "slot_l_ear"
#define slot_r_ear_str      "slot_r_ear"
#define slot_belt_str       "slot_belt"
#define slot_shoes_str      "slot_shoes"
#define slot_head_str      	"slot_head"
#define slot_wear_mask_str 	"slot_wear_mask"
#define slot_handcuffed_str "slot_handcuffed"
#define slot_legcuffed_str "slot_legcuffed"
#define slot_wear_mask_str 	"slot_wear_mask"
#define slot_wear_id_str  	"slot_wear_id"
#define slot_gloves_str  	"slot_gloves"
#define slot_glasses_str  	"slot_glasses"
#define slot_s_store_str	"slot_s_store"
#define slot_tie_str		"slot_tie"

// Bitflags for clothing parts.
#define HEAD        0x1
#define FACE        0x2
#define EYES        0x4
#define UPPER_TORSO 0x8
#define LOWER_TORSO 0x10
#define LEG_LEFT    0x20
#define LEG_RIGHT   0x40
#define LEGS        0x60   //  LEG_LEFT | LEG_RIGHT
#define FOOT_LEFT   0x80
#define FOOT_RIGHT  0x100
#define FEET        0x180  // FOOT_LEFT | FOOT_RIGHT
#define ARM_LEFT    0x200
#define ARM_RIGHT   0x400
#define ARMS        0x600 //  ARM_LEFT | ARM_RIGHT
#define HAND_LEFT   0x800
#define HAND_RIGHT  0x1000
#define HANDS       0x1800 // HAND_LEFT | HAND_RIGHT
#define FULL_BODY   0xFFFF

// Bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection().
// The values here should add up to 1, e.g., the head has 30% protection.
#define THERMAL_PROTECTION_HEAD        0.3
#define THERMAL_PROTECTION_UPPER_TORSO 0.15
#define THERMAL_PROTECTION_LOWER_TORSO 0.15
#define THERMAL_PROTECTION_LEG_LEFT    0.075
#define THERMAL_PROTECTION_LEG_RIGHT   0.075
#define THERMAL_PROTECTION_FOOT_LEFT   0.025
#define THERMAL_PROTECTION_FOOT_RIGHT  0.025
#define THERMAL_PROTECTION_ARM_LEFT    0.075
#define THERMAL_PROTECTION_ARM_RIGHT   0.075
#define THERMAL_PROTECTION_HAND_LEFT   0.025
#define THERMAL_PROTECTION_HAND_RIGHT  0.025

// Pressure limits.
#define  HAZARD_HIGH_PRESSURE 550 // This determines at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define WARNING_HIGH_PRESSURE 325 // This determines when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_LOW_PRESSURE  50  // This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define  HAZARD_LOW_PRESSURE  20  // This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)

#define TEMPERATURE_DAMAGE_COEFFICIENT  1.5 // This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR   12  // This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM   1   // Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_COLD_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_COOLING_MAX           -30  // The maximum number of degrees that your body can cool down in 1 tick, when in a cold area.
#define BODYTEMP_HEATING_MAX            30  // The maximum number of degrees that your body can heat up in 1 tick,   when in a hot  area.

#define BODYTEMP_HEAT_DAMAGE_LIMIT 360.15 // The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_COLD_DAMAGE_LIMIT 260.15 // The limit the human body can take before it starts taking damage from coldness.

#define SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define   SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define       HELMET_MIN_COLD_PROTECTION_TEMPERATURE 160 // For normal helmets.
#define        ARMOR_MIN_COLD_PROTECTION_TEMPERATURE 160 // For armor.
#define       GLOVES_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For some gloves.
#define         SHOE_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For shoes.

#define  SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE 5000  // These need better heat protect, but not as good heat protect as firesuits.
#define    FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // What max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // For fire-helmet quality items. (Red and white hardhats)
#define      HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For normal helmets.
#define       ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For armor.
#define      GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For some gloves.
#define        SHOE_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For shoes.

// Fire.
#define FIRE_MIN_STACKS          -20
#define FIRE_MAX_STACKS           25
#define FIRE_MAX_FIRESUIT_STACKS  20 // If the number of stacks goes above this firesuits won't protect you anymore. If not, you can walk around while on fire like a badass.

#define THROWFORCE_SPEED_DIVISOR    5  // The throwing speed value at which the throwforce multiplier is exactly 1.
#define THROWNOBJ_KNOCKBACK_SPEED   15 // The minumum speed of a w_class 2 thrown object that will cause living mobs it hits to be knocked back. Heavier objects can cause knockback at lower speeds.
#define THROWNOBJ_KNOCKBACK_DIVISOR 2  // Affects how much speed the mob is knocked back with.

// Suit sensor levels
#define SUIT_SENSOR_OFF      0
#define SUIT_SENSOR_BINARY   1
#define SUIT_SENSOR_VITAL    2
#define SUIT_SENSOR_TRACKING 3

#define SUIT_NO_SENSORS 0
#define SUIT_HAS_SENSORS 1
#define SUIT_LOCKED_SENSORS 2

// Hair Flags
#define VERY_SHORT 0x1
#define HAIR_TRIPPABLE 0x2

// Storage

/*
	A note on w_classes - this is an attempt to describe the w_classes currently in use
	with an attempt at providing examples of the kinds of things that fit each w_class

	1 - tiny items - things like screwdrivers and pens, sheets of paper
	2 - small items - things that can fit in a pocket
	3 - normal items
	4 - large items - the largest things you can fit in a backpack
	5 - bulky items - backpacks are this size, for reference
	6 - human sized objects
	7 - things that are large enough to contain humans, like closets, but smaller than entire turfs
	8 - things that take up an entire turf, like wall girders or door assemblies
*/

var/list/default_onmob_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
		slot_belt_str = 'icons/mob/belt.dmi',
		slot_back_str = 'icons/mob/back.dmi',
		slot_l_ear_str = 'icons/mob/ears.dmi',
		slot_r_ear_str = 'icons/mob/ears.dmi',
		slot_glasses_str = 'icons/mob/eyes.dmi',
		slot_wear_id_str = 'icons/mob/mob.dmi',
		slot_w_uniform_str = 'icons/mob/uniform.dmi',
		slot_wear_suit_str = 'icons/mob/suit.dmi',
		slot_head_str = 'icons/mob/head.dmi',
		slot_shoes_str = 'icons/mob/feet.dmi',
		slot_wear_mask_str = 'icons/mob/mask.dmi',
		slot_handcuffed_str = 'icons/mob/mob.dmi',
		slot_legcuffed_str = 'icons/mob/mob.dmi',
		slot_gloves_str = 'icons/mob/hands.dmi',
		slot_s_store_str = 'icons/mob/belt_mirror.dmi',
		slot_tie_str = 'icons/mob/ties.dmi'
		)
