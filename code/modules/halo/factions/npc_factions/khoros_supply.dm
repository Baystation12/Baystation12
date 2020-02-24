


/* SUPPLY PACKS */

/decl/hierarchy/supply_pack/khoros
	name = "Khoros Desert Raiders"
	access = access_innie
	hidden = 1
	contraband = "Insurrection"
	var/rep_unlock = 10

/decl/hierarchy/supply_pack/khoros/tallista_spice
	name = "Tallista Spice"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/tallista_spice = 3)
	cost = 100
	containername = "\improper Tallista spice crate"
	containertype = /obj/structure/closet/crate/secure/hydrosec

/decl/hierarchy/supply_pack/khoros/explosive_spear
	name = "Combat Spear"
	contains = list(/obj/item/weapon/explosive_spear = 2)
	cost = 250
	containername = "\improper Combat spear crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 50

/decl/hierarchy/supply_pack/khoros/khoros_horn
	name = "Raider Horn"
	contains = list(/obj/item/weapon/khoros_horn = 1)
	cost = 250
	containername = "\improper Khoros warhorn crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 100

/decl/hierarchy/supply_pack/khoros/raider_armour
	name = "Khoros Raider Armour"
	contains = list(/obj/item/clothing/suit/armor/raider_armour = 1)
	cost = 1250
	containername = "\improper Khoros Raider Armour crate"
	containertype = /obj/structure/closet/secure_closet/cargotech
	rep_unlock = 200

/decl/hierarchy/supply_pack/khoros/lightarmour
	name = "Khoros Light Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/light/brown = 1,\
		/obj/item/clothing/head/helmet/innie/light/brown = 1,\
		/obj/item/clothing/suit/storage/innie/light/brown = 1)
	cost = 1250
	containername = "\improper khoros Light Armour crate"
	containertype = /obj/structure/closet/secure_closet/cargotech
	rep_unlock = 50

/decl/hierarchy/supply_pack/khoros/mediumarmour
	name = "Khoros Medium Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/brown = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/brown = 1,\
		/obj/item/clothing/suit/storage/innie/medium/brown = 1)
	cost = 1500
	containername = "\improper khoros Medium Armour crate"
	containertype = /obj/structure/closet/secure_closet/cargotech

/decl/hierarchy/supply_pack/khoros/heavyarmour
	name = "Khoros Heavy Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/brown = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/brown = 1,\
		/obj/item/clothing/suit/storage/innie/heavy/brown = 1)
	cost = 1500
	containername = "\improper khoros Heavy Armour crate"
	containertype = /obj/structure/closet/secure_closet/cargotech
	rep_unlock = 50

/decl/hierarchy/supply_pack/khoros/mongoose
	name = "M274 Ultra-Light All-Terrain Vehicle \"Mongoose\""
	contains = list(/obj/vehicles/mongoose = 1)
	cost = 3000
	containertype = null
	rep_unlock = 75

/decl/hierarchy/supply_pack/khoros/machete
	name = "Machete (x3)"
	contains = list(/obj/item/weapon/material/machete = 3)
	cost = 200
	containername = "\improper Machete crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 10

/decl/hierarchy/supply_pack/khoros/sawn_off
	name = "Sawn off shotgun"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn = 1,\
		/obj/item/ammo_casing/shotgun = 6,\
		/obj/item/ammo_casing/shotgun/pellet = 6)
	cost = 250
	containername = "\improper Sawn off shotgun crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 10

/decl/hierarchy/supply_pack/khoros/plastique
	name = "C12 breaching charges (x3)"
	contains = list(/obj/item/weapon/plastique = 3)
	cost = 300
	containername = "\improper C12 crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 20

/decl/hierarchy/supply_pack/khoros/explosivemines
	name = "Explosive mines (x3)"
	contains = list(/obj/item/device/landmine/explosive = 3)
	cost = 45
	containername = "\improper Explosive landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 20

/decl/hierarchy/supply_pack/khoros/fragmines
	name = "Frag mines (x3)"
	contains = list(/obj/item/device/landmine/frag = 3)
	cost = 45
	containername = "\improper Fag landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 20
