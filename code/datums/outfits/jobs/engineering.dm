/decl/hierarchy/outfit/job/engineering/ds13chiefofengines
	name = OUTFIT_JOB_NAME("Chief Engineer")
	head = null //used by engineering rig
	glasses = /obj/item/clothing/glasses/meson
	mask = /obj/item/clothing/mask/gas/budget
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/heads/ce
	gloves = null //used by engineering rig
	belt = /obj/item/weapon/storage/belt/utility/full
	shoes = null //used by engineering rig
	id_type = /obj/item/weapon/card/id/holoidchiefengineman
	back = /obj/item/weapon/rig/deadspace/edfengineer/equipped //placeholder till we have sprites for engineering rig

/decl/hierarchy/outfit/job/engineering/ds13expendableengineer
	name = OUTFIT_JOB_NAME("Technical Engineer")
	head = null //used by engineering rig
	glasses = /obj/item/clothing/glasses/meson
	mask = /obj/item/clothing/mask/gas/budget
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/headset_eng
	gloves = null //used by engineering rig
	belt = /obj/item/weapon/storage/belt/utility/full
	shoes = null //used by engineering rig
	id_type = /obj/item/weapon/card/id/holoidengineermeatshield
	back = /obj/item/weapon/rig/deadspace/edfengineer/equipped //placeholder till we have sprites for engineering rig

////////////////////////////////////////////////////////////////////////////////
////			DEFAULT OUTFITS BELOW HERE.									////
////////////////////////////////////////////////////////////////////////////////


/decl/hierarchy/outfit/job/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/engineering
	belt = /obj/item/weapon/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/engineering/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/engineering/chief_engineer
	name = OUTFIT_JOB_NAME("Chief engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/rank/chief_engineer
	l_ear = /obj/item/device/radio/headset/heads/ce
	gloves = /obj/item/clothing/gloves/thick
	id_type = /obj/item/weapon/card/id/engineering/head
	pda_type = /obj/item/modular_computer/pda/heads/ce

/decl/hierarchy/outfit/job/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/rank/engineer
	r_pocket = /obj/item/device/t_scanner
	id_type = /obj/item/weapon/card/id/engineering
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/engineering/engineer/void
	name = OUTFIT_JOB_NAME("Engineer - Voidsuit")
	head = /obj/item/clothing/head/helmet/space/void/engineering
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/void/engineering

/decl/hierarchy/outfit/job/engineering/atmos
	name = OUTFIT_JOB_NAME("Atmospheric technician")
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/weapon/storage/belt/utility/atmostech
	id_type = /obj/item/weapon/card/id/engineering/atmos
	pda_type = /obj/item/modular_computer/pda/engineering
