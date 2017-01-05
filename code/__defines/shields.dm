#define SHIELD_DAMTYPE_PHYSICAL 1	// Physical damage - bullets, meteors, various hand objects - aka. "brute" damtype.
#define SHIELD_DAMTYPE_EM 2			// Electromagnetic damage - Ion weaponry, stun beams, ...
#define SHIELD_DAMTYPE_HEAT 3		// Heat damage - Lasers, fire

#define ENERGY_PER_HP (50 KILOWATTS)// Base amount energy that will be deducted from the generator's internal reserve per 1 HP of damage taken
#define ENERGY_UPKEEP_PER_TILE 100	// Base upkeep per tile protected. Multiplied by various enabled shield modes. Without them the field does literally nothing.

// This shield model is slightly inspired by Sins of a Solar Empire series. In short, shields are designed to analyze what hits them, and adapt themselves against that type of damage.
// This means shields will become increasingly effective against things like emitters - as they will adapt to heat damage, however they will be vulnerable to brute and EM damage.
// In a theoretical assault scenario, it is best to combine all damage types, so mitigation can't build up. The value is capped to prevent full scale invulnerability.

#define MAX_MITIGATION_BASE 50		// % Base maximal reachable mitigation.
#define MAX_MITIGATION_RESEARCH 10	// % Added to MAX_MITIGATION_BASE when generator is built using more advanced components. This value is added for each "tier" of used component, ie. basic one has 1, the best one has 3. Actual maximum should be 80% in this case (with best components). Make sure you won't get above 100%!
#define MITIGATION_HIT_GAIN 5		// Mitigation gain per hit of respective damage type.
#define MITIGATION_HIT_LOSS 4		// Mitigation loss per hit. If we get hit once by EM damage type, EM mitigation will grow, while Physical and Heat mitigation values drop.
#define MITIGATION_LOSS_PASSIVE 0.5	// Mitigation of all damage types will drop by this every tick, up to 0.

// Shield modes allow you to calibrate the field to fit specific needs. It is, for example, possible to create a field that will block airflow, but let people pass by calibrating it
// properly. Each enabled shield mode adds up to the upkeep power usage, however. The following defines are a multiplier - 1.5 means the power usage will be increased 1.5x.

#define MODEUSAGE_HYPERKINETIC 			// Blocks meteors and projectile based weapons. Relatively low as the shields are primarily intended as an anti-meteor countermeasure.
#define MODEUSAGE_PHOTONIC 				// Blocks energy weapons, and makes the field opaque.
#define MODEUSAGE_NONHUMANS 				// Blocks most organic lifeforms, with an exception being humanoid mobs. Typical uses include carps.
#define MODEUSAGE_HUMANOIDS 			// Blocks humanoid mobs.
#define MODEUSAGE_ANORGANIC 				// Blocks silicon-based mobs (cyborgs, drones, FBPs, IPCs, ..)
#define MODEUSAGE_ATMOSPHERIC 			// Blocks airflow.
#define MODEUSAGE_HULL 1					// Enables hull shielding mode, which changes a square shaped field into a field that covers external hull only.
#define MODEUSAGE_BYPASS 					// Attempts to counter shield diffusers. Puts very large EM strain on the shield when doing so. Has to be hacked.
#define MODEUSAGE_OVERCHARGE 3				// Overcharges the shield, causing it to shock anyone who touches a field segment. Best used with MODE_ORGANIC_HUMANOIDS. Has to be hacked.
#define MODEUSAGE_MODULATE 2				// Modulates the shield, enabling the mitigation system.

// Relevant mode bitflags (maximal of 16 flags due to current BYOND limitations)
#define MODEFLAG_HYPERKINETIC 1
#define MODEFLAG_PHOTONIC 2
#define MODEFLAG_NONHUMANS 4
#define MODEFLAG_HUMANOIDS 8
#define MODEFLAG_ANORGANIC 16
#define MODEFLAG_ATMOSPHERIC 32
#define MODEFLAG_HULL 64
#define MODEFLAG_BYPASS 128
#define MODEFLAG_OVERCHARGE 256
#define MODEFLAG_MODULATE 512
#define MODEFLAG_MULTIZ 1024
#define MODEFLAG_ANTIRAD 2048

// Return codes for shield hits.
#define SHIELD_ABSORBED 1			// The shield has completely absorbed the hit
#define SHIELD_BREACHED_MINOR 2		// The hit was absorbed, but a small gap will be created in the field (1-3 tiles)
#define SHIELD_BREACHED_MAJOR 3		// Same as above, with 2-5 tile gap
#define SHIELD_BREACHED_CRITICAL 4	// Same as above, with 4-8 tile gap
#define SHIELD_BREACHED_FAILURE 5	// Same as above, with 8-16 tile gap. Occurs when the hit exhausts all remaining shield energy.

#define SHIELD_OFF 0				// The shield is offline
#define SHIELD_DISCHARGING 1		// The shield is shutting down and discharging.
#define SHIELD_RUNNING 2			// The shield is running

#define SHIELD_SHUTDOWN_DISPERSION_RATE (500 KILOWATTS)		// The rate at which shield energy disperses when shutdown is initiated.
#define SHIELD_RAD_RESISTANCE 150	// How well shields protect against radiation. This should protect against almost anything, except for the strongest radiation sources.