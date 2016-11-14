//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/winterhood/hood
	var/hoodtype = null //so the chaplain hoodie or other hoodies can override this
	var/suittoggled = 0
	var/hooded = 0

/obj/item/clothing/suit/storage/hooded/New()
	MakeHood()
	..()

/obj/item/clothing/suit/storage/hooded/Destroy()
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	qdel_null(hood)
=======
	qdel(hood)
>>>>>>> b25ff1f... add new clothing and code for said clothing
=======
	qdel_null(hood)
>>>>>>> 5c6c2d8... Add files via upload
=======
	qdel_null(hood)
>>>>>>> origin/dev
	return ..()

/obj/item/clothing/suit/storage/hooded/proc/MakeHood()
	if(!hood)
		var/obj/item/clothing/head/winterhood/W = new hoodtype(src)
		hood = W

/obj/item/clothing/suit/storage/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	suittoggled = 0
	update_icon()
=======
	icon_state = "[initial(icon_state)]"
	suittoggled = 0
>>>>>>> b25ff1f... add new clothing and code for said clothing
=======
	suittoggled = 0
	update_icon()
>>>>>>> 5c6c2d8... Add files via upload
=======
	suittoggled = 0
	update_icon()
>>>>>>> origin/dev
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1)
		H.update_inv_wear_suit()
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	hood.forceMove(src)
=======
	hood.loc = src
>>>>>>> b25ff1f... add new clothing and code for said clothing
=======
	hood.forceMove(src)
>>>>>>> 5c6c2d8... Add files via upload
=======
	hood.forceMove(src)
>>>>>>> origin/dev

/obj/item/clothing/suit/storage/hooded/dropped()
	RemoveHood()

/obj/item/clothing/suit/storage/hooded/proc/ToggleHood()
	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				H << "<span class='warning'>You must be wearing [src] to put up the hood!</span>"
				return
			if(H.head)
				H << "<span class='warning'>You're already wearing something on your head!</span>"
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				suittoggled = 1
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/dev
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/update_icon()
	if(suittoggled)
		icon_state = "[initial(icon_state)]_t"
	else
		icon_state = "[initial(icon_state)]"
<<<<<<< HEAD
=======
				icon_state = "[initial(icon_state)]_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()
>>>>>>> b25ff1f... add new clothing and code for said clothing
=======
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/update_icon()
	if(suittoggled)
		icon_state = "[initial(icon_state)]_t"
<<<<<<< HEAD
    	else
		icon_state = "[initial(icon_state)]"
>>>>>>> 5c6c2d8... Add files via upload
=======
	else
		icon_state = "[initial(icon_state)]"
>>>>>>> 34f4898... Update toggles.dm
=======
>>>>>>> origin/dev
