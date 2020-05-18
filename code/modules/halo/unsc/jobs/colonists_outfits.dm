
/decl/hierarchy/outfit/job/colonist
	name = "UEG Colonist"
	uniform = /obj/item/clothing/under/frontier
	flags = 0

/decl/hierarchy/outfit/job/colonist/equip_base(mob/living/carbon/human/H)
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
