/// Max length of a keypress command before it's considered to be a forged packet/bogus command
#define MAX_KEYPRESS_COMMANDLENGTH 16
/// Maximum keys that can be bound to one button
#define MAX_COMMANDS_PER_KEY 5
/// Maximum keys per keybind
#define MAX_KEYS_PER_KEYBIND 3
/// Length of held key buffer
#define HELD_KEY_BUFFER_LENGTH 15

// NOTE: INTENT_HOTKEY_* defines are not actual intents!
// They are here to support hotkeys
#define INTENT_HOTKEY_LEFT  "left"
#define INTENT_HOTKEY_RIGHT "right"
