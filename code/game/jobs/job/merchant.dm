/datum/job/merchant
	title = "Merchant"
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "yourself and your fellow merchants"
	selection_color = "#515151"
	alt_titles = list("Trader", "Clerk")
	idtype = /obj/item/weapon/card/id/silver
	minimal_player_age = 15
	create_record = 0
	access = list(access_merchant)
	minimal_access = list(access_merchant)
	account_allowed = 0

/datum/job/merchant/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	return 1