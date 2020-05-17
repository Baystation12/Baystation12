
/datum/job/unsc/firefight_colonist
	outfit_type = /decl/hierarchy/outfit/job/unsc/firefight_colonist
	spawnpoint_override = null
	fallback_spawnpoint = null
	account_allowed = FALSE
	generate_email = FALSE

/decl/hierarchy/outfit/job/unsc/firefight_colonist
	name = "Firefight Colonist"
	belt = /obj/item/weapon/material/hatchet
	r_hand = /obj/item/weapon/shovel
	uniform = /obj/item/clothing/under/frontier
	id_type = /obj/item/weapon/card/id/civilian
	l_pocket = /obj/item/weapon/storage/wallet/random
	shoes = /obj/item/clothing/shoes/brown
	starting_accessories = list()

/decl/hierarchy/outfit/job/unsc/firefight_colonist/equip_base(mob/living/carbon/human/H)
	var/random_uniform = pick(/obj/item/clothing/under/serviceoveralls,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/focal,\
		/obj/item/clothing/under/grayson,\
		/obj/item/clothing/under/hazard,\
		/obj/item/clothing/under/blazer,\
		/obj/item/clothing/under/aether)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	. = ..()
