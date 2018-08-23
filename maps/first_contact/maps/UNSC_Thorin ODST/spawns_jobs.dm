GLOBAL_LIST_EMPTY(corvette_crew_spawns)

/datum/spawnpoint/corvette_crew
	display_name = "Corvette Crew"
	restrict_job = list("UNSC Corvette Ship Crew")

/datum/spawnpoint/corvette_crew/New()
	..()
	turfs = GLOB.corvette_crew_spawns

/obj/effect/landmark/start/corvette_crew
	name = "Corvette Crew"

/obj/effect/landmark/start/corvette_crew/New()
	..()
	GLOB.corvette_crew_spawns += loc

GLOBAL_LIST_EMPTY(corvette_captain_spawns)

/datum/spawnpoint/corvette_captain
	display_name = "Corvette Crew Captain"
	restrict_job = list("UNSC Corvette Ship Captain")

/datum/spawnpoint/corvette_captain/New()
	..()
	turfs = GLOB.corvette_captain_spawns

/obj/effect/landmark/start/corvette_captain
	name = "Corvette Crew Captain"

/obj/effect/landmark/start/corvette_captain/New()
	..()
	GLOB.corvette_captain_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_odst_spawns)

/datum/spawnpoint/corvetteodst_odst
	display_name = "ODST Spawn"
	restrict_job = list("Rifleman,Field Medic,Sharpshooter,Combat Engineer,CQC Specialist")

/datum/spawnpoint/corvetteodst_odst/New()
	..()
	turfs = GLOB.corvetteodst_odst_spawns

/obj/effect/landmark/start/corvetteodst_odst
	name = "ODST Spawn"

/obj/effect/landmark/start/corvetteodst_odst/New()
	..()
	GLOB.corvette_odst_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_ftl_spawns)

/datum/spawnpoint/corvetteodst_ftl
	display_name = "Fireteam Leader Spawn"
	restrict_job = list("Fireteam Leader")

/datum/spawnpoint/corvetteodst_ftl/New()
	..()
	turfs = GLOB.corvetteodst_ftl_spawns

/obj/effect/landmark/start/corvetteodst_ftl
	name = "Fireteam Leader Spawn"

/obj/effect/landmark/start/corvetteodst_ftl/New()
	..()
	GLOB.corvetteodst_ftl_spawns += loc

GLOBAL_LIST_EMPTY(corvetteodst_officer_spawns)

/datum/spawnpoint/corvetteodst_officer
	display_name = "Corvette officer ODST Spawn"
	restrict_job = list("Officer")

/datum/spawnpoint/corvetteodst_officer/New()
	..()
	turfs = GLOB.corvetteodst_officer_spawns

/obj/effect/landmark/start/corvetteodst_officer
	name = "Corvette officer ODST Spawn"

/obj/effect/landmark/start/corvetteodst_officer/New()
	..()
	GLOB.corvetteodst_officer_spawns += loc

/datum/job/odstrifleman
	title = "Rifleman"
	total_positions = 8
	spawn_positions = 8
	outfit_type = /decl/hierarchy/outfit/job/ODSTRifleman
	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Spawn"
	is_whitelisted = 1

/datum/job/odstfieldmedic
	title = "Field Medic"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/ODSTMedic
	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Spawn"
	is_whitelisted = 1

/datum/job/odstcqcspecialist
	title = "CQC Specialist"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/ODSTCQC
	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Spawn"
	is_whitelisted = 1

/datum/job/odstcombatengineer
	title = "Combat Engineer"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/ODSTengineer
	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Spawn"
	is_whitelisted = 1

/datum/job/odstsharpshooter
	title = "Sharpshooter"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/ODSTSharpshooter
	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Spawn"
	is_whitelisted = 1

/datum/job/odstfireteamlead
	title = "Fireteam Leader"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/ODSTFireteamLead
	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "Fireteam Leader Spawn"
	is_whitelisted = 1

/datum/job/odstofficercorvette
	title = "Second Lieutenant"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/ODSTFireteamLead
	selection_color = "#008000"
	access = list(142,144,110,300,306,309,310,311)
	spawnpoint_override = "Corvette officer ODST Spawn"
	is_whitelisted = 1



/decl/hierarchy/outfit/job/ODSTSharpshooter
	name = "Sharpshooter"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e5, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/ODSTMedic
	name = "Field Medic"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/fleet/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/ODSTCQC
	name = "CQC Specialist"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e2, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/ODSTengineer
	name = "Combat Engineer"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/ODSTRifleman
	name = "Rifleman"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/ODSTFireteamLead
	name = "Fireteam Leader"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e8, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/ODSTFieldofficer
	name = "Officer"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

