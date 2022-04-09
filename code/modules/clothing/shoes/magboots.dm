//Note that despite the use of the NOSLIP flag, magboots are still hardcoded to prevent spaceslipping in Check_Shoegrip().
/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	item_flags = null
	species_restricted = null
	force = 3
	overshoes = 1
	var/magpulse = 0
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/carbon/human/wearer = null	//For shoe procs
	randpixel = 0
	var/online_slowdown = 3

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	slowdown_per_slot[slot_shoes] = shoes? max(0, shoes.slowdown_per_slot[slot_shoes]): 0	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown_per_slot[slot_shoes] += online_slowdown

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~ITEM_FLAG_NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		if(icon_base) icon_state = "[icon_base]0"
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		item_flags |= ITEM_FLAG_NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		if(icon_base) icon_state = "[icon_base]1"
		playsound(get_turf(src), 'sound/effects/magnetclamp.ogg', 20)
		to_chat(user, "You enable the mag-pulse traction system.")
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user)
	var/mob/living/carbon/human/H = user

	if(H.shoes)
		shoes = H.shoes
		if(shoes.overshoes)
			to_chat(user, "You are unable to wear \the [src] as \the [H.shoes] are in the way.")
			shoes = null
			return 0
		if(!H.unEquip(shoes, src))//Remove the old shoes so you can put on the magboots.
			shoes = null
			return 0

	if(!..())
		if(shoes) 	//Put the old shoes back on if the check fails.
			if(H.equip_to_slot_if_possible(shoes, slot_shoes))
				src.shoes = null
		return 0

	if (shoes)
		to_chat(user, "You slip \the [src] on over \the [shoes].")
	set_slowdown()
	wearer = H //TODO clean this up
	return 1

/obj/item/clothing/shoes/magboots/equipped()
	..()
	var/mob/M = src.loc
	if(istype(M))
		M.update_floating()

/obj/item/clothing/shoes/magboots/dropped()
	..()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(shoes && istype(H))
		if(!H.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.dropInto(loc)
		src.shoes = null
	wearer.update_floating()
	wearer = null

/obj/item/clothing/shoes/magboots/examine(mob/user)
	. = ..()
	var/state = "disabled"
	if(item_flags & ITEM_FLAG_NOSLIP)
		state = "enabled"
	to_chat(user, "Its mag-pulse traction system appears to be [state].")
