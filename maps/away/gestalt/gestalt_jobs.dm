/datum/job/submap/gestalt_seedling
	title = "Gestalt Seedling"
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/gestalt/seedling
	supervisors = "the chorus"
	info = "Your home gestalt is scouting through unknown space, searching for hidden knowledge, and potential friends."
	whitelisted_species = list(SPECIES_DIONA)
	blacklisted_species = null
	min_skill = list(SKILL_PILOT = SKILL_BASIC,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_SCIENCE = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)

#define GESTALT_OUTFIT_JOB_NAME(job_name) ("Travelling Gestalt - Job - " + job_name)
/decl/hierarchy/outfit/job/gestalt
	hierarchy_type = /decl/hierarchy/outfit/job/gestalt
	l_ear = /obj/item/device/radio/headset
	r_ear = null

/decl/hierarchy/outfit/job/gestalt/seedling
	name = GESTALT_OUTFIT_JOB_NAME("Gestalt Seedling")
	uniform = /obj/item/clothing/under/harness
	r_pocket = /obj/item/device/radio
	belt = /obj/item/weapon/storage/belt/utility/full
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/device/flashlight

/obj/effect/submap_landmark/spawnpoint/gestalt_crew
	name = "Gestalt Seedling"

#undef GESTALT_OUTFIT_JOB_NAME