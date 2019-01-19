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

	on_item_icon_states = list(\
		"Suppressor" = "MA5-Suppressor",
		"Scope" = "MA5-Scope",
		"underslung shotgun" = "MA5-Shotgun",
		"MA5 stock cheekrest" = "MA5-Cheekrest",
		"MA5 basic stock butt" = "MA5-Butt-Basic",
		"MA5 extended stock butt" = "MA5-Butt-Extended",
		"MA5 underbarrel grip" = "MA5-Grip-Compact",
		"underslung shotgun" = "MA5-Shotgun",
		"MA5 basic upper" = "MA5-Top-Basic",
		"MA5 railed upper" = "MA5-Top-Rails")

	weapon_pixel_offsets = list(\
	"Suppressor" = list(0,0),
	"Scope" = list(0,0),
	"underslung shotgun" = list(0,0), //most of these are pre-aligned for the ma5b and therfore require no modification
	"MA5 stock cheekrest" = list(0,0),
	"MA5 basic stock butt" = list(0,0),
	"MA5 extended stock butt" = list(0,0),
	"MA5 underbarrel grip" = list(0,0),
	"underslung shotgun" = list(0,0),
	"MA5 basic upper" = list(0,0),
	"MA5 railed upper" = list(0,0)
	)

	attribute_modifications = list(\
		"scope" = list(0,0.5,0.1),
		"Suppressor" = list(0.5,0,0.1),
		"MA5 stock cheekrest" = list(0,0,0),
		"MA5 basic stock butt" = list(0,0,0),
		"MA5 extended stock butt" = list(-0.25,0,0.1),
		"MA5 underbarrel grip" = list(-0.25,0,0.1),
		"underslung shotgun" = list(0.5,0,0.1),
		"MA5 basic upper" = list(0,0,0),
		"MA5 railed upper" = list(0,0,0.1)
		)
