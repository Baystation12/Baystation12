GLOBAL_LIST_EMPTY(ice_staff_spawns)

/datum/spawnpoint/ice_staff
	display_name =  "Depot Guard Spawn"
	restrict_job = list("Depot Guard")

/datum/spawnpoint/ice_staff/New()
	..()
	turfs = GLOB.ice_staff_spawns

/obj/effect/landmark/start/ice_staff
	name = "Depot Guard Spawn"

/obj/effect/landmark/start/ice_staff/New()
	..()
	GLOB.ice_staff_spawns += loc




/decl/hierarchy/outfit/job/IGUARD
	name = "Depot Guard"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/datum/job/IGUARD
	title = "Depot Guard"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/IGUARD
	selection_color = "#008000"
	access = list(110)
	spawnpoint_override = "Depot Guard Spawn"
	is_whitelisted = 0