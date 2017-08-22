
/datum/job/UNSC_ship/mechanic_chief
	title = "Crew Chief (flight)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = MECHCO
	department_flag = CIVILIAN
	total_positions = 1
	spawn_positions = 1
	selection_color = "#995500"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	job_guide = "Your job is to oversee the flight crew as they repair, maintain, upgrade, rearm and refuel the various strike craft (fighters, shuttles and drophips). You're probably a decent pilot as well but not necessarily combat qualified."

	access = list(access_unsc_crew, access_unsc_fighters,
		access_unsc_shuttles, access_unsc_supplies)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/mechanic(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/ce(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		return 1

/datum/job/UNSC_ship/mechanic
	title = "Flight Mechanic"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = MECH
	department_flag = 	CIVILIAN
	total_positions = -1
	spawn_positions = 4
	selection_color = "#995500"
	alt_titles = list("Deck Mechanic","Hangar Mechanic","Structural Mechanic","Reserve Pilot","Ordnance Mechanic")
	job_guide = "Your job is to repair, maintain, upgrade, rearm and refuel the various strike craft (fighters, shuttles and drophips). You're probably a decent pilot as well but not necessarily combat qualified."

	access = list(access_unsc_crew, access_unsc_fighters,
		access_unsc_shuttles, access_unsc_supplies)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/mechanic(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/engineering(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		return 1

/obj/structure/closet/unsc_wardrobe/mechanic
	name = "flight mechanic closet"
	desc = "It's a storage unit for flight mechanics."
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/unsc_wardrobe/mechanic/New()
	..()
	new /obj/item/clothing/under/unsc/mechanic(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/under/unsc/mechanic(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/device/radio/headset/unsc(src)
