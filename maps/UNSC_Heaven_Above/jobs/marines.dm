
/datum/job/UNSC_ship/marine_co
	title = "UNSC Heavens Above Marine Company Officer"
	min_rank = RANK_CAPT
	default_rank = RANK_COL
	max_rank = MARINE_CO_MAX
	department_flag = MARCO
	total_positions = 1
	spawn_positions = 1
	selection_color = "#667700"
	req_admin_notify = 1
	spawnpoint_override = "UNSC Base Spawns"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine_co
	is_whitelisted = 1
	//job_guide = "Your responsibility is to command the shipboard complement of marines. Nominally you answer to the captain, but he has limited control over you once deployed. Remember that a good soldier leads from the front, but you can't lead if you're dead."

	access = list(access_unsc_bridge, access_unsc_crew, access_unsc_shuttles,
		access_unsc_armoury, access_unsc_officers, access_unsc_marine,308)

/datum/job/UNSC_ship/marine_xo
	title = "UNSC Heavens Above Marine Company Sergeant"
	min_rank = MARINE_CO_MIN
	default_rank = RANK_1LT
	max_rank = RANK_CAPT
	department_flag = MARXO
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Base Spawns"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine_xo
	selection_color = "#667700"
	req_admin_notify = 1
	//job_guide = "You are the 2IC of the shipboard marine complement, and what the marine CO says to you is gospel. Remember that a good soldier leads from the front, but you can't lead if you're dead."

	access = list(access_unsc_bridge, access_unsc_crew, access_unsc_shuttles,
		access_unsc_armoury, access_unsc_officers, access_unsc_marine,308)

/datum/job/UNSC_ship/marine_sl
	title = "UNSC Heavens Above Marine Squad Leader"
	min_rank = MARINE_SL_MIN
	default_rank = RANK_SGT
	max_rank = MARINE_SL_MAX
	department_flag = MARSL
	total_positions = 2
	spawn_positions = 6
	spawnpoint_override = "UNSC Base Spawns"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine_sl
	selection_color = "#667700"
	//job_guide = "You lead a squad of marines (not yet implemented, so pick some guys to be in your squad and try to RP it). Your marines are the best of the best, but they're only human."

	access = list(access_unsc_crew, access_unsc_shuttles,
		access_unsc_armoury, access_unsc_marine,308)

/datum/job/UNSC_ship/weapons
	title = "UNSC Heavens Above Infantry Weapons Officer"
	total_positions = 2
	spawn_positions = 4
	spawnpoint_override = "UNSC Base Spawns"
	min_rank = RANK_GYSGT
	default_rank = RANK_GYSGT
	max_rank = RANK_MGYSGT
	department_flag = MARWEP
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/logistics
	selection_color = "#667700"
	//job_guide = "You, master guns, know your weaponry better than almost any human alive. It's too bad you get treated like a glorified desk jockey whose main responsibility is doling out responsible portions of weaponry to needy marines."
	access = list(access_unsc_crew,
		access_unsc_armoury, access_unsc_marine,308)
	latejoin_at_spawnpoints = TRUE

/datum/job/UNSC_ship/marine
	title = "UNSC Heavens Above Marine"
	min_rank = MARINE_MIN
	default_rank = RANK_PVT
	max_rank = MARINE_MAX
	department_flag = MAR
	total_positions = -1
	spawn_positions = 12
	spawnpoint_override = "UNSC Base Spawns"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine
	selection_color = "#667700"
	alt_titles = list("Machine Gunner Marine","Marine Combat Medic","Assault Recon Marine",\
	"Designated Marksman Marine","Scout Sniper Marine","Anti-Tank Missile Gunner Marine",\
	"EVA Combat Marine")
	//job_guide = "Ooh rah marines! You're tha hardest son of a bitch this side of Terra and don't you know it! Other navy personnel just can't compare. Don't forget to follow orders and listen to your squad leader though."

	access = list(access_unsc_crew, access_unsc_marine,308)

/datum/job/UNSC_ship/marine/driver
	title = "UNSC Heavens Above Ground Vehicle Operator"
	department_flag = MARDR
	total_positions = 3
	spawn_positions = 5
	spawnpoint_override = "UNSC Base Spawns"
	alt_titles = list("Light Armored Vehicle Operator","Heavy Armored Vehicle Operator","Support Vehicle Operator","Tilt-rotor/VTOL Operator")

/datum/job/UNSC_ship/marine/specialist
	title = "UNSC Heavens Above Combat Engineer"
	department_flag = MARSPEC
	total_positions = 3
	spawn_positions = 8
	spawnpoint_override = "UNSC Base Spawns"
	alt_titles = list("Field Radio Operator","Explosive Ordnance Disposal Marine","Hazardous Materials Marine")

/obj/structure/closet/unsc_wardrobe/marine
	name = "marine fatigues closet"
	desc = "It's a storage unit for marine fatigues."
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/unsc_wardrobe/marine/New()
	..()
	new /obj/item/clothing/under/unsc/marine_fatigues(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/device/radio/headset/unsc/marine(src)
	new /obj/item/clothing/under/unsc/marine_fatigues(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/device/radio/headset/unsc/marine(src)
	new /obj/item/clothing/head/helmet/marine(src)
	new /obj/item/clothing/suit/storage/marine(src)

//UNSC Heaven Above ODST Jobs
/*
/datum/job/HeavenAbove_ODST
	title = "Orbital Drop Shock Trooper"
	total_positions = 5
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/bertelsfacil_ODST
	alt_titles = list("Private First Class"= /decl/hierarchy/outfit/job/bertelsODSTCQC,
	"Lance Corporal"= /decl/hierarchy/outfit/job/bertelsODSTengineer,
	"Corporal"= /decl/hierarchy/outfit/job/bertelsfacil_ODST,
	"Petty Officer Third Class"= /decl/hierarchy/outfit/job/bertelsODSTMedic,
	"Sergeant"= /decl/hierarchy/outfit/job/bertelsODSTSharpshooter,
	"Staff Sergeant"= /decl/hierarchy/outfit/job/bertelsODSTstaffsergeant,
	"Gunnery Sergeant"= /decl/hierarchy/outfit/job/bertelsODSTgunnerysergeant,
	"Master Sergeant" = /decl/hierarchy/outfit/job/bertelsODSTFireteamLead)

	selection_color = "#0A0A95"
	access = list(142,144,110,192,309,310)
	//spawnpoint_override = "UNSC Bertels ODST Spawn"
	is_whitelisted = 1

/datum/job/HeavenAbove_ODSTO
	title = "Orbital Drop Shock Trooper Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/bertelsODSTsecondlieutenant
	alt_titles = list("Second Lieutenant" = /decl/hierarchy/outfit/job/bertelsODSTsecondlieutenant,
	"First Lieutenant" = /decl/hierarchy/outfit/job/bertelsODSTfirstlieutenant,
	"Captain" = /decl/hierarchy/outfit/job/bertelsODSTcaptain,
	"Major" = /decl/hierarchy/outfit/job/bertelsODSTmajor,
	"Lieutenant Colonel" = /decl/hierarchy/outfit/job/bertelsODSTltcolonel,
	"Colonel" = /decl/hierarchy/outfit/job/bertelsODSTcolonel)
	selection_color = "#0A0A95"
	access = list(142,144,145,110,192,300,306,309,310,311)
	//spawnpoint_override = "UNSC Bertels ODST Officer Spawn"
	is_whitelisted = 1
*/