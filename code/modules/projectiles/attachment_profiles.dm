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
		"suppressor" = "suppressor",
		"red dot sight" = "red-dot",
		"acog sight" = "acog-scope",
		"underslung shotgun" = "MA5-Shotgun",
		"MA5 stock cheekrest" = "MA5-Cheekrest",
		"MA5 basic stock butt" = "MA5-Butt-Basic",
		"MA5 extended stock butt" = "MA5-Butt-Extended",
		"vertical grip" = "vertical-grip",
		"underslung shotgun" = "Underbarrel-Shotgun",
		"MA5 basic upper" = "MA5-Top-Basic",
		"underslung grenade launcher" = "underslung grenade launcher",
		"flashlight attachment" = "Underbarrel-Flashlight",
		"MA5 railed upper" = "MA5-Top-Rails")

	weapon_pixel_offsets = list(\
	"suppressor" = list(3,2),
	"red dot sight" = list(1,8),
	"acog sight" = list(-2,5),
	"underslung shotgun" = list(0,0), //most of these are pre-aligned for the ma5b and therfore require no modification
	"MA5 stock cheekrest" = list(0,0),
	"MA5 basic stock butt" = list(0,0),
	"MA5 extended stock butt" = list(0,0),
	"vertical grip" = list(-4,2),
	"underslung shotgun" = list(0,0),
	"MA5 basic upper" = list(0,0),
	"underslung grenade launcher" = list(0,0),
	"flashlight attachment" = list(0,0),
	"MA5 railed upper" = list(0,0)
	)

	attribute_modifications = list(\
		"red dot sight" = list(0,0.5,0,005),
		"acog sight" = list(0,0.5,0.005),
		"suppressor" = list(0.1,0,0.01),
		"MA5 stock cheekrest" = list(0,0,0),
		"MA5 basic stock butt" = list(0,0,0),
		"MA5 extended stock butt" = list(-0.25,0,0),
		"vertical grip" = list(-0.1,0.5,0),
		"underslung shotgun" = list(0.5,0,0,0.02),
		"MA5 basic upper" = list(0,0,0),
		"underslung grenade launcher" = list(0,0,0,0.03),
		"flashlight attachment" = list(0,0,0.01),
		"MA5 railed upper" = list(0,0,0,005)
		)

/datum/attachment_profile/BR55
	weapon_name = "\improper BR55 Battle Rifle"
	on_item_icon_states = list(\
		"BR55 barrel attachment" = "BR55-Barrel",
		"suppressor" = "suppressor",
		"BR55 scope" = "BR55-CarryHandle-Scope",
		"BR55 cheekrest" = "BR55-Cheekrest",
		"SOE underslung shotgun" = "Underbarrel-Shotgun-SOE",
		"BR55 hand guard" = "BR55-Bottom",
		"vertical grip" = "vertical-grip",
		"BR55 carry handle" = "BR55-CarryHandle",
		"red dot sight" = "red-dot",
		"acog sight" = "acog-scope",
		"flashlight attachment" = "Underbarrel-Flashlight")

	weapon_pixel_offsets = list(\
	"suppressor" = list(3,0),
	"BR55 barrel attachment" = list(3,0),
	"BR55 scope" = list(0,0),
	"BR55 cheekrest" = list(0,0),
	"SOE underslung shotgun" = list(0,1),
	"BR55 hand guard" = list(0,0),
	"vertical grip" = list(0,0),
	"BR55 carry handle" = list(0,0),
	"red dot sight" = list(2,6),
	"acog sight" = list(0,4),
	"flashlight attachment" = list(4,-2)
	)
	attribute_modifications = list(\
		"suppressor" = list(0.1,0.5,0),
		"BR55 barrel attachment" = list(0,0,0),
		"BR55 scope" = list(0,0,0),
		"BR55 cheekrest" = list(0,0,0),
		"SOE underslung shotgun" = list(0.5,0,0.01),
		"BR55 hand guard" = list(0,0,0),
		"vertical grip" = list(-0.1,0.5,0),
		"BR55 carry handle" = list(0,0,0),
		"red dot sight" = list(0,0.5,0.01),
		"acog sight" = list(0,0.5,0.01),
		"flashlight attachment" = list(0,0,0.01)
		)

/datum/attachment_profile/M395
	weapon_name = "M392 Designated Marksman Rifle"
	on_item_icon_states = list(\
		"M395 barrel attachment" = "M395-Barrel",
		"suppressor" = "suppressor",
		"Red Dot Sight" = "red-dot",
		"acog sight" = "acog-scope",
		"M395 scope" = "M395-Scope")
	weapon_pixel_offsets = list(\
	"suppressor" = list(4,0),
	"M395 barrel attachment" = list(5,0),
	"red dot sight" = list(-1,3),
	"acog sight" = list(-3,2),
	"M395 scope" = list(0,0)
	)
	attribute_modifications = list(\
		"suppressor" = list(0.1,0.5,0),
		"M395 barrel attachment" = list(0,0,0),
		"red dot sight" = list(0,0.5,0.1),
		"acog sight" = list(0,0.5,0.1),
		"M395 scope" = list(0,0,0)
		)

/datum/attachment_profile/M395/innie
	weapon_name = "Modified M392 DMR"
	on_item_icon_states = list(\
		"M395 barrel attachment" = "M395-Barrel",
		"suppressor" = "suppressor",
		"red dot sight" = "red-dot",
		"acog sight" = "acog-scope",
		"M395 scope" = "M395-Scope")
	weapon_pixel_offsets = list(\
	"suppressor" = list(4,0),
	"M395 barrel attachment" = list(5,0),
	"red dot sight" = list(-1,3),
	"acog sight" = list(-3,2),
	"M395 scope" = list(0,0)
	)
	attribute_modifications = list(\
		"suppressor" = list(0.1,0.5,0),
		"M395 barrel attachment" = list(0,0,0),
		"red dot sight" = list(0,0.5,0.01),
		"acog sight" = list(0,0.5,0.01),
		"M395 scope" = list(0,0,0)
		)

/datum/attachment_profile/ma5b_ar/MA3
	weapon_name = "\improper MA3 Assault Rifle"
	on_item_icon_states = list(\
		"suppressor" = "suppressor",
		"flashlight attachment" = "Underbarrel-Flashlight",
		"vertical grip" = "vertical-grip",
		"red dot sight" = "red-dot",
		"acog sight" = "acog-scope",
		"SOE underslung shotgun" = "Underbarrel-Shotgun-SOE")
	weapon_pixel_offsets = list(\
	"suppressor" = list(4,0),
	"SOE underslung shotgun" = list(0,0),
	"vertical grip" = list(0,-1),
	"red dot sight" = list(1,6),
	"acog sight" = list(-1,5),
	"flashlight attachment" = list(3,-3)
	)
	attribute_modifications = list(\
		"SOE underslung shotgun" = list(0.5,0,0),
		"vertical grip" = list(-0.1,0.5,0),
		"red dot sight" = list(0,0.5,0.01),
		"acog sight" = list(0,0.5,0.1),
		"flashlight attachment" = list(0,0,0.01),
		"suppressor" = list(0.1,0.5,0)
		)
       //dispersion,accuracy,slowdown//