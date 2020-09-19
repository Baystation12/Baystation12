
/decl/hierarchy/supply_pack/covenant_clothing
	name = "Clothing and Armour"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"
	containertype = /obj/structure/closet/crate/covenant



/* CLOTHING AND ARMOUR SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_clothing/kigyar_ranger
	name = "KigYar Ranger Suit (1)"
	contains = list(
		/obj/item/clothing/suit/armor/ranger_kigyar = 1,
		/obj/item/clothing/head/helmet/ranger_kigyar = 1,
		/obj/item/clothing/shoes/magboots/ranger_kigyar = 1)
	cost = 1250
	containername = "\improper KigYar Ranger Suit crate"

/decl/hierarchy/supply_pack/covenant_clothing/sangheili_ranger
	name = "Sangheili Ranger Suit (1)"
	contains = list(
		/obj/item/clothing/suit/armor/special/combatharness/ranger = 1,
		/obj/item/clothing/head/helmet/sangheili/ranger = 1,
		/obj/item/clothing/shoes/magboots/sangheili = 1,
		/obj/item/clothing/gloves/thick/sangheili/ranger = 1)
	cost = 1250
	containername = "\improper Sangheili Ranger Suit crate"

/decl/hierarchy/supply_pack/covenant_clothing/jiralhanae_ranger
	name = "Jiralhanae Ranger Suit (1)"
	contains = list(
		/obj/item/clothing/suit/armor/jiralhanae/covenant/EVA = 1,
		/obj/item/clothing/head/helmet/jiralhanae/covenant/EVA = 1,
		/obj/item/clothing/shoes/magboots/jiralhanaeEVA = 1)
	cost = 1250
	containername = "\improper Jiralhanae Ranger Suit crate"

/decl/hierarchy/supply_pack/covenant_clothing/belts
	name = "Mixed storage belt (3)"
	contains = list(
		/obj/item/weapon/storage/belt/covenant_ammo = 1,
		/obj/item/weapon/storage/belt/covenant_medic = 1)
	cost = 1200
	containername = "\improper Storage belts (mixed) crate"

/decl/hierarchy/supply_pack/covenant_clothing/backpack
	name = "Battle pack (1)"
	contains = list(/obj/item/weapon/storage/backpack/sangheili = 1)
	cost = 1500
	containername = "\improper Battle pack crate"

