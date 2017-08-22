
/datum/job/UNSC_ship/security_chief
	title = "Naval Security Officer"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = SECCO
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	selection_color = "#990000"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	job_guide = "Your job is to supervise and lead naval security in enforcing discipline and that all crew work to keep the ship secure. In the event being boarded, you are in charge of the defence."

	access = list(access_unsc_crew, access_unsc_navsec)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/tactical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hos(H), slot_belt)
		return 1

/datum/job/UNSC_ship/security
	title = "Naval Security Master-At-Arms"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = SEC
	department_flag = MEDSCI
	total_positions = -1
	spawn_positions = 3
	selection_color = "#990000"
	job_guide = "Your job is to enforce discipline and ensure all crew work to keep the ship secure. In the event of being boarded, you are the first line of defence."

	access = list(access_unsc_crew, access_unsc_navsec)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/tactical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_belt)
		return 1

/obj/structure/closet/unsc_wardrobe/security
	name = "tactical crewman closet"
	desc = "It's a storage unit for tactical uniforms."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/unsc_wardrobe/security/New()
	..()
	new /obj/item/clothing/under/unsc/tactical(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/under/unsc/tactical(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/device/radio/headset/unsc(src)
