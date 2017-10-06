/decl/hierarchy/supply_pack/security
	name = "Security"

/decl/hierarchy/supply_pack/security/lightarmorsol
	name = "Armor - SCG light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light/sol = 4,
					/obj/item/clothing/head/helmet/solgov =4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper SolGov light armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/secarmor
	name = "Armor - Security"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium/security = 2,
					/obj/item/clothing/head/helmet/solgov/security =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/solarmor
	name = "Armor - Peacekeeper"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/blue/sol = 2,
					/obj/item/clothing/head/helmet/solgov =2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Peacekeeper armor crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/comarmor
	name = "Armor - Command"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium/command = 2,
					/obj/item/clothing/head/helmet/solgov/command =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Command armor crate"
	access = access_heads

/decl/hierarchy/supply_pack/security/nanoarmor
	name = "Armor - NanoTrasen"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium/nt = 2,
					/obj/item/clothing/head/helmet/nt/guard =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper NanoTrasen armor crate"
	access = access_nanotrasen

/decl/hierarchy/supply_pack/security/lightnanoarmor
	name = "Armor - NanoTrasen light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light/nt = 2,
					/obj/item/clothing/head/helmet/nt/guard =2)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper NanoTrasen light armor crate"
	access = access_nanotrasen

/decl/hierarchy/supply_pack/security/laser
	name = "Weapons - Laser carbines"
	contains = list(/obj/item/weapon/gun/energy/laser = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Laser carbines crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/advancedlaser
	name = "Weapons - Advanced Laser Weapons"
	contains = list(/obj/item/weapon/gun/energy/xray = 2,
					/obj/item/weapon/gun/energy/xray/pistol = 2,
					/obj/item/weapon/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Advanced Laser Weapons crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/sniperlaser
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 70
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Energy marksman crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/pdw
	name = "Weapons - Ballistic PDWs"
	contains = list(/obj/item/weapon/gun/projectile/automatic/wt550 = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Ballistic PDW crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/bullpup
	name = "Weapons - Ballistic rifles"
	contains = list(/obj/item/weapon/gun/projectile/automatic/z8 = 2)
	cost = 80 //Because 5.56 is OP as fuck right now.
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Bullpup automatic rifle crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/holster
	name = "Misc - Holster crate"
	contains = list(/obj/item/clothing/accessory/holster/hip = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Holster crate"
	access = access_solgov_crew

/decl/hierarchy/supply_pack/security/securityextragear
	name = "Misc - Security equipment"
	contains = list(/obj/item/weapon/cartridge/security = 2,
					/obj/item/weapon/storage/belt/security = 2,
					/obj/item/device/radio/headset/headset_sec = 2,
					/obj/item/clothing/glasses/sunglasses/sechud/goggles = 2,
					/obj/item/taperoll/police = 2,
					/obj/item/device/hailer = 2,
					/obj/item/clothing/gloves/thick = 2,
					/obj/item/device/holowarrant = 2,
					/obj/item/device/flashlight/maglight = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security equipment crate"
	access = access_security

/decl/hierarchy/supply_pack/security/cosextragear
	name = "Misc - Chief of Security equipment"
	contains = list(/obj/item/weapon/cartridge/hos,
					/obj/item/device/radio/headset/heads/cos,
					/obj/item/clothing/glasses/sunglasses/sechud/goggles,
					/obj/item/taperoll/police,
					/obj/item/weapon/storage/belt/security,
					/obj/item/device/hailer,
					/obj/item/device/holowarrant,
					/obj/item/clothing/gloves/thick,
					/obj/item/device/flashlight/maglight,)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Chief of Security equipment crate"
	access = access_hos

/decl/hierarchy/supply_pack/security/practicelasers
	name = "Misc - Practice Laser Carbines"
	contains = list(/obj/item/weapon/gun/energy/laser/practice = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Practice laser carbine crate"
	access = access_solgov_crew
