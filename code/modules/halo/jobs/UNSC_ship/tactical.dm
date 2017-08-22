
/datum/job/UNSC_ship/gunnery_chief
	title = "Crew Chief (gunnery)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = GUNCO
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	selection_color = "#cc0000"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	job_guide = "Your responsibility is to oversee the gunnery operators manning the ship's turrets. Unfortunately your job has no content yet but it's coming soon."

	access = list(access_unsc_crew, access_unsc_gunnery)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/tactical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hos(H), slot_belt)
		return 1

/datum/job/UNSC_ship/gunnery
	title = "Gunnery Operator"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = GUN
	department_flag = MEDSCI
	total_positions = -1
	spawn_positions = 2
	selection_color = "#cc0000"
	job_guide = "Your responsibility is to man the ship's turrets. Unfortunately your job has no content yet but it's coming soon."

	access = list(access_unsc_crew, access_unsc_gunnery)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/tactical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_belt)
		return 1
