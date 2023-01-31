/obj/item/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	randpixel = 0
	throwforce = 1
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 3
	throw_range = 7
	layer = BELOW_OBJ_LAYER
	var/amount = 30					//How much paper is in the bin.
	var/list/papers = new/list()	//List of papers put in the bin for reference.


/obj/item/paper_bin/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/carbon/slime) && !istype(usr, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user, SPAN_NOTICE("You pick up the [src]."))
				user.put_in_hands(src)

	return

/obj/item/paper_bin/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
			return
	var/response = ""
	if(!length(papers) > 0)
		response = alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", "Regular", "Carbon-Copy", "Cancel")
		if (response != "Regular" && response != "Carbon-Copy")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/paper/P
		if(length(papers) > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[length(papers)]
			papers.Remove(P)
		else
			if(response == "Regular")
				P = new /obj/item/paper
			else if (response == "Carbon-Copy")
				P = new /obj/item/paper/carbon
		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("You take [P] out of the [src]."))
	else
		to_chat(user, SPAN_NOTICE("[src] is empty!"))

	add_fingerprint(user)
	return


/obj/item/paper_bin/attackby(obj/item/i as obj, mob/user as mob)
	if(istype(i, /obj/item/paper))
		if(!user.unEquip(i, src))
			return
		to_chat(user, SPAN_NOTICE("You put [i] in [src]."))
		papers.Add(i)
		update_icon()
		amount++
	else if(istype(i, /obj/item/paper_bundle))
		to_chat(user, SPAN_NOTICE("You loosen \the [i] and add its papers into \the [src]."))
		var/was_there_a_photo = 0
		for(var/obj/item/bundleitem in i) //loop through items in bundle
			if(istype(bundleitem, /obj/item/paper)) //if item is paper, add into the bin
				papers.Add(bundleitem)
				update_icon()
				amount++
			else if(istype(bundleitem, /obj/item/photo)) //if item is photo, drop it on the ground
				was_there_a_photo = 1
				bundleitem.dropInto(user.loc)
				bundleitem.reset_plane_and_layer()
		qdel(i)
		if(was_there_a_photo)
			to_chat(user, SPAN_NOTICE("The photo cannot go into \the [src]."))


/obj/item/paper_bin/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(amount)
			to_chat(user, SPAN_NOTICE("There " + (amount > 1 ? "are [amount] papers" : "is one paper") + " in the bin."))
		else
			to_chat(user, SPAN_NOTICE("There are no papers in the bin."))


/obj/item/paper_bin/on_update_icon()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"
