GLOBAL_LIST_EMPTY(innie_crew_spawns)

/datum/spawnpoint/innie_crew
	display_name = "Innie Crew"
	restrict_job = list("Insurrectionist Ship Crew")

/datum/spawnpoint/innie_crew/New()
	..()
	turfs = GLOB.innie_crew_spawns

/obj/effect/landmark/start/innie_crew
	name = "Innie Crew"

/obj/effect/landmark/start/innie_crew/New()
	..()
	GLOB.innie_crew_spawns += loc

GLOBAL_LIST_EMPTY(innie_captain_spawns)

/datum/spawnpoint/innie_captain
	display_name = "Innie Captain"
	restrict_job = list("Insurrectionist Ship Captain")

/datum/spawnpoint/innie_captain/New()
	..()
	turfs = GLOB.innie_captain_spawns

/obj/effect/landmark/start/innie_captain
	name = "Innie Captain"

/obj/effect/landmark/start/innie_captain/New()
	..()
	GLOB.innie_captain_spawns += loc

//Innies who usually use the asteroid can use the bertels now.

GLOBAL_LIST_EMPTY(innie_spawns)

/datum/spawnpoint/innie
	display_name =  "Innie Spawn"
	restrict_job = list("Insurrectionist")

/datum/spawnpoint/innie/New()
	..()
	turfs = GLOB.innie_spawns

/obj/effect/landmark/start/innie
	name = "Innie"

/obj/effect/landmark/start/innie/New()
	..()
	GLOB.innie_spawns += loc

GLOBAL_LIST_EMPTY(innieL_spawns)

/datum/spawnpoint/innieL
	display_name =  "Innie Commander Spawn"
	restrict_job = list("Insurrectionist Commander")

/datum/spawnpoint/innieL/New()
	..()
	turfs = GLOB.innieL_spawns

/obj/effect/landmark/start/innieL
	name = "Innie Commander"

/obj/effect/landmark/start/innieL/New()
	..()
	GLOB.innieL_spawns += loc

GLOBAL_LIST_EMPTY(commando_spawns)

/datum/spawnpoint/commando_spawn
	display_name = "Commando Spawn"
	restrict_job = list("URF Commando")

/datum/spawnpoint/commando_spawn/New()
	..()
	turfs = GLOB.commando_spawns

/obj/effect/landmark/start/commando_spawn
	name = "Commando Spawn"

/obj/effect/landmark/start/commando_spawn/New()
	..()
	GLOB.commando_spawns += loc

GLOBAL_LIST_EMPTY(commando_officer_spawns)

/datum/spawnpoint/commando_officer_spawn
	display_name = "Commando Officer Spawn"
	restrict_job = list("URF Commando Officer")

/datum/spawnpoint/commando_officer_spawn/New()
	..()
	turfs = GLOB.commando_officer_spawns

/obj/effect/landmark/start/commando_officer_spawn
	name = "Commando Officer Spawn"

/obj/effect/landmark/start/commando_officer_spawn/New()
	..()
	GLOB.commando_officer_spawns += loc


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
	spawnpoint_override = "Innie Spawn"
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
	spawnpoint_override = "Innie Commander Spawn"
	announced = FALSE
	is_whitelisted = 0
	faction_whitelist = "Insurrection"

/datum/job/URF_commando
	title = "URF Commando"
	outfit_type = /decl/hierarchy/outfit/job/URF_commando
	alt_titles = list("Recruit",\
	"Velites",\
	"Hastari",\
	"Principes",\
	"Triarii",\
	"Decanus",\
	"Tessearius")

	total_positions = 8
	spawn_positions = 8
	selection_color = "#0A0A95"
	access = list(252,632)
	spawnpoint_override = "Commando Spawn"
	is_whitelisted = 1

/datum/job/URF_commando_officer
	title = "URF Commando Officer"
	outfit_type = /decl/hierarchy/outfit/job/URF_commando_officer
	alt_titles = list("Optio",\
	"Centurion",\
	"Tribune",\
	"Legio",\
	"Legate")

	total_positions = 1
	spawn_positions = 1
	selection_color = "#0A0A95"
	access = list(252,632)
	spawnpoint_override = "Commando Officer Spawn"
	is_whitelisted = 1

