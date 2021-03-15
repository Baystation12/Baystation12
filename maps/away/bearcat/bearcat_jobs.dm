/datum/job/submap/bearcat_captain
	title = "Independant Captain"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/bearcat/captain
	supervisors = "your bottom line"
	info = "Your ship has suffered a catastrophic amount of damage, leaving it dark and crippled in the depths of \
	unexplored space. The Captain is dead, leaving you, previously the First Mate in charge. Organize what's left of \
	your crew, and maybe you'll be able to survive long enough to be rescued."

/datum/job/submap/bearcat_crewman
	title = "Independant Crewman"
	supervisors = "the Captain"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/bearcat/crew
	info = "Your ship has suffered a catastrophic amount of damage, leaving it dark and crippled in the depths of \
	unexplored space. Work together with the Acting Captain and what's left of the crew, and maybe you'll be able \
	to survive long enough to be rescued."

#define BEARCAT_OUTFIT_JOB_NAME(job_name) ("Bearcat - Job - " + job_name)

/decl/hierarchy/outfit/job/bearcat
	hierarchy_type = /decl/hierarchy/outfit/job/bearcat
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	r_pocket = /obj/item/device/radio/map_preset/bearcat
	l_ear = /obj/item/device/radio/headset/map_preset/bearcat
	r_ear = null

/decl/hierarchy/outfit/job/bearcat/crew
	name = BEARCAT_OUTFIT_JOB_NAME("Crew")
	id_types = list(/obj/item/card/id/bearcat)

/decl/hierarchy/outfit/job/bearcat/captain
	name = BEARCAT_OUTFIT_JOB_NAME("Captain")
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda/captain
	id_types = list(/obj/item/card/id/bearcat_captain)

/decl/hierarchy/outfit/job/bearcat/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

#undef BEARCAT_OUTFIT_JOB_NAME

/obj/effect/submap_landmark/spawnpoint/captain
	name = "Independant Captain"

/obj/effect/submap_landmark/spawnpoint/crewman
	name = "Independant Crewman"
