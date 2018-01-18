
/decl/hierarchy/outfit/job/marine
	name = "Marine"

	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	suit = /obj/item/clothing/suit/armor/marine
	head = /obj/item/clothing/head/helmet/marine
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	l_pocket = /obj/item/device/encryptionkey/shipcom
	flags = 0

/decl/hierarchy/outfit/job/marine/leader
	name = "Marine - Squad Leader"

	head = /obj/item/clothing/head/helmet/marine/visor

	flags = 0

/decl/hierarchy/outfit/job/colonist
	name = "Colonist"

	head = null
	uniform = null
	belt = null
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = slot_r_store

	flags = 0

/decl/hierarchy/outfit/job/colonist/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/colonist/proc/equip_special(mob/living/carbon/human/H)
	if(prob(25))
		H.equip_to_slot_or_del(/obj/item/clothing/mask/innie/shemagh)
	if(prob(30))
		var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/m6d_magnum
		G.ammo_magazine = new /obj/item/ammo_magazine/m127_saphp
		H.equip_to_slot_or_del(G,slot_belt)


/decl/hierarchy/outfit/job/colonist/equip_base(mob/living/carbon/human/H)

	var/random_uniform = pick(/obj/item/clothing/under/serviceoveralls,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	equip_special(H)

	. = ..()

/decl/hierarchy/outfit/job/colonist/innie_sympathiser
	name = "Insurrectionist Sympathiser"

	mask = /obj/item/clothing/mask/innie/shemagh

	l_pocket = /obj/item/ammo_magazine/m127_saphp
	l_ear = /obj/item/device/radio/headset/insurrection

/decl/hierarchy/outfit/job/colonist/innie_sympathiser/equip_special()
	return

/decl/hierarchy/outfit/job/colonist/innie_sympathiser/equip_base(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/m6d_magnum
	G.ammo_magazine = new /obj/item/ammo_magazine/m127_saphp
	H.equip_to_slot_or_del(G,slot_belt)

/decl/hierarchy/outfit/job/mayor
	name = "Mayor"

	uniform = /obj/item/clothing/under/blazer
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	shoes = /obj/item/clothing/shoes/black

	flags = 0

/decl/hierarchy/outfit/job/police
	name = "UEG Police Officer"

	head = /obj/item/clothing/head/helmet/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	uniform = /obj/item/clothing/under/tactical
	suit = /obj/item/clothing/suit/storage/vest/tactical
	belt = /obj/item/weapon/storage/belt/security/tactical
	shoes = /obj/item/clothing/shoes/tactical
	pda_slot = slot_r_store
	l_pocket = /obj/item/ammo_magazine/m762_ap/MA37
	back = /obj/item/weapon/gun/projectile/ma5b_ar/MA37
	gloves = /obj/item/clothing/gloves/tactical

	flags = 0