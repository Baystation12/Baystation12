// Consider these images/atoms as part of the UI/HUD
#define APPEARANCE_UI_IGNORE_ALPHA			RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA
#define APPEARANCE_UI						RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR

/// The atom is not clickable
#define XMOUSE_OPACITY_NEVER 0

/// The atom is clickable normally
#define XMOUSE_OPACITY_DEFAULT 1

/// The atom steals clicks from other clickables
#define XMOUSE_OPACITY_ALWAYS 2
