#define GEAR_HAS_COLOR_SELECTION FLAG(0)
#define GEAR_HAS_TYPE_SELECTION FLAG(1)
#define GEAR_HAS_SUBTYPE_SELECTION FLAG(2)
#define GEAR_HAS_NO_CUSTOMIZATION FLAG(3)
/// This flag is discouraged for loadout items with random contents.
/// Extended descriptions are cached and even if they weren't, seeing random descriptions every refresh of the loadout would be odd as well.
#define GEAR_HAS_EXTENDED_DESCRIPTION FLAG(4)
