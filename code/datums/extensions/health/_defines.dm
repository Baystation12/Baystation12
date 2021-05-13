// Flags for damage types
/// Generic physical damage sources - Punches, general attacks, bullets, etc
var/const/DAMAGE_BRUTE     = "brute"
/// Generic burn damage sources - Lasers, focused heat sources (Not fire, see DAMAGE_FIRE), etc
var/const/DAMAGE_BURN      = "burn"
/// Non-harming energy effects - Stun mode weapons, tasers, practice lasers, etc
var/const/DAMAGE_STUN      = "stun"
/// Electrical damage, shock rounds, less-than-lethal lasers, etc
var/const/DAMAGE_SHOCK     = "shock"
/// Strictly EMP damage, primarily used in emp_act()
var/const/DAMAGE_EMP       = "emp"
/// Strictly explosion damage, primarily used in explode_act()
var/const/DAMAGE_EXPLODE   = "explode"
/// Strictly fire damage, primarily used in fire_act()
var/const/DAMAGE_FIRE      = "fire"
/// Radiation damage
var/const/DAMAGE_RADIATION = "radiation"
/// Bio-damage. Infections, viruses, etc.
var/const/DAMAGE_BIO       = "bio"
/// Pain damage. Used for compatabiltiy with legacy code, not intended for actual health tracking use.
var/const/DAMAGE_PAIN      = "pain"
/// Toxin and poison damage.
var/const/DAMAGE_TOXIN     = "toxin"
/// Genetic damage
var/const/DAMAGE_GENETIC   = "genetic"
/// Oxyloss damage
var/const/DAMAGE_OXY       = "oxy"
/// Brain damage
var/const/DAMAGE_BRAIN     = "brain"
/// Psionic damage
var/const/DAMAGE_PSIONIC   = "psionic"

/// All damage flags
#define DAMAGE_ALL list(DAMAGE_BRUTE, DAMAGE_BURN, DAMAGE_STUN, DAMAGE_SHOCK, DAMAGE_EMP, DAMAGE_EXPLODE, DAMAGE_FIRE, DAMAGE_RADIATION, DAMAGE_BIO, DAMAGE_PAIN, DAMAGE_TOXIN, DAMAGE_GENETIC, DAMAGE_OXY, DAMAGE_BRAIN, DAMAGE_PSIONIC)


// Flags for use health types
/// Uses simple health vars, no extension
var/const/USE_HEALTH_SIMPLE = "simple"
/// Uses the standard health extension
var/const/USE_HEALTH_EXTENSION = /datum/extension/health
/// Uses the damage sources health extension
var/const/USE_HEALTH_DAMAGE_SOURCES = /datum/extension/health/damage_sources
