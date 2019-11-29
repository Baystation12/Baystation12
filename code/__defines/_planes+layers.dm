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

#define CLICKCATCHER_PLANE -100

#define SPACE_PLANE               -99
	#define SPACE_LAYER                  1
#define SKYBOX_PLANE              -98
	#define SKYBOX_LAYER                 1

#define DUST_PLANE                 -97
	#define DEBRIS_LAYER                 1
	#define DUST_LAYER                   2

// Openspace uses planes -80 through -70.

#define OVER_OPENSPACE_PLANE        -3

#define DEFAULT_PLANE                   0
	#define PLATING_LAYER               1
	//ABOVE PLATING
	#define HOLOMAP_LAYER               1.01
	#define DECAL_PLATING_LAYER         1.02
	#define DISPOSALS_PIPE_LAYER        1.03
	#define LATTICE_LAYER               1.04
	#define PIPE_LAYER                  1.05
	#define WIRE_LAYER                  1.06
	#define WIRE_TERMINAL_LAYER         1.07
	#define ABOVE_WIRE_LAYER            1.08
	//TURF PLANE
	//TURF_LAYER = 2
	#define TURF_DETAIL_LAYER           2.01
	#define TURF_SHADOW_LAYER           2.02
	//ABOVE TURF
	#define DECAL_LAYER                 2.03
	#define RUNE_LAYER                  2.04
	#define ABOVE_TILE_LAYER            2.05
	#define EXPOSED_PIPE_LAYER          2.06
	#define EXPOSED_WIRE_LAYER          2.07
	#define EXPOSED_WIRE_TERMINAL_LAYER 2.08
	#define CATWALK_LAYER               2.09
	#define BLOOD_LAYER                 2.10
	#define MOUSETRAP_LAYER             2.11
	#define PLANT_LAYER                 2.12
	#define AO_LAYER                    2.13
	//HIDING MOB
	#define HIDING_MOB_LAYER            2.14
	#define SHALLOW_FLUID_LAYER         2.15
	#define MOB_SHADOW_LAYER            2.16
	//OBJ
	#define BELOW_DOOR_LAYER            2.17
	#define OPEN_DOOR_LAYER             2.18
	#define BELOW_TABLE_LAYER           2.19
	#define TABLE_LAYER                 2.20
	#define BELOW_OBJ_LAYER             2.21
	#define STRUCTURE_LAYER             2.22
	// OBJ_LAYER                        3
	#define ABOVE_OBJ_LAYER             3.01
	#define CLOSED_DOOR_LAYER           3.02
	#define ABOVE_DOOR_LAYER            3.03
	#define SIDE_WINDOW_LAYER           3.04
	#define FULL_WINDOW_LAYER           3.05
	#define ABOVE_WINDOW_LAYER          3.06
	//LYING MOB AND HUMAN
	#define LYING_MOB_LAYER             3.07
	#define LYING_HUMAN_LAYER           3.08
	#define BASE_ABOVE_OBJ_LAYER        3.09
	//HUMAN
	#define BASE_HUMAN_LAYER            3.10
	//MOB
	#define MECH_UNDER_LAYER            3.11
	// MOB_LAYER                        4
	#define MECH_BASE_LAYER             4.01
	#define MECH_INTERMEDIATE_LAYER     4.02
	#define MECH_PILOT_LAYER            4.03
	#define MECH_LEG_LAYER              4.04
	#define MECH_COCKPIT_LAYER          4.05
	#define MECH_ARM_LAYER              4.06
	#define MECH_GEAR_LAYER             4.07
	//ABOVE HUMAN
	#define ABOVE_HUMAN_LAYER           4.08
	#define VEHICLE_LOAD_LAYER          4.09
	#define CAMERA_LAYER                4.10
	//BLOB
	#define BLOB_SHIELD_LAYER           4.11
	#define BLOB_NODE_LAYER             4.12
	#define BLOB_CORE_LAYER	            4.13
	//EFFECTS BELOW LIGHTING
	#define BELOW_PROJECTILE_LAYER      4.14
	#define DEEP_FLUID_LAYER            4.15
	#define FIRE_LAYER                  4.16
	#define PROJECTILE_LAYER            4.17
	#define ABOVE_PROJECTILE_LAYER      4.18
	#define SINGULARITY_LAYER           4.19
	#define POINTER_LAYER               4.20
	#define MIMICED_LIGHTING_LAYER      4.21	// Z-Mimic-managed lighting

	//FLY_LAYER                          5
	//OBSERVER
	#define OBSERVER_LAYER              5.1

	#define OBFUSCATION_LAYER           5.2
	#define BASE_AREA_LAYER             999

#define OBSERVER_PLANE             1

#define LIGHTING_PLANE             2 // For Lighting. - The highest plane (ignoring all other even higher planes)
	#define LIGHTBULB_LAYER        0
	#define LIGHTING_LAYER         1
	#define ABOVE_LIGHTING_LAYER   2

#define EFFECTS_ABOVE_LIGHTING_PLANE   3 // For glowy eyes, laser beams, etc. that shouldn't be affected by darkness
	#define EYE_GLOW_LAYER         1
	#define BEAM_PROJECTILE_LAYER  2
	#define SUPERMATTER_WALL_LAYER 3

#define FULLSCREEN_PLANE                4 // for fullscreen overlays that do not cover the hud.

	#define FULLSCREEN_LAYER    0
	#define DAMAGE_LAYER        1
	#define IMPAIRED_LAYER      2
	#define BLIND_LAYER         3
	#define CRIT_LAYER          4

#define HUD_PLANE                    5
	#define UNDER_HUD_LAYER              0
	#define HUD_BASE_LAYER               2
	#define HUD_ITEM_LAYER               3
	#define HUD_ABOVE_ITEM_LAYER         4


//This is difference between planes used for atoms and effects
#define PLANE_DIFFERENCE              3

/atom
	plane = DEFAULT_PLANE

/image/proc/plating_decal_layerise()
	plane = DEFAULT_PLANE
	layer = DECAL_PLATING_LAYER

/image/proc/turf_decal_layerise()
	plane =  DEFAULT_PLANE
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

GLOBAL_LIST_INIT(ghost_master, list(
	new /obj/screen/plane_master/ghost_master(),
	new /obj/screen/plane_master/ghost_dummy()
))
