


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

/obj/item/clothing/head/welding/covenant
	icon = 'code/modules/halo/covenant/items/tools.dmi'
	icon_state = "covwelding"
	base_state = "covwelding"

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
/obj/item/weapon/storage/belt/covenant/full/New()
	. = ..()
	new /obj/item/weapon/screwdriver/covenant(src)
	new /obj/item/weapon/wrench/covenant(src)
	new /obj/item/weapon/weldingtool/covenant(src)
	new /obj/item/weapon/crowbar/covenant(src)
	new /obj/item/weapon/wirecutters/covenant(src)
	new /obj/item/device/multitool/covenant(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))

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

/obj/item/device/flashlight/covenant
	name = "luminator"
	icon = 'code/modules/halo/covenant/items/tools.dmi'
	icon_state = "luminator"



/* TOOLBOXES */

/obj/item/weapon/storage/toolbox/covenant_emg
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/weapon/storage/toolbox/covenant_emg/New()
	. = ..()
	new /obj/item/weapon/crowbar/covenant(src)
	var/item = pick(list(/obj/item/device/flashlight/covenant, /obj/item/device/flashlight/glowstick/blue))
	new item(src)
	new /obj/item/device/radio/headset/covenant(src)

/obj/item/weapon/storage/toolbox/covenant_mech
	name = "mechanical toolbox"
	desc = "Bright blue toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/weapon/storage/toolbox/covenant_mech/New()
	. = ..()
	new /obj/item/weapon/screwdriver/covenant(src)
	new /obj/item/weapon/wrench/covenant(src)
	new /obj/item/weapon/weldingtool/covenant(src)
	new /obj/item/weapon/crowbar/covenant(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/weapon/wirecutters/covenant(src)

/obj/item/weapon/storage/toolbox/covenant_elec
	name = "electrical toolbox"
	desc = "Bright yellow toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/weapon/storage/toolbox/covenant_elec/New()
	. = ..()
	new /obj/item/weapon/screwdriver/covenant(src)
	new /obj/item/weapon/wirecutters/covenant(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/weapon/crowbar/covenant(src)
	new /obj/item/stack/cable_coil/random(src,30)
	new /obj/item/stack/cable_coil/random(src,30)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	else
		new /obj/item/stack/cable_coil/random(src,30)
