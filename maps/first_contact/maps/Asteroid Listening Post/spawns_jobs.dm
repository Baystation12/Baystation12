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


/datum/job/Asteroidinnie
	title = "Insurrectionist"
	total_positions = 7
	spawn_positions = 7
	outfit_type = /decl/hierarchy/outfit/job/Asteroidinnie
	selection_color = "#008000"
	spawnpoint_override = "Listening Post Spawn"
	announced = FALSE
	is_whitelisted = 0
	alt_titles = list("Insurrectionist Pilot","Insurrectionist Machine Gunner","Insurrectionist Engineer","Insurrectionist Sharpshooter")
