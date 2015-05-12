/obj/item/device/kit
	var/new_name = "mech"    //What is the variant called?
	var/new_desc = "A mech." //How is the new mech described?
	var/new_icon = "ripley"  //What base icon will the new mech use?
	var/uses = 2        // Uses before the kit deletes itself.

/obj/item/device/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses<1)
		user.drop_item()
		qdel(src)

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "salvage_kit"
	var/new_light_overlay

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O as obj, mob/user as mob)
	if(istype(O,/obj/item/device/kit/suit))

		var/obj/item/device/kit/suit/kit = O
		name = "[kit.new_name] suit helmet"
		desc = kit.new_desc
		icon_state = kit.new_icon
		item_state = kit.new_icon
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay
		user << "You set about modifying the helmet into [src]."
		kit.use(1,user)
		return 1
	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O as obj, mob/user as mob)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		name = "[kit.new_name] voidsuit"
		desc = kit.new_desc
		icon_state = kit.new_icon
		item_state = kit.new_icon
		user << "You set about modifying the suit into [src]."
		kit.use(1,user)
		return 1
	return ..()

// Actual application of this kit is handled in mecha.dm attackby().
/obj/item/device/kit/paint
	name = "mecha customisation kit"
	desc = "A generic kit containing all the needed tools and parts to turn a mech into another mech."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "royce_kit"

	var/removable = null
	var/list/allowed_types = list()