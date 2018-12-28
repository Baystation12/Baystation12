
/datum/job/UNSC_ship/logistics_chief
	title = "Crew Chief (logistics)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	department_flag = LOGCO
	total_positions = 1
	spawn_positions = 1
	selection_color = "#ffee00"
	req_admin_notify = 1
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/logistics_chief
	//job_guide = "Your responsibility is to oversee the logistics crewman as they distribute and manage inventory levels, as well as requesting and processing additional supplies as needed."

	access = list(access_unsc_crew, access_unsc_shuttles, access_unsc_supplies)

/datum/job/UNSC_ship/logistics
	title = "Logistics Specialist"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	department_flag = LOG
	total_positions = -1
	spawn_positions = 6
	spawnpoint_override = "UNSC Frigate"
	selection_color = "#ffee00"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/logistics
	alt_titles = list("Ordnance Specialist","Culinary Specialist", "Service Specialist")
	//job_guide = "Your job is to distribute and manage inventory levels, as well as request and process additional supplies as needed."

	access = list(access_unsc_crew, access_unsc_shuttles, access_unsc_supplies)

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
