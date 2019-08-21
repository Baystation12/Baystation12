GLOBAL_DATUM_INIT(default_hardpoint_background, /image, null)
GLOBAL_DATUM_INIT(hardpoint_error_icon, /image, null)
GLOBAL_DATUM_INIT(hardpoint_bar_empty, /image, null)

GLOBAL_LIST_INIT(hardpoint_bar_cache, new)
GLOBAL_LIST_INIT(mech_damage_overlay_cache, new)
GLOBAL_LIST_INIT(mech_image_cache, new)
GLOBAL_LIST_INIT(mech_icon_cache, new)
GLOBAL_LIST_INIT(mech_weapon_overlays, icon_states('icons/mecha/mech_weapon_overlays.dmi'))

#define HARDPOINT_BACK "back"
#define HARDPOINT_LEFT_HAND "left hand"
#define HARDPOINT_RIGHT_HAND "right hand"
#define HARDPOINT_LEFT_SHOULDER "left shoulder"
#define HARDPOINT_RIGHT_SHOULDER "right shoulder"
#define HARDPOINT_HEAD "head"

// No software required: taser. light, radio.
#define MECH_SOFTWARE_UTILITY "utility equipment"                // Plasma torch, clamp, drill.
#define MECH_SOFTWARE_MEDICAL "medical support systems"          // Sleeper.
#define MECH_SOFTWARE_WEAPONS "standard weapon systems"          // Ballistics and energy weapons.
#define MECH_SOFTWARE_ADVWEAPONS "advanced weapon systems"       // Railguns, missile launcher.
#define MECH_SOFTWARE_ENGINEERING "advanced engineering systems" // RCD.

// EMP damage points before various effects occur.
#define EMP_GUI_DISRUPT 5     // 1 ion rifle shot == 8.
#define EMP_MOVE_DISRUPT 10   // 2 shots.
#define EMP_ATTACK_DISRUPT 20 // 3 shots.

//About components
#define MECH_COMPONENT_DAMAGE_UNDAMAGED 1
#define MECH_COMPONENT_DAMAGE_DAMAGED 2
#define MECH_COMPONENT_DAMAGE_DAMAGED_BAD 3
#define MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL 4

//Construction
#define FRAME_REINFORCED 1
#define FRAME_REINFORCED_SECURE 2
#define FRAME_REINFORCED_WELDED 3

#define FRAME_WIRED 1
#define FRAME_WIRED_ADJUSTED 2
