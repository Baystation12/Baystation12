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

//This is a generic proc that should be called by other ling weapon procs to equip them.
/mob/proc/changeling_generic_weapon(var/weapon_type, var/make_sound = 1)
	var/datum/changeling/changeling = changeling_power(20,1,100,CONSCIOUS)
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