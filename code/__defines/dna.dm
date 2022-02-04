// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

// Generic mutations:
#define MUTATION_COLD_RESISTANCE 1
#define MUTATION_XRAY            2
#define MUTATION_HULK            3
#define MUTATION_CLUMSY          4
#define MUTATION_FAT             5
#define MUTATION_HUSK            6
#define MUTATION_LASER           7  // Harm intent - click anywhere to shoot lasers from eyes.
#define MUTATION_HEAL            8 // Healing people with hands.
#define MUTATION_SPACERES        9 // Can't be harmed via pressure damage.
#define MUTATION_SKELETON        10
#define MUTATION_FERAL           11 // Smash objects instead of using them, and unable to use items

// Other Mutations:
#define mNobreath      100 // No need to breathe.
#define mRemote        101 // Remote viewing.
#define mRegen         102 // Health regeneration.
#define mRun           103 // No slowdown.
#define mRemotetalk    104 // Remote talking.
#define mMorph         105 // Hanging appearance.
#define mBlend         106 // Nothing. (seriously nothing)
#define mHallucination 107 // Hallucinations.
#define mFingerprints  108 // No fingerprints.
#define mShock         109 // Insulated hands.
#define mSmallsize     110 // Table climbing.

// disabilities
#define NEARSIGHTED    FLAG(0)
#define EPILEPSY       FLAG(1)
#define COUGHING       FLAG(2)
#define TOURETTES      FLAG(3)
#define NERVOUS        FLAG(4)

// sdisabilities
#define BLINDED     FLAG(0)
#define MUTED       FLAG(1)
#define DEAFENED    FLAG(2)

// The way blocks are handled badly needs a rewrite, this is horrible.
// Too much of a project to handle at the moment, TODO for later.
GLOBAL_VAR_INIT(BLINDBLOCK,0)
GLOBAL_VAR_INIT(DEAFBLOCK,0)
GLOBAL_VAR_INIT(HULKBLOCK,0)
GLOBAL_VAR_INIT(TELEBLOCK,0)
GLOBAL_VAR_INIT(FIREBLOCK,0)
GLOBAL_VAR_INIT(XRAYBLOCK,0)
GLOBAL_VAR_INIT(CLUMSYBLOCK,0)
GLOBAL_VAR_INIT(FAKEBLOCK,0)
GLOBAL_VAR_INIT(COUGHBLOCK,0)
GLOBAL_VAR_INIT(GLASSESBLOCK,0)
GLOBAL_VAR_INIT(EPILEPSYBLOCK,0)
GLOBAL_VAR_INIT(TWITCHBLOCK,0)
GLOBAL_VAR_INIT(NERVOUSBLOCK,0)
GLOBAL_VAR_INIT(MONKEYBLOCK, STRUCDNASIZE)

GLOBAL_VAR_INIT(BLOCKADD,0)
GLOBAL_VAR_INIT(DIFFMUT,0)

GLOBAL_VAR_INIT(HEADACHEBLOCK,0)
GLOBAL_VAR_INIT(NOBREATHBLOCK,0)
GLOBAL_VAR_INIT(REMOTEVIEWBLOCK,0)
GLOBAL_VAR_INIT(REGENERATEBLOCK,0)
GLOBAL_VAR_INIT(INCREASERUNBLOCK,0)
GLOBAL_VAR_INIT(REMOTETALKBLOCK,0)
GLOBAL_VAR_INIT(MORPHBLOCK,0)
GLOBAL_VAR_INIT(BLENDBLOCK,0)
GLOBAL_VAR_INIT(HALLUCINATIONBLOCK,0)
GLOBAL_VAR_INIT(NOPRINTSBLOCK,0)
GLOBAL_VAR_INIT(SHOCKIMMUNITYBLOCK,0)
GLOBAL_VAR_INIT(SMALLSIZEBLOCK,0)
