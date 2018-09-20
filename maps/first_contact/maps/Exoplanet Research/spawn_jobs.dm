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



GLOBAL_LIST_EMPTY(facil_director_spawns)

/datum/spawnpoint/facil_director
	display_name =  "Research Facility Director Spawn"
	restrict_job = list("Research Director")

/datum/spawnpoint/facil_director/New()
	..()
	turfs = GLOB.facil_director_spawns

/obj/effect/landmark/start/facil_director
	name = "Research Director Spawn"

/obj/effect/landmark/start/facil_director/New()
	..()
	GLOB.facil_director_spawns += loc



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

/datum/spawnpoint/facil_comms
	display_name =  "Research Facility Comms Spawn"
	restrict_job = list("ONI Communications Operator")

/datum/spawnpoint/facil_comms/New()
	..()
	turfs = GLOB.facil_comms_spawns

/obj/effect/landmark/start/facil_comms
	name = "Research Facility Comms Spawn"

/obj/effect/landmark/start/facil_comms/New()
	..()
	GLOB.facil_comms_spawns += loc



/decl/hierarchy/outfit/job/facil_researcher
	name = "Researcher"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_pocket = /obj/item/clothing/accessory/badge/onib
	pda_slot = null
	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/researchdirector
	name = "Research Director"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/rank/research_director/rdalt
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	l_pocket = /obj/item/clothing/accessory/badge/onib
	pda_slot = null
	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/decl/hierarchy/outfit/job/facil_COMMO
	name = "ONI Communications Operator"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/oni_uniform
	gloves = /obj/item/clothing/gloves/thick/oni_guard
	shoes = /obj/item/clothing/shoes/oni_guard
	belt = /obj/item/weapon/storage/belt/marine_ammo/oni
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/facil_ONIGUARD
	name = "ONI Security Guard"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/oni_uniform
	gloves = /obj/item/clothing/gloves/thick/oni_guard
	shoes = /obj/item/clothing/shoes/oni_guard
	belt = /obj/item/weapon/storage/belt/marine_ammo/oni
	l_pocket = /obj/item/clothing/accessory/badge/onib
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/facil_ONIGUARDS
	name = "ONI Security Squad Leader"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/oni_uniform
	gloves = /obj/item/clothing/gloves/thick/oni_guard
	shoes = /obj/item/clothing/shoes/oni_guard
	belt = /obj/item/weapon/storage/belt/marine_ammo/oni
	l_pocket = /obj/item/clothing/accessory/badge/onib
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e7, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/datum/job/researcher
	title = "Researcher"
	total_positions = 10
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/facil_researcher
	alt_titles = list("Doctor","Physicist","Botanist","Chemist","Weapons Researcher","Surgeon","Geneticist")
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Spawn"

/datum/job/researchdirector
	title = "Research Director"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/researchdirector
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Director Spawn"


/datum/job/ONIGUARD
	title = "ONI Security Guard"
	total_positions = 9
	spawn_positions = 9
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARD
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
	title = "ONI Communications Operator"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/facil_COMMO
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Comms Spawn"
	is_whitelisted = 0