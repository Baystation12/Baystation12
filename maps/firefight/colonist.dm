
/datum/job/firefight_colonist
	title = "Colonist"
	outfit_type = /decl/hierarchy/outfit/job/firefight_colonist
	selection_color = "#000000"
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	spawn_faction = "UNSC"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE
	access = list(access_unsc)

/decl/hierarchy/outfit/job/firefight_colonist
	name = "Firefight Colonist"

	head = null
	uniform = null
	belt = /obj/item/weapon/storage/wallet/random
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

/decl/hierarchy/outfit/job/firefight_colonist/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/firefight_colonist/proc/equip_special(mob/living/carbon/human/H)
	if(prob(30))
		var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/colt
		G.ammo_magazine = new /obj/item/ammo_magazine/c45m
		H.equip_to_slot_or_del(G,slot_belt)


/decl/hierarchy/outfit/job/firefight_colonist/equip_base(mob/living/carbon/human/H)

	var/random_uniform = pick(/obj/item/clothing/under/serviceoveralls,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/focal,\
		/obj/item/clothing/under/grayson,\
		/obj/item/clothing/under/hazard,\
		/obj/item/clothing/under/aether)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	equip_special(H)

	. = ..()
