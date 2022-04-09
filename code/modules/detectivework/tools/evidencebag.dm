//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = ITEM_SIZE_SMALL
	var/obj/item/stored_item = null

/obj/item/evidencebag/MouseDrop(obj/item/I)
	if (!ishuman(usr) || !istype(I))
		return

	var/mob/living/carbon/human/user = usr

	if (!(user.l_hand == src || user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, "<span class='notice'>You find putting an evidence bag in another evidence bag to be slightly absurd.</span>")
		return

	if(I.w_class > ITEM_SIZE_NORMAL)
		to_chat(user, "<span class='notice'>[I] won't fit in [src].</span>")
		return

	if(stored_item)
		to_chat(user, "<span class='notice'>[src] already has something inside it.</span>")
		return

	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage))	//in a container.
			var/sdepth = I.storage_depth(user)
			if (sdepth == -1 || sdepth > 1)
				return	//too deeply nested to access

			var/obj/item/storage/U = I.loc
			user.client.screen -= I
			U.contents.Remove(I)
		else if(user.l_hand == I)					//in a hand
			user.drop_l_hand()
		else if(user.r_hand == I)					//in a hand
			user.drop_r_hand()

	user.visible_message("[user] puts [I] into [src]", "You put [I] inside [src].",\
	"You hear a rustle as someone puts something into a plastic bag.")
	if(!user.skill_check(SKILL_FORENSICS, SKILL_BASIC))
		I.add_fingerprint(user)
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class
	update_icon()

/obj/item/evidencebag/on_update_icon()
	underlays.Cut()
	if(stored_item)
		icon_state = "evidence"
		desc = "An evidence bag containing \a [stored_item]."
		var/mutable_appearance/MA = new(stored_item)
		MA.pixel_x = 0
		MA.pixel_y = 0
		MA.pixel_z = 0
		var/image/I = new
		I.appearance = MA
		I.plane = FLOAT_PLANE
		I.layer = FLOAT_LAYER
		underlays += I
	else
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."

/obj/item/evidencebag/attack_self(mob/user)
	if(stored_item)
		user.visible_message("[user] takes [stored_item] out of [src]", "You take [stored_item] out of [src].",\
		"You hear someone rustle around in a plastic bag, and remove something.")

		user.put_in_hands(stored_item)
		empty()
	else
		to_chat(user, "[src] is empty.")
		update_icon()

/obj/item/evidencebag/proc/empty()
	stored_item = null
	w_class = initial(w_class)
	update_icon()

/obj/item/evidencebag/examine(mob/user)
	. = ..()
	if (stored_item)
		user.examinate(stored_item)
