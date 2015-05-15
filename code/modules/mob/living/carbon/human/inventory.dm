/*
Add fingerprints to items when we put them in our hands.
This saves us from having to call add_fingerprint() any time something is put in a human's hands programmatically.

*/
/mob/living/carbon/human/put_in_l_hand(var/obj/item/W)
	. = ..()
	if(.) W.add_fingerprint(src)

/mob/living/carbon/human/put_in_r_hand(var/obj/item/W)
	. = ..()
	if(.) W.add_fingerprint(src)

/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			H << "<span class='notice'>You are not holding anything to equip.</span>"
			return
		if(H.equip_to_appropriate_slot(I))
			if(hand)
				update_inv_l_hand(0)
			else
				update_inv_r_hand(0)
		else
			H << "\red You are unable to equip that."

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot], del_on_fail = 0))
			return slot
	if (del_on_fail)
		qdel(W)
	return null


/mob/living/carbon/human/proc/has_organ(name)
	var/obj/item/organ/external/O = organs_by_name[name]

	return (O && !(O.status & ORGAN_DESTROYED) )

/mob/living/carbon/human/proc/has_organ_for_slot(slot)
	switch(slot)
		if(slot_back)
			return has_organ("chest")
		if(slot_wear_mask)
			return has_organ("head")
		if(slot_handcuffed)
			return has_organ("l_hand") && has_organ("r_hand")
		if(slot_legcuffed)
			return has_organ("l_leg") && has_organ("r_leg")
		if(slot_l_hand)
			return has_organ("l_hand")
		if(slot_r_hand)
			return has_organ("r_hand")
		if(slot_belt)
			return has_organ("chest")
		if(slot_wear_id)
			// the only relevant check for this is the uniform check
			return 1
		if(slot_l_ear)
			return has_organ("head")
		if(slot_r_ear)
			return has_organ("head")
		if(slot_glasses)
			return has_organ("head")
		if(slot_gloves)
			return has_organ("l_hand") || has_organ("r_hand")
		if(slot_head)
			return has_organ("head")
		if(slot_shoes)
			return has_organ("r_foot") || has_organ("l_foot")
		if(slot_wear_suit)
			return has_organ("chest")
		if(slot_w_uniform)
			return has_organ("chest")
		if(slot_l_store)
			return has_organ("chest")
		if(slot_r_store)
			return has_organ("chest")
		if(slot_s_store)
			return has_organ("chest")
		if(slot_in_backpack)
			return 1
		if(slot_tie)
			return 1

/mob/living/carbon/human/u_equip(obj/W as obj)
	if(!W)	return 0

	if (W == wear_suit)
		if(s_store)
			drop_from_inventory(s_store)
		wear_suit = null
		update_inv_wear_suit()
	else if (W == w_uniform)
		if (r_store)
			drop_from_inventory(r_store)
		if (l_store)
			drop_from_inventory(l_store)
		if (wear_id)
			drop_from_inventory(wear_id)
		if (belt)
			drop_from_inventory(belt)
		w_uniform = null
		update_inv_w_uniform()
	else if (W == gloves)
		gloves = null
		update_inv_gloves()
	else if (W == glasses)
		glasses = null
		update_inv_glasses()
	else if (W == head)
		head = null

		var/update_hair = 0
		if((W.flags & BLOCKHAIR) || (W.flags & BLOCKHEADHAIR))
			update_hair = 1
		else if(istype(W, /obj/item))
			var/obj/item/I = W
			if(I.flags_inv & HIDEMASK)
				update_hair = 1
		if(update_hair)
			update_hair(0)	//rebuild hair
			update_inv_ears(0)
			update_inv_wear_mask(0)

		update_inv_head()
	else if (W == l_ear)
		l_ear = null
		update_inv_ears()
	else if (W == r_ear)
		r_ear = null
		update_inv_ears()
	else if (W == shoes)
		shoes = null
		update_inv_shoes()
	else if (W == belt)
		belt = null
		update_inv_belt()
	else if (W == wear_mask)
		wear_mask = null
		if((W.flags & BLOCKHAIR) || (W.flags & BLOCKHEADHAIR))
			update_hair(0)	//rebuild hair
			update_inv_ears(0)
		if(internal)
			if(internals)
				internals.icon_state = "internal0"
			internal = null
		update_inv_wear_mask()
	else if (W == wear_id)
		wear_id = null
		update_inv_wear_id()
	else if (W == r_store)
		r_store = null
		update_inv_pockets()
	else if (W == l_store)
		l_store = null
		update_inv_pockets()
	else if (W == s_store)
		s_store = null
		update_inv_s_store()
	else if (W == back)
		back = null
		update_inv_back()
	else if (W == handcuffed)
		handcuffed = null
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
		update_inv_handcuffed()
	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else if (W == r_hand)
		r_hand = null
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		update_inv_l_hand()
	else
		return 0

	update_action_buttons()
	return 1



//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.
/mob/living/carbon/human/equip_to_slot(obj/item/W as obj, slot, redraw_mob = 1)

	if(!slot) return
	if(!istype(W)) return
	if(!has_organ_for_slot(slot)) return
	if(!species || !species.hud || !(slot in species.hud.equip_slots)) return
	W.loc = src
	switch(slot)
		if(slot_back)
			src.back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
		if(slot_wear_mask)
			src.wear_mask = W
			if((wear_mask.flags & BLOCKHAIR) || (wear_mask.flags & BLOCKHEADHAIR))
				update_hair(redraw_mob)	//rebuild hair
				update_inv_ears(0)
			W.equipped(src, slot)
			update_inv_wear_mask(redraw_mob)
		if(slot_handcuffed)
			src.handcuffed = W
			update_inv_handcuffed(redraw_mob)
		if(slot_legcuffed)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed(redraw_mob)
		if(slot_l_hand)
			src.l_hand = W
			W.equipped(src, slot)
			update_inv_l_hand(redraw_mob)
		if(slot_r_hand)
			src.r_hand = W
			W.equipped(src, slot)
			update_inv_r_hand(redraw_mob)
		if(slot_belt)
			src.belt = W
			W.equipped(src, slot)
			update_inv_belt(redraw_mob)
		if(slot_wear_id)
			src.wear_id = W
			W.equipped(src, slot)
			update_inv_wear_id(redraw_mob)
		if(slot_l_ear)
			src.l_ear = W
			if(l_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.loc = src
				src.r_ear = O
				O.layer = 20
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(slot_r_ear)
			src.r_ear = W
			if(r_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.loc = src
				src.l_ear = O
				O.layer = 20
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(slot_glasses)
			src.glasses = W
			W.equipped(src, slot)
			update_inv_glasses(redraw_mob)
		if(slot_gloves)
			src.gloves = W
			W.equipped(src, slot)
			update_inv_gloves(redraw_mob)
		if(slot_head)
			src.head = W
			if((head.flags & BLOCKHAIR) || (head.flags & BLOCKHEADHAIR) || (head.flags_inv & HIDEMASK))
				update_hair(redraw_mob)	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
			if(istype(W,/obj/item/clothing/head/kitty))
				W.update_icon(src)
			W.equipped(src, slot)
			update_inv_head(redraw_mob)
		if(slot_shoes)
			src.shoes = W
			W.equipped(src, slot)
			update_inv_shoes(redraw_mob)
		if(slot_wear_suit)
			src.wear_suit = W
			if(wear_suit.flags_inv & HIDESHOES)
				update_inv_shoes(0)
			W.equipped(src, slot)
			update_inv_wear_suit(redraw_mob)
		if(slot_w_uniform)
			src.w_uniform = W
			W.equipped(src, slot)
			update_inv_w_uniform(redraw_mob)
		if(slot_l_store)
			src.l_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(slot_r_store)
			src.r_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(slot_s_store)
			src.s_store = W
			W.equipped(src, slot)
			update_inv_s_store(redraw_mob)
		if(slot_in_backpack)
			if(src.get_active_hand() == W)
				src.remove_from_mob(W)
			W.loc = src.back
		if(slot_tie)
			var/obj/item/clothing/under/uniform = src.w_uniform
			uniform.attackby(W,src)
		else
			src << "\red You are trying to eqip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."
			return

	if((W == src.l_hand) && (slot != slot_l_hand))
		src.l_hand = null
		update_inv_l_hand() //So items actually disappear from hands.
	else if((W == src.r_hand) && (slot != slot_r_hand))
		src.r_hand = null
		update_inv_r_hand()

	W.layer = 20

	return 1

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/living/carbon/human/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	var/obj/item/covering = null
	var/check_flags = 0

	switch(slot)
		if(slot_wear_mask)
			covering = src.head
			check_flags = HEADCOVERSMOUTH
		if(slot_glasses)
			covering = src.head
			check_flags = HEADCOVERSEYES
		if(slot_gloves, slot_w_uniform)
			covering = src.wear_suit

	if(covering)
		if((covering.body_parts_covered & I.body_parts_covered) || (covering.flags & check_flags))
			user << "<span class='warning'>\The [covering] is in the way.</span>"
			return 0
	return 1

/mob/living/carbon/human/get_equipped_item(var/slot)
	switch(slot)
		if(slot_wear_suit) return wear_suit
		if(slot_gloves) return gloves
		if(slot_shoes) return shoes
		if(slot_belt) return belt
		if(slot_glasses) return glasses
		if(slot_head) return head
		if(slot_l_ear) return l_ear
		if(slot_r_ear) return r_ear
		if(slot_w_uniform) return w_uniform
		if(slot_wear_id) return wear_id
		if(slot_l_store) return l_store
		if(slot_r_store) return r_store
		if(slot_s_store) return s_store
		if(slot_handcuffed) return handcuffed
		if(slot_legcuffed) return legcuffed
	return ..()

///Bizarre equip effect system below

/*
	MouseDrop human inventory menu
*/

/obj/effect/equip_e
	name = "equip e"
	var/mob/source = null
	var/s_loc = null	//source location
	var/t_loc = null	//target location
	var/obj/item/item = null
	var/place = null

/obj/effect/equip_e/human
	name = "human"
	var/mob/living/carbon/human/target = null

/obj/effect/equip_e/process()
	return

/obj/effect/equip_e/proc/done()
	return

/obj/effect/equip_e/New()
	if (!ticker)
		qdel(src)
	spawn(100)
		qdel(src)
	..()
	return

/obj/effect/equip_e/human/process()
	if (item)
		item.add_fingerprint(source)
	else
		switch(place)
			if("mask")
				if (!( target.wear_mask ))
					qdel(src)
			if("l_hand")
				if (!( target.l_hand ))
					qdel(src)
			if("r_hand")
				if (!( target.r_hand ))
					qdel(src)
			if("suit")
				if (!( target.wear_suit ))
					qdel(src)
			if("uniform")
				if (!( target.w_uniform ))
					qdel(src)
			if("back")
				if (!( target.back ))
					qdel(src)
			if("syringe")
				return
			if("pill")
				return
			if("fuel")
				return
			if("drink")
				return
			if("dnainjector")
				return
			if("handcuff")
				if (!( target.handcuffed ))
					qdel(src)
			if("id")
				if ((!( target.wear_id ) || !( target.w_uniform )))
					qdel(src)
			if("splints")
				var/count = 0
				for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
					var/obj/item/organ/external/o = target.organs_by_name[organ]
					if(o.status & ORGAN_SPLINTED)
						count = 1
						break
				if(count == 0)
					qdel(src)
					return
			if("sensor")
				if (! target.w_uniform )
					qdel(src)
			if("internal")
				if ((!( (istype(target.wear_mask, /obj/item/clothing/mask) && (istype(target.back, /obj/item/weapon/tank) || istype(target.belt, /obj/item/weapon/tank) || istype(target.s_store, /obj/item/weapon/tank)) && !( target.internal )) ) && !( target.internal )))
					qdel(src)

	var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel", "sensor", "internal", "tie")
	if ((item && !( L.Find(place) )))
		if(isrobot(source) && place != "handcuff")
			qdel(src)
		for(var/mob/O in viewers(target, null))
			O.show_message("\red <B>[source] is trying to put \a [item] on [target]</B>", 1)
	else

		var/target_part = null
		var/obj/item/target_item = null
		var/message = null

		switch(place)
			if("mask")
				target_part = "head"
				target_item = target.wear_mask
			if("l_hand")
				target_part = "left hand"
				target_item = target.l_hand
			if("r_hand")
				target_part = "right hand"
				target_item = target.r_hand
			if("gloves")
				target_part = "hands"
				target_item = target.gloves
			if("eyes")
				target_part = "eyes"
				target_item = target.glasses
			if("l_ear")
				target_part = "left ear"
				target_item = target.l_ear
			if("r_ear")
				target_part = "right ear"
				target_item = target.r_ear
			if("head")
				target_part = "head"
				target_item = target.head
			if("shoes")
				target_part = "feet"
				target_item =  target.shoes
			if("belt")
				target_part = "waist"
				target_item = target.belt
			if("suit")
				target_part = "body"
				target_item = target.wear_suit
			if("back")
				target_part = "back"
				target_item = target.back
			if("s_store")
				target_part = "suit"
				target_item = target.s_store
			if("id")
				target_part = "uniform"
				target_item = target.wear_id

			if("syringe")
				message = "\red <B>[source] is trying to inject [target]!</B>"
			if("pill")
				message = "\red <B>[source] is trying to force [target] to swallow [item]!</B>"
			if("drink")
				message = "\red <B>[source] is trying to force [target] to swallow a gulp of [item]!</B>"
			if("dnainjector")
				message = "\red <B>[source] is trying to inject [target] with the [item]!</B>"
			if("uniform")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their uniform ([target.w_uniform]) removed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) uniform ([target.w_uniform])</font>")
				if(target.w_uniform && !target.w_uniform.canremove)
					message = "\red <B>[source] fails to take off \a [target.w_uniform] from [target]'s body!</B>"
					return
				else
					message = "\red <B>[source] is trying to take off \a [target.w_uniform] from [target]'s body!</B>"
					for(var/obj/item/I in list(target.l_store, target.r_store))
						if(I.on_found(source))
							return
			if("handcuff")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Was unhandcuffed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to unhandcuff [target.name]'s ([target.ckey])</font>")
				message = "\red <B>[source] is trying to unhandcuff [target]!</B>"
			if("legcuff")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Was unlegcuffed by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to unlegcuff [target.name]'s ([target.ckey])</font>")
				message = "\red <B>[source] is trying to unlegcuff [target]!</B>"
			if("tie")
				var/obj/item/clothing/under/suit = target.w_uniform
				if(suit.accessories.len)
					var/obj/item/clothing/accessory/A = suit.accessories[1]
					target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their accessory ([A]) removed by [source.name] ([source.ckey])</font>"
					source.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) accessory ([A])</font>"
					if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
						for(var/mob/M in viewers(target, null))
							M.show_message("\red <B>[source] tears off \the [A] from [target]'s [suit]!</B>" , 1)
						done()
						return
					else
						message = "\red <B>[source] is trying to take off \a [A] from [target]'s [suit]!</B>"
			if("pockets")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their pockets emptied by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to empty [target.name]'s ([target.ckey]) pockets</font>")
				for(var/obj/item/I in list(target.l_store, target.r_store))
					if(I.on_found(source))
						return
				message = "\red <B>[source] is trying to empty [target]'s pockets.</B>"
			if("CPR")
				if (!target.cpr_time)
					qdel(src)
				target.cpr_time = 0
				message = "\red <B>[source] is trying perform CPR on [target]!</B>"
			if("internal")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their internals toggled by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [target.name]'s ([target.ckey]) internals</font>")
				if (target.internal)
					message = "\red <B>[source] is trying to remove [target]'s internals</B>"
				else
					message = "\red <B>[source] is trying to set on [target]'s internals.</B>"
			if("splints")
				message = text("\red <B>[] is trying to remove []'s splints!</B>", source, target)
			if("sensor")
				target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their sensors toggled by [source.name] ([source.ckey])</font>")
				source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [target.name]'s ([target.ckey]) sensors</font>")
				var/obj/item/clothing/under/suit = target.w_uniform
				if (suit.has_sensor >= 2)
					source << "The controls are locked."
					return
				message = "\red <B>[source] is trying to set [target]'s suit sensors!</B>"

		if(target_item)
			target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had their [target_item] removed by [source.name] ([source.ckey])</font>")
			source.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [target.name]'s ([target.ckey]) [target_item]</font>")

			if(target_item.canremove)
				message = "<span class='danger'>[source] is trying to take off \a [target_item] from [target]'s [target_part]!</span>"
			else
				source.visible_message("<span class='danger'>[source] fails to take off \a [target_item] from [target]'s [target_part]!</span>")
				return

		source.visible_message(message)

	spawn( HUMAN_STRIP_DELAY )
		done()
		return
	return

/*
This proc equips stuff (or does something else) when removing stuff manually from the character window when you click and drag.
It works in conjuction with the process() above.
This proc works for humans only. Aliens stripping humans and the like will all use this proc. Stripping monkeys or somesuch will use their version of this proc.
The first if statement for "mask" and such refers to items that are already equipped and un-equipping them.
The else statement is for equipping stuff to empty slots.
!canremove refers to variable of /obj/item/clothing which either allows or disallows that item to be removed.
It can still be worn/put on as normal.
*/
/obj/effect/equip_e/human/done()	//TODO: And rewrite this :< ~Carn
	target.cpr_time = 1
	if(isanimal(source)) return //animals cannot strip people
	if(!source || !target) return		//Target or source no longer exist
	if(source.loc != s_loc) return		//source has moved
	if(target.loc != t_loc) return		//target has moved
	if(LinkBlocked(s_loc,t_loc)) return	//Use a proxi!
	if(item && source.get_active_hand() != item) return	//Swapped hands / removed item from the active one
	if ((source.restrained() || source.stat)) return //Source restrained or unconscious / dead

	var/slot_to_process
	var/obj/item/strip_item //this will tell us which item we will be stripping - if any.

	switch(place)	//here we go again...
		if("mask")
			slot_to_process = slot_wear_mask
			if (target.wear_mask && target.wear_mask.canremove)
				strip_item = target.wear_mask
		if("gloves")
			slot_to_process = slot_gloves
			if (target.gloves && target.gloves.canremove)
				strip_item = target.gloves
		if("eyes")
			slot_to_process = slot_glasses
			if (target.glasses)
				strip_item = target.glasses
		if("belt")
			slot_to_process = slot_belt
			if (target.belt)
				strip_item = target.belt
		if("s_store")
			slot_to_process = slot_s_store
			if (target.s_store)
				strip_item = target.s_store
		if("head")
			slot_to_process = slot_head
			if (target.head && target.head.canremove)
				strip_item = target.head
		if("l_ear")
			slot_to_process = slot_l_ear
			if (target.l_ear)
				strip_item = target.l_ear
		if("r_ear")
			slot_to_process = slot_r_ear
			if (target.r_ear)
				strip_item = target.r_ear
		if("shoes")
			slot_to_process = slot_shoes
			if (target.shoes && target.shoes.canremove)
				strip_item = target.shoes
		if("l_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				qdel(src)
			slot_to_process = slot_l_hand
			if (target.l_hand)
				strip_item = target.l_hand
		if("r_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				qdel(src)
			slot_to_process = slot_r_hand
			if (target.r_hand)
				strip_item = target.r_hand
		if("uniform")
			slot_to_process = slot_w_uniform
			if(target.w_uniform && target.w_uniform.canremove)
				strip_item = target.w_uniform
		if("suit")
			slot_to_process = slot_wear_suit
			if (target.wear_suit && target.wear_suit.canremove)
				strip_item = target.wear_suit
		if("tie")
			var/obj/item/clothing/under/suit = target.w_uniform
			//var/obj/item/clothing/accessory/tie = suit.hastie
			/*if(tie)
				if (istype(tie,/obj/item/clothing/accessory/storage))
					var/obj/item/clothing/accessory/storage/W = tie
					if (W.hold)
						W.hold.close(usr)
				usr.put_in_hands(tie)
				suit.hastie = null*/
			if(suit && suit.accessories.len)
				var/obj/item/clothing/accessory/A = suit.accessories[1]
				A.on_removed(usr)
				suit.accessories -= A
				target.update_inv_w_uniform()
		if("id")
			slot_to_process = slot_wear_id
			if (target.wear_id)
				strip_item = target.wear_id
		if("back")
			slot_to_process = slot_back
			if (target.back)
				strip_item = target.back
		if("handcuff")
			slot_to_process = slot_handcuffed
			if (target.handcuffed)
				strip_item = target.handcuffed
			else if (source != target && ishuman(source))
				//check that we are still grabbing them
				var/grabbing = 0
				for (var/obj/item/weapon/grab/G in target.grabbed_by)
					if (G.loc == source && G.state >= GRAB_AGGRESSIVE)
						grabbing = 1
						break
				if (!grabbing)
					slot_to_process = null
					source << "\red Your grasp was broken before you could restrain [target]!"

		if("legcuff")
			slot_to_process = slot_legcuffed
			if (target.legcuffed)
				strip_item = target.legcuffed
		if("splints")
			var/can_reach_splints = 1
			if(target.wear_suit && istype(target.wear_suit,/obj/item/clothing/suit/space))
				var/obj/item/clothing/suit/space/suit = target.wear_suit
				if(suit.supporting_limbs && suit.supporting_limbs.len)
					source << "You cannot remove the splints - [target]'s [suit] is supporting some of the breaks."
					can_reach_splints = 0

			if(can_reach_splints)
				for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
					var/obj/item/organ/external/o = target.get_organ(organ)
					if (o && o.status & ORGAN_SPLINTED)
						var/obj/item/W = new /obj/item/stack/medical/splint(amount=1)
						o.status &= ~ORGAN_SPLINTED
						if (W)
							W.loc = target.loc
							W.layer = initial(W.layer)
							W.add_fingerprint(source)
		if("CPR")
			if ((target.health > config.health_threshold_dead && target.health < config.health_threshold_crit))
				var/suff = min(target.getOxyLoss(), 5) //Pre-merge level, less healing, more prevention of dieing.
				target.adjustOxyLoss(-suff)
				target.updatehealth()
				for(var/mob/O in viewers(source, null))
					O.show_message("\red [source] performs CPR on [target]!", 1)
				target << "\blue <b>You feel a breath of fresh air enter your lungs. It feels good.</b>"
				source << "\red Repeat at least every 7 seconds."
		if("dnainjector")
			var/obj/item/weapon/dnainjector/S = item
			if(S)
				S.add_fingerprint(source)
				if (!( istype(S, /obj/item/weapon/dnainjector) ))
					S.inuse = 0
					qdel(src)
				S.inject(target, source)
				if (S.s_time >= world.time + 30)
					S.inuse = 0
					qdel(src)
				S.s_time = world.time
				for(var/mob/O in viewers(source, null))
					O.show_message("\red [source] injects [target] with the DNA Injector!", 1)
				S.inuse = 0
		if("pockets")
			if (!item || (target.l_store && target.r_store))	// Only empty pockets when hand is empty or both pockets are full
				slot_to_process = slot_l_store
				strip_item = target.l_store		//We'll do both
			else if (target.l_store)
				slot_to_process = slot_r_store
			else
				slot_to_process = slot_l_store
		if("sensor")
			var/obj/item/clothing/under/suit = target.w_uniform
			if (suit)
				if(suit.has_sensor >= 2)
					source << "The controls are locked."
				else
					suit.set_sensors(source)
		if("internal")
			if (target.internal)
				target.internal.add_fingerprint(source)
				target.internal = null
				if (target.internals)
					target.internals.icon_state = "internal0"
			else
				if (!( istype(target.wear_mask, /obj/item/clothing/mask) ))
					return
				else
					if (istype(target.back, /obj/item/weapon/tank))
						target.internal = target.back
					else if (istype(target.s_store, /obj/item/weapon/tank))
						target.internal = target.s_store
					else if (istype(target.belt, /obj/item/weapon/tank))
						target.internal = target.belt
					if (target.internal)
						for(var/mob/M in viewers(target, 1))
							M.show_message("[target] is now running on internals.", 1)
						target.internal.add_fingerprint(source)
						if (target.internals)
							target.internals.icon_state = "internal1"
	if(slot_to_process)
		if(strip_item) //Stripping an item from the mob
			if(strip_item.mob_can_unequip(target, slot_to_process, 0))
				target.drop_from_inventory(strip_item)
				source.put_in_hands(strip_item)
				strip_item.add_fingerprint(source)
				if(slot_to_process == slot_l_store) //pockets! Needs to process the other one too. Snowflake code, wooo! It's not like anyone will rewrite this anytime soon. If I'm wrong then... CONGRATULATIONS! ;)
					if(target.r_store)
						target.drop_from_inventory(target.r_store) //At this stage l_store is already processed by the code above, we only need to process r_store.
			else
				source << "<span class='warning'>You fail to remove \the [strip_item] from [target]!</span>"
		else if(item)
			if(target.has_organ_for_slot(slot_to_process) && item.mob_can_equip(target, slot_to_process, 0)) //Placing an item on the mob
				source.drop_from_inventory(item)
				target.equip_to_slot_if_possible(item, slot_to_process, 0, 1, 1)
			else
				source << "<span class='warning'>You fail to place \the [item] on [target]!</span>"

	if(source && target)
		if(source.machine == target)
			target.show_inv(source)
	qdel(src)