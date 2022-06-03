/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A, mob/user)
	if (!length(valid_accessory_slots))
		if (user)
			to_chat(user, SPAN_WARNING("\The [src] can't take any attachments."))
		return FALSE

	if (!istype(A) || !(A.slot in valid_accessory_slots))
		if (user)
			to_chat(user, SPAN_WARNING("\The [A] can't attach to \the [src]."))
		return FALSE

	if (accessories.len && restricted_accessory_slots && (A.slot in restricted_accessory_slots))
		for (var/obj/item/clothing/accessory/AC in accessories)
			if (AC.slot == A.slot)
				if (user)
					to_chat(user, SPAN_WARNING("\The [src] can't attach more accessories of that type."))
				return FALSE

	var/bulky = A.get_bulky_coverage()
	if (bulky)
		if (bulky & get_bulky_coverage())
			if (user)
				to_chat(user, SPAN_WARNING("\The [src] is already too bulky to attach \the [A]."))
			return FALSE

		if (ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if (src != H.l_hand && src != H.r_hand)
				for (var/obj/item/clothing/C in H.get_equipped_items())
					if ((C != src) && (C.get_bulky_coverage() & bulky))
						if (user)
							to_chat(user, SPAN_WARNING("\The [A] is too bulky to wear with \the [C]."))
						return FALSE
	return TRUE


/obj/item/clothing/attackby(obj/item/I, mob/user)
	if (attempt_attach_accessory(I, user))
		return
	if (attempt_store_item(I, user))
		return
	..()

/obj/item/clothing/attack_hand(var/mob/user)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(accessories.len && src.loc == user)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attack_hand(user)
		return
	return ..()

/obj/item/clothing/MouseDrop(var/obj/over_object)
	if (!over_object || !(ishuman(usr) || issmall(usr)))
		return

	//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
	if (!(src.loc == usr))
		return

	if (usr.incapacitated())
		return

	switch(over_object.name)
		if("r_hand")
			if (usr.unEquip(src))
				usr.put_in_r_hand(src)
		if("l_hand")
			if (usr.unEquip(src))
				usr.put_in_l_hand(src)
	src.add_fingerprint(usr)

/obj/item/clothing/examine(mob/user)
	. = ..()
	for(var/obj/item/clothing/accessory/A in accessories)
		if (!(A.accessory_flags & ACCESSORY_HIDDEN))
			to_chat(user, "[icon2html(A, user)] \A [A] is attached to it.")
	switch(ironed_state)
		if(WRINKLES_WRINKLY)
			to_chat(user, "<span class='bad'>It's wrinkly.</span>")
		if(WRINKLES_NONE)
			to_chat(user, "<span class='notice'>It's completely wrinkle-free!</span>")
	switch(smell_state)
		if(SMELL_CLEAN)
			to_chat(user, "<span class='notice'>It smells clean!</span>")
		if(SMELL_STINKY)
			to_chat(user, "<span class='bad'>It's quite stinky!</span>")


/obj/item/clothing/proc/update_accessory_slowdown()
	slowdown_accessory = 0
	for(var/obj/item/clothing/accessory/A in accessories)
		slowdown_accessory += A.slowdown

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	accessories += A
	A.on_attached(src, user)
	if (A.accessory_flags & ACCESSORY_REMOVABLE)
		src.verbs |= /obj/item/clothing/proc/removetie_verb
	update_accessory_slowdown()
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!A || !(A in accessories))
		return

	A.on_removed(user)
	accessories -= A
	update_accessory_slowdown()
	update_clothing_icon()


/obj/item/clothing/proc/attempt_attach_accessory(obj/item/I, mob/user)
	if (!istype(I, /obj/item/clothing/accessory))
		return FALSE
	if (can_attach_accessory(I, user) && user.unEquip(I))
		attach_accessory(user, I)
		return TRUE
	if (length(accessories))
		for (var/obj/item/clothing/accessory/A in accessories)
			if (A.attempt_attach_accessory(I, user))
				return TRUE
	return FALSE


/obj/item/clothing/accessory/storage/proc/can_be_inserted(obj/item/I, mob/user, silent)
	return container?.can_be_inserted(I, user, silent)


/obj/item/clothing/accessory/storage/proc/handle_item_insertion(obj/item/I, silent, no_update)
	return container?.handle_item_insertion(I, silent, no_update)


/obj/item/clothing/proc/attempt_store_item(obj/item/I, mob/user, silent)
	for (var/obj/item/clothing/accessory/storage/S in accessories)
		if (S.can_be_inserted(I, user, TRUE) && S.handle_item_insertion(I, silent))
			return TRUE
	return FALSE


/obj/item/clothing/suit/storage/attempt_store_item(obj/item/I, mob/user, silent)
	if (pockets?.can_be_inserted(I, user, TRUE) && pockets.handle_item_insertion(I, silent))
		return TRUE
	return ..()


/obj/item/clothing/accessory/storage/holster/can_be_inserted(obj/item/I, mob/user, silent)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	return H?.can_holster(I)


/obj/item/clothing/accessory/storage/holster/handle_item_insertion(obj/item/I, silent, no_update)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	return H.holster(I, usr)


/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(!accessories.len) return
	var/obj/item/clothing/accessory/A
	var/list/removables = list()
	for(var/obj/item/clothing/accessory/ass in accessories)
		if (ass.accessory_flags & ACCESSORY_REMOVABLE)
			removables |= ass
	if(accessories.len > 1)
		A = input("Select an accessory to remove from [src]") as null|anything in removables
	else
		A = accessories[1]
	src.remove_accessory(usr,A)
	removables -= A
	if(!removables.len)
		src.verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()
