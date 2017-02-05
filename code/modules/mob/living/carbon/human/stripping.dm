/mob/living/carbon/human/proc/handle_strip(var/slot_to_strip_text,var/mob/living/user)

	if(!slot_to_strip_text || !istype(user))
		return

	if(user.incapacitated()  || !user.Adjacent(src))
		user << browse(null, text("window=mob[src.name]"))
		return

	var/obj/item/target_slot = get_equipped_item(text2num(slot_to_strip_text))

	// Are we placing or stripping?
	var/stripping
	var/obj/item/held = user.get_active_hand()
	if(!istype(held) || is_robot_module(held))
		stripping = 1

	switch(slot_to_strip_text)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("pockets")
			if(stripping)
				visible_message("<span class='danger'>\The [user] is trying to empty [src]'s pockets!</span>")
				if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
					empty_pockets(user)
			else
				//should it be possible to discreetly slip something into someone's pockets?
				visible_message("<span class='danger'>\The [user] is trying to stuff \a [held] into [src]'s pocket!</span>")
				if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
					place_in_pockets(held, user)
			return
		if("splints")
			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s splints!</span>")
			if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
				remove_splints(user)
			return
		if("sensors")
			visible_message("<span class='danger'>\The [user] is trying to set \the [src]'s sensors!</span>")
			if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
				toggle_sensors(user)
			return
		if("internals")
			visible_message("<span class='danger'>\The [usr] is trying to set \the [src]'s internals!</span>")
			if(do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
				toggle_internals(user)
			return
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!stripping && istype(held, /obj/item/clothing/accessory))
				if(!suit.can_attach_accessory(held))
					to_chat(user, "<span class='warning'>You cannot attach this to [src]'s [suit.name]!</span>")
					return

				visible_message("<span class='danger'>\The [usr] is trying to attach \a [held] to [src]'s [suit.name]!</span>")

				if(!do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
					return

				user.drop_item()
				suit.attach_accessory(user, held)

				if(istype(held, /obj/item/clothing/accessory/badge) || istype(held, /obj/item/clothing/accessory/medal))
					user.visible_message("<span class='danger'>\The [user] pins \the [held] on [src]'s [suit.name]!</span>")
					admin_attack_log(user, src, "pinned \an [held] on \the [suit].", "Was awarded \an [held] to \the [suit].", "awarded \an [held] to \the [suit] of")
				else
					user.visible_message("<span class='danger'>\The [user] attaches \the [held] to [src]'s [suit.name]!</span>")
					admin_attack_log(user, src, "attached \an [held] to \the [suit].", "Had attached \an [held] to their [suit].", "attached \an [held] to \the [suit] of")
				return

			else
				if(!suit.accessories.len)
					return

				var/obj/item/clothing/accessory/A = suit.accessories[1]
				if(!istype(suit) || !suit.accessories.len)
					return


				if(suit.accessories.len > 1)
					A = input("Select an accessory to remove from [src]") as null|anything in suit.accessories

				if(!istype(A))
					return
				if(!user.incapacitated()  && user.Adjacent(src))
					visible_message("<span class='danger'>\The [usr] is trying to remove \the [src]'s [A.name]!</span>")

				if(!do_after(user, HUMAN_STRIP_DELAY, src, progress = 0))
					return

				if(!A || suit.loc != src || !(A in suit.accessories))
					return

				if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
					user.visible_message("<span class='danger'>\The [user] tears off \the [A] from [src]'s [suit.name]!</span>")
				admin_attack_log(user, src, "Stripped \an [A] from \the [suit].", "Was stripped of \an [A] from \the [suit].", "stripped \an [A] from \the [suit] of")
				A.on_removed(user)
				suit.accessories -= A
				update_inv_w_uniform()
				return

	if(stripping)
		if(!istype(target_slot))  // They aren't holding anything valid and there's nothing to remove, why are we even here?
			return
		if(!target_slot.mob_can_unequip(src, text2num(slot_to_strip_text), disable_warning=1))
			to_chat(user, "<span class='warning'>You cannot remove \the [src]'s [target_slot.name].</span>")
			return

		visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s [target_slot.name]!</span>")
	else
		visible_message("<span class='danger'>\The [user] is trying to put \a [held] on \the [src]!</span>")

	if(!do_mob(user, src, HUMAN_STRIP_DELAY))
		return

	if(stripping)
		if(unEquip(target_slot))
			admin_attack_log(user, src, "Stripped \a [target_slot]", "Was stripped of \a [target_slot].", "stripped \a [target_slot] from")
			user.put_in_active_hand(target_slot)
		else
			admin_attack_log(user, src, "Attempted to strip \a [target_slot]", "Target of a failed strip of \a [target_slot].", "attempted to strip \a [target_slot] from")
	else if(user.unEquip(held))
		if(!equip_to_slot_if_possible(held, text2num(slot_to_strip_text), del_on_fail=0, disable_warning=1, redraw_mob=1))
			user.put_in_active_hand(held)

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(var/mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, "<span class='warning'>\The [src] has nothing in their pockets.</span>")
		return
	if(r_store)
		unEquip(r_store)
	if(l_store)
		unEquip(l_store)
	visible_message("<span class='danger'>\The [user] empties [src]'s pockets!</span>")

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

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)
	var/removed_splint = 0
	for(var/obj/item/organ/external/o in organs)
		if (o && o.splinted)
			var/obj/item/S = o.splinted
			if(!istype(S) || S.loc != o) //can only remove splints that are actually worn on the organ (deals with hardsuit splints)
				to_chat(user, "<span class='warning'>You cannot remove any splints on [src]'s [o.name] - [o.splinted] is supporting some of the breaks.</span>")
			else
				S.add_fingerprint(user)
				if(o.remove_splint())
					user.put_in_active_hand(S)
					removed_splint = 1
	if(removed_splint)
		visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] has no splints that can be removed.</span>")

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		internal.add_fingerprint(user)
		internal = null
		if(internals)
			internals.icon_state = "internal0"
	else
		// Check for airtight mask/helmet.
		if(!(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space)))
			return
		// Find an internal source.
		if(istype(back, /obj/item/weapon/tank))
			internal = back
		else if(istype(s_store, /obj/item/weapon/tank))
			internal = s_store
		else if(istype(belt, /obj/item/weapon/tank))
			internal = belt

	if(internal)
		visible_message("<span class='warning'>\The [src] is now running on internals!</span>")
		internal.add_fingerprint(user)
		if (internals)
			internals.icon_state = "internal1"
	else
		visible_message("<span class='danger'>\The [user] disables \the [src]'s internals!</span>")
