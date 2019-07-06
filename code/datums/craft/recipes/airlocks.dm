/datum/craft_recipe/airlock
	category = "Airlocks"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	time = 150
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
	)

/datum/craft_recipe/airlock/standard
	name = "standard airlock assembly"
	result = /obj/structure/door_assembly

/datum/craft_recipe/airlock/command
	name = "command airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_com

/datum/craft_recipe/airlock/security
	name = "security airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_sec

/datum/craft_recipe/airlock/engineering
	name = "engineering airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_eng

/datum/craft_recipe/airlock/mining
	name = "mining airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_min

/datum/craft_recipe/airlock/atmospherics
	name = "atmospherics airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_atmo

/datum/craft_recipe/airlock/research
	name = "research airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_research

/datum/craft_recipe/airlock/medical
	name = "medical airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_med

/datum/craft_recipe/airlock/maintenance
	name = "maintenance airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_mai

/datum/craft_recipe/airlock/external
	name = "external airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_ext

/datum/craft_recipe/airlock/freezer
	name = "freezer airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_fre

/datum/craft_recipe/airlock/airtight
	name = "airtight hatch assembly"
	result = /obj/structure/door_assembly/door_assembly_hatch

/datum/craft_recipe/airlock/maintenance
	name = "maintenance hatch assembly"
	result = /obj/structure/door_assembly/door_assembly_mhatch

/datum/craft_recipe/airlock/high_security
	name = "high security airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_highsecurity

/datum/craft_recipe/airlock/emergency_shutter
	name = "emergency shutter"
	result = /obj/structure/firedoor_assembly

/datum/craft_recipe/airlock/multitile
	name = "multi-tile airlock assembly"
	result = /obj/structure/door_assembly/multi_tile
	steps = list(
		list(CRAFT_MATERIAL, 20, MATERIAL_STEEL),
	)

