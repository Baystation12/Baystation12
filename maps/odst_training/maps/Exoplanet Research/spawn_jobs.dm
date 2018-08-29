GLOBAL_LIST_EMPTY(hostage_spawns)

/datum/spawnpoint/hostage
	display_name =  "Research Facility Spawn"
	restrict_job = list("Hostage")

/datum/spawnpoint/hostage/New()
	..()
	turfs = GLOB.hostage_spawns

/obj/effect/landmark/start/hostage
	name = "Researcher Spawn"

/obj/effect/landmark/start/hostage/New()
	..()
	GLOB.hostage_spawns += loc



GLOBAL_LIST_EMPTY(occupier_spawns)

/datum/spawnpoint/occupier
	display_name =  "Research Facility Insurrectionist Spawn"
	restrict_job = list("Insurrectionist","Insurrectionist Commander")

/datum/spawnpoint/occupier/New()
	..()
	turfs = GLOB.occupier_spawns

/obj/effect/landmark/start/occupier
	name = "Research Facility Insurrectionist Spawn"

/obj/effect/landmark/start/occupier/New()
	..()
	GLOB.occupier_spawns += loc



/decl/hierarchy/outfit/job/hostage
	name = "Hostage"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_pocket = /obj/item/clothing/accessory/badge/onib
	pda_slot = null
	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/traininginnie
	name = "Insurrectionist"

	head = /obj/item/clothing/head/helmet/tactical
	glasses = /obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	suit = /obj/item/clothing/suit/storage/vest/tactical
	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/tactical
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/tactical
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/datum/job/hostage
	title = "Hostage"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/hostage
	selection_color = "#008000"
	spawnpoint_override = "Research Facility Spawn"

/datum/job/traininginsurrectionist
	title = "Insurrectionist"
	total_positions = 25
	spawn_positions = 25
	outfit_type = /decl/hierarchy/outfit/job/traininginnie
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Insurrectionist Spawn"

/datum/job/traininginsurrectionistcommander
	title = "Insurrectionist Commander"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/traininginnie
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Insurrectionist Spawn"