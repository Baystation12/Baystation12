/obj/item/device/kit
	icon_state = "modkit"
	icon = 'icons/obj/modkit.dmi'
	var/new_name = "custom item"
	var/new_desc = "A custom item."
	var/new_icon
	var/new_icon_file
	var/new_mob_icon_file
	var/allowed_type
	var/uses = 1        // Uses before the kit deletes itself.

/obj/item/device/kit/examine(mob/user)
	. = ..()
	to_chat(user, "It has [uses] use\s left.")

/obj/item/device/kit/inherit_custom_item_data(var/datum/custom_item/citem)
	new_name = citem.item_name
	new_desc = citem.item_desc
	new_icon = citem.item_icon_state
	new_icon_file = CUSTOM_ITEM_OBJ
	new_mob_icon_file = CUSTOM_ITEM_MOB
	allowed_type = citem.apply_to_target_type
	. = src

/obj/item/device/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses<1)
		qdel(src)

/obj/item/device/kit/proc/can_customize(var/obj/item/I)
	return !allowed_type || istype(I, allowed_type)

/obj/item/device/kit/proc/customize(var/obj/item/I, var/mob/user)
	if(can_customize(I))
		I.SetName(new_name)
		I.desc = new_desc
		I.icon = new_icon_file ? new_icon_file : I.icon
		I.icon_override = new_mob_icon_file ? new_mob_icon_file : I.icon_override
		if(new_icon)
			I.set_icon_state(new_icon)
		var/obj/item/clothing/under/U = I
		if(istype(U))
			U.worn_state = I.icon_state
			U.update_rolldown_status()
		use(1, user)

// Generic use
/obj/item/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/device/kit))
		var/obj/item/device/kit/K = I
		K.customize(src, user)
		return

	. = ..()

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/device/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	var/new_light_overlay

/obj/item/device/kit/suit/can_customize(var/obj/item/I)
	return istype(I, /obj/item/clothing/head/helmet/space/void) || istype(I, /obj/item/clothing/suit/space/void)

/obj/item/device/kit/suit/customize(var/obj/item/I, var/mob/user)
	if(can_customize(I))
		if(istype(I, /obj/item/clothing/head/helmet/space/void))
			var/obj/item/clothing/head/helmet/space/void/helmet = I
			helmet.SetName("[new_name] suit helmet")
			helmet.desc = new_desc
			if(new_icon)
				helmet.icon_state = "[new_icon]_helmet"
				helmet.item_state = "[new_icon]_helmet"
			if(new_icon_file)
				helmet.icon = new_icon_file
			if(new_mob_icon_file)
				helmet.icon_override = new_mob_icon_file
			if(new_light_overlay)
				helmet.light_overlay = new_light_overlay
			to_chat(user, "You set about modifying the helmet into [helmet].")
			var/mob/living/carbon/human/H = user
			if(istype(H))
				helmet.species_restricted = list(H.species.get_bodytype(H))
		else
			var/obj/item/clothing/suit/space/void/suit = I
			suit.SetName("[new_name] voidsuit")
			suit.desc = new_desc
			suit.icon_state = "[new_icon]_suit"
			suit.item_state = "[new_icon]_suit"
			if(new_icon_file)
				suit.icon = new_icon_file
			if(new_mob_icon_file)
				suit.icon_override = new_mob_icon_file
			to_chat(user, "You set about modifying the suit into [suit].")
			var/mob/living/carbon/human/H = user
			if(istype(H))
				suit.species_restricted = list(H.species.get_bodytype(H))
		use(1,user)

/obj/item/device/kit/suit/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	if(citem.additional_data["light_overlay"])
		new_light_overlay = citem.additional_data["light_overlay"]

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		kit.customize(src, user)
	else
		return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		kit.customize(src, user)
	else
		return ..()

/obj/item/device/kit/paint
	name = "exosuit customisation kit"
	desc = "A kit containing all the needed tools and parts to repaint a exosuit."
	var/removable = null

/obj/item/device/kit/paint/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()

	allowed_type = /mob/living/exosuit

/obj/item/device/kit/paint/examine(var/mob/user)
	. = ..()
	to_chat(user, "This kit will add a '[new_name]' decal to a exosuit'.")

/obj/item/device/kit/paint/customize(var/mob/living/exosuit/M, var/mob/user)
	if(can_customize(M))
		user.visible_message(SPAN_NOTICE("\The [user] opens \the [src] and spends some quality time customising \the [M]."))
		M.SetName(new_name)
		M.desc = new_desc
		if(new_icon)
			for(var/obj/item/mech_component/comp in list(M.arms, M.legs, M.head, M.body))
				comp.decal = new_icon
		if(new_icon_file)
			M.icon = new_icon_file
		M.queue_icon_update()
		use(1, user)

/mob/living/exosuit/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/device/kit/paint))
		var/obj/item/device/kit/paint/P = I
		P.customize(src, user)
	else
		return ..()

// exosuit kits.
/obj/item/device/kit/paint/flames_red
	name = "\"Firestarter\" exosuit customisation kit"
	new_icon = "flames_red"

/obj/item/device/kit/paint/flames_blue
	name = "\"Burning Chrome\" exosuit customisation kit"
	new_icon = "flames_blue"

/obj/item/device/kit/paint/camouflage
	name = "\"Guerilla\" exosuit customisation kit"
	desc = "The exact same pattern the 76th Armored Gauntlet used in the Gaia war, now available for general use."
	new_icon = "cammo1"

/obj/item/device/kit/paint/camouflage/forest
	name = "\"Alpine\" exosuit customisation kit"
	new_icon = "cammo2"
	desc = "A muted pattern for alpine environments. Don't miss the forest for the trees!"
