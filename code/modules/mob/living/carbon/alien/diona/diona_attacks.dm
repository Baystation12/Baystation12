/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()
	if(H.a_intent == I_HELP)
		if(H.species && H.species.name == "Diona" && do_merge(H))
			return
		get_scooped(H)
		return
	else if(H.a_intent == "grab" && hat && !(H.l_hand && H.r_hand))
		hat.loc = get_turf(src)
		H.put_in_hands(hat)
		H.visible_message("<span class='danger'>\The [H] removes \the [src]'s [hat].</span>")
		hat = null
		update_icons()
	else
		return ..()

/mob/living/carbon/alien/diona/attackby(var/obj/item/weapon/W, var/mob/user)
	if(user.a_intent == I_HELP && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, "<span class='warning'>\The [src] is already wearing \the [hat].</span>")
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message("<span class='notice'>\The [user] puts \the [W] on \the [src].</span>")
		return
	return ..()