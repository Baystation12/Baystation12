//This is a generic proc that should be called by other ling armor procs to equip them.
/mob/proc/changeling_generic_armor(var/armor_type, var/helmet_type)
	var/datum/changeling/changeling = changeling_power(20,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	//First, check if we're already wearing the armor, and if so, take it off.
	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type))
		M.visible_message("<span class='warning'>[M] casts off their [M.wear_suit.name]!</span>",
		"<span class='warning'>We cast off our [M.wear_suit.name]</span>",
		"<span class='italics'>You hear the organic matter ripping and tearing!</span>")
		qdel(M.wear_suit)
		qdel(M.head)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		return 1

	if(M.head || M.wear_suit) //Make sure our slots aren't full
		src << "<span class='warning'>We require nothing to be on our head, and we cannot wear any external suits.</span>"
		return 0

	var/obj/item/clothing/suit/A = new armor_type(src)
	src.equip_to_slot_or_del(A, slot_wear_suit)

	var/obj/item/clothing/suit/H = new helmet_type(src)
	src.equip_to_slot_or_del(H, slot_head)

	src.mind.changeling.chem_charges -= 20
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	M.update_inv_wear_suit()
	M.update_inv_head()
	M.update_hair()
	return 1

/mob/proc/changeling_generic_equip_all_slots(var/list/stuff_to_equip, var/cost)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	var/success = 0
/*
		slot_back,\
		slot_wear_id,\
		slot_w_uniform,\
		slot_wear_suit,\
		slot_wear_mask,\
		slot_head,\
		slot_shoes,\
		slot_gloves,\
		slot_l_ear,\
		slot_r_ear,\
		slot_glasses,\
		slot_belt,\
		slot_s_store,\
		slot_tie,\
		slot_l_store,\
		slot_r_store\
	)
*/
	//First, check if we're already wearing the armor, and if so, take it off.
/*
	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type))
		M.visible_message("<span class='warning'>[M] casts off their [M.wear_suit.name]!</span>",
		"<span class='warning'>We cast off our [M.wear_suit.name]</span>",
		"<span class='italics'>You hear the organic matter ripping and tearing!</span>")
		qdel(M.wear_suit)
		qdel(M.head)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		return 1
*/

	if(M.mind.changeling.armor_deployed)
		if(M.head)
			for(var/obj/item/clothing/head/head_slot in stuff_to_equip)
				if(istype(M.head,head_slot))
					qdel(M.head)
					success = 1
					break

		if(M.wear_suit)
			for(var/obj/item/clothing/suit/suit_slot in stuff_to_equip)
				if(istype(M.glasses,suit_slot))
					qdel(M.wear_suit)
					success = 1
					break

		if(M.gloves)
			for(var/obj/item/clothing/gloves/gloves_slot in stuff_to_equip)
				if(istype(M.head,gloves_slot))
					qdel(M.gloves)
					success = 1
					break
		if(M.shoes)
			for(var/obj/item/clothing/shoes/shoes_slot in stuff_to_equip)
				if(istype(M.head,shoes_slot))
					qdel(M.shoes)
					success = 1
					break

		if(M.belt)
			for(var/obj/item/weapon/storage/belt/belt_slot in stuff_to_equip)
				if(istype(M.belt,belt_slot))
					qdel(M.belt)
					success = 1
					break

		if(M.glasses)
			for(var/obj/item/clothing/glasses/glasses_slot in stuff_to_equip)
				if(istype(M.glasses,glasses_slot))
					qdel(M.glasses)
					success = 1
					break

		if(M.wear_mask)
			for(var/obj/item/clothing/mask/mask_slot in stuff_to_equip)
				if(istype(M.glasses,mask_slot))
					qdel(M.wear_mask)
					success = 1
					break

		if(M.back)
			for(var/obj/item/weapon/storage/backpack/backpack_slot in stuff_to_equip)
				if(istype(M.glasses,backpack_slot))
					qdel(M.back)
					success = 1
					break

		if(M.w_uniform)
			for(var/obj/item/clothing/under/uniform_slot in stuff_to_equip)
				if(istype(M.head,uniform_slot))
					qdel(M.w_uniform)
					success = 1
					break

		if(M.wear_id)
			for(var/obj/item/weapon/card/id/id_slot in stuff_to_equip)
				if(istype(M.glasses,id_slot))
					qdel(M.wear_id)
					success = 1
					break
		if(success)
			M.mind.changeling.armor_deployed = 0
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			visible_message("<span class='warning'>[src] pulls on their clothes, peeling it off along with parts of their skin attached!</span>",
			"<span class='notice'>We remove and deform our equipment.</span>")
		M.update_icons()
		return success

	else

		M << "<span class='notice'>We begin growing our new equipment...</span>"

		var/list/grown_items_list = list()
		if(!M.head)
			for(var/obj/item/clothing/head/head_slot in stuff_to_equip)
				var/I = new head_slot.type
				M.equip_to_slot_or_del(I, slot_head)
				grown_items_list.Add("a helmet")
				playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.w_uniform)
			for(var/obj/item/clothing/under/uniform_slot in stuff_to_equip)
				var/I = new uniform_slot.type
				M.equip_to_slot_or_del(I, slot_w_uniform)
				grown_items_list.Add("a uniform")
				playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.gloves)
			for(var/obj/item/clothing/gloves/gloves_slot in stuff_to_equip)
				var/I = new gloves_slot.type
				M.equip_to_slot_or_del(I, slot_gloves)
				grown_items_list.Add("some gloves")
				playsound(src, 'sound/effects/splat.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.shoes)
			for(var/obj/item/clothing/shoes/shoes_slot in stuff_to_equip)
				var/I = new shoes_slot.type
				M.equip_to_slot_or_del(I, slot_shoes)
				grown_items_list.Add("shoes")
				playsound(src, 'sound/effects/splat.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.belt)
			for(var/obj/item/weapon/storage/belt/belt_slot in stuff_to_equip)
				var/I = new belt_slot.type
				M.equip_to_slot_or_del(I, slot_belt)
				grown_items_list.Add("a belt")
				playsound(src, 'sound/effects/splat.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.glasses)
			for(var/obj/item/clothing/glasses/glasses_slot in stuff_to_equip)
				var/I = new glasses_slot.type
				M.equip_to_slot_or_del(I, slot_glasses)
				grown_items_list.Add("some glasses")
				playsound(src, 'sound/effects/splat.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.wear_mask)
			for(var/obj/item/clothing/mask/mask_slot in stuff_to_equip)
				var/I = new mask_slot.type
				M.equip_to_slot_or_del(I, slot_wear_mask)
				grown_items_list.Add("a mask")
				playsound(src, 'sound/effects/splat.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.back)
			for(var/obj/item/weapon/storage/backpack/backpack_slot in stuff_to_equip)
				var/I = new backpack_slot.type
				M.equip_to_slot_or_del(I, slot_back)
				grown_items_list.Add("a backpack")
				playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.wear_suit)
			for(var/obj/item/clothing/suit/suit_slot in stuff_to_equip)
				var/I = new suit_slot.type
				M.equip_to_slot_or_del(I, slot_wear_suit)
				grown_items_list.Add("an exosuit")
				playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		if(!M.wear_id)
			for(var/obj/item/weapon/card/id/id_slot in stuff_to_equip)
				var/I = new id_slot.type
				M.equip_to_slot_or_del(I, slot_wear_id)
				grown_items_list.Add("an ID card")
				playsound(src, 'sound/effects/splat.ogg', 30, 1)
				M.update_icons()
				success = 1
				sleep(20)
				break

		var/feedback = english_list(grown_items_list, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )

		M << "<span class='notice'>We have grown [feedback].</span>"
	/*
		for(var/I in stuff_to_equip)
			world << I
		world << stuff_to_equip
		world << "Proc ended."
	*/
		M.update_icons()
		if(success)
			M.mind.changeling.armor_deployed = 1
			M.mind.changeling.chem_charges -= 10
		return success

//This is a generic proc that should be called by other ling weapon procs to equip them.
/mob/proc/changeling_generic_weapon(var/weapon_type, var/make_sound = 1)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	if(M.l_hand && M.r_hand) //Make sure our hands aren't full.
		src << "<span class='warning'>Our hands are full.  Drop something first.</span>"
		return 0

	var/obj/item/weapon/W = new weapon_type(src)
	src.put_in_hands(W)

	src.mind.changeling.chem_charges -= 20
	if(make_sound)
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	return 1