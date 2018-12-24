
/datum/job/UNSC_ship/security_chief
	title = "Naval Security Officer"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	department_flag = SECCO
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/security_chief
	selection_color = "#990000"
	req_admin_notify = 1
	//job_guide = "Your job is to supervise and lead naval security in enforcing discipline and that all crew work to keep the ship secure. In the event being boarded, you are in charge of the defence."

	access = list(access_unsc_crew, access_unsc_navsec)

/datum/job/UNSC_ship/security
	title = "Master-At-Arms"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	department_flag = SEC
	total_positions = -1
	spawn_positions = 3
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/security
	selection_color = "#990000"
	//job_guide = "Your job is to enforce discipline and ensure all crew work to keep the ship secure. In the event of being boarded, you are the first line of defence."

	access = list(access_unsc_crew, access_unsc_navsec)

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
