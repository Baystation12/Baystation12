/datum/map/overmap_example
	allowed_jobs = list(/datum/job/captain, /datum/job/chief_engineer, /datum/job/doctor, /datum/job/qm, /datum/job/cyborg, /datum/job/assistant, /datum/job/engineer)

/datum/job/captain
	supervisors = "the Merchant Code and your conscience"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/captain

/datum/job/chief_engineer
	title = "Chief Engineer"
	supervisors = "the Captain"
	department_flag = ENG
	outfit_type = /decl/hierarchy/outfit/job/bearcat/chief_engineer

/datum/job/doctor
	title = "Ship's Doc"
	supervisors = "the Captain and your idea of Hippocratic Oath"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/doc
	alt_titles = list(
		"Ship's Surgeon")

/datum/job/qm
	title = "First Mate"
	supervisors = "the Captain and the Merchant Code"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/mate

/datum/job/assistant
	title = "Deck Hand"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/hand
	alt_titles = list(
		"Cook" = /decl/hierarchy/outfit/job/bearcat/hand/cook,
		"Cargo Hand")

/datum/job/engineer
	title = "Junior Engineer"
	supervisors = "Chief Engineer"

/datum/job/cyborg
	supervisors = "your laws and the Captain"
	outfit_type = /decl/hierarchy/outfit/job/bearcat/hand/engine

/decl/hierarchy/outfit/job/bearcat/
	hierarchy_type = /decl/hierarchy/outfit/job/bearcat
	pda_type = /obj/item/device/pda
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/bearcat/captain
	name = OUTFIT_JOB_NAME("Bearcat - Captain")
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda/captain

/decl/hierarchy/outfit/job/bearcat/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			world << "couldn't attach shirt"
			qdel(eyegore)

/decl/hierarchy/outfit/job/bearcat/chief_engineer
	name = OUTFIT_JOB_NAME("Bearcat - Chief Engineer")
	uniform = /obj/item/clothing/under/rank/chief_engineer
	glasses = /obj/item/clothing/glasses/welding/superior
	suit = /obj/item/clothing/suit/storage/hazardvest
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/device/pda/heads/ce
	l_hand = /obj/item/weapon/wrench
	belt = /obj/item/weapon/storage/belt/utility/full
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/bearcat/doc
	name = OUTFIT_JOB_NAME("Bearcat - Ship's Doc")
	uniform = /obj/item/clothing/under/det/black
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	pda_type = /obj/item/device/pda/medical

/decl/hierarchy/outfit/job/bearcat/mate
	name = OUTFIT_JOB_NAME("Bearcat - First Mate")
	uniform = /obj/item/clothing/under/suit_jacket/checkered
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	pda_type = /obj/item/device/pda/cargo
	l_hand = /obj/item/weapon/clipboard

/decl/hierarchy/outfit/job/bearcat/hand
	name = OUTFIT_JOB_NAME("Bearcat - Deck Hand")

/decl/hierarchy/outfit/job/bearcat/hand/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(list(/obj/item/clothing/under/overalls,/obj/item/clothing/under/focal,/obj/item/clothing/under/hazard,/obj/item/clothing/under/rank/cargotech,/obj/item/clothing/under/color/black,/obj/item/clothing/under/color/grey,/obj/item/clothing/under/casual_pants/track, ))

/decl/hierarchy/outfit/job/bearcat/hand/cook
	name = OUTFIT_JOB_NAME("Bearcat - Cook")
	head = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef/classic

/decl/hierarchy/outfit/job/bearcat/hand/engine
	name = OUTFIT_JOB_NAME("Bearcat - Junior Engineer")
	head = /obj/item/clothing/head/hardhat
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	
/decl/hierarchy/outfit/job/bearcat/hand/engine/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/storage/hazardvest