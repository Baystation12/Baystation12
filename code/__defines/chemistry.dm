#define DEFAULT_HUNGER_FACTOR 0.03 // Factor of how fast mob nutrition decreases
#define DEFAULT_THIRST_FACTOR 0.03 // Factor of how fast mob hydration decreases

#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3

#define MINIMUM_CHEMICAL_VOLUME 0.01

#define SOLID 1
#define LIQUID 2
#define GAS 3

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

// Some on_mob_life() procs check for alien races.
#define IS_DIONA   1
#define IS_VOX     2
#define IS_SKRELL  3
#define IS_UNATHI  4
#define IS_SLIME   5
#define IS_NABBER  6

#define CE_STABLE        "stable"       // Inaprovaline
#define CE_ANTIBIOTIC    "antibiotic"   // Spaceacilin
#define CE_BLOODRESTORE  "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER    "painkiller"
#define CE_ALCOHOL       "alcohol"      // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic"    // Liver damage
#define CE_SPEEDBOOST    "gofast"       // Hyperzine
#define CE_SLOWDOWN      "goslow"       // Slowdown
#define CE_PULSE         "xcardic"      // increases or decreases heart rate
#define CE_NOPULSE       "heartstop"    // stops heartbeat
#define CE_ANTITOX       "antitox"      // Dylovene
#define CE_OXYGENATED    "oxygen"       // Dexalin.
#define CE_BRAIN_REGEN   "brainfix"     // Alkysine.
#define CE_ANTIVIRAL     "antiviral"    // Anti-virus effect.
#define CE_TOXIN         "toxins"       // Generic toxins, stops autoheal.
#define CE_BREATHLOSS    "breathloss"   // Breathing depression, makes you need more air
#define CE_MIND    		 "mindbending"  // Stabilizes or wrecks mind. Used for hallucinations
#define CE_CRYO 	     "cryogenic"    // Prevents damage from being frozen
#define CE_BLOCKAGE	     "blockage"     // Gets in the way of blood circulation, higher the worse
#define CE_SQUEAKY		 "squeaky"      // Helium voice. Squeak squeak.
#define CE_THIRDEYE      "thirdeye"     // Gives xray vision.
#define CE_SEDATE        "sedate"       // Applies sedation effects, i.e. paralysis, inability to use items, etc.
#define CE_ENERGETIC     "energetic"    // Speeds up stamina recovery.
#define	CE_VOICELOSS     "whispers"     // Lowers the subject's voice to a whisper
#define CE_STIMULANT     "stimulants"   // Makes it harder to disarm someone

//reagent flags
#define IGNORE_MOB_SIZE 0x1
#define AFFECTS_DEAD    0x2

#define HANDLE_REACTIONS(_reagents)  SSchemistry.active_holders[_reagents] = TRUE
#define UNQUEUE_REACTIONS(_reagents) SSchemistry.active_holders -= _reagents
