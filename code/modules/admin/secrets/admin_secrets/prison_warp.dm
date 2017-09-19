/datum/admin_secret_item/admin_secret/prison_warp
	name = "Prison Warp"
	warn_before_use = TRUE

/datum/admin_secret_item/admin_secret/prison_warp/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/admin_secret/prison_warp/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		var/turf/T = get_turf(H)
		var/security = 0
		if((T && (T in GLOB.using_map.admin_levels)) || GLOB.prisonwarped.Find(H))
		//don't warp them if they aren't ready or are already there
			continue
		H.Paralyse(5)
		if(H.wear_id)
			var/obj/item/weapon/card/id/id = H.get_idcard()
			for(var/A in id.access)
				if(A == access_security)
					security++
		if(!security)
			//strip their stuff before they teleport into a cell :downs:
			for(var/obj/item/weapon/W in H)
				if(istype(W, /obj/item/organ/external))
					continue
					//don't strip organs
				H.drop_from_inventory(W)
			//teleport person to cell
			H.forceMove(pick(GLOB.prisonwarp))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), slot_shoes)
		else
			//teleport security person
			H.forceMove(pick(GLOB.prisonsecuritywarp))
		GLOB.prisonwarped |= H
