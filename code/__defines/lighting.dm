#define LIGHTING_INTERVAL 1 // frequency, in 1/10ths of a second, of the lighting process

#ifndef LIGHTING_INSTANT_UPDATES
#define LIGHTING_INTERVAL 1 // Frequency, in 1/10ths of a second, of the lighting process.
#include "..\controllers\Processes\lighting.dm"
#endif

#define LIGHTING_FALLOFF    1 // type of falloff to use for lighting; 1 for circular, 2 for square
#define LIGHTING_LAMBERTIAN 0 // use lambertian shading for light sources
#define LIGHTING_HEIGHT     1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone

#define LIGHTING_LAYER 10 // drawing layer for lighting overlays
#define LIGHTING_ICON 'icons/effects/lighting_overlay.png' // icon used for lighting shading effects

#define LIGHTING_ROUND_VALUE (1 / 196) //Value used to round lumcounts, values smaller than 1/255 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

#define LIGHTING_SOFT_THRESHOLD 0.05 // If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting overlays.

// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		0, 0, 0, 1           \
	)                        \

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

//Some defines to generalise colours used in lighting.
//Important note on colors. Colors can end up significantly different from the basic html picture, especially when saturated
#define LIGHT_COLOR_RED        "#FA8282" //Warm but extremely diluted red. rgb(250, 130, 130)
#define LIGHT_COLOR_GREEN      "#64C864" //Bright but quickly dissipating neon green. rgb(100, 200, 100)
#define LIGHT_COLOR_BLUE       "#6496FA" //Cold, diluted blue. rgb(100, 150, 250)

#define LIGHT_COLOR_CYAN       "#7DE1E1" //Diluted cyan. rgb(125, 225, 225)
#define LIGHT_COLOR_PINK       "#E17DE1" //Diluted, mid-warmth pink. rgb(225, 125, 225)
#define LIGHT_COLOR_YELLOW     "#E1E17D" //Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define LIGHT_COLOR_BROWN      "#966432" //Clear brown, mostly dim. rgb(150, 100, 50)
#define LIGHT_COLOR_ORANGE     "#FA9632" //Mostly pure orange. rgb(250, 150, 50)

//These ones aren't a direct colour like the ones above, because nothing would fit
#define LIGHT_COLOR_FIRE       "#FAA019" //Warm orange color, leaning strongly towards yellow. rgb(250, 160, 25)
#define LIGHT_COLOR_FLARE      "#FA644B" //Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define LIGHT_COLOR_SLIME_LAMP "#AFC84B" //Weird color, between yellow and green, very slimy. rgb(175, 200, 75)
#define LIGHT_COLOR_TUNGSTEN   "#FAE1AF" //Extremely diluted yellow, close to skin color (for some reason). rgb(250, 225, 175)
#define LIGHT_COLOR_HALOGEN    "#F0FAFA" //Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)


#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null