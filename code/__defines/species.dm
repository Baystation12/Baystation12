// Species flags
#define SPECIES_FLAG_NO_MINOR_CUT          FLAG(0)  // Can step on broken glass with no ill-effects. Either thick skin (diona/vox), cut resistant (slimes) or incorporeal (shadows)
#define SPECIES_FLAG_IS_PLANT              FLAG(1)  // Is a treeperson.
#define SPECIES_FLAG_NO_SCAN               FLAG(2)  // Cannot be scanned in a DNA machine/genome-stolen.
#define SPECIES_FLAG_NO_PAIN               FLAG(3)  // Cannot suffer halloss/recieves deceptive health indicator.
#define SPECIES_FLAG_NO_SLIP               FLAG(4)  // Cannot fall over.
#define SPECIES_FLAG_NO_POISON             FLAG(5)  // Cannot not suffer toxloss.
#define SPECIES_FLAG_NO_EMBED              FLAG(6)  // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define SPECIES_FLAG_NO_TANGLE             FLAG(7)  // This species wont get tangled up in weeds
#define SPECIES_FLAG_NO_BLOCK              FLAG(8)  // Unable to block or defend itself from attackers.
#define SPECIES_FLAG_NEED_DIRECT_ABSORB    FLAG(9)  // This species can only have their DNA taken by direct absorption.
#define SPECIES_FLAG_LOW_GRAV_ADAPTED      FLAG(10) // This species is used to lower than standard gravity, affecting stamina in high-grav


// Species spawn flags
#define SPECIES_IS_WHITELISTED                FLAG(0)  // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED                 FLAG(1)  // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN                      FLAG(2)  // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION           FLAG(3)  // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN                FLAG(4)  // FBP of this species can't be selected at chargen.
#define SPECIES_NO_ROBOTIC_INTERNAL_ORGANS    FLAG(5)  // Species cannot start with robotic organs or have them attached.


// Species appearance flags
#define HAS_SKIN_TONE_NORMAL     FLAG(0)  // Skin tone selectable in chargen for baseline humans (0-220)
#define HAS_SKIN_COLOR           FLAG(1)  // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS                 FLAG(2)  // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR            FLAG(3)  // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR            FLAG(4)  // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR           FLAG(5)  // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS          FLAG(6)  // Radiation causes this character to glow.
#define HAS_SKIN_TONE_GRAV       FLAG(7)  // Skin tone selectable in chargen for grav-adapted humans (0-100)
#define HAS_SKIN_TONE_SPCR       FLAG(8)  // Skin tone selectable in chargen for spacer humans (0-165)
#define HAS_SKIN_TONE_TRITON     FLAG(9)  // Skin tone selectable in chargen for tritonian humans
#define HAS_BASE_SKIN_COLOURS    FLAG(10) // Has multiple base skin sprites to go off of
#define HAS_A_SKIN_TONE (HAS_SKIN_TONE_NORMAL | HAS_SKIN_TONE_GRAV | HAS_SKIN_TONE_SPCR | HAS_SKIN_TONE_TRITON) // Species has a numeric skintone


// Skin Defines
#define SKIN_NORMAL EMPTY_BITFIELD
#define SKIN_THREAT FLAG(0)


// Darkvision Levels. Inverted - white is darkest, black is full vision
#define DARKTINT_NONE      "#ffffff"
#define DARKTINT_MODERATE  "#f9f9f5"
#define DARKTINT_GOOD      "#ebebe6"
