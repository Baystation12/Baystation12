/* README */
/*
This is the first implementation of the new jobsystem.
Basic jobs are all defined in the halo modules folder and used by default in all gamemodes and maps.
If a gamemode or map needs to do something slightly different, copy the procedure below by making the slight adjustment needed.
This will keep jobs and outfits consistent across the server, while also reducing code bloat.
Cael May 2020
*/



/* Jobs we are going to tweak */

/datum/job/unsc/marine/firefight
	outfit_type = /decl/hierarchy/outfit/job/unsc/marine/firefight
	alt_titles = list()		//some alt titles have custom outfits, do this just to make sure they are disabled
	spawnpoint_override = null
	fallback_spawnpoint = null

/datum/job/unsc/marine/squad_leader/firefight
	outfit_type = /decl/hierarchy/outfit/job/unsc/marine/e5/firefight
	alt_titles = list()
	spawnpoint_override = null
	fallback_spawnpoint = null

/datum/job/unsc/odst/firefight
	outfit_type = /decl/hierarchy/outfit/job/unsc/odst/firefight
	alt_titles = list()
	spawnpoint_override = null
	fallback_spawnpoint = null

/datum/job/unsc/odst/squad_leader/firefight
	outfit_type = /decl/hierarchy/outfit/job/unsc/odst/e5/firefight
	alt_titles = list()
	spawnpoint_override = null
	fallback_spawnpoint = null

/datum/job/unsc/spartan2/firefight
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc/spartan2/firefight
	alt_titles = list()
	spawnpoint_override = null
	fallback_spawnpoint = null

/* The actual changes */

/decl/hierarchy/outfit/job/unsc/marine/firefight
	name = "Marine (e3) (firefight)"

	//some armour
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	back = /obj/item/weapon/storage/backpack/marine

	//a starting weapon
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	l_pocket = /obj/item/ammo_magazine/m127_saphe

/decl/hierarchy/outfit/job/unsc/marine/e5/firefight
	name = "Marine Sergeant (e5) (firefight)"

	//some armour
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	back = /obj/item/weapon/storage/backpack/marine

	//a starting weapon
	gloves = /obj/item/clothing/gloves/thick/unsc
	belt = /obj/item/weapon/gun/projectile/m7_smg/silenced
	l_pocket = /obj/item/ammo_magazine/m5

/decl/hierarchy/outfit/job/unsc/odst/firefight
	name = "ODST (firefight)"

	//some armour
	head = /obj/item/clothing/head/helmet/odst
	suit = /obj/item/clothing/suit/armor/special/odst
	shoes = /obj/item/clothing/shoes/magboots/odst
	gloves = /obj/item/clothing/gloves/thick/unsc
	back = /obj/item/weapon/storage/backpack/odst/regular

	//a starting weapon
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	l_pocket = /obj/item/ammo_magazine/m127_saphp

/decl/hierarchy/outfit/job/unsc/odst/e5/firefight
	name = "ODST Sergeant (firefight)"

	//some armour
	head = /obj/item/clothing/head/helmet/odst/squadleader
	suit = /obj/item/clothing/suit/armor/special/odst/squadleader
	shoes = /obj/item/clothing/shoes/magboots/odst
	gloves = /obj/item/clothing/gloves/thick/unsc
	back = /obj/item/weapon/storage/backpack/odst/squadlead

	//a starting weapon
	belt = /obj/item/weapon/gun/projectile/m7_smg/silenced
	l_pocket = /obj/item/ammo_magazine/m5

/decl/hierarchy/outfit/job/unsc/spartan2/firefight
	name = "Spartan II (firefight)"

	//a starting weapon
	belt = /obj/item/weapon/gun/projectile/ma5b_ar
	l_pocket = /obj/item/ammo_magazine/m762_ap/MA5B
