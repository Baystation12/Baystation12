GLOBAL_LIST_EMPTY(example_spawns)

/datum/spawnpoint/example
	display_name =  "Test Spawn"
	restrict_job = list("Test Officer")

/datum/spawnpoint/example/New()
	..()
	turfs = GLOB.example_spawns

/obj/effect/landmark/start/example
	name = "Test Spawn"

/obj/effect/landmark/start/example/New()
	..()
	GLOB.example_spawns += loc

/decl/hierarchy/outfit/job/test
	name = "test"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/datum/job/example
	title = "Test Officer"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#008000"
	outfit_type = /decl/hierarchy/outfit/job/test
	access = list(142,110,300,306,309,310,311)
	spawnpoint_override = "Test Spawn"
	is_whitelisted = 1

