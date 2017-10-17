/decl/hierarchy/supply_pack/security
	name = "Security"

/decl/hierarchy/supply_pack/security/specialops
	name = "Special Ops supplies"
	contains = list(/obj/item/weapon/storage/box/emps,
					/obj/item/weapon/grenade/smokebomb = 3,
					/obj/item/weapon/pen/reagent/paralysis,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	cost = 20
	containername = "\improper Special Ops crate"
	hidden = 1

/decl/hierarchy/supply_pack/security/lightarmor
	name = "Armor - Light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light = 4,
					/obj/item/clothing/head/helmet =4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Light armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/armor
	name = "Armor - Unmarked"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium = 2,
					/obj/item/clothing/head/helmet =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/tacticalarmor
	name = "Armor - Tactical"
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/pcarrier/tan/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/tacgoggles,
					/obj/item/weapon/storage/belt/security/tactical,
					/obj/item/clothing/shoes/tactical,
					/obj/item/clothing/gloves/tactical)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Tactical armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/armguards
	name = "Armor - Black arm guards"
	contains = list(/obj/item/clothing/accessory/armguards = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/legguards
	name = "Armor - Black leg guards"
	contains = list(/obj/item/clothing/accessory/legguards = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/armguards_random
	name = "Armor - Assorted arm guards"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/armguards/blue,
					/obj/item/clothing/accessory/armguards/navy,
					/obj/item/clothing/accessory/armguards/green,
					/obj/item/clothing/accessory/armguards/tan)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm guards crate"
	access = access_armory
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/legguards_random
	name = "Armor - Assorted leg guards"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/legguards/blue,
					/obj/item/clothing/accessory/legguards/navy,
					/obj/item/clothing/accessory/legguards/green,
					/obj/item/clothing/accessory/legguards/tan)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Leg guards crate"
	access = access_armory
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/riotarmor
	name = "Armor - Riot gear"
	contains = list(/obj/item/weapon/shield/riot = 4,
					/obj/item/clothing/head/helmet/riot = 4,
					/obj/item/clothing/suit/armor/riot = 4,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Riot armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ballisticarmor
	name = "Armor - Ballistic"
	contains = list(/obj/item/clothing/head/helmet/ballistic = 4,
					/obj/item/clothing/suit/armor/bulletproof = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Ballistic suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ablativearmor
	name = "Armor - Ablative"
	contains = list(/obj/item/clothing/head/helmet/ablative = 4,
					/obj/item/clothing/suit/armor/laserproof = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Ablative suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/voidsuit
	name = "Armor - Security voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "\improper Security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_brig

/decl/hierarchy/supply_pack/security/weapons
	name = "Weapons - Security basic"
	contains = list(/obj/item/device/flash = 4,
					/obj/item/weapon/reagent_containers/spray/pepper = 4,
					/obj/item/weapon/melee/baton/loaded = 4,
					/obj/item/weapon/gun/energy/taser = 4)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Weapons crate"
	access = access_security

/decl/hierarchy/supply_pack/security/egun
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/weapon/gun/energy/gun = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Energy sidearms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/ion
	name = "Weapons - Electromagnetic"
	contains = list(/obj/item/weapon/gun/energy/ionrifle = 2,
					/obj/item/weapon/storage/box/emps)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Electromagnetic weapons crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/pistol
	name = "Weapons - Ballistic sidearms"
	contains = list(/obj/item/weapon/gun/projectile/sec = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Ballistic sidearms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shotgun
	name = "Weapons - Shotgun"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Shotgun crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/flashbang
	name = "Weapons - Flashbangs"
	contains = list(/obj/item/weapon/storage/box/flashbangs = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Flashbang crate"
	access = access_security

/decl/hierarchy/supply_pack/security/teargas
	name = "Weapons - Tear gas grenades"
	contains = list(/obj/item/weapon/storage/box/teargas = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Tear gas grenades crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pistolammo
	name = "Ammunition - .45 magazines"
	contains = list(/obj/item/ammo_magazine/c45m = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper .45 ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/pistolammorubber
	name = "Ammunition - .45 rubber"
	contains = list(/obj/item/ammo_magazine/c45m/rubber = 4)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper .45 rubber ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pistolammopractice
	name = "Ammunition - .45 practice"
	contains = list(/obj/item/ammo_magazine/c45m/practice = 8)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper .45 practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/shotgunammo
	name = "Ammunition - Lethal shells"
	contains = list(/obj/item/weapon/storage/box/shotgunammo = 2,
					/obj/item/weapon/storage/box/shotgunshells = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Lethal shotgun shells crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shotgunbeanbag
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/weapon/storage/box/beanbags = 3)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Beanbag shotgun shells crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pdwammo
	name = "Ammunition - 9mm top mounted"
	contains = list(/obj/item/ammo_magazine/mc9mmt = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 9mm ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/pdwammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(/obj/item/ammo_magazine/mc9mmt/rubber = 4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 9mm rubber ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pdwammopractice
	name = "Ammunition - 9mm top mounted practice"
	contains = list(/obj/item/ammo_magazine/mc9mmt/practice = 8)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 9mm practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/bullpupammo
	name = "Ammunition - 7.62"
	contains = list(/obj/item/ammo_magazine/a762 = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 7.62 ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/bullpupammopractice
	name = "Ammunition - 7.62 practice"
	contains = list(/obj/item/ammo_magazine/a762/practice = 8)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 7.62 practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/forensics //Not access-restricted so PIs can use it.
	name = "Forensics - Auxiliary tools"
	contains = list(/obj/item/weapon/forensics/sample_kit,
					/obj/item/weapon/forensics/sample_kit/powder,
					/obj/item/weapon/storage/box/swabs = 3,
					/obj/item/weapon/reagent_containers/spray/luminol)
	cost = 30
	containername = "\improper Auxiliary forensic tools crate"

/decl/hierarchy/supply_pack/security/detectivegear
	name = "Forensics - investigation equipment"
	contains = list(/obj/item/weapon/storage/box/evidence = 2,
					/obj/item/weapon/cartridge/detective,
					/obj/item/device/radio/headset/headset_sec,
					/obj/item/taperoll/police,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/device/camera,
					/obj/item/weapon/folder/red,
					/obj/item/weapon/folder/blue,
					/obj/item/clothing/gloves/forensic,
					/obj/item/device/taperecorder,
					/obj/item/device/mass_spectrometer,
					/obj/item/device/camera_film = 2,
					/obj/item/weapon/storage/photo_album,
					/obj/item/device/reagent_scanner,
					/obj/item/weapon/storage/briefcase/crimekit = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Forensic equipment crate"
	access = access_forensics_lockers

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Misc - Barrier crate"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Security barrier crate"
	access = access_security

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Misc - Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper wall shield generators crate"
	access = access_brig

/decl/hierarchy/supply_pack/security/securitybiosuit
	name = "Misc - Security biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/oxygen,
					/obj/item/clothing/gloves/latex)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security biohazard gear crate"
	access = access_security