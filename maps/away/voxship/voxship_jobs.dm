/datum/job/submap/voxship_vox
	title = "Shoal Scavenger"
	total_positions = 2
	outfit_type = /singleton/hierarchy/outfit/job/voxship/crew
	supervisors = "quill, apex and the arkship"
	info = "Scrap is thin. Not much food is left, but thankfully the sector is quite rich, and it's time to get some more supplies. \
	although staying on base is tempting. Plenty of nitrogen, and not much hazards to worry about."
	whitelisted_species = list(SPECIES_VOX)
	blacklisted_species = null
	is_semi_antagonist = TRUE
	skill_points = 7

/datum/job/submap/voxship_vox/doc
	title = "Shoal Biotechnician"
	total_positions = 1
	info = "You are the sawbones of your scavenger crew. You are in charge of removing stacks, replacing limbs, and generally keeping \
	your kin alive at all costs."
	whitelisted_species = list(SPECIES_VOX)
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_EVA = SKILL_EXPERIENCED,
		SKILL_MEDICAL = SKILL_EXPERIENCED,
		SKILL_ANATOMY = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_DEVICES = SKILL_TRAINED,
		SKILL_WEAPONS = SKILL_BASIC
	)

/datum/job/submap/voxship_vox/engineer
	title = "Shoal Technician"
	total_positions = 1
	info = "You are the mechanic of your scavenger crew. Keep all your salvaged technology running, fix robotics, and disassemble some of \
	the more complex devices your crew comes across."
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_EVA = SKILL_EXPERIENCED,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
		SKILL_ELECTRICAL = SKILL_TRAINED,
		SKILL_ATMOS = SKILL_TRAINED,
		SKILL_ENGINES = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC
	)


/datum/job/submap/voxship_vox/quill
	title = "Quill"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/voxship/crew
	supervisors = "apex and the arkship"
	info = "You're in charge. You fly the ship, and dictate what the crew does. Do not disappoint the Apex."
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA = SKILL_EXPERIENCED,
		SKILL_SCIENCE = SKILL_TRAINED,
		SKILL_PILOT = SKILL_TRAINED,
		SKILL_COMBAT = SKILL_TRAINED,
		SKILL_WEAPONS = SKILL_TRAINED
	)


var/global/const/access_voxship = "ACCESS_VOXSHIP"
/datum/access/vox
	id = access_voxship
	desc = "Vox Ship"
	region = ACCESS_REGION_NONE

/obj/item/card/id/voxship
	access = list(access_voxship)

/obj/machinery/door/airlock/hatch/voxship

#define VOXSHIP_OUTFIT_JOB_NAME
/singleton/hierarchy/outfit/job/voxship
	hierarchy_type = /singleton/hierarchy/outfit/job/voxship
	l_ear = null
	r_ear = null

/singleton/hierarchy/outfit/job/voxship/crew
	id_types = list(/obj/item/card/id/voxship)
	name = ("Vox - Job - Shoal Scavenger")
	uniform = /obj/item/clothing/under/vox/vox_robes
	r_pocket = /obj/item/device/radio
	shoes = /obj/item/clothing/shoes/magboots/vox
	belt = /obj/item/storage/belt/utility/full
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/crowbar/prybar
	l_ear = /obj/item/device/radio/headset/map_preset/voxship

/obj/submap_landmark/spawnpoint/voxship_crew
	name = "Shoal Scavenger"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/submap_landmark/spawnpoint/voxship_crew/doc
	name = "Shoal Biotechnician"

/obj/submap_landmark/spawnpoint/voxship_crew/engineer
	name = "Shoal Technician"

/obj/submap_landmark/spawnpoint/voxship_crew/quill
	name = "Quill"

#undef VOXSHIP_OUTFIT_JOB_NAME
