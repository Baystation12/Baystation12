// Species flags.
#define NO_BLOOD          1     // Vessel var is not filled with blood, cannot bleed out.
#define NO_BREATHE        2     // Cannot suffocate or take oxygen loss.
#define NO_SCAN           4     // Cannot be scanned in a DNA machine/genome-stolen.
#define NO_PAIN           8     // Cannot suffer halloss/recieves deceptive health indicator.
#define NO_SLIP           16    // Cannot fall over.
#define NO_POISON         32    // Cannot not suffer toxloss.
#define HAS_SKIN_TONE     64    // Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_COLOR    128   // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          256   // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     512   // Underwear is drawn onto the mob icon.
#define IS_PLANT          1024  // Is a treeperson.
#define IS_WHITELISTED    2048  // Must be whitelisted to play.
#define HAS_EYE_COLOR     4096  // Eye colour selectable in chargen. (RGB)
#define CAN_JOIN          8192  // Species is selectable in chargen.
#define IS_RESTRICTED     16384 // Is not a core/normally playable species. (castes, mutantraces)
// unused: 32768 - higher than this will overflow

// Languages.
#define LANGUAGE_HUMAN  1
#define LANGUAGE_ALIEN  2
#define LANGUAGE_DOG    4
#define LANGUAGE_CAT    8
#define LANGUAGE_BINARY 16
#define LANGUAGE_OTHER  32768

#define LANGUAGE_UNIVERSAL 65535

#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_SIIK_MAAS "Siik'maas"
#define LANGUAGE_SIIK_TAJR "Siik'tajr"
#define LANGUAGE_SKRELLIAN "Skrellian"
#define LANGUAGE_ROOTSPEAK "Rootspeak"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Gutter"

// Language flags.
#define WHITELISTED 1   // Language is available if the speaker is whitelisted.
#define RESTRICTED  2   // Language can only be accquired by spawning or an admin.
#define NONVERBAL   4   // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG    8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND    16  // Broadcast to all mobs with this language.
#define NONGLOBAL   32  // Do not add to general languages list.
#define INNATE      64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG 128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER 256	// No stuttering, slurring, or other speech problems