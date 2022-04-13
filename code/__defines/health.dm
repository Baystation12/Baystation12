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
