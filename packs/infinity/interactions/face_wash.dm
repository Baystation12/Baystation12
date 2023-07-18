/obj/item/organ/external/head/proc/remove_graffiti()
	forehead_graffiti = null
	graffiti_style = null

// And after commiting whis warcrime, we can finaly wash our face

/obj/structure/hygiene/sink/attack_hand(mob/user)
	var/graffiti = FALSE
	var/target_part = "hands"
	if (ishuman(user) && user.client)
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		var/target_zone = H.zone_sel.selecting
		if((target_zone == BP_HEAD) && (H.organs_by_name[BP_HEAD]))
			target_part = "face"
			var/obj/item/organ/external/head/HD = H.organs_by_name[BP_HEAD]
			if(HD.forehead_graffiti)
				graffiti = TRUE
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	if(graffiti)
		to_chat(usr, "<span class='notice'>You start removing your graffiti and washing your [target_part].</span>")
	else
		to_chat(usr, "<span class='notice'>You start washing your [target_part].</span>")

	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = TRUE
	if(!do_after(user, 40, src))
		busy = FALSE
		return TRUE
	busy = FALSE

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	if(graffiti)
		user.visible_message("<span class='notice'>[user] washes their [target_part] and forehead using \the [src].</span>")
	else
		user.visible_message("<span class='notice'>[user] washes their [target_part] using \the [src].</span>")

	if(graffiti)
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/head/I = H.organs_by_name[BP_HEAD]
		I.remove_graffiti()
		graffiti = FALSE
