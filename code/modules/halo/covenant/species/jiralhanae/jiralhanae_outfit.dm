


/* Unaligned Jiralhanae */

/decl/hierarchy/outfit/jiralhanae
	name = "Jiralhanae Runt"

	head = null
	l_ear = null
	uniform = /obj/item/clothing/under/covenant/jiralhanae
	r_hand = /obj/item/weapon/material/hatchet/unathiknife
	suit = null
	back = null
	belt = null
	head = null
	shoes = /obj/item/clothing/shoes/jiralhanae
	l_pocket = null
	r_pocket = null

/decl/hierarchy/outfit/jiralhanae/minor
	name = "Jiralhanae Minor"

	head = /obj/item/clothing/head/helmet/jiralhanae
	l_ear = /obj/item/device/radio/headset/covenant
	uniform = /obj/item/clothing/under/covenant/jiralhanae
	suit = /obj/item/clothing/suit/armor/jiralhanae
	head = /obj/item/clothing/head/helmet/jiralhanae
	shoes = /obj/item/clothing/shoes/jiralhanae
	//
	id_type = /obj/item/weapon/card/id/brute_minor
	id_slot = slot_wear_id

/decl/hierarchy/outfit/jiralhanae/major
	name = "Jiralhanae Major"

	head = /obj/item/clothing/head/helmet/jiralhanae/major
	suit = /obj/item/clothing/suit/armor/jiralhanae/major
	//
	id_type = /obj/item/weapon/card/id/brute_major
	id_slot = slot_wear_id

/decl/hierarchy/outfit/jiralhanae/captain
	name = "Jiralhanae Captain"

	head = /obj/item/clothing/head/helmet/jiralhanae/captain
	suit = /obj/item/clothing/suit/armor/jiralhanae/captain
	//
	id_type = /obj/item/weapon/card/id/brute_captain
	id_slot = slot_wear_id

/* Covenant Jiralhanae */

/obj/item/weapon/storage/belt/covenant_ammo/loadedspawn_spiker
	startswith = list(\
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker
	)

/obj/item/weapon/storage/belt/covenant_ammo/loadedspawn_mauler
	startswith = list(\
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler
	)

/decl/hierarchy/outfit/jiralhanae/covenant
	name = "Covenant Jiralhanae Soldier"

	head = /obj/item/clothing/head/helmet/jiralhanae/covenant
	l_ear = /obj/item/device/radio/headset/covenant
	r_hand = null
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant
	suit = /obj/item/clothing/suit/armor/jiralhanae/covenant
	//
	id_type = /obj/item/weapon/card/id/brute_minor
	id_slot = slot_wear_id

/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov/loadedspawn_bruteshot
	startswith = list(\
	/obj/item/weapon/grenade/brute_shot,
	/obj/item/weapon/grenade/brute_shot,
	/obj/item/weapon/grenade/brute_shot,
	/obj/item/weapon/grenade/brute_shot,
	/obj/item/weapon/grenade/brute_shot
	)

/decl/hierarchy/outfit/jiralhanae/covenant/minor
	name = "Covenant Jiralhanae Minor"

	head = /obj/item/clothing/head/helmet/jiralhanae/covenant/minor
	suit = /obj/item/clothing/suit/armor/jiralhanae/covenant/minor
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant/minor
	//
	id_type = /obj/item/weapon/card/id/brute_minor
	id_slot = slot_wear_id

/decl/hierarchy/outfit/jiralhanae/covenant/minor/armed
	name = "Armed Covenant Jiralhanae Minor"

	back = /obj/item/weapon/gun/projectile/spiker
	belt = /obj/item/weapon/storage/belt/covenant_ammo/loadedspawn_spiker
	l_pocket = /obj/item/weapon/grenade/frag/spike

/decl/hierarchy/outfit/jiralhanae/covenant/major
	name = "Covenant Jiralhanae Major"

	head = /obj/item/clothing/head/helmet/jiralhanae/covenant/major
	suit = /obj/item/clothing/suit/armor/jiralhanae/covenant/major
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant/major

/decl/hierarchy/outfit/jiralhanae/covenant/major/armed
	name = "Armed Covenant Jiralhanae Major"

	back = /obj/item/weapon/gun/projectile/spiker
	belt = /obj/item/weapon/storage/belt/covenant_ammo/loadedspawn_spiker
	l_pocket = /obj/item/weapon/grenade/frag/spike

/decl/hierarchy/outfit/jiralhanae/covenant/captain
	name = "Covenant Jiralhanae Captain"

	head = /obj/item/clothing/head/helmet/jiralhanae/covenant/captain
	suit = /obj/item/clothing/suit/armor/jiralhanae/covenant/captain
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant/captain
	l_hand = /obj/item/language_learner/unggoy_to_common
	//
	id_type = /obj/item/weapon/card/id/brute_captain
	id_slot = slot_wear_id

/decl/hierarchy/outfit/jiralhanae/covenant/captain/armed
	name = "Armed Covenant Jiralhanae Captain"

	suit_store = /obj/item/weapon/gun/projectile/mauler
	belt = /obj/item/weapon/storage/belt/covenant_ammo/loadedspawn_mauler
	r_hand = /obj/item/weapon/gun/launcher/grenade/brute_shot
	l_pocket = /obj/item/weapon/grenade/frag/spike
	r_pocket = /obj/item/weapon/storage/pocketstore/hardcase/grenade/cov/loadedspawn_bruteshot

/decl/hierarchy/outfit/jiralhanae/covenant/chieftain
	name = "Covenant Jiralhanae Chieftain"

	head = /obj/item/clothing/head/helmet/jiralhanae/covenant/chieftain
	suit = /obj/item/clothing/suit/armor/special/chieftain
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant/captain
	l_hand = /obj/item/language_learner/unggoy_to_common
	//
	id_type = /obj/item/weapon/card/id/brute_captain
	id_slot = slot_wear_id

/decl/hierarchy/outfit/jiralhanae/covenant/chieftain/armed
	name = "Armed Covenant Jiralhanae Chieftain"

	back = /obj/item/weapon/grav_hammer
	belt = /obj/item/weapon/storage/belt/covenant_ammo/loadedspawn_mauler
	suit_store = /obj/item/weapon/gun/projectile/mauler
	l_pocket = /obj/item/weapon/grenade/frag/spike
/* Ram Clan Jiralhanae */

/decl/hierarchy/outfit/jiralhanae_ramclan
	name = "Jiralhanae Ram Clan Minor"

	l_ear = /obj/item/device/radio/headset/brute_ramclan
	uniform = /obj/item/clothing/under/covenant/jiralhanae/blue

/decl/hierarchy/outfit/jiralhanae_ramclan/major
	name = "Jiralhanae Ram Clan Major"

	head = /obj/item/clothing/head/helmet/jiralhanae
	shoes = /obj/item/clothing/shoes/jiralhanae

/decl/hierarchy/outfit/jiralhanae_ramclan/captain
	name = "Jiralhanae Ram Clan Captain"

	head = /obj/item/clothing/head/helmet/jiralhanae
	shoes = /obj/item/clothing/shoes/jiralhanae
	suit = /obj/item/clothing/suit/armor/jiralhanae
	back = /obj/item/clothing/jiralhanae_flag_ram

/decl/hierarchy/outfit/jiralhanae_ramclan/chieftain
	name = "Jiralhanae Ram Clan Chieftain"

	head = /obj/item/clothing/head/helmet/jiralhanae/chieftain_ram
	suit = /obj/item/clothing/suit/armor/jiralhanae/chieftain_ram
	shoes = /obj/item/clothing/shoes/jiralhanae



/* Boulder Clan Jiralhanae */

/decl/hierarchy/outfit/jiralhanae_boulderclan
	name = "Jiralhanae Boulder Clan Minor"

	l_ear = /obj/item/device/radio/headset/brute_boulderclan
	uniform = /obj/item/clothing/under/covenant/jiralhanae/red

/decl/hierarchy/outfit/jiralhanae_boulderclan/major
	name = "Jiralhanae Boulder Clan Major"

	head = /obj/item/clothing/head/helmet/jiralhanae
	shoes = /obj/item/clothing/shoes/jiralhanae

/decl/hierarchy/outfit/jiralhanae_boulderclan/captain
	name = "Jiralhanae Boulder Clan Captain"

	head = /obj/item/clothing/head/helmet/jiralhanae
	suit = /obj/item/clothing/suit/armor/jiralhanae
	back = /obj/item/clothing/jiralhanae_flag_boulder
	shoes = /obj/item/clothing/shoes/jiralhanae

/decl/hierarchy/outfit/jiralhanae_boulderclan/chieftain
	name = "Jiralhanae Boulder Clan Chieftain"

	head = /obj/item/clothing/head/helmet/jiralhanae/chieftain_boulder
	suit = /obj/item/clothing/suit/armor/jiralhanae/chieftain_boulder
	shoes = /obj/item/clothing/shoes/jiralhanae
