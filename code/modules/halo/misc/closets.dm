//for job related closets see the relevant files in code/modules/halo/jobs


/obj/structure/closet/wall_emergency
	name = "emergency closet"
	desc = "It's a wall-mounted UNSC storage unit for emergency tools and supplies."
	icon_state = "hydrant"
	icon_closed = "hydrant"
	icon_opened = "hydrant_open"
	anchored = 1
	density = 0
	wall_mounted = 1
	large = 0

/obj/structure/closet/wall_emergency/New()
	..()
	new /obj/item/device/flashlight/unsc(src)
	new /obj/item/device/flashlight/unsc(src)
	new /obj/item/device/flashlight/unsc(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/crowbar(src)

/obj/structure/closet/wall_medical //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's wall-mounted UNSC storage unit for first aid supplies."
	icon_state = "medical_wall"
	icon_closed = "medical_wall"
	icon_opened = "medical_wall_open"
	anchored = 1
	density = 0
	wall_mounted = 1
	large = 0

/obj/structure/closet/wall_medical/New()
	..()
	new /obj/item/weapon/storage/firstaid/unsc(src)
	new /obj/item/weapon/storage/firstaid/unsc(src)
	new /obj/item/weapon/storage/firstaid/unsc(src)
	new /obj/item/weapon/storage/firstaid/unsc(src)

/obj/structure/oxy_dispenser
	name = "emergency oxygen dispenser"
	desc = "It's a wall-mounted UNSC dispenser for emergency equipment in case of a hull breach."
	icon = 'code/modules/halo/misc/emtankdispensersmall.dmi'
	icon_state = "dispenser"
	anchored = 1
	density = 0
	var/contents_type = /obj/item/weapon/storage/firstaid/erk
	var/max_contents = 8
	var/can_dispense = 1
	var/dispense_level = 6

/obj/structure/oxy_dispenser/New()
	..()
	while(src.contents.len < max_contents)
		new contents_type(src)
	overlays += "dispenser_on"
	update_icon()

/obj/structure/oxy_dispenser/update_icon()
	overlays -= "dispenser_[dispense_level]"
	dispense_level = max(min(round(src.contents.len / max_contents * 6), 6), 0)
	overlays += "dispenser_[dispense_level]"

/obj/structure/oxy_dispenser/attack_hand()
	if(src.contents.len)
		for(var/atom/movable/A in src)
			A.loc = src.loc
			src.visible_message("\icon[src] <span class='info'>\the [src] dispenses \icon[A] \a [A].</span>")
			break
		update_icon()
		if(!src.contents.len)
			overlays -= "dispenser_on"

/obj/structure/oxy_dispenser/eng
	icon_state = "dispenser_eng"
	contents_type = /obj/item/weapon/storage/firstaid/erk/eng

/obj/structure/oxy_dispenser/large
	icon = 'code/modules/halo/misc/emtankdispenser.dmi'
	max_contents = 12
