
/datum/job/UNSC_ship/medical_chief
	title = "Chief Hospital Corpsman"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = MEDCO
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	selection_color = "#3300cc"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	job_guide = "Your responsibility is to supervise the hospital corpsman and ensure the crew, pilots and marines are in good medical condition."

	access = list(access_unsc_crew, access_unsc_medical)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/cmo(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		return 1

/datum/job/UNSC_ship/medical
	title = "Hospital Corpsman"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = MED
	department_flag = MEDSCI
	total_positions = -1
	spawn_positions = 6
	selection_color = "#3300cc"
	job_guide = "Your job is ensure the crew, pilots and marines are in good medical condition."

	access = list(access_unsc_crew, access_unsc_medical)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		return 1

/obj/structure/closet/unsc_wardrobe/medical
	name = "hospital corpsman closet"
	desc = "It's a storage unit for hospital corpsmen."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/unsc_wardrobe/medical/New()
	..()
	new /obj/item/clothing/under/unsc/medical(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/under/unsc/medical(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/device/radio/headset/unsc(src)
