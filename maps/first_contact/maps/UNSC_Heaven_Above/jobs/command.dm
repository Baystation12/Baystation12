/datum/job/UNSC_ship
	title = "unknown" //For travis
	faction_flag = UNSC //Defining here rather than in every job

//ship commanding officer
/datum/job/UNSC_ship/commander
	title = "Commanding Officer"
	min_rank = RANK_LCDR
	default_rank = RANK_CPT
	max_rank = RANK_CPT
	department_flag = CO
	total_positions = 1
	spawn_positions = 1
	ideal_character_age = 40
	minimal_player_age = 21
	spawnpoint_override = "UNSC Frigate"
	selection_color = "#777777"
	req_admin_notify = 1
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/CO
	is_whitelisted = 1
	//job_guide = "Commander on deck! This is your ship, and your word is law. Subject matter experts have theoretical authority in their area of expertise, but otherwise everyone on the ship is a tool to complete the mission and the more that go home the better."

	access = list(access_unsc_bridge, access_unsc_tech, access_unsc_crew, access_unsc_navsec,
		access_unsc_ops, access_unsc_fighters, access_unsc_shuttles, access_unsc_medical,
		access_unsc_armoury, access_unsc_supplies, access_unsc_officers, access_unsc_marine,
		access_unsc_gunnery, access_unsc_ids, 60)

//ship 2ic officer
/datum/job/UNSC_ship/exo
	title = "Executive Officer"
	min_rank = RANK_LT
	default_rank = RANK_CDR
	max_rank = RANK_CDR
	department_flag = XO
	total_positions = 1
	spawn_positions = 1
	ideal_character_age = 40
	minimal_player_age = 14
	spawnpoint_override = "UNSC Frigate"
	selection_color = "#777777"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/EXO
	req_admin_notify = 1
	//job_guide = "You are the 2IC to the commanding officer of the ship. You are to assist him wherever possible, primarily by getting him to delegate tasks to you and other crewmembers."

	access = list(access_unsc_bridge, access_unsc_tech, access_unsc_crew, access_unsc_navsec,
		access_unsc_ops, access_unsc_fighters, access_unsc_shuttles, access_unsc_medical,
		access_unsc_armoury, access_unsc_supplies, access_unsc_officers, access_unsc_marine,
		access_unsc_gunnery, access_unsc_ids, 60)

//overall commander of strike craft
/datum/job/UNSC_ship/cag
	title = "Commander Air Group"
	min_rank = RANK_LT
	default_rank = RANK_CDR
	max_rank = RANK_CDR
	department_flag = CAG
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/cag
	selection_color = "#777777"
	//job_guide = "You are the ultimate commander of all strike craft (fighters, shuttles, dropships) on the ship. You have the final word on docking approaches, fire missions, strike deployments and whether to engage or retreat. Remember to trust the word of your pilots though as you're stuck on the bridge and it's probably been decades since you flew yourself."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_ops, access_unsc_fighters, access_unsc_shuttles,
		access_unsc_armoury, access_unsc_officers)

//misc officers
/datum/job/UNSC_ship/bridge
	title = "Bridge Officer"
	min_rank = RANK_ENSIGN
	default_rank = RANK_LT
	max_rank = RANK_CDR
	department_flag = BO
	total_positions = -1
	spawn_positions = 2
	ideal_character_age = 40
	minimal_player_age = 7
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/BO
	selection_color = "#777777"
	//job_guide = "You are a bridge officer. It's your job to push buttons, supervise and generally look busy. Try and help out one of the senior officers if you can, otherwise go and bug busy crewmen elsewhere on the ship."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_ops, access_unsc_armoury, access_unsc_officers)

/obj/structure/closet/unsc_wardrobe/command
	name = "command crew closet"
	desc = "It's a storage unit for command uniforms."
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/unsc_wardrobe/command/New()
	..()
	new /obj/item/clothing/under/unsc/command(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/unsc/commander(src)
	new /obj/item/clothing/under/unsc/command(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/unsc/commander(src)
