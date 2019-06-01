GLOBAL_LIST_EMPTY(listen_staff_spawns)

/datum/spawnpoint/listen_staff
	display_name =  "Listening Post Spawn"
	restrict_job = list("Insurrectionist")

/datum/spawnpoint/listen_staff/New()
	..()
	turfs = GLOB.listen_staff_spawns

/obj/effect/landmark/start/listen_staff
	name = "Listening Post Technician"

/obj/effect/landmark/start/listen_staff/New()
	..()
	GLOB.listen_staff_spawns += loc

GLOBAL_LIST_EMPTY(listen_staffl_spawns)

/datum/spawnpoint/listen_staffl
	display_name =  "Listening Post Commander Spawn"
	restrict_job = list("Insurrectionist Commander")

/datum/spawnpoint/listen_staffl/New()
	..()
	turfs = GLOB.listen_staffl_spawns

/obj/effect/landmark/start/listen_staffl
	name = "Listening Post Commander"

/obj/effect/landmark/start/listen_staffl/New()
	..()
	GLOB.listen_staffl_spawns += loc


/decl/hierarchy/outfit/job/Asteroidinnie
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

/decl/hierarchy/outfit/job/Asteroidinnieleader
	name = "Insurrectionist Commander"

	head = /obj/item/clothing/head/helmet/tactical/mirania
	glasses =/obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	suit = /obj/item/clothing/suit/storage/vest/tactical/mirania
	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/tactical
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/tactical
	pda_slot = null
	l_pocket = /obj/item/squad_manager
	r_pocket = /obj/item/device/spy_monitor

	flags = 0

/datum/job/Asteroidinnie
	title = "Insurrectionist"
	total_positions = 7
	spawn_positions = 7
	access = list(632,668)
	outfit_type = /decl/hierarchy/outfit/job/Asteroidinnie
	selection_color = "#008000"
	spawnpoint_override = "Listening Post Spawn"
	announced = FALSE
	is_whitelisted = 0
	alt_titles = list("Insurrectionist Pilot","Insurrectionist Machine Gunner","Insurrectionist Engineer","Insurrectionist Sharpshooter")

/datum/job/Asteroidinnieleader
	title = "Insurrectionist Commander"
	total_positions = 1
	spawn_positions = 1
	access = list(632,667,668)
	outfit_type = /decl/hierarchy/outfit/job/Asteroidinnieleader
	selection_color = "#008000"
	spawnpoint_override = "Listening Post Commander Spawn"
	announced = FALSE
	is_whitelisted = 0
	faction_whitelist = "Insurrection"