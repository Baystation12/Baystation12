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
	containername = "security armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/solarmor
	name = "Armor - Peacekeeper"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/blue/sol = 2,
					/obj/item/clothing/head/helmet/solgov =2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "peacekeeper armor crate"
	access = access_emergency_armory

/decl/hierarchy/supply_pack/security/comarmor
	name = "Armor - Command"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium/command = 2,
					/obj/item/clothing/head/helmet/solgov/command =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "command armor crate"
	access = access_heads

/decl/hierarchy/supply_pack/security/nanoarmor
	name = "Armor - Corporate"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium/nt = 2,
					/obj/item/clothing/head/helmet/nt/guard =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "corporate armor crate"
	access = access_nanotrasen

/decl/hierarchy/supply_pack/security/lightnanoarmor
	name = "Armor - Corporate light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light/nt = 2,
					/obj/item/clothing/head/helmet/nt/guard =2)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "corporate light armor crate"
	access = access_nanotrasen

/decl/hierarchy/supply_pack/security/pistol
	name = "Weapons - Ballistic sidearms"
	contains = list(/obj/item/gun/projectile/pistol/military = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "ballistic sidearms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/laser
	name = "Weapons - Laser carbines"
	contains = list(/obj/item/gun/energy/laser/secure = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "laser carbines crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/laser/shady
	name = "Weapons - Laser carbines (For disposal)"
	contains = list(/obj/item/gun/energy/laser = 4)
	cost = 80
	contraband = 1
	security_level = null

/decl/hierarchy/supply_pack/security/advancedlaser
	name = "Weapons - Advanced Laser Weapons"
	contains = list(/obj/item/gun/energy/xray = 2,
					/obj/item/gun/energy/xray/pistol = 2,
					/obj/item/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "advanced Laser Weapons crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_HIGH

//proxima code start
/decl/hierarchy/supply_pack/security/k342
	name = "Weapons - K342 - Barrakuda"
	contains = list(/obj/item/gun/energy/k342 = 2, /obj/item/cell/guncell/medium = 4)
	cost = 110
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "k342 - barrakuda crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_ELEVATED
//proxima code end

/decl/hierarchy/supply_pack/security/sniperlaser
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/gun/energy/sniperrifle = 2)
	cost = 70
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "energy marksman crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/pdw
	name = "Weapons - Ballistic PDWs"
	contains = list(/obj/item/gun/projectile/automatic/sec_smg = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Ballistic PDW crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/bullpup
	name = "Weapons - Ballistic rifles"
	contains = list(/obj/item/gun/projectile/automatic/bullpup_rifle = 2)
	cost = 80 //Because 5.56 is OP as fuck right now.
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "bullpup automatic rifle crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_HIGH

//rubay code
/decl/hierarchy/supply_pack/security/gren_launch
	name = "Weapons - Grenade Launcher Ammunition"
	contains = list(/obj/item/grenade/frag/shell = 6)
	cost = 65
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "grenade launcher ammunition crate"
	access = access_emergency_armory
	security_level = SUPPLY_SECURITY_HIGH
//rubay code end

/decl/hierarchy/supply_pack/security/pistolammo
	name = "Ammunition - pistol magazines"
	contains = list(/obj/item/ammo_magazine/pistol/double = 4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "pistol ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/pistolammorubber
	name = "Ammunition - pistol rubber"
	contains = list(/obj/item/ammo_magazine/pistol/double/rubber = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "pistol rubber ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pistolammopractice
	name = "Ammunition - pistol practice ammo"
	contains = list(/obj/item/ammo_magazine/pistol/double/practice = 8)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "pistol practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/holster
	name = "Gear - Holster crate"
	contains = list(/obj/item/clothing/accessory/storage/holster/hip = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "holster crate"
	access = access_solgov_crew

/decl/hierarchy/supply_pack/security/securityextragear
	name = "Gear - Master at Arms equipment"
	contains = list(/obj/item/device/radio/headset/headset_sec,
					/obj/item/device/radio/headset/headset_sec/alt,
					/obj/item/storage/belt/holster/security,
					/obj/item/device/flash,
					/obj/item/reagent_containers/spray/pepper,
					/obj/item/grenade/chem_grenade/teargas,
					/obj/item/melee/baton/loaded,
					/obj/item/clothing/glasses/hud/security/prot,
					/obj/item/taperoll/police,
					/obj/item/device/hailer,
					/obj/item/clothing/accessory/storage/black_vest,
					/obj/item/device/megaphone,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/gloves/thick/duty/solgov/sec,
					/obj/item/device/holowarrant,
					/obj/item/device/flashlight/maglight,
					/obj/item/storage/belt/security)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Master at Arms equipment crate"
	access = access_security

/decl/hierarchy/supply_pack/security/cosextragear
	name = "Gear - Chief of Security equipment"
	contains = list(/obj/item/device/radio/headset/heads/cos,
					/obj/item/clothing/glasses/hud/security/prot,
					/obj/item/taperoll/police,
					/obj/item/storage/belt/holster/security,
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
	contains = list(/obj/item/gun/energy/laser/practice = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "practice laser carbine crate"
	access = access_solgov_crew
