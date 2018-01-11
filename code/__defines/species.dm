// Species flags.
#define SPECIES_FLAG_NO_MINOR_CUT        0x0001  // Can step on broken glass with no ill-effects. Either thick skin (diona/vox), cut resistant (slimes) or incorporeal (shadows)
#define SPECIES_FLAG_IS_PLANT            0x0002  // Is a treeperson.
#define SPECIES_FLAG_NO_SCAN             0x0004  // Cannot be scanned in a DNA machine/genome-stolen.
#define SPECIES_FLAG_NO_PAIN             0x0008  // Cannot suffer halloss/recieves deceptive health indicator.
#define SPECIES_FLAG_NO_SLIP             0x0010  // Cannot fall over.
#define SPECIES_FLAG_NO_POISON           0x0020  // Cannot not suffer toxloss.
#define SPECIES_FLAG_NO_EMBED            0x0040  // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define SPECIES_FLAG_CAN_NAB             0x0080  // Uses the special set of grab rules.
#define SPECIES_FLAG_NO_BLOCK            0x0100  // Unable to block or defend itself from attackers.
#define SPECIES_FLAG_NEED_DIRECT_ABSORB  0x0200  // This species can only have their DNA taken by direct absorption.

// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define SPECIES_IS_WHITELISTED      0x1    // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED       0x2    // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN            0x4    // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION 0x8    // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN      0x10   // FBP of this species can't be selected at chargen.
#define SPECIES_NO_LACE             0x20   // This species can't have a neural lace.

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
#define HAS_A_SKIN_TONE (HAS_SKIN_TONE_NORMAL | HAS_SKIN_TONE_GRAV | HAS_SKIN_TONE_SPCR) // Species has a numeric skintone

// Skin Defines
#define SKIN_NORMAL 0
#define SKIN_THREAT 1
