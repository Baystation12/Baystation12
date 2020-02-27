


/* SUPPLY PACKS */

/decl/hierarchy/supply_pack/flp
	name = "Freedom and Liberation Party"
	access = access_innie
	hidden = 1
	contraband = "Insurrection"
	var/rep_unlock = 10

/decl/hierarchy/supply_pack/flp/flp_flamer
	name = "Freedom flamethrower"
	contains = list(/obj/item/weapon/flamethrower/innie = 1, /obj/item/weapon/tank/phoron/innie = 2)
	cost = 1000
	containername = "\improper Freedom flamethrower crate"
	containertype = /obj/structure/closet/crate/secure/phoron
	rep_unlock = 150

/decl/hierarchy/supply_pack/flp/lightarmour
	name = "Freedom Light Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/light/brown = 1,\
		/obj/item/clothing/head/helmet/innie/light/brown = 1,\
		/obj/item/clothing/suit/storage/innie/light/brown = 1)
	cost = 1250
	containername = "\improper flp Light Armour crate"
	containertype = /obj/structure/closet/secure_closet/CMO
	rep_unlock = 50

/decl/hierarchy/supply_pack/flp/mediumarmour
	name = "Freedom Medium Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/brown = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/brown = 1,\
		/obj/item/clothing/suit/storage/innie/medium/brown = 1)
	cost = 1500
	containername = "\improper flp Medium Armour crate"
	containertype = /obj/structure/closet/secure_closet/CMO

/decl/hierarchy/supply_pack/flp/heavyarmour
	name = "Freedom Heavy Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/brown = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/brown = 1,\
		/obj/item/clothing/suit/storage/innie/heavy/brown = 1)
	cost = 1500
	containername = "\improper flp Heavy Armour crate"
	containertype = /obj/structure/closet/secure_closet/CMO
	rep_unlock = 50

/decl/hierarchy/supply_pack/flp/gasmines
	name = "Gas mines (x3)"
	contains = list(/obj/item/device/landmine/gas = 3)
	cost = 45
	containername = "\improper Gas landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 20

/decl/hierarchy/supply_pack/flp/flamemines
	name = "Incendiary mines (x3)"
	contains = list(/obj/item/device/landmine/flame = 3)
	cost = 45
	containername = "\improper Incendiary landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 20

/decl/hierarchy/supply_pack/flp/teargas
	name = "Teargas grenades (x3)"
	contains = list(/obj/item/weapon/grenade/chem_grenade/teargas = 3)
	cost = 50
	containername = "\improper Teargas grenades crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 10

/decl/hierarchy/supply_pack/flp/incendiarynades
	name = "Incendiary grenades (x3)"
	contains = list(/obj/item/weapon/grenade/chem_grenade/incendiary = 3)
	cost = 55
	containername = "\improper Incendiary grenades crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 20

/decl/hierarchy/supply_pack/flp/colossus
	name = "Colossus combat suit"
	contains = list(/obj/item/clothing/head/bomb_hood/security/colossus = 1, /obj/item/clothing/suit/bomb_suit/security/colossus = 1)
	cost = 10000
	containername = "\improper Colossus combat suit"
	containertype = /obj/structure/closet/secure_closet
	rep_unlock = 100
