///This is a generic proc that should be called by other ling armor procs to equip them.
/mob/proc/changeling_generic_armor(armor_type, helmet_type, boot_type, chem_cost)

	if(!ishuman(src))
		return FALSE
	var/list/species_restricted = list("exclude", SPECIES_NABBER, SPECIES_ADHERENT,SPECIES_VOX, SPECIES_DIONA)
	var/mob/living/carbon/human/M = src

	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type))
		chem_cost = 0

	var/datum/changeling/changeling = changeling_power(chem_cost, 1, 100, CONSCIOUS)

	if(!changeling)
		return
	if(M.species in species_restricted)
		to_chat(M,SPAN_WARNING("Our current form is not suited to such a transformation."))
		return

	var/obj/item/clothing/suit/space/changeling/ling_suit = armor_type

	/// Time during Destroy(), to start the healing.
	var/time_of_heal = null

	//First, check if we're already wearing the armor, and if so, take it off. (And repair if needed)
	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type))
		if (ling_suit.damage >= 30)
			to_chat(M, SPAN_WARNING("\The [src] requires time to heal. It will be mending itself."))
			time_of_heal = world.time
			if (ling_suit.damage)
				ling_suit.damage = 0
			if (ling_suit.brute_damage || ling_suit.burn_damage)
				ling_suit.brute_damage = 0
				ling_suit.burn_damage = 0
			if (ling_suit.breaches)
				ling_suit.breaches = null
			ling_suit.calc_breach_damage()

			time_of_heal = world.time
		M.visible_message("<span class='warning'>[M] casts off their [M.wear_suit.name]!</span>",
		"<span class='warning'>We cast off our [M.wear_suit.name]</span>",
		"<span class='italics'>You hear the organic matter ripping and tearing!</span>")
		if(istype(M.wear_suit, armor_type))
			qdel(M.wear_suit)
		if(istype(M.head, helmet_type))
			qdel(M.head)
		if(istype(M.shoes, boot_type))
			qdel(M.shoes)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		M.update_inv_shoes()
		return TRUE

	if (time_of_heal) // Check if it's within the time-limit of "repair"
		if (world.time < time_of_heal + ling_suit.heal_time)
			to_chat(loc, SPAN_WARNING("The [src] has not been fully repaired, yet."))
			return FALSE

		time_of_heal = null

	if(M.head || M.wear_suit) //Make sure our slots aren't full
		to_chat(src, "<span class='warning'>We require nothing to be on our head, and we cannot wear any external suits, or shoes.</span>")
		return FALSE

	var/obj/item/clothing/suit/A = new armor_type(src)
	src.equip_to_slot_or_del(A, slot_wear_suit)

	var/obj/item/clothing/suit/H = new helmet_type(src)
	src.equip_to_slot_or_del(H, slot_head)

	var/obj/item/clothing/shoes/B = new boot_type(src)
	src.equip_to_slot_or_del(B, slot_shoes)

	src.mind.changeling.chem_charges -= chem_cost
	if(istype(M.wear_suit,/obj/item/clothing/suit/space/changeling/armored))
		playsound(src, 'sound/effects/ling_horror.ogg', 30, 1)
		src.visible_message(SPAN_DANGER("\the [src] lets out out a monstrous roar of fury!"))
	else
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	M.update_inv_wear_suit()
	M.update_inv_head()
	M.update_hair()
	M.update_inv_shoes()
	M.mind.changeling.armor_deployed = TRUE
	return TRUE

/mob/proc/changeling_generic_equip_all_slots(list/stuff_to_equip, cost)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return FALSE

	var/mob/living/carbon/human/M = src

	var/success = FALSE

	//First, check if we're already wearing the armor, and if so, take it off.

	if(M.mind.changeling.armor_deployed)
		if(M.head && stuff_to_equip["head"])
			if(istype(M.head, stuff_to_equip["head"]))
				qdel(M.head)
				success = TRUE

		if(M.wear_id && stuff_to_equip["wear_id"])
			if(istype(M.wear_id, stuff_to_equip["wear_id"]))
				qdel(M.wear_id)
				success = TRUE

		if(M.wear_suit && stuff_to_equip["wear_suit"])
			if(istype(M.wear_suit, stuff_to_equip["wear_suit"]))
				qdel(M.wear_suit)
				success = TRUE

		if(M.gloves && stuff_to_equip["gloves"])
			if(istype(M.gloves, stuff_to_equip["gloves"]))
				qdel(M.gloves)
				success = TRUE
		if(M.shoes && stuff_to_equip["shoes"])
			if(istype(M.shoes, stuff_to_equip["shoes"]))
				qdel(M.shoes)
				success = TRUE

		if(M.belt && stuff_to_equip["belt"])
			if(istype(M.belt, stuff_to_equip["belt"]))
				qdel(M.belt)
				success = TRUE

		if(M.glasses && stuff_to_equip["glasses"])
			if(istype(M.glasses, stuff_to_equip["glasses"]))
				qdel(M.glasses)
				success = TRUE

		if(M.wear_mask && stuff_to_equip["wear_mask"])
			if(istype(M.wear_mask, stuff_to_equip["wear_mask"]))
				qdel(M.wear_mask)
				success = TRUE

		if(M.back && stuff_to_equip["back"])
			if(istype(M.back, stuff_to_equip["back"]))
				for(var/atom/movable/AM in M.back.contents) //Dump whatever's in the bag before deleting.
					AM.forceMove(src.loc)
				qdel(M.back)
				success = TRUE

		if(M.w_uniform && stuff_to_equip["w_uniform"])
			if(istype(M.w_uniform, stuff_to_equip["w_uniform"]))
				qdel(M.w_uniform)
				success = TRUE

		if(success)
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			visible_message("<span class='warning'>[src] pulls on their clothes, peeling it off along with parts of their skin attached!</span>",
			"<span class='notice'>We remove and deform our equipment.</span>")
		M.mind.changeling.armor_deployed = FALSE
		update_icon()
		return success

	else

		to_chat(M, "<span class='notice'>We begin growing our new equipment...</span>")

		var/list/grown_items_list = list()

		var/t = stuff_to_equip["head"]
		if(!M.head && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_head)
			grown_items_list.Add("a helmet")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["w_uniform"]
		if(!M.w_uniform && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_w_uniform)
			grown_items_list.Add("a uniform")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["gloves"]
		if(!M.gloves && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_gloves)
			grown_items_list.Add("some gloves")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["shoes"]
		if(!M.shoes && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_shoes)
			grown_items_list.Add("shoes")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["belt"]
		if(!M.belt && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_belt)
			grown_items_list.Add("a belt")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["glasses"]
		if(!M.glasses && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_glasses)
			grown_items_list.Add("some glasses")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["wear_mask"]
		if(!M.wear_mask && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_wear_mask)
			grown_items_list.Add("a mask")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["back"]
		if(!M.back && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_back)
			grown_items_list.Add("a backpack")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["wear_suit"]
		if(!M.wear_suit && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_wear_suit)
			grown_items_list.Add("an exosuit")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		t = stuff_to_equip["wear_id"]
		if(!M.wear_id && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_wear_id)
			grown_items_list.Add("an ID card")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = TRUE
			sleep(1 SECOND)

		var/feedback = english_list(grown_items_list, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )

		to_chat(M, "<span class='notice'>We have grown [feedback].</span>")

		if(success)
			M.mind.changeling.armor_deployed = TRUE
			M.mind.changeling.chem_charges -= 10
		update_icon()
		return success

///This is a generic proc that should be called by other ling weapon procs to equip them.
/mob/proc/changeling_generic_weapon(weapon_type, make_sound = TRUE, cost)

	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return FALSE
	if (!src || src.incapacitated() || src.lying)
		to_chat(src,SPAN_WARNING("We cannot do this while we are stunned."))
		return FALSE
	var/mob/living/carbon/human/M = src
	if(M.l_hand && M.r_hand) //Make sure our hands aren't full.
		to_chat(src, SPAN_WARNING("We do not have any free hands we can shape into a weapon!"))
		return FALSE


	var/obj/item/weapon/W = new weapon_type(src)
	if(!M.put_in_hands(W))
		to_chat(src, SPAN_WARNING("We cannot shape a missing limb into a weapon!"))
		qdel(W)
		return FALSE

	src.mind.changeling.chem_charges -= cost
	if(make_sound)
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	return TRUE

///Special proc for the ranged sting to pass information about the type of sting
/mob/proc/changeling_equip_ranged(weapon_type, make_sound = FALSE, cost = 10, sting_type)

	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return FALSE

	var/mob/living/carbon/human/M = src

	if(M.l_hand && M.r_hand ) //Make sure our hands aren't full.
		to_chat(src, SPAN_WARNING("We do not have a free hand to shape into a weapon.  Drop something first."))
		return FALSE

	var/obj/item/gun/projectile/changeling/W = new weapon_type(src)
	src.put_in_hands(W)
	W.selected_sting = sting_type
	src.mind.changeling.selected_ranged_sting = sting_type
	src.mind.changeling.chem_charges -= cost
	if(make_sound)
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	return TRUE
