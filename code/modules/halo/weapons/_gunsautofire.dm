
//General rule for giving guns larger burst-size firemodes: triple base burst size and multiply dispersions by 1.5
//or add like .1/.2 to the disp.

/client/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	if(mob && istype(mob,/mob/living/carbon/human))
		var/mob/living/carbon/human/h = mob
		var/obj/item/weapon/gun/g = h.get_active_hand()
		//If we have one already (and are thus firing!), change our target!
		if(istype(g))
			spawn()
				if(!g.stored_targ)
					g.Fire(over_object, mob, params, h.Adjacent(over_location), 0)
				else
					g.stored_targ = over_location
		return 1
	return ..()

//Basic crosshair replacement for guns.

/obj/item/weapon/gun
	var/crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon2.dmi'

/obj/item/weapon/gun/proc/check_should_have_crosshair(var/mob/living/user,var/slot = null)
	if(!user.client)
		return
	if(istype(user,/mob/living/carbon/human))
		var/eval = null
		if(slot)
			eval = (slot == slot_l_hand || slot == slot_r_hand)
		else
			var/mob/living/carbon/human/h = user
			eval = (h.l_hand == src || h.r_hand == src)
		if(eval)
			user.client.mouse_pointer_icon = crosshair_file
		else
			user.client.mouse_pointer_icon = null
	else if(istype(user))
		if(loc == user)
			user.client.mouse_pointer_icon = crosshair_file
		else
			user.client.mouse_pointer_icon = null

/obj/item/weapon/gun/equipped(var/mob/living/carbon/human/user,var/slot)
	. = ..()
	check_should_have_crosshair(user,slot)

/obj/item/weapon/gun/dropped(var/mob/living/carbon/human/user)
	. = ..()
	check_should_have_crosshair(user)
