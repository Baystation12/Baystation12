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
		"MA5B suppressor" = "MA5-Suppressor",
		"MA5B scope" = "MA5-Scope",
		"underslung shotgun" = "MA5-Shotgun",
		"MA5 stock cheekrest" = "MA5-Cheekrest",
		"MA5 basic stock butt" = "MA5-Butt-Basic",
		"MA5 extended stock butt" = "MA5-Butt-Extended",
		"MA5 underbarrel grip" = "MA5-Grip-Compact",
		"underslung shotgun" = "MA5-Shotgun",
		"MA5 basic upper" = "MA5-Top-Basic",
		"MA5 railed upper" = "MA5-Top-Rails",
		"underslung grenade launcher" = "underslung grenade launcher",
		"flashlight attachment" = "MA5-Grip-Basic-FlashlightOff")

	weapon_pixel_offsets = list(\
	"MA5B suppressor" = list(0,0),
	"MA5B scope" = list(0,0),
	"underslung shotgun" = list(0,0), //most of these are pre-aligned for the ma5b and therfore require no modification
	"MA5 stock cheekrest" = list(0,0),
	"MA5 basic stock butt" = list(0,0),
	"MA5 extended stock butt" = list(0,0),
	"MA5 underbarrel grip" = list(0,0),
	"underslung shotgun" = list(0,0),
	"MA5 basic upper" = list(0,0),
	"MA5 railed upper" = list(0,0),
	"underslung grenade launcher" = list(0,0),
	"flashlight attachment" = list(0,0)
	)

	attribute_modifications = list(\
		"MA5B scope" = list(0,0.5,0.1),
		"MA5B suppressor" = list(0.5,0,0.1),
		"MA5 stock cheekrest" = list(0,0,0),
		"MA5 basic stock butt" = list(0,0,0),
		"MA5 extended stock butt" = list(-0.25,0,0.1),
		"MA5 underbarrel grip" = list(-0.25,0,0.1),
		"underslung shotgun" = list(0.5,0,0.2),
		"MA5 basic upper" = list(0,0,0),
		"MA5 railed upper" = list(0,0,0.1),
		"underslung grenade launcher" = list(0,0,0,2),
		"flashlight attachment" = list(0,0,0.1)
		)

/datum/attachment_profile/BR55
	weapon_name = "\improper BR55 Battle Rifle"
	on_item_icon_states = list(\
		"BR55 barrel attachment" = "BR55-Barrel",
		"BR55 suppressor" = "BR55-Suppressor",
		"BR55 scope" = "BR55-CarryHandle-Scope",
		"BR55 cheekrest" = "BR55-Cheekrest",
		"BR55 hand guard" = "BR55-Bottom",
		"BR55 vertical grip" = "BR55-Grip",
		"BR55 carry handle" = "BR55-CarryHandle")
	weapon_pixel_offsets = list(\
	"BR55 suppressor" = list(3,0),
	"BR55 barrel attachment" = list(3,0),
	"BR55 scope" = list(0,0),
	"BR55 cheekrest" = list(0,0),
	"BR55 hand guard" = list(0,0),
	"BR55 vertical grip" = list(0,0),
	"BR55 carry handle" = list(0,0)
	)
	attribute_modifications = list(\
		"BR55 suppressor" = list(-0.5,0.5,0),
		"BR55 barrel attachment" = list(0,1,0),
		"BR55 scope" = list(0,0,0),
		"BR55 cheekrest" = list(0,0,0),
		"BR55 hand guard" = list(0,0,0),
		"BR55 vertical grip" = list(-0.75,0.5,0),
		"BR55 carry handle" = list(0,0,0)
		)