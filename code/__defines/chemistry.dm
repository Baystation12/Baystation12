#define HUNGER_FACTOR              0.05 // Factor of how fast mob nutrition decreases

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
#define IS_TAJARA  5
#define IS_XENOS   6
#define IS_MACHINE 7

#define CE_STABLE "stable" // Inaprovaline
#define CE_ANTIBIOTIC "antibiotic" // Spaceacilin
#define CE_BLOODRESTORE "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER "painkiller"
#define CE_ALCOHOL "alcohol" // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic" // Liver damage
#define CE_SPEEDBOOST "gofast" // Hyperzine

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_phorochloride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional
