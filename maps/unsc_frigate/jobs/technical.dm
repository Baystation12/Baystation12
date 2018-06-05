
/datum/job/UNSC_ship/technician_chief
	title = "Crew Chief (technical)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	department_flag = TECHCO
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/technician_chief
	selection_color = "#CC6600"
	req_admin_notify = 1
	//job_guide = "Your responsibility is to oversee the technicians in operating the fusion reactors and repairing damage to the ship. More content is planned in future."

	access = list(access_unsc_tech, access_unsc_crew,
		access_unsc_ops, access_unsc_supplies)

/datum/job/UNSC_ship/technician
	title = "Technician"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	department_flag = TECH
	total_positions = -1
	spawn_positions = 8
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/technician
	selection_color = "#CC6600"
	alt_titles = list("Life Support Technician","Engine Technician","Electrical Technician","Damage Control Technician","EVA Technician","Hull Technician","Maintenance Technician")
	//job_guide = "Your responsibility is to operate the fusion reactors and repair damage to the ship. More content is planned in future."

	access = list(access_unsc_tech, access_unsc_crew,
		access_unsc_ops, access_unsc_supplies)

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
