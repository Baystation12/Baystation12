


/* SUPPLY PACKS */

/decl/hierarchy/supply_pack/olympus
	name = "Olympus Council"
	access = access_innie
	hidden = 1
	contraband = "Insurrection"
	var/rep_unlock = 10

/decl/hierarchy/supply_pack/olympus/lightarmour
	name = "Olympus Light Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/light/white = 1,\
		/obj/item/clothing/head/helmet/innie/light/white = 1,\
		/obj/item/clothing/suit/storage/innie/light/white = 1)
	cost = 1250
	containername = "\improper Olympus Light Armour crate"
	containertype = /obj/structure/closet/secure_closet/medical3
	rep_unlock = 50

/decl/hierarchy/supply_pack/olympus/mediumarmour
	name = "Olympus Medium Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/white = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/white = 1,\
		/obj/item/clothing/suit/storage/innie/medium/white = 1)
	cost = 1500
	containername = "\improper Olympus Medium Armour crate"
	containertype = /obj/structure/closet/secure_closet/medical3

/decl/hierarchy/supply_pack/olympus/heavyarmour
	name = "Olympus Heavy Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/white = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/white = 1,\
		/obj/item/clothing/suit/storage/innie/heavy/white = 1)
	cost = 1500
	containername = "\improper Olympus Heavy Armour crate"
	containertype = /obj/structure/closet/secure_closet/medical3
	rep_unlock = 50

/decl/hierarchy/supply_pack/olympus/rocketlauncher
	name = "RGL-Mk12 singleshot launcher (x3)"
	contains = list(/obj/item/weapon/gun/launcher/rocket/rgl = 3)
	cost = 1200
	containername = "\improper RGL-Mk12 crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 25

/decl/hierarchy/supply_pack/olympus/ma5b
	name = "MA5B Assault Rifle (x2)"
	contains = list(/obj/item/weapon/gun/projectile/ma5b_ar = 2,\
		/obj/item/ammo_magazine/m762_ap/MA5B = 6)
	cost = 2000
	containername = "\improper MA5B crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 25

/decl/hierarchy/supply_pack/olympus/powersink
	name = "Power sink"
	contains = list(/obj/item/device/powersink = 1)
	cost = 5000
	containername = "\improper Night Vision Goggles crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 75

/decl/hierarchy/supply_pack/olympus/thermal
	name = "Thermal Vision Goggles (x4)"
	contains = list(/obj/item/clothing/glasses/thermal = 4)
	cost = 6000
	containername = "\improper Thermal Vision Goggles crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 100

/decl/hierarchy/supply_pack/olympus/aicard
	name = "AI intelicard"
	contains = list(/obj/item/weapon/aicard = 1)
	cost = 1500
	containername = "\improper AI intelicard crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 50

/decl/hierarchy/supply_pack/olympus/empnade
	name = "EMP grenades (x3)"
	contains = list(/obj/item/weapon/grenade/empgrenade = 3)
	cost = 70
	containername = "\improper EMP grenades crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 15

/decl/hierarchy/supply_pack/olympus/antiphoton
	name = "Anti-Photon grenades (x3)"
	contains = list(/obj/item/weapon/grenade/anti_photon = 3)
	cost = 1750
	containername = "\improper Anti-Photon grenades crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 50

/decl/hierarchy/supply_pack/olympus/manhack
	name = "Viscerator pack"
	contains = list(/obj/item/weapon/grenade/spawnergrenade/manhacks = 1)
	cost = 2500
	containername = "\improper Viscerator pack crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 100

/decl/hierarchy/supply_pack/olympus/empmines
	name = "EMP mines (x3)"
	contains = list(/obj/item/device/landmine/emp = 3)
	cost = 35
	containername = "\improper EMP landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 15

/decl/hierarchy/supply_pack/olympus/flashmines
	name = "Flash mines (x3)"
	contains = list(/obj/item/device/landmine/flash = 3)
	cost = 40
	containername = "\improper Flash landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 15

/decl/hierarchy/supply_pack/olympus/zealot
	name = "Zealot combat suit"
	contains = list(/obj/item/clothing/suit/justice/zeal = 1, /obj/item/clothing/head/helmet/zeal = 1)
	cost = 10000
	containername = "\improper Zealot combat suit"
	containertype = /obj/structure/closet/secure_closet
	rep_unlock = 100
