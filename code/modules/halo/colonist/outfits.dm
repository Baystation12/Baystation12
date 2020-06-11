
/decl/hierarchy/outfit/job/colonist
	name = "Colonist"
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

/decl/hierarchy/outfit/job/mayor
	name = "Mayor"

	uniform = /obj/item/clothing/under/blazer
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	shoes = /obj/item/clothing/shoes/black
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/police
	name = "GCPD Officer"

	head = /obj/item/clothing/head/soft/police
	uniform = /obj/item/clothing/under/police
	belt = /obj/item/weapon/gun/projectile/m7_smg/rubber
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = null
	l_pocket = /obj/item/clothing/accessory/badge/police
	l_ear = /obj/item/device/radio/headset/police
	id_type = /obj/item/weapon/card/id/security/warden
	gloves = /obj/item/clothing/gloves/thick/swat/police

	flags = 0

/decl/hierarchy/outfit/job/cop
	name = "GCPD Chief of Police"

	head = /obj/item/clothing/head/soft/police
	uniform = /obj/item/clothing/under/police
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = null
	l_pocket = /obj/item/clothing/accessory/badge/police
	l_ear = /obj/item/device/radio/headset/police
	id_type = /obj/item/weapon/card/id/security/head
	suit = /obj/item/clothing/suit/armor/vest/police_medium
	gloves = /obj/item/clothing/gloves/thick/swat/police

	flags = 0
