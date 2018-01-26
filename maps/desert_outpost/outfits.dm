
/decl/hierarchy/outfit/job/stranded_unsc
	name = "UNSC Survivor"
	id_slot = null
	id_type = null
	pda_slot = null
	pda_type = null
	flags = null

/decl/hierarchy/outfit/job/stranded_unsc/marine
	name = OUTFIT_JOB_NAME("UNSC marine survivor outfit")
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	l_pocket = /obj/item/weapon/grenade/frag/m9_hedp
	r_pocket = /obj/item/device/flashlight/flare

/decl/hierarchy/outfit/job/stranded_unsc/marine/equip_base(mob/living/carbon/human/H)

	. = ..()

	var/list/random_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum = /obj/item/ammo_magazine/m127_saphe,\
		/obj/item/weapon/gun/projectile/ma5b_ar = /obj/item/ammo_magazine/m762_ap,\
		/obj/item/weapon/gun/projectile/m7_smg = /obj/item/ammo_magazine/m5,\
		/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = /obj/item/ammo_box/shotgun)
	var/picked_weapon = pick(random_weapons)
	H.equip_to_slot_or_del(new picked_weapon(H),slot_r_hand)
	var/picked_ammo = random_weapons[picked_weapon]
	H.equip_to_slot_or_del(new picked_ammo(H),slot_belt)

	if(prob(50))
		if(prob(50))
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H),slot_head)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/visor(H),slot_head)

	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H),slot_wear_suit)

	if(prob(50))
		var/obj/item/weapon/storage/belt/B
		if(prob(50))
			B = new /obj/item/weapon/storage/belt/marine_ammo(H)
			new picked_ammo(B)
		else
			B = new /obj/item/weapon/storage/belt/marine_medic(H)
			new /obj/item/weapon/storage/firstaid/unsc(B)
		H.equip_to_slot_or_del(B,slot_belt)

/decl/hierarchy/outfit/job/stranded_unsc/tech
	name = OUTFIT_JOB_NAME("UNSC technician survivor outfit")
	shoes = /obj/item/clothing/shoes/brown
	r_hand = /obj/item/weapon/storage/toolbox/mechanical

/decl/hierarchy/outfit/job/stranded_unsc/tech/equip_base(mob/living/carbon/human/H)

	var/random_uniform = pick(/obj/item/clothing/under/unsc/technician,\
		/obj/item/clothing/under/unsc/mechanic)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H),slot_belt)

	..()

/decl/hierarchy/outfit/job/stranded_unsc/medic
	name = OUTFIT_JOB_NAME("UNSC corpsman survivor outfit")
	uniform = /obj/item/clothing/under/unsc/medical
	shoes = /obj/item/clothing/shoes/white
	r_hand = /obj/item/weapon/storage/firstaid/unsc
	l_hand = /obj/item/weapon/storage/firstaid/surgery

/decl/hierarchy/outfit/job/stranded_unsc/medic/equip_base(mob/living/carbon/human/H)

	if(prob(50))
		var/obj/item/weapon/storage/belt/medical/B = new(H)
		new /obj/item/weapon/storage/firstaid/unsc(B)
		H.equip_to_slot_or_del(B,slot_belt)
	..()

/decl/hierarchy/outfit/job/stranded_unsc/crew
	name = OUTFIT_JOB_NAME("UNSC crewman survivor outfit")
	shoes = /obj/item/clothing/shoes/brown

/decl/hierarchy/outfit/job/stranded_unsc/crew/equip_base(mob/living/carbon/human/H)

	var/random_uniform = pick(/obj/item/clothing/under/unsc/command,\
		/obj/item/clothing/under/unsc/logistics,\
		/obj/item/clothing/under/unsc/operations,\
		/obj/item/clothing/under/unsc/pilot,\
		/obj/item/clothing/under/unsc/tactical)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	if(random_uniform == /obj/item/clothing/under/unsc/pilot)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/pilot(H),slot_head)
	..()

/decl/hierarchy/outfit/job/stranded_unsc/civ
	name = OUTFIT_JOB_NAME("human colonist survivor outfit")
	shoes = /obj/item/clothing/shoes/orange
	belt = /obj/item/weapon/material/hatchet
	r_hand = /obj/item/weapon/shovel

/decl/hierarchy/outfit/job/stranded_unsc/civ/equip_base(mob/living/carbon/human/H)

	var/random_uniform = pick(/obj/item/clothing/under/serviceoveralls,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/blazer)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	..()
