
/datum/job/UNSC_ship/mechanic_chief
	title = "Crew Chief (flight)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	department_flag = MECHCO
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Frigate"
	selection_color = "#995500"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/mechanic_chief
	req_admin_notify = 1
	//job_guide = "Your job is to oversee the flight crew as they repair, maintain, upgrade, rearm and refuel the various strike craft (fighters, shuttles and drophips). You're probably a decent pilot as well but not necessarily combat qualified."

	access = list(access_unsc_crew, access_unsc_fighters,
		access_unsc_shuttles, access_unsc_supplies)

/datum/job/UNSC_ship/mechanic
	title = "Flight Mechanic"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	department_flag = MECH
	total_positions = -1
	spawn_positions = 4
	spawnpoint_override = "UNSC Frigate"
	selection_color = "#995500"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/mechanic
	alt_titles = list("Deck Mechanic","Hangar Mechanic","Structural Mechanic","Reserve Pilot","Ordnance Mechanic")
	//job_guide = "Your job is to repair, maintain, upgrade, rearm and refuel the various strike craft (fighters, shuttles and drophips). You're probably a decent pilot as well but not necessarily combat qualified."

	access = list(access_unsc_crew, access_unsc_fighters,
		access_unsc_shuttles, access_unsc_supplies)

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
