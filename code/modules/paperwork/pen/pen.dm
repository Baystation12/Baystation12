/obj/item/weapon/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(MATERIAL_PLASTIC = 10)
	var/colour = "black"	//what colour the ink is!
	var/color_description = "black ink"

	var/active = TRUE
	var/iscrayon = FALSE
	var/isfancy = FALSE

/obj/item/weapon/pen/blue
	name = "blue pen"
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"
	color_description = "blue ink"

/obj/item/weapon/pen/red
	name = "red pen"
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"
	color_description = "red ink"

/obj/item/weapon/pen/green
	name = "green pen"
	desc = "It's a normal green ink pen."
	icon_state = "pen_green"
	colour = "green"

/obj/item/weapon/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"
	colour = "white"
	color_description = "transluscent ink"

/obj/item/weapon/pen/attack(atom/A, mob/user, target_zone)
	if(ismob(A))
		var/mob/M = A
		if(ishuman(A) && user.a_intent == I_HELP && target_zone == BP_HEAD)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/head/head = H.organs_by_name[BP_HEAD]
			if(istype(head))
				head.write_on(user, color_description)
		else
			to_chat(user, SPAN_WARNING("You stab [M] with \the [src]."))
			admin_attack_log(user, M, "Stabbed using \a [src]", "Was stabbed with \a [src]", "used \a [src] to stab")
	else if(istype(A, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = A
		head.write_on(user, color_description)

/obj/item/weapon/pen/proc/toggle()
	return