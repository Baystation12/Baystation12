#define LANG_PROPERTY_RESTRICTED 0x000001
#define LANG_PROPERTY_NONGLOBAL  0x000002
#define LANG_PROPERTY_INNATE     0x000004

#define LANG_MODIFIER_NO_TALK    0x000001
#define LANG_MODIFIER_NO_STUTTER 0x000002

// The various components of a language
// When a message is received these flags are compared VS the RECEIVED_* flags and the message is scrambled accordingly
#define LANG_COMPONENT_AUDIBLE         0x000001 // Whether the language has an audible component
#define LANG_COMPONENT_VISIBLE         0x000002 // Whether the language has a visible component
#define LANG_COMPONENT_RANGED_HIVEMIND 0x000004 // Whether the language can be sent to viable receiver in the given distance
#define LANG_COMPONENT_ZBLOCK_HIVEMIND 0x000008 // Whether the language can be sent to viable receivers in the current Z-block
#define LANG_COMPONENT_GLOBAL_HIVEMIND 0x000010 // Whether the language can be sent to viable receivers globally
#define LANG_COMPONENT_OTHER           0x000020 // Whether the language has some alternative component. The language to override OnGetReceivers() to acquire relevant receivers

#define LANG_COMPONENT_ANY_HIVEMIND (LANG_COMPONENT_RANGED_HIVEMIND|LANG_COMPONENT_ZBLOCK_HIVEMIND|LANG_COMPONENT_GLOBAL_HIVEMIND)

#define RECEIVED_AUDIO           0x000001
#define RECEIVED_VISION          0x000002
#define RECEIVED_RANGE_HIVEMIND  0x000004
#define RECEIVED_ZBLOCK_HIVEMIND 0x000008
#define RECEIVED_GLOBAL_HIVEMIND 0x000010
#define RECEIVED_OTHER           0x000020
#define RECEIVED_FULLY           (~0)


#define MESSAGE_MOD_STUTTER     0x000001 // Causes stutter
#define MESSAGE_MOD_WHISPER     0x000002 // Requires whisper verbs
#define MESSAGE_MOD_EXCLAMATION 0x000004 // Requires exclamation verbs
#define MESSAGE_MOD_QUESTION    0x000008 // Requires ask verbs

// flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER
/*
#define WHITELISTED  1   // Language is available if the speaker is whitelisted.
#define RESTRICTED   2   // Language can only be acquired by spawning or an admin.
#define NONVERBAL    4   // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG     8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     16  // Broadcast to all mobs with this language.
#define NONGLOBAL    32  // Do not add to general languages list.
#define INNATE       64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   256 // No stuttering, slurring, or other speech problems
#define ALT_TRANSMIT 512 // Language is not based on vision or sound (Todo: add this into the say code and use it for the rootspeak languages)
*/