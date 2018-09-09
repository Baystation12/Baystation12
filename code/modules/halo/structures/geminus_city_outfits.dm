
/decl/hierarchy/outfit/job/marine
	name = "Geminus Garrisson Marine"

	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	suit = /obj/item/clothing/suit/storage/marine
	head = /obj/item/clothing/head/helmet/marine
	glasses = /obj/item/clothing/glasses/hud/tactical
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	l_pocket = /obj/item/device/encryptionkey/shipcom
	flags = 0

/decl/hierarchy/outfit/job/marine/leader
	name = "Marine - Squad Leader"

	head = /obj/item/clothing/head/helmet/marine/visor
	r_pocket = /obj/item/squad_manager

	flags = 0

/decl/hierarchy/outfit/job/colonist
	name = "Colonist"

	head = null
	uniform = null
	belt = /obj/item/weapon/storage/wallet/random
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/colonist/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/colonist/proc/equip_special(mob/living/carbon/human/H)
	if(prob(30))
		var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/colt
		G.ammo_magazine = new /obj/item/ammo_magazine/c45m
		H.equip_to_slot_or_del(G,slot_belt)


/decl/hierarchy/outfit/job/colonist/equip_base(mob/living/carbon/human/H)

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

/decl/hierarchy/outfit/job/colonist/innie_sympathiser
	name = "Insurrectionist Sympathiser"

	l_pocket = /obj/item/ammo_magazine/m127_saphp

/decl/hierarchy/outfit/job/colonist/innie_sympathiser/equip_special()
	return

/decl/hierarchy/outfit/job/colonist/innie_sympathiser/equip_base(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/m6d_magnum
	G.ammo_magazine = new /obj/item/ammo_magazine/m127_saphp
	H.equip_to_slot_or_del(G,slot_belt)

/decl/hierarchy/outfit/job/colonist/innie_recruiter
	name = "Insurrectionist Recruiter"

	l_pocket = /obj/item/ammo_magazine/m127_saphp
	mask = /obj/item/clothing/mask/balaclava
	l_ear = /obj/item/device/radio/headset/insurrection

/decl/hierarchy/outfit/job/colonist/innie_recruiter/equip_special()
	return

/decl/hierarchy/outfit/job/colonist/innie_recruiter/equip_base(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/m6d_magnum
	G.ammo_magazine = new /obj/item/ammo_magazine/m127_saphp
	H.equip_to_slot_or_del(G,slot_belt)

/decl/hierarchy/outfit/job/mayor
	name = "Mayor"

	uniform = /obj/item/clothing/under/blazer
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	shoes = /obj/item/clothing/shoes/black
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/police
	name = "GCPD Officer"

	head = /obj/item/clothing/head/soft/sec/corp
	uniform = /obj/item/clothing/under/police
	belt = /obj/item/weapon/gun/projectile/m7_smg/rubber
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = null
	l_pocket = /obj/item/clothing/accessory/badge/police
	l_ear = /obj/item/device/radio/headset/police
	id_type = /obj/item/weapon/card/id/security/warden

	flags = 0

/decl/hierarchy/outfit/job/marshall
	name = "Emsville Marshall"

	head = /obj/item/clothing/head/soft/sec/corp
	uniform = /obj/item/clothing/under/marshall

	belt = /obj/item/weapon/gun/projectile/m7_smg/rubber
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = null
	l_ear = /obj/item/device/radio/headset/police
	id_type = /obj/item/weapon/card/id/security/warden
	starting_accessories = list (/obj/item/clothing/accessory/badge/security, /obj/item/clothing/accessory/holster/thigh)
	flags = 0

/obj/item/clothing/suit/armor/vest/police
	name = "ballistic padding"
	desc = "GCPD shoulder and torso padding designed for bullet resistance."
	icon_state = "ertarmor_cmd"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 40, bullet = 35, laser = 15, energy = 15, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/under/police
	name = "police uniform"
	desc = "A black uniform worn by the GCPD."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"
	starting_accessories = list(/obj/item/clothing/accessory/department/medical, /obj/item/clothing/accessory/holster/thigh)
	armor = list(melee = 20, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/under/marshall
	name = "Marshall's uniform"
	desc = "A black uniform worn by the Emsville Marshalls."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"
	starting_accessories = list(/obj/item/clothing/accessory/holster/thigh)
	armor = list(melee = 20, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/decl/hierarchy/outfit/job/cop
	name = "GCPD Chief of Police"

	head = /obj/item/clothing/head/soft/sec/corp
	uniform = /obj/item/clothing/under/police
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = null
	l_pocket = /obj/item/clothing/accessory/badge/police
	l_ear = /obj/item/device/radio/headset/police
	id_type = /obj/item/weapon/card/id/security/head
	suit = /obj/item/clothing/suit/armor/hos

	flags = 0