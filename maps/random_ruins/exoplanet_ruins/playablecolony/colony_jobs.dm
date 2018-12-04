/datum/job/submap/colonist
	title = "Colonist"
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/colony/colonist
	info = "You are a Colonist, living on the rim of explored, let alone inhabited, space in a reconstructed shelter made from the very ship that took you here."

/datum/job/submap/colonist_doc
	title = "Doctor"
	supervisors = "the Overseer"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/colony/doc
	info = "You are the Colony Doctor. You are a part of this rag-tag group of souls living in this no-man's land. You are here to keep them alive with what little supplies you have."

/datum/job/submap/colonist_law
	title = "Guard"
	supervisors = "the Overseer"
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/colony/law
	info = "You are the Colony Guard. Either by volunteering or by being told to, you have found yourself tasked with ensuring the security and safety of the Colonists from the unknown beyond your walls."

/datum/job/submap/colonist_boss
	title = "Overseer"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/colony/boss
	info = "You are the Colony Overseer. You have found yourself as the person leading this rag-tag group, either by force, coercion, or some other process."

#define COLONY_OUTFIT_JOB_NAME(job_name) ("Colony - Job - " + job_name)

/decl/hierarchy/outfit/job/colony
	hierarchy_type = /decl/hierarchy/outfit/job/colony
	l_ear = null
	r_ear = null
	r_pocket = /obj/item/device/radio
	pda_type = null

/decl/hierarchy/outfit/job/colony/colonist
	name = COLONY_OUTFIT_JOB_NAME("Colonist")
	uniform = /obj/item/clothing/under/frontier
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/colony

/decl/hierarchy/outfit/job/colony/doc
	name = COLONY_OUTFIT_JOB_NAME("Doctor")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/blue
	head = /obj/item/clothing/head/surgery/blue
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/colony_doc

/decl/hierarchy/outfit/job/colony/law
	name = COLONY_OUTFIT_JOB_NAME("Guard")
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/pcarrier/medium
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/weapon/card/id/colony_law

/decl/hierarchy/outfit/job/colony/boss
	name = COLONY_OUTFIT_JOB_NAME("Captain")
	uniform = /obj/item/clothing/under/suit_jacket/navy
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/colony_boss

#undef COLONY_OUTFIT_JOB_NAME

/obj/effect/submap_landmark/spawnpoint/colonist
	name = "Colonist"

/obj/effect/submap_landmark/spawnpoint/colonist_doc
	name = "Doctor"

/obj/effect/submap_landmark/spawnpoint/colonist_law
	name = "Guard"

/obj/effect/submap_landmark/spawnpoint/colonist_boss
	name = "Overseer"
