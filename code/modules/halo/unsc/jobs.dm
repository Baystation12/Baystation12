/decl/hierarchy/outfit/job/unsc_job
	name = "UNSC"
	hierarchy_type = /decl/hierarchy/outfit/job/unsc_job
	pda_slot = null
	flags = 0

/decl/hierarchy/outfit/job/unsc_job/marine
	name = "UNSC Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	mask = /obj/item/clothing/mask/marine
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e2, /obj/item/clothing/accessory/badge/tags)

/decl/hierarchy/outfit/job/unsc_job/marine/co
	name = "UNSC Commanding Officer"
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/grey

	belt = /obj/item/weapon/gun/projectile/m6d_magnum/CO_magnum
	back = /obj/item/weapon/material/machete/officersword
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o6,/obj/item/clothing/accessory/badge/tags)

/decl/hierarchy/outfit/job/unsc_job/odst
	name = "ODST Rifleman"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/badge/tags)
	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_job/oni_researcher
	name = "ONI Researcher"

	l_ear = /obj/item/device/radio/headset/unsc/oni
	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_pocket = /obj/item/clothing/accessory/badge/onib
	hierarchy_type = /decl/hierarchy/outfit/job

//JOBS//

/datum/job/unsc_job
	spawnpoint_override = "UNSC Base Spawns"
	fallback_spawnpoint = "UNSC Base Fallback Spawns"
	access = list(access_unsc,access_unsc_armoury)
	selection_color = "0A0A95"
	whitelisted_species = list(/datum/species/human)
	spawn_faction = "UNSC"
	loadout_allowed = TRUE
	lace_access = TRUE

/datum/job/unsc_job/unsc_marine
	title = "UNSC Marine"
	total_positions = -1
	spawn_positions = -1
	outfit_type = /decl/hierarchy/outfit/job/unsc_job/marine
	alt_titles = list("Marine Combat Medic",
	"Assault Recon Marine",
	"Designated Marksman Marine",
	"Combat Pilot Marine")

/datum/job/unsc_job/unsc_marine_specialist
	title = "UNSC Marine Specialist"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/unsc_job/marine
	alt_titles = list("Light Machine Gunner Marine","Scout Sniper Marine","Anti-Tank Marine")
	access = list(access_unsc,access_unsc_armoury,access_unsc_specialist)

/datum/job/unsc_job/unsc_squad_lead
	title = "UNSC Squad Leader"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/unsc_job/marine
	access = list(access_unsc,access_unsc_armoury,access_unsc_specialist)

/datum/job/unsc_job/unsc_co
	title = "UNSC Commanding Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc_job/marine/co
	access = list(access_unsc,access_unsc_armoury,access_unsc_specialist,access_unsc_odst,access_unsc_oni)

/datum/job/unsc_job/odst
	title = "UNSC ODST"
	total_positions = 8
	spawn_positions = 8
	access = list(access_unsc,access_unsc_armoury,access_unsc_odst,access_unsc_specialist)
	outfit_type = /decl/hierarchy/outfit/job/unsc_job/odst

/datum/job/unsc_job/oni_researcher
	title = "ONI Researcher"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/unsc_job/oni_researcher
	alt_titles = list("Doctor","Physicist","Botanist","Chemist","Weapons Researcher","Surgeon","Geneticist")
	access = list(access_unsc,access_unsc_armoury,access_unsc_oni)

/datum/spawnpoint/unsc_base
	restrict_job_type = list(\
	/datum/job/unsc_job/unsc_marine,
	/datum/job/unsc_job/unsc_marine_specialist,
	/datum/job/unsc_job/unsc_squad_lead,
	/datum/job/unsc_job/unsc_co,
	/datum/job/unsc_job/odst,
	/datum/job/unsc_job/oni_researcher
	)

GLOBAL_LIST_EMPTY(unsc_base_fallback_spawns)

/datum/spawnpoint/unsc_base_fallback
	display_name = "UNSC Base Fallback Spawns"
	restrict_job_type = list(\
	/datum/job/unsc_job/unsc_marine,
	/datum/job/unsc_job/unsc_marine_specialist,
	/datum/job/unsc_job/unsc_squad_lead,
	/datum/job/unsc_job/unsc_co,
	/datum/job/unsc_job/odst,
	/datum/job/unsc_job/oni_researcher
	)

/datum/spawnpoint/unsc_base_fallback/New()
	..()
	turfs = GLOB.unsc_base_fallback_spawns

/obj/effect/landmark/start/unsc_base_fallback
	name = "UNSC Base Fallback Spawns"

/obj/effect/landmark/start/unsc_base_fallback/New()
	..()
	GLOB.unsc_base_fallback_spawns += loc
