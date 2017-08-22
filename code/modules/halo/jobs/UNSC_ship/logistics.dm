
/datum/job/UNSC_ship/logistics_chief
	title = "Crew Chief (logistics)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = LOGCO
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	selection_color = "#ffee00"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	job_guide = "Your responsibility is to oversee the logistics crewman as they distribute and manage inventory levels, as well as requesting and processing additional supplies as needed."

	access = list(access_unsc_crew, access_unsc_shuttles, access_unsc_supplies)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/logistics(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/quartermaster(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)
		return 1

/datum/job/UNSC_ship/logistics
	title = "Logistics Specialist"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = LOG
	department_flag = MEDSCI
	total_positions = -1
	spawn_positions = 6
	selection_color = "#ffee00"
	alt_titles = list("Ordnance Specialist","Culinary Specialist", "Service Specialist")
	job_guide = "Your job is to distribute and manage inventory levels, as well as request and process additional supplies as needed."

	access = list(access_unsc_crew, access_unsc_shuttles, access_unsc_supplies)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/logistics(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/cargo(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)
		return 1

/obj/structure/closet/unsc_wardrobe/logistics
	name = "logistics crewman closet"
	desc = "It's a storage unit for logistics crewmen."
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/unsc_wardrobe/logistics/New()
	..()
	new /obj/item/clothing/under/unsc/logistics(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/under/unsc/logistics(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/unsc(src)
