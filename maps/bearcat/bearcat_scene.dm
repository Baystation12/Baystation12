//This file sets up zlevels
/datum/scene/bearcat
	//Authortime
	//------------------
	name = "FTV Bearcat" //The name of the location. This may be shown in interfaces and should be human-readable
	id = "ftv_bearcat"	  //ID must be unique, landmarks will use it to link levels to this scene datum

//Base type of level, this one won't be instantiated but subtypes will
/datum/level/bearcat
	//Authortime
	//----------------
	name = "Deck 0" //Name of the level. This should NOT include the name of the scene, as that will be automatically prepended in most cases
	id	=	"bearcat_deck0" //ID of the level, this must be unique, so do include the scene name in this case. this will be used for a landmark to find this level
	scene_id = "ftv_bearcat"	//ID of the scene, must be unique, used to link this level to the scene datum
	base_type	= /datum/level/bearcat //The parent/base type of this level. It will be excluded from the all_level_datums list




/datum/level/bearcat/lower
	//Authortime
	//----------------
	name = "Lower Deck"
	id	=	"bearcat_lower"
	connections = list(UP_S = "bearcat_upper")

/obj/effect/landmark/map_data/bearcat/lower
	level_id	=	"bearcat_lower"



/datum/level/bearcat/upper
	//Authortime
	//----------------
	name = "Upper Deck"
	id	=	"bearcat_upper"
	connections = list(DOWN_S =  "bearcat_lower")

/obj/effect/landmark/map_data/bearcat/upper
	level_id	=	"bearcat_upper"

