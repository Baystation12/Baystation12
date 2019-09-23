/datum/job/submap/hyperion_pathfinder
	title = "Independant Pathfinder"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/hyperion/pathfinder
	supervisors = "the infinite expanse of space"
	info = "Your ship has suffered a catastrophic amount of damage after an unplanned rapid landing on this planet, due to \
	an ill-timed ionic anomaly. Gather your explorers and survive long enough to make it off this planet."

/datum/job/submap/hyperion_explorer
	title = "Independant Explorer"
	supervisors = "the Pathfinder"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/hyperion/explorer
	info = "Your ship has suffered a catastrophic amount of damage after an unplanned rapid landing on this planet, due to \
	an ill-timed ionic anomaly. Work together with the Pathfinder and what's left of the crew, and maybe you'll be able \
	to survive long enough to get off this planet."

#define HYPERION_OUTFIT_JOB_NAME(job_name) ("Hyperion - Job - " + job_name)

/decl/hierarchy/outfit/job/hyperion
	hierarchy_type = /decl/hierarchy/outfit/job/hyperion
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	r_pocket = /obj/item/device/radio
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/hyperion/explorer
	name = HYPERION_OUTFIT_JOB_NAME("Explorer")
	id_type = /obj/item/weapon/card/id/bearcat

/decl/hierarchy/outfit/job/hyperion/pathfinder
	name = HYPERION_OUTFIT_JOB_NAME("Pathfinder")
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda/captain
	id_type = /obj/item/weapon/card/id/bearcat_captain

/decl/hierarchy/outfit/job/hyperion/pathfinder/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

#undef HYPERION_OUTFIT_JOB_NAME

/obj/effect/submap_landmark/spawnpoint/hyperion/pathfinder
	name = "Independant Pathfinder"

/obj/effect/submap_landmark/spawnpoint/hyperion/explorer
	name = "Independant Explorer"
