GLOBAL_LIST_EMPTY(kigyar_pirate_spawns)

/datum/spawnpoint/kigyar_pirate
	display_name =  "Kig-Yar Pirate Spawn"
	restrict_job = list("Kig-Yar Ship - Pirate","Kig-Yar Ship - Captain","Kig-Yar Ship - Unggoy Crewmember")

/datum/spawnpoint/kigyar_pirate/New()
	..()
	turfs = GLOB.kigyar_pirate_spawns

/obj/effect/landmark/start/kigyar_pirate
	name = "Kig-Yar Pirate Spawn"

/obj/effect/landmark/start/kigyar_pirate/New()
	..()
	GLOB.kigyar_pirate_spawns += loc

/decl/hierarchy/outfit/kigyarpirate
	name = "Kig-Yar Pirate"

	l_ear = /obj/item/device/radio/headset/covenant
	uniform = null
	shoes = null
	head = null
	suit = null

	hierarchy_type = /decl/hierarchy/outfit/kigyarpirate

	flags = 0

/decl/hierarchy/outfit/kigyarpirate/captain
	name = "Kig-Yar Ship-captain"

	l_ear = /obj/item/device/radio/headset/covenant
	uniform = /obj/item/clothing/under/covenant/kigyar
	suit = /obj/item/clothing/suit/armor/covenant/kigyar
	back = null
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/shield_gauntlet/kigyar
	head = /obj/item/clothing/head/helmet/kigyar

	flags = 0

/datum/job/covenant/kigyarpirate
	title = "Kig-Yar Ship - Pirate"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/kigyarpirate
	selection_color = "#667700"
	spawnpoint_override = "Kig-Yar Pirate Spawn"

/datum/job/covenant/kigyarpirate/captain
	title = "Kig-Yar Ship - Captain"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/kigyarpirate/captain
	spawnpoint_override = "Kig-Yar Pirate Spawn"

/datum/job/covenant/unggoy_deacon
	title = "Kig-Yar Ship - Unggoy Crewmember"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/unggoy/major
	spawnpoint_override = "Kig-Yar Pirate Spawn"
