/decl/hierarchy/outfit/standard_space_gear
	name = "Standard space gear"
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/space
	uniform = /obj/item/clothing/under/color/grey
	back = /obj/item/weapon/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/breath
	flags = OUTFIT_HAS_JETPACK

/decl/hierarchy/outfit/soviet_soldier
	name = "Soviet soldier"
	uniform = /obj/item/clothing/under/soviet
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/ushanka

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/station
	id_pda_assignment = "Admiral"

/decl/hierarchy/outfit/soviet_admiral
	head = /obj/item/clothing/head/hgpiratecap
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	suit = /obj/item/clothing/suit/hgpirate
	back = /obj/item/weapon/storage/backpack/satchel
	belt = /obj/item/weapon/gun/projectile/revolver/mateba
	uniform = /obj/item/clothing/under/soviet

/decl/hierarchy/outfit/merchant
	name = "Merchant"
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset
	uniform = /obj/item/clothing/under/color/grey
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/merchant
	pda_slot = slot_r_store
	pda_type = /obj/item/device/pda/chef //cause I like the look
	id_pda_assignment = "Merchant"

/decl/hierarchy/outfit/merchant/vox
	name = "Merchant - Vox"
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	uniform = /obj/item/clothing/under/vox/vox_robes