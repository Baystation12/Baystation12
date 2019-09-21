//This file sets up zlevels
/datum/scene/torch
	//Authortime
	//------------------
	name = "SEV Torch" //The name of the location. This may be shown in interfaces and should be human-readable
	id = "sev_torch"	  //ID must be unique, landmarks will use it to link levels to this scene datum

//Base type of level, this one won't be instantiated but subtypes will
/datum/level/torch
	//Authortime
	//----------------
	name = "Deck 0" //Name of the level. This should NOT include the name of the scene, as that will be automatically prepended in most cases
	id	=	"torch_deck0" //ID of the level, this must be unique, so do include the scene name in this case. this will be used for a landmark to find this level
	scene_id = "sev_torch"	//ID of the scene, must be unique, used to link this level to the scene datum
	base_type	= /datum/level/torch //The parent/base type of this level. It will be excluded from the all_level_datums list




/datum/level/torch/hangar
	//Authortime
	//----------------
	name = "Hangar Deck"
	id	=	"torch_deck5"
	connections = list(UP_S = "torch_deck4")

/obj/effect/landmark/map_data/torch/hangar
	level_id	=	"torch_deck5"



/datum/level/torch/supply
	//Authortime
	//----------------
	name = "Supply Deck"
	id	=	"torch_deck4"
	connections = list(UP_S = "torch_deck3",
	DOWN_S =  "torch_deck5")

/obj/effect/landmark/map_data/torch/supply
	level_id	=	"torch_deck4"


/datum/level/torch/hab
	//Authortime
	//----------------
	name = "Habitation Deck"
	id	=	"torch_deck3"

	connections = list(UP_S = "torch_deck2",
	DOWN_S =  "torch_deck4")

/obj/effect/landmark/map_data/torch/hab
	level_id	=	"torch_deck3"



/datum/level/torch/ops
	//Authortime
	//----------------
	name = "Operations Deck"
	id	=	"torch_deck2"

	connections = list(UP_S = "torch_deck1",
	DOWN_S =  "torch_deck3")

/obj/effect/landmark/map_data/torch/ops
	level_id	=	"torch_deck2"

/datum/level/torch/medical
	//Authortime
	//----------------
	name = "Medical Deck"
	id	=	"torch_deck1"
	connections = list(UP_S = "torch_deck0",
	DOWN_S =  "torch_deck2")

/obj/effect/landmark/map_data/torch/medical
	level_id	=	"torch_deck1"



/datum/level/torch/bridge
	//Authortime
	//----------------
	name = "Command Deck"
	id	=	"torch_deck0"
	connections = list(DOWN_S =  "torch_deck1")

/obj/effect/landmark/map_data/torch/bridge
	level_id	=	"torch_deck0"
