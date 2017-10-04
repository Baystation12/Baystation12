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
	name = "Armor - Arm guards"
	contains = list(/obj/item/clothing/gloves/guards = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Arm guards crate"
	access = access_armory

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

/decl/hierarchy/supply_pack/security/ion
	name = "Weapons - Electromagnetic"
	contains = list(/obj/item/weapon/gun/energy/ionrifle = 2,
					/obj/item/weapon/storage/box/emps)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Electromagnetic weapons crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/pistol
	name = "Weapons - Ballistic sidearms"
	contains = list(/obj/item/weapon/gun/projectile/sec = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Ballistic sidearms crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/shotgun
	name = "Weapons - Shotgun"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Shotgun crate"
	access = access_armory

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
	name = "Ammunition - 5.56"
	contains = list(/obj/item/ammo_magazine/a556 = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 5.56 ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/bullpupammopractice
	name = "Ammunition - 5.56 practice"
	contains = list(/obj/item/ammo_magazine/a556/practice = 8)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 5.56 practice ammunition crate"
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
/*
/decl/hierarchy/supply_pack/security/flareguns
	name = "Flare guns crate"
	contains = list(/obj/item/weapon/gun/projectile/sec/flash,
					/obj/item/ammo_magazine/c45m/flash,
					/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare,
					/obj/item/weapon/storage/box/flashshells)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Flare gun crate"
	access = access_security

/decl/hierarchy/supply_pack/security/eweapons
	name = "Advanced Energy Weapons crate"
	contains = list(/obj/item/weapon/gun/energy/xray = 2,
					/obj/item/weapon/gun/energy/xray/pistol = 1,
					/obj/item/weapon/shield/energy = 2,
					/obj/item/clothing/suit/armor/laserproof = 2)
	cost = 125
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Advanced Energy Weapons crate"
	access = access_heads

/decl/hierarchy/supply_pack/security/armor
	num_contained = 5
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest/nt,
					/obj/item/clothing/suit/armor/vest/detective,
					/obj/item/clothing/suit/storage/vest/nt/hos,
					/obj/item/clothing/suit/storage/vest/pcrc,
					/obj/item/clothing/suit/storage/vest/nt/warden,
					/obj/item/clothing/suit/storage/vest)

	name = "Armor crate"
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Armor crate"
	access = access_security
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/energyweapons
	name = "Energy weapons crate"
	contains = list(/obj/item/weapon/gun/energy/laser = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper energy weapons crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof = 2,
					/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Energy marksman crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/automatic
	name = "Automatic weapon crate"
	num_contained = 2
	contains = list(/obj/item/weapon/gun/projectile/automatic/wt550,
					/obj/item/weapon/gun/projectile/automatic/z8)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Automatic weapon crate"
	access = access_armory
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/holster
	name = "Holster crate"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/holster,
					/obj/item/clothing/accessory/holster/armpit,
					/obj/item/clothing/accessory/holster/waist,
					/obj/item/clothing/accessory/holster/hip)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Holster crate"
	access = access_security
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/securityextragear
	name = "Security surplus equipment"
	contains = list(/obj/item/weapon/storage/belt/security = 3,
					/obj/item/clothing/glasses/sunglasses/sechud = 3)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security surplus equipment"
	access = access_security

/decl/hierarchy/supply_pack/security/detectiveclothes
	name = "Investigation apparel"
	contains = list(/obj/item/clothing/under/det/black = 2,
					/obj/item/clothing/under/det/grey = 2,
					/obj/item/clothing/head/det/grey = 2,
					/obj/item/clothing/under/det = 2,
					/obj/item/clothing/head/det = 2,
					/obj/item/clothing/suit/storage/det_trench,
					/obj/item/clothing/suit/storage/det_trench/grey,
					/obj/item/clothing/suit/storage/forensics/red,
					/obj/item/clothing/suit/storage/forensics/blue,
					/obj/item/clothing/gloves/forensic,
					/obj/item/clothing/gloves/thick = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Investigation clothing"
	access = access_forensics_lockers

/decl/hierarchy/supply_pack/security/officergear
	name = "Officer equipment"
	contains = list(/obj/item/clothing/suit/storage/vest/nt,
					/obj/item/clothing/head/helmet,
					/obj/item/weapon/cartridge/security,
					/obj/item/clothing/accessory/badge/holo,
					/obj/item/clothing/accessory/badge/holo/cord,
					/obj/item/device/radio/headset/headset_sec,
					/obj/item/weapon/storage/belt/security,
					/obj/item/device/flash,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/weapon/grenade/flashbang,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/taperoll/police,
					/obj/item/clothing/gloves/thick,
					/obj/item/device/hailer,
					/obj/item/device/flashlight/flare,
					/obj/item/clothing/accessory/storage/black_vest,
					/obj/item/clothing/head/soft/sec/corp,
					/obj/item/clothing/under/rank/security/corp,
					/obj/item/weapon/gun/energy/taser)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Officer equipment"
	access = access_brig

/decl/hierarchy/supply_pack/security/wardengear
	name = "Warden equipment"
	contains = list(/obj/item/clothing/suit/storage/vest/nt/warden,
					/obj/item/clothing/under/rank/warden,
					/obj/item/clothing/under/rank/warden/corp,
					/obj/item/clothing/suit/armor/vest/warden,
					/obj/item/weapon/cartridge/security,
					/obj/item/device/radio/headset/headset_sec,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/taperoll/police,
					/obj/item/device/hailer,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/belt/security,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/storage/box/holobadge,
					/obj/item/clothing/head/beret/sec/corporate/warden)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Warden equipment"
	access = access_armory

/decl/hierarchy/supply_pack/security/headofsecgear
	name = "Head of security equipment"
	contains = list(/obj/item/clothing/suit/storage/vest/nt/hos,
					/obj/item/clothing/under/rank/head_of_security/corp,
					/obj/item/clothing/suit/armor/hos,
					/obj/item/weapon/cartridge/hos,
					/obj/item/device/radio/headset/heads/hos,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/weapon/storage/belt/security,
					/obj/item/device/flash,
					/obj/item/device/hailer,
					/obj/item/clothing/accessory/holster/waist,
					/obj/item/weapon/melee/telebaton,
					/obj/item/clothing/head/beret/sec/corporate/hos)
	cost = 65
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Head of security equipment"
	access = access_hos

/decl/hierarchy/supply_pack/security/securityclothing
	name = "Security uniform crate"
	contains = list(/obj/item/weapon/storage/backpack/satchel_sec = 2,
					/obj/item/weapon/storage/backpack/security = 2,
					/obj/item/clothing/accessory/armband = 4,
					/obj/item/clothing/under/rank/security = 4,
					/obj/item/clothing/under/rank/security2 = 4,
					/obj/item/clothing/under/rank/warden,
					/obj/item/clothing/under/rank/head_of_security,
					/obj/item/clothing/suit/armor/hos/jensen,
					/obj/item/clothing/head/soft/sec = 4,
					/obj/item/clothing/gloves/thick = 4,
					/obj/item/weapon/storage/box/holobadge)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security uniform crate"
	access = access_security

/decl/hierarchy/supply_pack/security/navybluesecurityclothing
	name = "Navy blue security uniform crate"
	contains = list(/obj/item/weapon/storage/backpack/satchel_sec = 2,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/clothing/under/rank/security/navyblue = 4,
					/obj/item/clothing/suit/security/navyofficer = 4,
					/obj/item/clothing/under/rank/warden/navyblue,
					/obj/item/clothing/suit/security/navywarden,
					/obj/item/clothing/under/rank/head_of_security/navyblue,
					/obj/item/clothing/suit/security/navyhos,
					/obj/item/clothing/head/beret/sec/navy/officer = 4,
					/obj/item/clothing/head/beret/sec/navy/warden,
					/obj/item/clothing/head/beret/sec/navy/hos,
					/obj/item/clothing/gloves/thick = 4,
					/obj/item/weapon/storage/box/holobadge)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Navy blue security uniform crate"
	access = access_security

/decl/hierarchy/supply_pack/security/corporatesecurityclothing
	name = "Corporate security uniform crate"
	contains = list(/obj/item/weapon/storage/backpack/satchel_sec = 2,
					/obj/item/weapon/storage/backpack/security = 2,
					/obj/item/clothing/under/rank/security/corp = 4,
					/obj/item/clothing/head/soft/sec/corp = 4,
					/obj/item/clothing/under/rank/warden/corp,
					/obj/item/clothing/under/rank/head_of_security/corp,
					/obj/item/clothing/head/beret/sec = 4,
					/obj/item/clothing/head/beret/sec/corporate/warden,
					/obj/item/clothing/head/beret/sec/corporate/hos,
					/obj/item/clothing/gloves/thick = 4,
					/obj/item/weapon/storage/box/holobadge)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Corporate security uniform crate"
	access = access_security

/decl/hierarchy/supply_pack/security/practicelasers
	name = "Practice Laser Carbines"
	contains = list(/obj/item/weapon/gun/energy/laser/practice = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Practice laser carbine crate"
	access = access_brig
*/