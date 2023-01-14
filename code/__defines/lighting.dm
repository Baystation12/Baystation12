#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center; \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define END_FOR_DVIEW GLOB.dview_mob.loc = null

#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi' // icon used for lighting shading effects
#define LIGHTING_ICON_STATE_DARK "dark" // Change between "soft_dark" and "dark" to swap soft darkvision

#define LIGHTING_ROUND_VALUE (1 / 64) // Value used to round lumcounts, values smaller than 1/69 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

#define LIGHTING_SOFT_THRESHOLD 0 // If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting overlays.  This also should be the transparancy of the "soft_dark" icon state.

#define LIGHTING_MULT_FACTOR 0.9

// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		0, 0, 0, 1           \
	)

// Helpers so we can (more easily) control the colour matrices.
#define CL_MATRIX_RR 1
#define CL_MATRIX_RG 2
#define CL_MATRIX_RB 3
#define CL_MATRIX_RA 4
#define CL_MATRIX_GR 5
#define CL_MATRIX_GG 6
#define CL_MATRIX_GB 7
#define CL_MATRIX_GA 8
#define CL_MATRIX_BR 9
#define CL_MATRIX_BG 10
#define CL_MATRIX_BB 11
#define CL_MATRIX_BA 12
#define CL_MATRIX_AR 13
#define CL_MATRIX_AG 14
#define CL_MATRIX_AB 15
#define CL_MATRIX_AA 16
#define CL_MATRIX_CR 17
#define CL_MATRIX_CG 18
#define CL_MATRIX_CB 19
#define CL_MATRIX_CA 20

// Lightbulb statuses
#define LIGHT_OK 		0 // A light bulb is installed and functioning.
#define LIGHT_EMPTY		1 // There is no light bulb installed.
#define LIGHT_BROKEN	2 // The light bulb is broken/shattered.
#define LIGHT_BURNED	3 // The light bulb is burned out.

// Lighting color presets
#define LIGHT_COLOUR_WHITE	"#fefefe" // Clinical white light bulbs
#define LIGHT_COLOUR_WARM	"#fffee0" // Warm yellowish light bulbs
#define LIGHT_COLOUR_COOL	"#e0fefe" // Cool bluish light bulbs
#define LIGHT_COLOUR_E_RED	"#da0205" // Emergency red lighting
#define LIGHT_COLOUR_READY	"#00ff00" // Green 'READY' lighting
#define LIGHT_COLOUR_SKRELL	"#66ccff" // Skrellian cyan lighting

#define LIGHT_STANDARD_COLORS list(LIGHT_COLOUR_WHITE, LIGHT_COLOUR_WARM, LIGHT_COLOUR_COOL) // List of standard light colors used for randomized lighting and selectable printed lights.

// Light replacer color options
#define LIGHT_REPLACE_AREA     "AREA"     // Match the areas defined light color(s)
#define LIGHT_REPLACE_EXISTING "EXISTING" // Mimic the existing bulb's color
#define LIGHT_REPLACE_RANDOM   "RANDOM"   // Default behaviour. Randomize the light color from LIGHT_STANDARD_COLORS.

// Options available for users to set light replacer colors.
#define LIGHT_REPLACE_OPTIONS list(\
	"Random (Default)",\
	"Match Blueprint",\
	"Match Existing",\
	"Warm",\
	"Cool",\
	"White",\
	"Custom"\
)

// Area lighting modes
#define AREA_LIGHTING_WHITE		"white"
#define AREA_LIGHTING_WARM		"warm"
#define AREA_LIGHTING_COOL		"cool"
#define AREA_LIGHTING_DEFAULT	"default" // For light replacers, defaults to whatever the area is set to. For areas, uses the initial lighting value from the light bulb itself.
