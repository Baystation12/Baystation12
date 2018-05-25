GLOBAL_LIST_EMPTY(listen_staff_spawns)

/datum/spawnpoint/listen_staff
	display_name =  "Listening Post Spawn"
	restrict_job = list("Listening Post Technician")

/datum/spawnpoint/listen_staff/New()
	..()
	turfs = GLOB.listen_staff_spawns

/obj/effect/landmark/start/listen_staff
	name = "Listening Post Technician"

/obj/effect/landmark/start/listen_staff/New()
	..()
	GLOB.listen_staff_spawns += loc




/decl/hierarchy/outfit/job/LISTENG
	name = "Listening Post Technician"
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
	title = "Listening Post Technician"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/LISTENG
	selection_color = "#008000"
	access = list(110)
	spawnpoint_override = "Listening Post Spawn"
	is_whitelisted = 0