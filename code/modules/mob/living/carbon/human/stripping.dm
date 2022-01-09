/mob/living/carbon/human/proc/handle_strip(var/slot_to_strip_text,var/mob/living/user,var/obj/item/clothing/holder)
	if(!slot_to_strip_text || !istype(user))
		return

	if(user.incapacitated()  || !user.Adjacent(src))
		show_browser(user, null, "window=mob[src.name]")
		return TRUE

	var/strip_delay = HUMAN_STRIP_DELAY

	// Are we placing or stripping?
	var/stripping = FALSE
	var/obj/item/held = user.get_active_hand()

	if (istype(held, /obj/item/grab))
		to_chat(user, SPAN_WARNING("You cannot do this with the hand that has an active grab!"))
		return

	if(!istype(held) || is_robot_module(held))
		stripping = TRUE

	switch (slot_to_strip_text)
		if ("pockets")
			if (stripping)
				visible_message(SPAN_DANGER("\The [user] is trying to empty [src]'s pockets!"))
				if (do_after(user, strip_delay, src, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
					empty_pockets(user)
			else
				visible_message(SPAN_DANGER("\The [user] is trying to stuff \a [held] into \the [src]'s pocket!"))
				if (do_after(user, strip_delay, src, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
					place_in_pockets(held, user)
			return

		if ("sensors")
			visible_message(SPAN_DANGER("\The [user] is trying to set \the [src]'s sensors!"))
			if (do_after(user, strip_delay, src, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
				toggle_sensors(user)
			return

		if ("lock_sensors")
			if (!istype(w_uniform, /obj/item/clothing/under))
				return
			var/obj/item/clothing/under/subject_uniform = w_uniform
			visible_message(SPAN_DANGER("\The [user] is trying to [subject_uniform.has_sensor == SUIT_LOCKED_SENSORS ? "un" : ""]lock \the [src]'s sensors!"), range = 3)
			if (do_after(user, strip_delay, src, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
				if (subject_uniform != w_uniform)
					to_chat(user, SPAN_WARNING("\The [src] is not wearing \the [subject_uniform] anymore."))
					return
				if (!subject_uniform.has_sensor)
					to_chat(user, SPAN_WARNING("\The [subject_uniform] has no sensors to lock."))
					return
				var/obj/item/device/multitool/user_multitool = user.get_multitool()
				if (!istype(user_multitool))
					to_chat(user, SPAN_WARNING("You need a multitool to lock \the [subject_uniform]'s sensors."))
					return
				subject_uniform.has_sensor = subject_uniform.has_sensor == SUIT_LOCKED_SENSORS ? SUIT_HAS_SENSORS : SUIT_LOCKED_SENSORS
				visible_message(SPAN_NOTICE("\The [user] [subject_uniform.has_sensor == SUIT_LOCKED_SENSORS ? "" : "un"]locks \the [subject_uniform]'s suit sensor controls."), range = 3)
			return

		if ("internals")
			visible_message(SPAN_DANGER("\The [usr] is trying to set \the [src]'s internals!"))
			if (do_after(user, strip_delay, src, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
				toggle_internals(user)
			return

		if ("tie")
			if (!istype(holder))
				return
			var/len = length(holder.accessories)
			if (!len)
				return
			var/obj/item/clothing/accessory/A = holder.accessories[1]
			if (len > 1)
				A = input("Select an accessory to remove from [holder]") as null | anything in holder.accessories
			if (isnull(A))
				return
			visible_message(SPAN_DANGER("\The [user] starts trying to remove \the [src]'s [A.name]!"))
			if (!do_after(user, strip_delay, src, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
				return
			if (!A || holder.loc != src || !(A in holder.accessories))
				return
			admin_attack_log(user, src, "Stripped \an [A] from \the [holder].", "Was stripped of \an [A] from \the [holder].", "stripped \an [A] from \the [holder] of")
			holder.remove_accessory(user, A)
			return

		else
			var/obj/item/located_item = locate(slot_to_strip_text) in src
			if (isunderwear(located_item))
				var/obj/item/underwear/UW = located_item
				visible_message(
					SPAN_DANGER("\The [user] starts trying to remove \the [src]'s [UW.name]!"),
					SPAN_WARNING("You start trying to remove \the [src]'s [UW.name]!")
				)
				if (UW.DelayedRemoveUnderwear(user, src))
					admin_attack_log(user, src, "Stripped \an [UW] from \the [holder].", "Was stripped of \an [UW] from \the [holder].", "stripped \an [UW] from \the [holder] of")
					user.put_in_active_hand(UW)
				return

	var/obj/item/target_slot = get_equipped_item(text2num(slot_to_strip_text))
	if (stripping)
		if (!istype(target_slot))  // They aren't holding anything valid and there's nothing to remove, why are we even here?
			return
		if (!target_slot.mob_can_unequip(src, text2num(slot_to_strip_text), disable_warning = TRUE))
			to_chat(user, SPAN_WARNING("You cannot remove \the [src]'s [target_slot.name]."))
			return
		visible_message(SPAN_DANGER("\The [user] is trying to remove \the [src]'s [target_slot.name]!"))
	else
		visible_message(SPAN_DANGER("\The [user] is trying to put \a [held] on \the [src]!"))

	if (!do_after(user, strip_delay, src))
		return

	if (stripping)
		if (unEquip(target_slot))
			admin_attack_log(user, src, "Stripped \a [target_slot]", "Was stripped of \a [target_slot].", "stripped \a [target_slot] from")
			user.put_in_active_hand(target_slot)
		else
			admin_attack_log(user, src, "Attempted to strip \a [target_slot]", "Target of a failed strip of \a [target_slot].", "attempted to strip \a [target_slot] from")
	else if (user.unEquip(held))
		var/obj/item/clothing/C = get_equipped_item(text2num(slot_to_strip_text))
		if (istype(C) && C.can_attach_accessory(held, user))
			C.attach_accessory(user, held)
		else if (!equip_to_slot_if_possible(held, text2num(slot_to_strip_text), del_on_fail = FALSE, disable_warning = FALSE, redraw_mob = TRUE))
			user.put_in_active_hand(held)

/mob/living/carbon/human/proc/empty_pockets(mob/living/user)
	if (!r_store && !l_store)
		to_chat(user, SPAN_WARNING("\The [src] has nothing in their pockets."))
		return
	if (r_store)
		unEquip(r_store)
	if (l_store)
		unEquip(l_store)
	visible_message(SPAN_DANGER("\The [user] empties [src]'s pockets!"))

/mob/living/carbon/human/proc/place_in_pockets(obj/item/I, var/mob/living/user)
	if(!user.unEquip(I))
		return
	if(!r_store)
		if(equip_to_slot_if_possible(I, slot_r_store, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return
	if(!l_store)
		if(equip_to_slot_if_possible(I, slot_l_store, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return
	to_chat(user, "<span class='warning'>You are unable to place [I] in [src]'s pockets.</span>")
	user.put_in_active_hand(I)

// Modify the current target sensor level.
/mob/living/carbon/human/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/under/suit = w_uniform
	if(!suit)
		to_chat(user, "<span class='warning'>\The [src] is not wearing a suit with sensors.</span>")
		return
	if (suit.has_sensor >= 2)
		to_chat(user, "<span class='warning'>\The [src]'s suit sensor controls are locked.</span>")
		return

	admin_attack_log(user, src, "Toggled their suit sensors.", "Toggled their suit sensors.", "toggled the suit sensors of")
	suit.set_sensors(user)

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		visible_message("<span class='danger'>\The [user] disables \the [src]'s internals!</span>")
		internal.add_fingerprint(user)
		set_internals(null)
		return
	else
		// Check for airtight mask/helmet.
		if(!(wear_mask && wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
			if(!(head && head.item_flags & ITEM_FLAG_AIRTIGHT))
				to_chat(user, "<span class='warning'>\The [src] does not have a suitable mask or helmet.</span>")
				return

		// Find an internal source.
		if(istype(back, /obj/item/tank))
			set_internals(back)
		else if(istype(s_store, /obj/item/tank))
			set_internals(s_store)
		else if(istype(r_store, /obj/item/tank))
			set_internals(r_store)
		else if(istype(l_store, /obj/item/tank))
			set_internals(l_store)
		else if(istype(belt, /obj/item/tank))
			set_internals(belt)
		else
			to_chat(user, "<span class='warning'>You could not find a suitable tank!</span>")
			return
		visible_message("<span class='warning'>\The [src] is now running on internals!</span>")
		internal.add_fingerprint(user)
