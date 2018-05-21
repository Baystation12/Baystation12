GLOBAL_LIST_EMPTY(facil_researcher_spawns)

/datum/spawnpoint/facil_researcher
	display_name =  "Research Facility Spawn"
	restrict_job = list("Researcher")

/datum/spawnpoint/facil_researcher/New()
	..()
	turfs = GLOB.facil_researcher_spawns

/obj/effect/landmark/start/facil_researcher
	name = "Researcher Spawn"

/obj/effect/landmark/start/facil_researcher/New()
	..()
	GLOB.facil_researcher_spawns += loc


GLOBAL_LIST_EMPTY(facil_security_spawn)

/datum/spawnpoint/facil_security_spawn
	display_name = "Research Facility Security Spawn"
	restrict_job = list("ODST Rifleman","ONI Officer")

/datum/spawnpoint/facil_security_spawn/New()
	..()
	turfs = GLOB.facil_security_spawn

/obj/effect/landmark/start/facil_security_spawn
	name = "Research Facility Security Spawn"

/obj/effect/landmark/start/facil_security_spawn/New()
	..()
	GLOB.facil_security_spawn += loc


/decl/hierarchy/outfit/job/facil_researcher
	name = "Researcher"

	l_ear = /obj/item/device/radio/headset/unsc
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	pda_slot = null
	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/facil_ODST
	name = "ODST Rifleman"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	shoes = /obj/item/clothing/shoes/jungleboots
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/facil_ODSTO
	name = "ODST Squad Leader"
	l_ear = /obj/item/device/radio/headset/unsc/odsto
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	shoes = /obj/item/clothing/shoes/jungleboots
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	l_pocket = /obj/item/weapon/folder/envelope/nuke_instructions
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/datum/job/researcher
	title = "Researcher"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/facil_researcher
	alt_titles = list("Physicist","Botanist","Chemist","Weapons Researcher","Artifact Analyser")
	selection_color = "#667700"
	access = list(309)
	spawnpoint_override = "Research Facility Spawn"

/datum/job/ODST
	title = "ODST Rifleman"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/facil_ODST
	alt_titles = list("ODST Medic","ODST CQC Specialist")
	selection_color = "#667700"
	access = list(309)
	spawnpoint_override = "Research Facility Security Spawn"
	is_whitelisted = 1

/datum/job/ODSTO
	title = "ODST Squad Leader"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/facil_ODSTO
	selection_color = "#667700"
	access = list(309,310)
	spawnpoint_override = "Research Facility Security Spawn"
	is_whitelisted = 1