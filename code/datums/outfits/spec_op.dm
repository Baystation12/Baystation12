/decl/hierarchy/outfit/spec_op_officer
	name = "Special ops - Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/beret/deathsquad
	belt = /obj/item/weapon/gun/energy/pulse_rifle/pistol
	back = /obj/item/weapon/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/thick/combat

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

/decl/hierarchy/outfit/spec_op_officer/space
	name = "Special ops - Officer in space"
	suit = /obj/item/clothing/suit/space/void/swat
	back = /obj/item/weapon/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas/swat

	flags = OUTFIT_HAS_JETPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/ert
	name = "Spec ops - Emergency response team"
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset/ert
	belt = /obj/item/weapon/gun/energy/gun
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/weapon/storage/backpack/satchel

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT

/decl/hierarchy/outfit/death_command
	name = "Spec ops - Death commando"

/decl/hierarchy/outfit/death_command/equip(var/mob/living/carbon/human/H)
	deathsquad.equip(H)
	return 1

/decl/hierarchy/outfit/syndicate_command
	name = "Spec ops - Syndicate commando"

/decl/hierarchy/outfit/syndicate_command/equip(var/mob/living/carbon/human/H)
	commandos.equip(H)
	return 1

/decl/hierarchy/outfit/mercenary
	name = "Spec ops - Mercenary"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/syndicate
	belt = /obj/item/weapon/storage/belt/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/thick/swat

	l_pocket = /obj/item/weapon/reagent_containers/pill/cyanide

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate
	id_pda_assignment = "Mercenary"

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_RESET_EQUIPMENT
