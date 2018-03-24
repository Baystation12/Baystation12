#define ATTACHMENT_BARREL "barrel"
#define ATTACHMENT_SIGHT "sight"
#define ATTACHMENT_STOCK "stock"

//Weapon Attachment Profiles//

/datum/attachment_profile
	var/weapon_name = "Basic Attachment Profile"

	var/list/on_item_icon_states = list() //Associative list. Format: attachment_name = icon_state
	var/list/weapon_pixel_offsets = list()//An associative list. Format: attachment_slot = list(offsetX,offsetY)
	var/list/attribute_modifications = list(0,0,0) //Associative list. Format: attachment_name = list(dispersion,accuracy,slowdown)

/datum/attachment_profile/MA5B
	weapon_name = "\improper MA5B Assault Rifle"

	on_item_icon_states = list("MA5B stock" = "ma5b_attachment",\
		"skeletal stock" = "stock_skeletal_attachment",\
		"Red Dot Sight" = "sight_attachment",\
		"ACOG Sight" = "acog_attachment"
		)
	weapon_pixel_offsets = list(ATTACHMENT_BARREL = list(28,17),ATTACHMENT_SIGHT = list(15,22),ATTACHMENT_STOCK = list(2,9))

	attribute_modifications = list("MA5B stock" = list(-2,0.5,0.25),\
		"skeletal stock" = list(-1.25,0,-0.5),\
		"Red Dot Sight" = list(-0.5,1,0),\
		"ACOG Sight" = list(-0.25,0.5,0),\
		"Suppressor" = list(0.25,0,0)
		)
