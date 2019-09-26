#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)

#define MOVING_DELIBERATELY(X) (X.move_intent.flags & MOVE_INTENT_DELIBERATE)
#define MOVING_QUICKLY(X) (X.move_intent.flags & MOVE_INTENT_QUICK)

#define FOOTSTEP_CARPET 	"carpet"
#define FOOTSTEP_TILES 		"tiles"
#define FOOTSTEP_PLATING 	"plating"
#define FOOTSTEP_WOOD 		"wood"
#define FOOTSTEP_ASTEROID 	"asteroid"
#define FOOTSTEP_GRASS 		"grass"
#define FOOTSTEP_WATER		"water"
#define FOOTSTEP_BLANK		"blank"
#define FOOTSTEP_CATWALK	"catwalk"
#define FOOTSTEP_LAVA		"lava"
#define FOOTSTEP_SNOW		"snow"
#define FOOTSTEP_SAND		"sand"

//Bitflags for methods of z movement
#define ZMOVE_PHASE		0	//Includes ghost/admin/BST movement. Can never fail, and thus is the default
#define ZMOVE_FLIGHT	1	//Includes jetpacks, wings, antigrav, hovering, etc. Flight using some kind of ingame means.
	//Generally never fails, but it will go slower when moving against gravity
#define ZMOVE_STRUCTURE_CLIMB	2	//Includes climbing up walls and ship spokes. Generally requires 0g or superhuman climbing abilities
#define ZMOVE_OBJECT_CLIMB		4	//Climbing Ladders, stairs, and stacks of dense objects.
//This is primarily a seperate category so that these can be prevented from making certain very long zjourneys