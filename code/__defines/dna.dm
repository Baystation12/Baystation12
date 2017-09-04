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
var/BLINDBLOCK    = 0
var/DEAFBLOCK     = 0
var/HULKBLOCK     = 0
var/TELEBLOCK     = 0
var/FIREBLOCK     = 0
var/XRAYBLOCK     = 0
var/CLUMSYBLOCK   = 0
var/FAKEBLOCK     = 0
var/COUGHBLOCK    = 0
var/GLASSESBLOCK  = 0
var/EPILEPSYBLOCK = 0
var/TWITCHBLOCK   = 0
var/NERVOUSBLOCK  = 0
var/MONKEYBLOCK   = STRUCDNASIZE

var/BLOCKADD = 0
var/DIFFMUT  = 0

var/HEADACHEBLOCK      = 0
var/NOBREATHBLOCK      = 0
var/REMOTEVIEWBLOCK    = 0
var/REGENERATEBLOCK    = 0
var/INCREASERUNBLOCK   = 0
var/REMOTETALKBLOCK    = 0
var/MORPHBLOCK         = 0
var/BLENDBLOCK         = 0
var/HALLUCINATIONBLOCK = 0
var/NOPRINTSBLOCK      = 0
var/SHOCKIMMUNITYBLOCK = 0
var/SMALLSIZEBLOCK     = 0
