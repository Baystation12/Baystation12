/datum/job/submap/voxship_vox
	title = "Shoal Scavenger"
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/voxship/crew
	supervisors = "quill, apex and the arkship"
	info = "Scrap is thin. Not much food is left, but thankfully the sector is quite rich, and it's time to get some more supplies. \
	although staying on base is tempting. Plenty of nitrogen, and not much hazards to worry about."
	whitelisted_species = list(SPECIES_VOX)
	blacklisted_species = null
	is_semi_antagonist = TRUE

/datum/job/submap/voxship_vox/New(var/datum/submap/_owner, var/abstract_job = FALSE)
	..()
	max_skill[SKILL_ELECTRICAL] = SKILL_ADEPT
	max_skill[SKILL_ATMOS] = SKILL_ADEPT
	max_skill[SKILL_ENGINES] = SKILL_ADEPT
	max_skill[SKILL_MEDICAL] = SKILL_ADEPT
	max_skill[SKILL_ANATOMY] = SKILL_ADEPT
	max_skill[SKILL_CHEMISTRY] = SKILL_ADEPT
	
/datum/job/submap/voxship_vox/doc
	title = "Shoal Biotechnician"
	total_positions = 1
	info = "You are the sawbones of your scavenger crew. You are in charge of removing stacks, replacing limbs, and generally keeping your kin alive at all costs."
	whitelisted_species = list(SPECIES_VOX)
	min_skill = list(	SKILL_HAULING     = SKILL_BASIC,
						SKILL_EVA         = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_EXPERT,
						SKILL_CHEMISTRY   = SKILL_BASIC)
	skill_points = 20

/datum/job/submap/voxship_vox/doc/New(var/datum/submap/_owner, var/abstract_job = FALSE)
	..()
	max_skill[SKILL_CONSTRUCTION] = SKILL_ADEPT
	max_skill[SKILL_ELECTRICAL] = SKILL_ADEPT
	max_skill[SKILL_ATMOS] = SKILL_ADEPT
	max_skill[SKILL_ENGINES] = SKILL_ADEPT
	max_skill[SKILL_MEDICAL] = SKILL_MAX
	max_skill[SKILL_ANATOMY] = SKILL_MAX
	max_skill[SKILL_CHEMISTRY] = SKILL_MAX
	
/datum/job/submap/voxship_vox/engineer
	title = "Shoal Technician"
	total_positions = 1
	info = "You are the mechanic of your scavenger crew. Keep all your salvaged technology running, fix robotics, and disassemble some of the more complex devices your crew comes across."
	min_skill = list(	SKILL_HAULING     = SKILL_BASIC,
						SKILL_COMPUTER     = SKILL_BASIC,
	                    SKILL_EVA          = SKILL_EXPERT,
	                    SKILL_CONSTRUCTION = SKILL_ADEPT,
	                    SKILL_ELECTRICAL   = SKILL_BASIC,
	                    SKILL_ATMOS        = SKILL_BASIC,
	                    SKILL_ENGINES      = SKILL_BASIC)
						
	skill_points = 20
	
/datum/job/submap/voxship_vox/engineer/New(var/datum/submap/_owner, var/abstract_job = FALSE)
	..()
	max_skill[SKILL_ELECTRICAL] = SKILL_MAX
	max_skill[SKILL_ATMOS] = SKILL_MAX
	max_skill[SKILL_ENGINES] = SKILL_MAX
	max_skill[SKILL_MEDICAL] = SKILL_ADEPT
	max_skill[SKILL_ANATOMY] = SKILL_ADEPT
	max_skill[SKILL_CHEMISTRY] = SKILL_ADEPT
	
/datum/job/submap/voxship_vox/quill
	title = "Quill"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/voxship/crew
	supervisors = "apex and the arkship"
	info = "You're in charge. You fly the ship, and dictate what the crew does. Do not disappoint the Apex."
	min_skill = list(	SKILL_HAULING     = SKILL_BASIC,
						SKILL_EVA         = SKILL_EXPERT,
						SKILL_SCIENCE     = SKILL_ADEPT,
						SKILL_PILOT       = SKILL_ADEPT,
						SKILL_COMBAT      = SKILL_ADEPT,
						SKILL_WEAPONS     = SKILL_ADEPT)
					
	skill_points = 20

/datum/job/submap/voxship_vox/quill/New(var/datum/submap/_owner, var/abstract_job = FALSE)
	..()
	max_skill[SKILL_ELECTRICAL] = SKILL_EXPERT
	max_skill[SKILL_ATMOS] = SKILL_EXPERT
	max_skill[SKILL_ENGINES] = SKILL_EXPERT
	max_skill[SKILL_MEDICAL] = SKILL_EXPERT
	max_skill[SKILL_ANATOMY] = SKILL_EXPERT
	max_skill[SKILL_CHEMISTRY] = SKILL_EXPERT
	
#define VOXSHIP_OUTFIT_JOB_NAME(job_name) ("Vox Asteroid Base - Job - " + job_name)
/decl/hierarchy/outfit/job/voxship
	hierarchy_type = /decl/hierarchy/outfit/job/voxship
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/voxship/crew
	name = VOXSHIP_OUTFIT_JOB_NAME("Shoal Scavenger")
	uniform = /obj/item/clothing/under/vox/vox_robes
	r_pocket = /obj/item/device/radio
	shoes = /obj/item/clothing/shoes/magboots/vox
	belt = /obj/item/weapon/storage/belt/utility/full
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/weapon/crowbar/prybar

/obj/effect/submap_landmark/spawnpoint/voxship_crew
	name = "Shoal Scavenger"

/obj/effect/submap_landmark/spawnpoint/voxship_crew/doc
	name = "Shoal Biotechnician"
	
/obj/effect/submap_landmark/spawnpoint/voxship_crew/engineer
	name = "Shoal Technician"
	
/obj/effect/submap_landmark/spawnpoint/voxship_crew/quill
	name = "Quill"

#undef VOXSHIP_OUTFIT_JOB_NAME
