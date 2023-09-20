/obj/item/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	force = 2
	w_class = ITEM_SIZE_TINY
	force = 2
	puncture = TRUE
	throw_speed = 7
	throw_range = 15
	matter = list(MATERIAL_PLASTIC = 10)
	var/colour = "black"	//what colour the ink is!
	var/color_description = "black ink"

	var/active = TRUE
	var/iscrayon = FALSE
	var/isfancy = FALSE

/obj/item/pen/blue
	name = "blue pen"
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"
	color_description = "blue ink"

/obj/item/pen/red
	name = "red pen"
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"
	color_description = "red ink"

/obj/item/pen/green
	name = "green pen"
	desc = "It's a normal green ink pen."
	icon_state = "pen_green"
	colour = "green"

/obj/item/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"
	colour = "white"
	color_description = "transluscent ink"

/obj/item/pen/use_after(atom/A, mob/user)
	. = FALSE
	if (ishuman(A) && user.a_intent == I_HELP && user.zone_sel.selecting == BP_HEAD)
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/head/head = H.organs_by_name[BP_HEAD]
		if (istype(head))
			head.write_on(user, color_description)
			return TRUE

	if (istype(A, /obj/item/organ/external/head) && user.a_intent != I_HELP) //Not on help intent to not break ghetto surgery.
		var/obj/item/organ/external/head/head = A
		head.write_on(user, color_description)
		return TRUE

/obj/item/pen/proc/toggle()
	return
