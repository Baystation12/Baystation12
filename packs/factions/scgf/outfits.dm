/singleton/hierarchy/outfit/fleet
	name = OUTFIT_JOB_NAME("Enlisted - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat
	id_types = list(/obj/item/card/id/centcom)
	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	pda_type = /obj/item/modular_computer/pda/ert
	shoes = /obj/item/clothing/shoes/dutyboots

/singleton/hierarchy/outfit/fleet/ert
	name = OUTFIT_JOB_NAME("ERT - Fifth Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat
	belt = /obj/item/storage/belt/holster/security/tactical/ert
	id_types = list(/obj/item/card/id/centcom/station/ert)
	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	l_pocket = /obj/item/clothing/accessory/badge/solgov/tags
	glasses = /obj/item/clothing/glasses/tacgoggles
	pda_slot = slot_r_store
	id_slot = slot_wear_id
	back = null

/singleton/hierarchy/outfit/fleet/ert/leader
	name = OUTFIT_JOB_NAME("ERT Leader - Fifth Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/command
	id_types = list(/obj/item/card/id/centcom/station/ert/leader)
	l_ear = /obj/item/device/radio/headset/ert/alt
	head = /obj/item/clothing/head/beret/solgov/fleet/branch/fifth

/singleton/hierarchy/outfit/fleet/ertsuit
	name = OUTFIT_JOB_NAME("ERT Heavy - Fifth Fleet")
	back = /obj/item/rig/ert/fleet
	flags = OUTFIT_RESET_EQUIPMENT | OUTFIT_ADJUSTMENT_SKIP_BACKPACK
	head = null
	gloves = null

/singleton/hierarchy/outfit/fleet/ert/hostile
	name = OUTFIT_JOB_NAME("Fleet - Hostile")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat
	suit = /obj/item/clothing/suit/armor/pcarrier/light/sol
	head = /obj/item/clothing/head/helmet
	mask = /obj/item/clothing/mask/gas/half
	glasses = /obj/item/clothing/glasses/tacgoggles
	flags = OUTFIT_RESET_EQUIPMENT | OUTFIT_ADJUSTMENT_ALL_SKIPS
	l_ear = null

/singleton/hierarchy/outfit/fleet/ert/hostile/leader
	name = OUTFIT_JOB_NAME("Fleet Leader - Hostile")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat
	suit = /obj/item/clothing/suit/armor/bulletproof/armsman
	head = /obj/item/clothing/head/helmet/armsman

/singleton/hierarchy/outfit/fleet/ert/hostile/suit
	name = OUTFIT_JOB_NAME("Fleet Heavy - Hostile")
	back = /obj/item/rig/ert/fleet
	gloves = null
	suit = null
	head = null
