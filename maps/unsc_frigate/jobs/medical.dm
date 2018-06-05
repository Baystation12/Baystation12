
/datum/job/UNSC_ship/medical_chief
	title = "Chief Hospital Corpsman"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	department_flag = MEDCO
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/medical_chief
	selection_color = "#3300cc"
	req_admin_notify = 1
	//job_guide = "Your responsibility is to supervise the hospital corpsman and ensure the crew, pilots and marines are in good medical condition."

	access = list(access_unsc_crew, access_unsc_medical)

/datum/job/UNSC_ship/medical
	title = "Hospital Corpsman"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	department_flag = MED
	total_positions = -1
	spawn_positions = 6
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/medical
	selection_color = "#3300cc"
	//job_guide = "Your job is ensure the crew, pilots and marines are in good medical condition."

	access = list(access_unsc_crew, access_unsc_medical)

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
