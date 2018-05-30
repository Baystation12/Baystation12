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


GLOBAL_LIST_EMPTY(facil_security_spawns)

/datum/spawnpoint/facil_security
	display_name =  "Research Facility Security Spawn"
	restrict_job = list("ONI Security Guard","ONI Security Squad Leader")

/datum/spawnpoint/facil_security/New()
	..()
	turfs = GLOB.facil_security_spawns

/obj/effect/landmark/start/facil_security
	name = "Research Facility Security Spawn"

/obj/effect/landmark/start/facil_security/New()
	..()
	GLOB.facil_security_spawns += loc



GLOBAL_LIST_EMPTY(facil_comms_spawns)

/datum/spawnpoint/facil_comms_spawns
	display_name = "Research Facility Comms Spawn"
	restrict_job = list("Communications Operator")

/datum/spawnpoint/facil_comms/New()
	..()
	turfs = GLOB.facil_comms_spawns

/obj/effect/landmark/start/facil_comms
	name = "Research Facility comms Spawn"

/obj/effect/landmark/start/facil_comms/New()
	..()
	GLOB.facil_comms_spawns += loc


/decl/hierarchy/outfit/job/facil_researcher
	name = "Researcher"

	l_ear = /obj/item/device/radio/headset/unsc
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	pda_slot = null
	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/decl/hierarchy/outfit/job/facil_COMMO
	name = "Communications Operator"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/facil_ONIGUARD
	name = "Communications Operator"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/facil_ONIGUARDS
	name = "Communications Operator"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e7, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/datum/job/researcher
	title = "Researcher"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/facil_researcher
	alt_titles = list("Physicist","Botanist","Chemist","Weapons Researcher","Artifact Analyser")
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Spawn"

/datum/job/ONIGUARD
	title = "ONI Security Guard"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARDS
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Spawn"

/datum/job/ONIGUARDS
	title = "ONI Security Squad Leader"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARDS
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Spawn"


/datum/job/COMMO
	title = "Communications Operator"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/facil_COMMO
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Comms Spawn"
	is_whitelisted = 0