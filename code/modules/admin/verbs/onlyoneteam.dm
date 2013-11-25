/client/proc/only_one_team()
	if(!ticker)
		alert("The game hasn't started yet!")
		return

	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue



//		ticker.mode.traitors += H.mind


		for (var/obj/item/I in H)
			if (istype(I, /obj/item/weapon/implant))
				continue
			del(I)



		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(H), slot_l_ear)
//		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/beach_ball/dodgeball(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)



		if(prob(50))
			team_alpha += H

			H.equip_to_slot_or_del(new /obj/item/clothing/under/color/red(H), slot_w_uniform)

			var/obj/item/weapon/card/id/W = new(H)
			W.name = "[H.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "Highlander"
			W.registered_name = H.real_name
			H.equip_to_slot_or_del(W, slot_wear_id)

		else
			team_bravo += H

			H.equip_to_slot_or_del(new /obj/item/clothing/under/color/blue(H), slot_w_uniform)

			var/obj/item/weapon/card/id/W = new(H)
			W.name = "[H.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.access = get_all_accesses()
			W.access += get_all_centcom_access()
			W.assignment = "Professional Pee-Wee League Dodgeball Player"
			W.registered_name = H.real_name
			H.equip_to_slot_or_del(W, slot_wear_id)
	message_admins("\blue [key_name_admin(usr)] used DODGEBAWWWWWWWL!", 1)
	log_admin("[key_name(usr)] used dodgeball.")


/obj/item/weapon/beach_ball/dodgeball
	name = "dodgeball"
	icon_state = "dodgeball"
	item_state = "dodgeball"
	desc = "Used for playing the most violent and degrading of childhood games."

/obj/item/weapon/beach_ball/dodgeball/throw_impact(atom/hit_atom)
	if((ishuman(hit_atom)))
		var/mob/living/carbon/M = hit_atom
		if(dir&get_dir(src,M))
			if(M.in_throw_mode && !M.get_active_hand())  //empty active hand and we're in throw mode
				if(M.canmove && !M.restrained())
					M.hitby(src)
		else
			playsound(src, 'sound/items/dodgeball.ogg', 50, 1)
			visible_message("\red [M] HAS BEEN ELIMINATED!!", 3)
			spawn(0)
				var/mobloc = get_turf(M.loc)
				var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
				animation.name = "water"
				animation.density = 0
				animation.anchored = 1
				animation.icon = 'icons/mob/mob.dmi'
				animation.icon_state = "liquify"
				animation.layer = 5
//				animation.master = holder
				del(M)