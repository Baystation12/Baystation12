
/datum/job/UNSC_ship/technician_chief
	title = "Crew Chief (technical)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = TECHCO
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	selection_color = "#CC6600"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	job_guide = "Your responsibility is to oversee the technicians in operating the fusion reactors and repairing damage to the ship. More content is planned in future."

	access = list(access_unsc_tech, access_unsc_crew,
		access_unsc_ops, access_unsc_supplies)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/technician(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/ce(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		return 1

/datum/job/UNSC_ship/technician
	title = "Technician"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = TECH
	department_flag = MEDSCI
	total_positions = -1
	spawn_positions = 8
	selection_color = "#CC6600"
	alt_titles = list("Life Support Technician","Engine Technician","Electrical Technician","Damage Control Technician","EVA Technician","Hull Technician","Maintenance Technician")
	job_guide = "Your responsibility is to operate the fusion reactors and repair damage to the ship. More content is planned in future."

	access = list(access_unsc_tech, access_unsc_crew,
		access_unsc_ops, access_unsc_supplies)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/technician(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/engineering(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		return 1

/obj/structure/closet/unsc_wardrobe/technician
	name = "technician uniforms closet"
	desc = "It's a storage unit for technician uniforms."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/unsc_wardrobe/technician/New()
	..()
	new /obj/item/clothing/under/unsc/technician(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/under/unsc/technician(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/device/radio/headset/unsc(src)
