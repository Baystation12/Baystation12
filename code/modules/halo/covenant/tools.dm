


/* ENGINERING TOOLS */

/obj/item/weapon/wrench/covenant
	icon = 'tools.dmi'

/obj/item/weapon/screwdriver/covenant
	icon = 'tools.dmi'
	rand_colour = 0

/obj/item/weapon/wirecutters/covenant
	icon = 'tools.dmi'
	rand_colour = 0

/obj/item/weapon/weldingtool/covenant
	icon = 'tools.dmi'

/obj/item/weapon/crowbar/covenant
	icon = 'tools.dmi'

/obj/item/device/multitool/covenant
	icon = 'tools.dmi'



/* MEDICAL TOOLS */

/obj/item/weapon/hemostat/covenant
	icon = 'tools.dmi'

/obj/item/weapon/scalpel/covenant
	icon = 'tools.dmi'

/obj/item/weapon/retractor/covenant
	icon = 'tools.dmi'

/obj/item/weapon/cautery/covenant
	icon = 'tools.dmi'

/obj/item/weapon/circular_saw/covenant
	icon = 'tools.dmi'

/obj/item/weapon/surgicaldrill/covenant
	icon = 'tools.dmi'

/obj/item/weapon/bonesetter/covenant
	icon = 'tools.dmi'



/* OTHER */

/obj/item/weapon/storage/belt/covenant
	name = "Covenant utility belt"
	desc = "A belt of durable leather, festooned with hooks, slots, and pouches."
	description_info = "The tool-belt has enough slots to carry a full engineer's toolset: screwdriver, crowbar, wrench, welder, cable coil, and multitool. Simply click the belt to move a tool to one of its slots."
	description_fluff = "Good hide is hard to come by in certain regions of the galaxy. When they can't come across it, most TSCs will outfit their crews with toolbelts made of synthesized leather."
	description_antag = "Only amateurs skip grabbing a tool-belt."
	icon = 'tools.dmi'
	item_state = "securitybelt"
	//species_restricted = list("Unggoy","Jiralhanae","San-Shyuum","Sangheili","Kig-Yar","Tvaoan Kig-Yar")
	can_hold = list(
		///obj/item/weapon/combitool,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/hatchet,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/taperoll,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/clothing/gloves/insulated
		)
	sprite_sheets = list(
		"Tvaoan Kig-Yar" = null,\
		"Sangheili" = null\
		)

/obj/item/weapon/cell/covenant
	name = "covenant power cell"
	desc = "A small plasma based power storage device."
	icon = 'tools.dmi'
	icon_state = "cell"

/obj/item/cov_fuel
	name = "covenant H-fuel"
	desc = "An advanced hydrogen derivative fuel packet for Covenant technology."
	icon = 'tools.dmi'
	icon_state = "hfuel"
