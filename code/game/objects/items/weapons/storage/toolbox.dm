/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Bright red toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 20
	attack_cooldown = 21
	melee_accuracy_bonus = -15
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	use_sound = 'sound/effects/storage/toolbox.ogg'

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	startswith = list(
		/obj/item/weapon/crowbar/red,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/device/radio,
		/obj/item/weapon/weldingtool/mini,
		/obj/item/weapon/welder_tank/mini
	)

/obj/item/weapon/storage/toolbox/emergency/Initialize()
	. = ..()
	var/item = pick(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare,  /obj/item/device/flashlight/flare/glowstick/red))
	new item(src)


/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	desc = "Bright blue toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "blue"
	item_state = "toolbox_blue"
	startswith = list(/obj/item/weapon/screwdriver, /obj/item/weapon/wrench, /obj/item/weapon/weldingtool, /obj/item/weapon/crowbar, /obj/item/device/scanner/gas, /obj/item/weapon/wirecutters)

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	desc = "Bright yellow toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	startswith = list(/obj/item/weapon/screwdriver, /obj/item/weapon/wirecutters, /obj/item/device/t_scanner, /obj/item/weapon/crowbar)

/obj/item/weapon/storage/toolbox/electrical/Initialize()
	. = ..()
	new /obj/item/stack/cable_coil/random(src,30)
	new /obj/item/stack/cable_coil/random(src,30)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	else
		new /obj/item/stack/cable_coil/random(src,30)

/obj/item/weapon/storage/toolbox/syndicate
	name = "black and red toolbox"
	desc = "A toolbox in black, with stylish red trim. This one feels particularly heavy, yet balanced."
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ESOTERIC = 1)
	attack_cooldown = 10
	startswith = list(/obj/item/clothing/gloves/insulated, /obj/item/weapon/screwdriver, /obj/item/weapon/wrench, /obj/item/weapon/weldingtool, /obj/item/weapon/crowbar, /obj/item/weapon/wirecutters, /obj/item/device/multitool)
