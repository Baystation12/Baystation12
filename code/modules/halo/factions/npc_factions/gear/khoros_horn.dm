


/* KHOROS HORN */

/obj/item/weapon/khoros_horn
	name = "Raider Horn"
	icon = 'khoros.dmi'
	icon_state = "khoros_horn"
	item_icons = list(
		slot_l_hand_str = 'khoros.dmi',
		slot_r_hand_str = 'khoros.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "khoros_hornl",
		slot_r_hand_str = "khoros_hornr",
		)

	var/last_used = 0
	var/cooldown_time = 10 MINUTES

/obj/item/weapon/khoros_horn/attack_self(mob/user)
	var/can_use = (!last_used || last_used + cooldown_time < world.time)
	if(can_use)
		if(do_after(user, 3 SECONDS))
			can_use = (!last_used || last_used + cooldown_time < world.time)
			if(can_use)
				user.audible_message("<span class='info'>[user] blows on the [src]!</span>")
				playsound(get_turf(src),'code/modules/halo/sounds/Warhorn.ogg',70)
				last_used = world.time
	else
		var/time_left = last_used + cooldown_time - world.time
		if(time_left > 1 MINUTE)
			time_left = "[round(time_left/600, 0.1)] minutes"
		else
			time_left = "[round(time_left/60)] seconds"
		to_chat(user, "<span class='warning'>You cannot blow on [src] for another [time_left]!</span>")
