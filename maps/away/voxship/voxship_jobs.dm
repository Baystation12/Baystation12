/datum/job/submap/voxship_vox
	title = "Vox"
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/voxship/crew
	supervisors = "arkship"
	info = "Scrap is thin. Not much food is left, but thankfully the sector is quite rich, and it's time to get some more supplies. \
	although staying on base is tempting. Plenty of nitrogen, and not much hazards to worry about."


#define VOXSHIP_OUTFIT_JOB_NAME(job_name) ("Vox Asteroid Base - Job - " + job_name)
/decl/hierarchy/outfit/job/voxship
	hierarchy_type = /decl/hierarchy/outfit/job/voxship
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/voxship/crew
	name = VOXSHIP_OUTFIT_JOB_NAME("Vox")
	uniform = /obj/item/clothing/under/vox/vox_robes
	r_pocket = /obj/item/device/radio
	shoes = /obj/item/clothing/shoes/magboots/vox
	belt = /obj/item/weapon/storage/belt/utility/full
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/weapon/crowbar/prybar

/obj/effect/submap_landmark/spawnpoint/voxship_crew
	name = "Vox"

#undef VOXSHIP_OUTFIT_JOB_NAME
