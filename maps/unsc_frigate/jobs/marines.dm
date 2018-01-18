
/datum/job/UNSC_ship/marine_co
	title = "Marine Commanding Officer"
	min_rank = RANK_CAPT
	default_rank = RANK_COL
	max_rank = MARINE_CO_MAX
	department_flag = MARCO
	total_positions = 1
	spawn_positions = 1
	selection_color = "#667700"
	req_admin_notify = 1
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine_co
	//job_guide = "Your responsibility is to command the shipboard complement of marines. Nominally you answer to the captain, but he has limited control over you once deployed. Remember that a good soldier leads from the front, but you can't lead if you're dead."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_armoury, access_unsc_officers, access_unsc_marine)

/datum/job/UNSC_ship/marine_xo
	title = "Marine Executive Officer"
	min_rank = MARINE_CO_MIN
	default_rank = RANK_1LT
	max_rank = RANK_CAPT
	department_flag = MARXO
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine_xo
	selection_color = "#667700"
	req_admin_notify = 1
	//job_guide = "You are the 2IC of the shipboard marine complement, and what the marine CO says to you is gospel. Remember that a good soldier leads from the front, but you can't lead if you're dead."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_armoury, access_unsc_officers, access_unsc_marine)

/datum/job/UNSC_ship/marine_sl
	title = "Marine Squad Leader"
	min_rank = MARINE_SL_MIN
	default_rank = RANK_SGT
	max_rank = MARINE_SL_MAX
	department_flag = MARSL
	total_positions = 2
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine_sl
	selection_color = "#667700"
	//job_guide = "You lead a squad of marines (not yet implemented, so pick some guys to be in your squad and try to RP it). Your marines are the best of the best, but they're only human."

	access = list(access_unsc_crew,
		access_unsc_armoury, access_unsc_marine)

/datum/job/UNSC_ship/marine_sl/weapons
	title = "Infantry Weapons Officer"
	total_positions = 1
	spawn_positions = 4
	min_rank = RANK_GYSGT
	default_rank = RANK_GYSGT
	max_rank = RANK_MGYSGT
	department_flag = MARWEP
	//job_guide = "You, master guns, know your weaponry better than almost any human alive. It's too bad you get treated like a glorified desk jockey whose main responsibility is doling out responsible portions of weaponry to needy marines."

/datum/job/UNSC_ship/marine
	title = "Marine"
	min_rank = MARINE_MIN
	default_rank = RANK_PVT
	max_rank = MARINE_MAX
	department_flag = MAR
	total_positions = -1
	spawn_positions = 12
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/marine
	selection_color = "#667700"
	alt_titles = list("Machine Gunner Marine","Marine Combat Medic","Assault Recon Marine",\
	"Designated Marksman Marine","Scout Sniper Marine","Anti-Tank Missile Gunner Marine",\
	"EVA Combat Marine")
	//job_guide = "Ooh rah marines! You're tha hardest son of a bitch this side of Terra and don't you know it! Other navy personnel just can't compare. Don't forget to follow orders and listen to your squad leader though."

	access = list(access_unsc_crew, access_unsc_marine)

/datum/job/UNSC_ship/marine/driver
	title = "Ground Vehicle Operator"
	department_flag = MARDR
	total_positions = 3
	spawn_positions = 5
	alt_titles = list("Light Armored Vehicle Operator","Heavy Armored Vehicle Operator","Support Vehicle Operator","Tilt-rotor/VTOL Operator")

/datum/job/UNSC_ship/marine/specialist
	title = "Combat Engineer"
	department_flag = MARSPEC
	total_positions = 3
	spawn_positions = 8
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
	new /obj/item/clothing/suit/armor/marine(src)
