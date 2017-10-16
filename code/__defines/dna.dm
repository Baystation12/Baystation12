// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

// Generic mutations:
#define TK              1
#define COLD_RESISTANCE 2
#define XRAY            3
#define HULK            4
#define CLUMSY          5
#define FAT             6
#define HUSK            7
#define NOCLONE         8
#define LASER           9  // Harm intent - click anywhere to shoot lasers from eyes.
#define HEAL            10 // Healing people with hands.

#define SKELETON      29
#define PLANT         30

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
#define NEARSIGHTED 0x1
#define EPILEPSY    0x2
#define COUGHING    0x4
#define TOURETTES   0x8
#define NERVOUS     0x10

// sdisabilities
#define BLIND 0x1
#define MUTE  0x2
#define DEAF  0x4

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
