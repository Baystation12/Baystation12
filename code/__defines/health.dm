// Flags for damage types
/// Generic physical damage sources - Punches, general attacks, bullets, etc
#define DAMAGE_BRUTE     "brute"
/// Generic burn damage sources - Lasers, focused heat sources (Not fire, see DAMAGE_FIRE), etc
#define DAMAGE_BURN      "burn"
/// Non-harming energy effects - Stun mode weapons, tasers, practice lasers, etc
#define DAMAGE_STUN      "stun"
/// Electrical damage, shock rounds, less-than-lethal lasers, etc
#define DAMAGE_SHOCK     "shock"
/// Strictly EMP damage, primarily used in emp_act()
#define DAMAGE_EMP       "emp"
/// Strictly explosion damage, primarily used in explode_act()
#define DAMAGE_EXPLODE   "explode"
/// Strictly fire damage, primarily used in fire_act()
#define DAMAGE_FIRE      "fire"
/// Radiation damage
#define DAMAGE_RADIATION "radiation"
/// Bio-damage. Infections, viruses, etc.
#define DAMAGE_BIO       "bio"
/// Pain damage. Used for compatabiltiy with legacy code, not intended for actual health tracking use.
#define DAMAGE_PAIN      "pain"
/// Toxin and poison damage.
#define DAMAGE_TOXIN     "toxin"
/// Genetic damage
#define DAMAGE_GENETIC   "genetic"
/// Oxyloss damage
#define DAMAGE_OXY       "oxy"
/// Brain damage
#define DAMAGE_BRAIN     "brain"
/// Psionic damage
#define DAMAGE_PSIONIC   "psi"

/// Common, basic damage types
#define DAMAGE_STANDARD   list(DAMAGE_BRUTE, DAMAGE_BURN)
/// Damage types that should specifically affect electrical systems
#define DAMAGE_ELECTRICAL list(DAMAGE_SHOCK, DAMAGE_EMP)
/// All damage flags
#define DAMAGE_ALL        list(DAMAGE_BRUTE, DAMAGE_BURN, DAMAGE_STUN, DAMAGE_SHOCK, DAMAGE_EMP, DAMAGE_EXPLODE, DAMAGE_FIRE, DAMAGE_RADIATION, DAMAGE_BIO, DAMAGE_PAIN, DAMAGE_TOXIN, DAMAGE_GENETIC, DAMAGE_OXY, DAMAGE_BRAIN, DAMAGE_PSIONIC)


/// Damage resistance preset for physical inorganic objects - Walls, structures, items, etc.
#define DAMAGE_RESIST_PHYSICAL list(\
	DAMAGE_STUN = 0,\
	DAMAGE_EMP = 0,\
	DAMAGE_RADIATION = 0,\
	DAMAGE_BIO = 0,\
	DAMAGE_PAIN = 0,\
	DAMAGE_TOXIN = 0,\
	DAMAGE_GENETIC = 0,\
	DAMAGE_OXY = 0,\
	DAMAGE_BRAIN = 0,\
	DAMAGE_PSIONIC = 0\
)

/// Damage resistance preset for electronic equipment - Computers, machinery, etc.
#define DAMAGE_RESIST_ELECTRICAL list(\
	DAMAGE_STUN = 0.5,\
	DAMAGE_RADIATION = 0,\
	DAMAGE_BIO = 0,\
	DAMAGE_PAIN = 0,\
	DAMAGE_TOXIN = 0,\
	DAMAGE_GENETIC = 0,\
	DAMAGE_OXY = 0,\
	DAMAGE_BRAIN = 0,\
	DAMAGE_PSIONIC = 0\
)

/// Damage resistance preset for biological atoms - Animals, plants, etc.
#define DAMAGE_RESIST_BIOLOGICAL list(\
	DAMAGE_EMP = 0\
)


/// Damage Flags for damage_health()
/// The damage proc chain should skip calling `handle_death_state_change()` if applicable
#define DAMAGE_FLAG_SKIP_DEATH_STATE_CHANGE FLAG(0)
/// The damage source should deal extra damage to turfs - Walls, floors,
#define DAMAGE_FLAG_TURF_BREAKER            FLAG(1)
#define DAMAGE_FLAG_SHARP                   FLAG(2)
#define DAMAGE_FLAG_EDGE                    FLAG(3)
#define DAMAGE_FLAG_LASER                   FLAG(4)
#define DAMAGE_FLAG_BULLET                  FLAG(5)
#define DAMAGE_FLAG_EXPLODE                 FLAG(6)
/// Makes apply_damage calls without specified zone distribute damage rather than randomly choose organ (for humans)
#define DAMAGE_FLAG_DISPERSED               FLAG(7)
/// Toxin damage that should be mitigated by biological (i.e. sterile) armor
#define DAMAGE_FLAG_BIO                     FLAG(8)


/// Health Status flags for `/atom/var/health_status`.
/// The atom is currently dead.
#define HEALTH_STATUS_DEAD FLAG(0)
/// The atom is currently broken. An atom is `broken` if `HEALTH_FLAG_BREAKABLE` is set and the atom's health falls below 1/2 of `health_max`. Used for certain atoms that needed an additional damage state.
#define HEALTH_STATUS_BROKEN FLAG(1)


/// Health Flags for `/atom/var/health_flags`.
/// The atom is 'breakable', and considered broken upon reaching 1/2 health.
#define HEALTH_FLAG_BREAKABLE FLAG(0)
/// The atom should be treated as a structure for damage calculations.
#define HEALTH_FLAG_STRUCTURE FLAG(1)
