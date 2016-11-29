/*This file is a list of all preclaimed planes & layers

All planes & layers should be given a value here instead of using a magic/arbitrary number.

After fiddling with planes and layers for some time, I figured I may as well provide some documentation:

What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of having planesmasters.

What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.

What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things

How do planes work?
	A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.

How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.

How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.

What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.

*/

/*
	from stddef.dm, planes & layers built into byond.

	FLOAT_LAYER = -1
	AREA_LAYER = 1
	TURF_LAYER = 2
	OBJ_LAYER = 3
	MOB_LAYER = 4
	FLY_LAYER = 5
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	------

	FLOAT_PLANE = -32767
*/

#define CLICKCATCHER_PLANE -99
#define SPACE_PLANE -98

#define BELOW_TURF_PLANE             -22 // objects that are below turfs. Useful for asteroid smoothing or other such magic.
	// TURF_LAYER 2

#define PLATING_PLANE                -21

#define ABOVE_PLATING_PLANE          -20

	#define HOLOMAP_LAYER        1 // NOTE: ENSURE this is equal to the one at ABOVE_TURF_PLANE!
	#define DECAL_PLATING_LAYER  2
	#define DISPOSALS_PIPE_LAYER 3
	#define LATTICE_LAYER        4
	#define PIPE_LAYER           5
	#define WIRE_LAYER           6
	#define WIRE_TERMINAL_LAYER  7
	#define ABOVE_WIRE_LAYER     8

#define TURF_PLANE				-19

	#define BASE_TURF_LAYER -999

#define ABOVE_TURF_PLANE              -18 // For items which should appear above turfs but below other objects and hiding mobs, eg: wires & pipes

	#define HOLOMAP_LAYER               1 // NOTE: ENSURE this is equal to the one at ABOVE_PLATING_PLANE!
	#define RUNE_LAYER                  2
	#define DECAL_LAYER                 3
	#define ABOVE_TILE_LAYER            4
	#define EXPOSED_PIPE_LAYER          5
	#define EXPOSED_WIRE_LAYER          6
	#define EXPOSED_WIRE_TERMINAL_LAYER 7
	#define BLOOD_LAYER                 8
	#define MOUSETRAP_LAYER             9
	#define PLANT_LAYER                 10

#define HIDING_MOB_PLANE              -16 // for hiding mobs like MoMMIs or spiders or whatever, under most objects but over pipes & such.

	#define HIDING_MOB_LAYER 0

#define OBJ_PLANE                     -15 // For objects which appear below humans.
	#define BELOW_DOOR_LAYER        0.25
	#define OPEN_DOOR_LAYER         0.5
	#define BELOW_TABLE_LAYER       0.75
	#define TABLE_LAYER             1
	#define BELOW_OBJ_LAYER         2
	// OBJ_LAYER                    3
	#define ABOVE_OBJ_LAYER         4
	#define CLOSED_DOOR_LAYER       5
	#define ABOVE_DOOR_LAYER        6
	#define SIDE_WINDOW_LAYER       7
	#define FULL_WINDOW_LAYER       8
	#define ABOVE_WINDOW_LAYER      9

#define LYING_MOB_PLANE               -14 // other mobs that are lying down.

	#define LYING_MOB_LAYER 0

#define LYING_HUMAN_PLANE             -13 // humans that are lying down

	#define LYING_HUMAN_LAYER 0

#define ABOVE_OBJ_PLANE               -12 // for objects that are below humans when they are standing but above them when they are not. - eg, blankets.

	#define BASE_ABOVE_OBJ_LAYER 0

#define HUMAN_PLANE                   -11 // For Humans that are standing up.
	// MOB_LAYER 4

#define MOB_PLANE                      -7 // For Mobs.
	// MOB_LAYER 4

#define ABOVE_HUMAN_PLANE              -6 // For things that should appear above humans.

	#define ABOVE_HUMAN_LAYER  0
	#define VEHICLE_LOAD_LAYER 1
	#define CAMERA_LAYER       2

#define BLOB_PLANE                     -5 // For Blobs, which are above humans.

	#define BLOB_SHIELD_LAYER		1
	#define BLOB_NODE_LAYER			2
	#define BLOB_CORE_LAYER			3

#define EFFECTS_BELOW_LIGHTING_PLANE   -4 // For special effects.

	#define BELOW_PROJECTILE_LAYER  2
	#define FIRE_LAYER              3
	#define PROJECTILE_LAYER        4
	#define ABOVE_PROJECTILE_LAYER  5
	#define SINGULARITY_LAYER       6
	#define POINTER_LAYER           7

#define OBSERVER_PLANE                 -3 // For observers and ghosts

#define LIGHTING_PLANE 			       -2 // For Lighting. - The highest plane (ignoring all other even higher planes)

	#define LIGHTBULB_LAYER        0
	#define LIGHTING_LAYER         1
	#define ABOVE_LIGHTING_LAYER   2
	#define SUPER_PORTAL_LAYER     3
	#define NARSIE_GLOW            4

#define EFFECTS_ABOVE_LIGHTING_PLANE   -1 // For glowy eyes, laser beams, etc. that shouldn't be affected by darkness
	#define EYE_GLOW_LAYER         1
	#define BEAM_PROJECTILE_LAYER  2
	#define SUPERMATTER_WALL_LAYER 3

#define BASE_PLANE 				        0 // Not for anything, but this is the default.
	#define BASE_AREA_LAYER 999

#define OBSCURITY_PLANE 		        2 // For visualnets, such as the AI's static.

#define FULLSCREEN_PLANE                3 // for fullscreen overlays that do not cover the hud.

	#define FULLSCREEN_LAYER    0
	#define DAMAGE_LAYER        1
	#define IMPAIRED_LAYER      2
	#define BLIND_LAYER         3
	#define CRIT_LAYER          4
	#define HALLUCINATION_LAYER 5

#define HUD_PLANE                       4 // For the Head-Up Display

	#define UNDER_HUD_LAYER      0
	#define HUD_BASE_LAYER       1
	#define HUD_ITEM_LAYER       2
	#define HUD_ABOVE_ITEM_LAYER 3


/image
	plane = FLOAT_PLANE			// this is defunct, lummox fixed this on recent compilers, but it will bug out if I remove it for coders not on the most recent compile.

/image/proc/plating_decal_layerise()
	plane = ABOVE_PLATING_PLANE
	layer = DECAL_PLATING_LAYER

/image/proc/turf_decal_layerise()
	plane = ABOVE_TURF_PLANE
	layer = DECAL_LAYER

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)

/*
  PLANE MASTERS
*/

/obj/screen/plane_master
	appearance_flags = PLANE_MASTER
	screen_loc = "CENTER,CENTER"
	globalscreen = 1

/obj/screen/plane_master/ghost_master
	plane = OBSERVER_PLANE

/obj/screen/plane_master/ghost_dummy
	// this avoids a bug which means plane masters which have nothing to control get angry and mess with the other plane masters out of spite
	alpha = 0
	appearance_flags = 0
	plane = OBSERVER_PLANE

var/ghost_master = list(new /obj/screen/plane_master/ghost_master(),new /obj/screen/plane_master/ghost_dummy())
