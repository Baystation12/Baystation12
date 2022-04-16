// Injury types for wounds
#define INJURY_TYPE_CUT     "cut"
#define INJURY_TYPE_BRUISE  "bruise"
#define INJURY_TYPE_BURN    "burn"
#define INJURY_TYPE_PIERCE  "pierce"
#define INJURY_TYPE_LASER   "laser"
#define INJURY_TYPE_SHATTER "shatter"

// Effect types for mobs
#define EFFECT_STUN     "stun"
#define EFFECT_WEAKEN   "weaken"
#define EFFECT_PARALYZE "paralize"
#define EFFECT_STUTTER  "stutter"
#define EFFECT_EYE_BLUR "eye_blur"
#define EFFECT_DROWSY   "drowsy"
#define EFFECT_PAIN     "pain"

// Damage flags
#define DAMAGE_FLAG_SHARP     FLAG(0)
#define DAMAGE_FLAG_EDGE      FLAG(1)
#define DAMAGE_FLAG_LASER     FLAG(2)
#define DAMAGE_FLAG_BULLET    FLAG(3)
#define DAMAGE_FLAG_EXPLODE   FLAG(4)
#define DAMAGE_FLAG_DISPERSED FLAG(5) // Makes apply_damage calls without specified zone distribute damage rather than randomly choose organ (for humans)
#define DAMAGE_FLAG_BIO       FLAG(6) // Toxin damage that should be mitigated by biological (i.e. sterile) armor

#define FIRE_DAMAGE_MODIFIER 0.0215 // Higher values result in more external fire damage to the skin. (default 0.0215)
#define  AIR_DAMAGE_MODIFIER 2.025  // More means less damage from hot air scalding lungs, less = more damage. (default 2.025)

// Organ defines.
#define ORGAN_CUT_AWAY   FLAG(0)  // The organ is in the process of being surgically removed.
#define ORGAN_BLEEDING   FLAG(1)  // The organ is currently bleeding.
#define ORGAN_BROKEN     FLAG(2)  // The organ is broken.
#define ORGAN_DEAD       FLAG(3)  // The organ is necrotic.
#define ORGAN_MUTATED    FLAG(4)  // The organ is unusable due to genetic damage.
#define ORGAN_ARTERY_CUT FLAG(6)  // The organ has had its artery cut.
#define ORGAN_TENDON_CUT FLAG(7)  // The organ has had its tendon cut.
#define ORGAN_DISFIGURED FLAG(8)  // The organ is scarred/disfigured. Alters whether or not the face can be recognised.
#define ORGAN_SABOTAGED  FLAG(9)  // The organ will explode if exposed to EMP, if prosthetic.
#define ORGAN_ASSISTED   FLAG(10) // The organ is partially prosthetic. No mechanical effect.
#define ORGAN_ROBOTIC    FLAG(11) // The organ is robotic. Changes numerous behaviors, search BP_IS_ROBOTIC for checks.
#define ORGAN_BRITTLE    FLAG(12) // The organ takes additional blunt damage. If robotic, cannot be repaired through normal means.
#define ORGAN_CRYSTAL    FLAG(13) // The organ does not suffer laser damage, but shatters on droplimb.
#define ORGAN_CONFIGURE  FLAG(14) // The organ has an extra configuration step for surgery that it handles itself.

// Flags for proc/take_organ_damage
#define ORGAN_DAMAGE_SHARP       FLAG(0) // Damage should be treated as sharp when applied
#define ORGAN_DAMAGE_EDGE        FLAG(1) // Damage should be treated as edged when applied
#define ORGAN_DAMAGE_FLESH_ONLY  FLAG(2) // Damage should not be applied to robotic organs
#define ORGAN_DAMAGE_ROBOT_ONLY  FLAG(3) // Damage should not be applied to flesh organs
#define ORGAN_DAMAGE_SILICON_EMP FLAG(4) // Damage should be treated as bypassing armor for silicons

// Organ flag defines.
#define ORGAN_FLAG_CAN_AMPUTATE   FLAG(0) // The organ can be amputated.
#define ORGAN_FLAG_CAN_BREAK      FLAG(1) // The organ can be broken.
#define ORGAN_FLAG_CAN_GRASP      FLAG(2) // The organ contributes to grasping.
#define ORGAN_FLAG_CAN_STAND      FLAG(3) // The organ contributes to standing.
#define ORGAN_FLAG_HAS_TENDON     FLAG(4) // The organ can have its tendon cut.
#define ORGAN_FLAG_FINGERPRINT    FLAG(5) // The organ has a fingerprint.
#define ORGAN_FLAG_GENDERED_ICON  FLAG(6) // The icon state for this organ appends _m/_f.
#define ORGAN_FLAG_HEALS_OVERKILL FLAG(7) // The organ heals from overkill damage.
#define ORGAN_FLAG_DEFORMED       FLAG(8) // The organ is permanently disfigured.

// Droplimb types.
#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

// Robotics hatch_state defines.
#define HATCH_CLOSED 0
#define HATCH_UNSCREWED 1
#define HATCH_OPENED 2

// These control the amount of blood lost from burns. The loss is calculated so
// that dealing just enough burn damage to kill the player will cause the given
// proportion of their max blood volume to be lost
// (e.g. 0.6 == 60% lost if 200 burn damage is taken).
#define FLUIDLOSS_WIDE_BURN 0.15 //for burns from heat applied over a wider area, like from fire
#define FLUIDLOSS_CONC_BURN 0.1 //for concentrated burns, like from lasers

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_SELF_REPAIR_CAP 30

//Germs and infections.
#define GERM_LEVEL_AMBIENT  275 // Maximum germ level you can reach by standing still.
#define GERM_LEVEL_MOVE_CAP 300 // Maximum germ level you can reach by running around.

#define INFECTION_LEVEL_ONE   250
#define INFECTION_LEVEL_TWO   500  // infections grow from ambient to two in ~5 minutes
#define INFECTION_LEVEL_THREE 1000 // infections grow from two to three in ~10 minutes

//Blood levels. These are percentages based on the species blood_volume far.
#define BLOOD_VOLUME_FULL    100
#define BLOOD_VOLUME_SAFE    85
#define BLOOD_VOLUME_OKAY    70
#define BLOOD_VOLUME_BAD     60
#define BLOOD_VOLUME_SURVIVE 30
