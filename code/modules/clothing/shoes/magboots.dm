//Note that despite the use of the NOSLIP flag, magboots are still hardcoded to prevent spaceslipping in Check_Shoegrip().
/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = 3
	overshoes = 1
	var/magpulse = 0
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"

	//For covering shoes when worn
	var/obj/item/clothing/shoes/shoes = null
	var/mob/wearer = null

/obj/item/clothing/shoes/magboots/Destroy()
	shoes = null
	wearer = null
	. = ..()

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	slowdown = shoes? max(SHOES_SLOWDOWN, shoes.slowdown): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown += 3

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		if(icon_base) icon_state = "[icon_base]0"
		user << "You disable the mag-pulse traction system."
	else
		item_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		if(icon_base) icon_state = "[icon_base]1"
		user << "You enable the mag-pulse traction system."
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user)
	if(!..())
		if(shoes) 	//Put the old shoes back on if the check fails.
			if(user.equip_to_slot_if_possible(shoes, slot_shoes, disable_warning = 1))
				shoes.forceMove(get_turf(user)) //well if that fails then drop them on the floor
			shoes = null
		return 0

/obj/item/clothing/shoes/magboots/proc/cover_shoes(obj/item/clothing/shoes/S, mob/user)
	if(S.overshoes)
		user << "You are unable to wear \the [src] as \the [S] are in the way."
		return 0

	shoes = S
	user.drop_from_inventory(shoes)	//Remove the old shoes so you can put on the magboots.
	shoes.forceMove(src)

	if (shoes)
		user << "You slip \the [src] on over \the [shoes]."
	set_slowdown()
	wearer = user
	return 1

//This gets called only if the item is successfully equipped, luckily for us
/obj/item/clothing/shoes/magboots/equipped()
	..()
	var/mob/M = src.loc
	if(istype(M))
		M.update_floating()

		var/obj/item/clothing/shoes/S = M.get_equipped_item(slot_shoes)
		if(istype(S))
			cover_shoes(S, M)

/obj/item/clothing/shoes/magboots/dropped()
	..()
	if(shoes)
		if(!wearer || !wearer.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.forceMove(get_turf(src))
		src.shoes = null
	if(wearer)
		wearer.update_floating()
		wearer = null

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if(item_flags & NOSLIP)
		state = "enabled"
	user << "Its mag-pulse traction system appears to be [state]."