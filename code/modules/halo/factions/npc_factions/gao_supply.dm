


/* SUPPLY PACKS */

/decl/hierarchy/supply_pack/gao
	name = "Reublic of Gao"
	access = access_innie
	hidden = 1
	contraband = "Insurrection"
	var/rep_unlock = 10

/decl/hierarchy/supply_pack/gao/lightarmour
	name = "Gao Light Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/light/black = 1,\
		/obj/item/clothing/head/helmet/innie/light/black = 1,\
		/obj/item/clothing/suit/storage/innie/light/black = 1)
	cost = 1250
	containername = "\improper Gao Light Armour crate"
	containertype = /obj/structure/closet/secure_closet/counselor
	rep_unlock = 50

/decl/hierarchy/supply_pack/gao/mediumarmour
	name = "Gao Medium Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/black = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/black = 1,\
		/obj/item/clothing/suit/storage/innie/medium/black = 1)
	cost = 1500
	containername = "\improper Gao Medium Armour crate"
	containertype = /obj/structure/closet/secure_closet/counselor

/decl/hierarchy/supply_pack/gao/heavyarmour
	name = "Gao Heavy Armour pack"
	contains = list(/obj/item/clothing/shoes/innie_boots/medium/black = 1,\
		/obj/item/clothing/head/helmet/innie/heavy/black = 1,\
		/obj/item/clothing/suit/storage/innie/heavy/black = 1)
	cost = 1500
	containername = "\improper Gao Heavy Armour crate"
	containertype = /obj/structure/closet/secure_closet/counselor
	rep_unlock = 50

/decl/hierarchy/supply_pack/gao/flashmines
	name = "Flash mines (x3)"
	contains = list(/obj/item/device/landmine/flash = 3)
	cost = 40
	containername = "\improper Flash landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 15

/decl/hierarchy/supply_pack/gao/foammines
	name = "Foam mines (x3)"
	contains = list(/obj/item/device/landmine/foam = 3)
	cost = 35
	containername = "\improper Foam landmines crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 15

/decl/hierarchy/supply_pack/gao/smokebomb
	name = "Smokebomb (x3)"
	contains = list(/obj/item/weapon/grenade/smokebomb = 3)
	cost = 70
	containername = "\improper Smokebomb crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 15

/decl/hierarchy/supply_pack/gao/teargas
	name = "Teargas grenades (x3)"
	contains = list(/obj/item/weapon/grenade/chem_grenade/teargas = 3)
	cost = 50
	containername = "\improper Teargas grenades crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 10

/decl/hierarchy/supply_pack/gao/flashbang
	name = "Flashbangs (x3)"
	contains = list(/obj/item/weapon/grenade/flashbang = 3)
	cost = 40
	containername = "\improper Flashbang crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 15

/decl/hierarchy/supply_pack/gao/m7s
	name = "M7S submachine gun (x2)"
	contains = list(/obj/item/weapon/gun/projectile/m7_smg/silenced = 2,\
		/obj/item/ammo_magazine/m5 = 6)
	cost = 4000
	containername = "\improper M7S crate"
	containertype = /obj/structure/closet/crate/secure/weapon
	rep_unlock = 35

/decl/hierarchy/supply_pack/gao/nvg
	name = "Disguised Night Vision Goggles (x4)"
	contains = list(/obj/item/clothing/glasses/night/disguised = 4)
	cost = 2000
	containername = "\improper Disguised Night Vision Goggles crate"
	containertype = /obj/structure/closet/crate/secure/gear
	rep_unlock = 80

/decl/hierarchy/supply_pack/gao/freedom_implants
	name = "Freedom implants (x3)"
	contains = list(/obj/item/weapon/implanter/freedom = 3)
	cost = 200
	containername = "\improper Freedom implants crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 20

/decl/hierarchy/supply_pack/gao/compressed_implants
	name = "Compressed matter implants (x3)"
	contains = list(/obj/item/weapon/implanter/compressed = 3)
	cost = 250
	containername = "\improper Compressed implants crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 25

/decl/hierarchy/supply_pack/gao/explosive_implants
	name = "Explosive implants (x3)"
	contains = list(/obj/item/weapon/implanter/explosive = 3, /obj/item/weapon/implantpad = 1)
	cost = 300
	containername = "\improper Explosive implants crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 20

/decl/hierarchy/supply_pack/gao/adrenaline_implants
	name = "Adrenaline implants (x3)"
	contains = list(/obj/item/weapon/implanter/adrenalin = 3)
	cost = 500
	containername = "\improper Adrenaline implants crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 50

/decl/hierarchy/supply_pack/gao/spacesuit
	name = "Mercenary space suit"
	contains = list(/obj/item/weapon/storage/backpack/satchel/syndie_kit/space = 1)
	cost = 2500
	containername = "\improper Mercenary space suit crate"
	containertype = /obj/structure/closet/syndicate
	rep_unlock = 35

/decl/hierarchy/supply_pack/gao/chameleon_suit
	name = "Chameleon suit"
	contains = list(/obj/item/weapon/storage/backpack/chameleon/sydie_kit = 1)
	cost = 3000
	containername = "\improper Chameleon suit crate"
	containertype = /obj/structure/closet/syndicate
	rep_unlock = 50

/decl/hierarchy/supply_pack/gao/spybug
	name = "Spybug kit"
	contains = list(/obj/item/weapon/storage/box/syndie_kit/spy = 1)
	cost = 25
	containername = "\improper Spy kit crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 10

/decl/hierarchy/supply_pack/gao/trick_cigs
	name = "Trick cigarettes kit"
	contains = list(/obj/item/weapon/storage/box/syndie_kit/cigarette = 1)
	cost = 30
	containername = "\improper Trick cigarettes crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 10

/decl/hierarchy/supply_pack/gao/voicechanger
	name = "Voice changer (x2)"
	contains = list(/obj/item/clothing/mask/gas/voice = 2)
	cost = 750
	containername = "\improper Voice changer crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 15

/decl/hierarchy/supply_pack/gao/emag
	name = "Cryptographic sequencer"
	contains = list(/obj/item/weapon/card/emag = 1)
	cost = 500
	containername = "\improper Cryptographic sequencer crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 15

/decl/hierarchy/supply_pack/gao/agent_card
	name = "Agent ID card"
	contains = list(/obj/item/weapon/card/id/syndicate = 1)
	cost = 10
	containername = "\improper Agent ID card crate"
	containertype = /obj/structure/closet/crate/secure
	rep_unlock = 10
