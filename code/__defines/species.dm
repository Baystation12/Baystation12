// Species flags.
#define SPECIES_FLAG_NO_MINOR_CUT               0x0001  // Can step on broken glass with no ill-effects. Either thick skin (diona/vox), cut resistant (slimes) or incorporeal (shadows)
#define SPECIES_FLAG_IS_PLANT                   0x0002  // Is a treeperson.
#define SPECIES_FLAG_NO_SCAN                    0x0004  // Cannot be scanned in a DNA machine/genome-stolen.
#define SPECIES_FLAG_NO_PAIN                    0x0008  // Cannot suffer halloss/recieves deceptive health indicator.
#define SPECIES_FLAG_NO_SLIP                    0x0010  // Cannot fall over.
#define SPECIES_FLAG_NO_POISON                  0x0020  // Cannot not suffer toxloss.
#define SPECIES_FLAG_NO_EMBED                   0x0040  // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define SPECIES_FLAG_NO_TANGLE                  0x0080  // This species wont get tangled up in weeds
#define SPECIES_FLAG_NO_BLOCK                   0x0100  // Unable to block or defend itself from attackers.
#define SPECIES_FLAG_NEED_DIRECT_ABSORB         0x0200  // This species can only have their DNA taken by direct absorption.
#define SPECIES_FLAG_LOW_GRAV_ADAPTED           0x0400  // This species is used to lower than standard gravity, affecting stamina in high-grav

// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define SPECIES_IS_WHITELISTED               0x1    // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED                0x2    // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN                     0x4    // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION          0x8    // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN               0x10   // FBP of this species can't be selected at chargen.
#define SPECIES_NO_ROBOTIC_INTERNAL_ORGANS   0x20   // Species cannot start with robotic organs or have them attached.

// Species appearance flags
#define HAS_SKIN_TONE_NORMAL                                                      0x1    // Skin tone selectable in chargen for baseline humans (0-220)
#define HAS_SKIN_COLOR                                                            0x2    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS                                                                  0x4    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR                                                             0x8    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR                                                             0x10   // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR                                                            0x20   // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS                                                           0x40   // Radiation causes this character to glow.
#define HAS_SKIN_TONE_GRAV                                                        0x80   // Skin tone selectable in chargen for grav-adapted humans (0-100)
#define HAS_SKIN_TONE_SPCR                                                        0x100  // Skin tone selectable in chargen for spacer humans (0-165)
#define HAS_SKIN_TONE_TRITON                                                      0x200
#define HAS_BASE_SKIN_COLOURS                                                     0x400  // Has multiple base skin sprites to go off of
#define HAS_A_SKIN_TONE (HAS_SKIN_TONE_NORMAL | HAS_SKIN_TONE_GRAV | HAS_SKIN_TONE_SPCR | HAS_SKIN_TONE_TRITON) // Species has a numeric skintone

// Skin Defines
#define SKIN_NORMAL 0
#define SKIN_THREAT 1

// Darkvision Levels these are inverted from normal so pure white is the darkest
// possible and pure black is none
#define DARKTINT_NONE      "#ffffff"
#define DARKTINT_MODERATE  "#f9f9f5"
#define DARKTINT_GOOD      "#ebebe6"
