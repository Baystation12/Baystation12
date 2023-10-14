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
	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_MECH = SKILL_MAX,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_MAX,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL = SKILL_TRAINED,
		SKILL_ATMOS = SKILL_TRAINED,
		SKILL_ENGINES = SKILL_TRAINED,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_TRAINED,
		SKILL_ANATOMY = SKILL_TRAINED,
		SKILL_CHEMISTRY = SKILL_TRAINED
	)

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
		SKILL_DEVICES = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_MECH = SKILL_MAX,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_MAX,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
		SKILL_ELECTRICAL = SKILL_TRAINED,
		SKILL_ATMOS = SKILL_TRAINED,
		SKILL_ENGINES = SKILL_TRAINED,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_MAX,
		SKILL_ANATOMY = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)
	skill_points = 20

/datum/job/submap/voxship_vox/engineer
	title = "Shoal Technician"
	total_positions = 1
	info = "You are the mechanic of your scavenger crew. Keep all your salvaged technology running, fix robotics, and disassemble some of \
	the more complex devices your crew comes across."
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_EVA = SKILL_EXPERIENCED,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
		SKILL_ELECTRICAL = SKILL_BASIC,
		SKILL_ATMOS = SKILL_BASIC,
		SKILL_ENGINES = SKILL_BASIC
	)

	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_MECH = SKILL_MAX,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_MAX,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL = SKILL_MAX,
		SKILL_ATMOS = SKILL_MAX,
		SKILL_ENGINES = SKILL_MAX,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_TRAINED,
		SKILL_ANATOMY = SKILL_TRAINED,
		SKILL_CHEMISTRY = SKILL_TRAINED
	)
	skill_points = 20

/datum/job/submap/voxship_vox/quill
	title = "Quill"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/voxship/crew
	supervisors = "apex and the arkship"
	info = "You're in charge. You fly the ship, and dictate what the crew does. Do not disappoint the Apex."
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_EVA = SKILL_EXPERIENCED,
		SKILL_SCIENCE = SKILL_TRAINED,
		SKILL_PILOT = SKILL_TRAINED,
		SKILL_COMBAT = SKILL_TRAINED,
		SKILL_WEAPONS = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_MECH = SKILL_MAX,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_MAX,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL = SKILL_EXPERIENCED,
		SKILL_ATMOS = SKILL_EXPERIENCED,
		SKILL_ENGINES = SKILL_EXPERIENCED,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_EXPERIENCED,
		SKILL_ANATOMY = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY = SKILL_EXPERIENCED
	)
	skill_points = 20

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
