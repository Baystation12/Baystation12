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

/decl/hierarchy/supply_pack/security/forensics
	name = "Auxiliary forensic tools"
	contains = list(/obj/item/weapon/forensics/sample_kit,
					/obj/item/weapon/forensics/sample_kit/powder,
					/obj/item/weapon/storage/box/swabs = 3,
					/obj/item/weapon/reagent_containers/spray/luminol)
	cost = 30
	containername = "\improper Auxiliary forensic tools"

/decl/hierarchy/supply_pack/security/beanbagammo
	name = "Beanbag shells"
	contains = list(/obj/item/weapon/storage/box/beanbags = 3)
	cost = 30
	containername = "\improper Beanbag shells"

/decl/hierarchy/supply_pack/security/weapons
	name = "Weapons crate"
	contains = list(/obj/item/weapon/melee/baton = 2,
					/obj/item/weapon/gun/energy/gun = 2,
					/obj/item/weapon/gun/energy/taser = 2,
					/obj/item/weapon/gun/projectile/sec = 2,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper Weapons crate"
	access = access_security

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

/decl/hierarchy/supply_pack/security/riot
	name = "Riot gear crate"
	contains = list(/obj/item/weapon/melee/baton = 3,
					/obj/item/weapon/shield/riot = 3,
					/obj/item/weapon/handcuffs = 3,
					/obj/item/clothing/head/helmet/riot = 3,
					/obj/item/clothing/suit/armor/riot = 3,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas,
					/obj/item/weapon/storage/box/beanbags,
					/obj/item/weapon/storage/box/handcuffs)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Riot gear crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/energyweapons
	name = "Energy weapons crate"
	contains = list(/obj/item/weapon/gun/energy/laser = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper energy weapons crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/shotgun
	name = "Shotgun crate"
	contains = list(/obj/item/clothing/suit/armor/bulletproof = 2,
					/obj/item/weapon/storage/box/shotgunammo,
					/obj/item/weapon/storage/box/shotgunshells,
					/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2)
	cost = 65
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Shotgun crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof = 2,
					/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Energy marksman crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/shotgunammo
	name = "Ballistic ammunition crate"
	contains = list(/obj/item/weapon/storage/box/shotgunammo = 2,
					/obj/item/weapon/storage/box/shotgunshells = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper ballistic ammunition crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ionweapons
	name = "Electromagnetic weapons crate"
	contains = list(/obj/item/weapon/gun/energy/ionrifle = 2,
					/obj/item/weapon/storage/box/emps)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper electromagnetic weapons crate"
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

/decl/hierarchy/supply_pack/security/autoammo
	name = "Automatic weapon ammunition crate"
	num_contained = 6
	contains = list(/obj/item/ammo_magazine/mc9mmt,
					/obj/item/ammo_magazine/mc9mmt/rubber,
					/obj/item/ammo_magazine/a556)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Automatic weapon ammunition crate"
	access = access_armory
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/expenergy
	name = "Experimental energy gear crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof = 2,
					/obj/item/weapon/gun/energy/gun = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Experimental energy gear crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/exparmor
	name = "Experimental armor crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/suit/armor/riot)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Experimental armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Security barrier crate"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "\improper Security barrier crate"

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper wall shield generators crate"
	access = access_teleporter

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

/decl/hierarchy/supply_pack/security/detectivegear
	name = "Forensic investigation equipment"
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
					/obj/item/weapon/storage/briefcase/crimekit = 2,
					)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Forensic equipment"
	access = access_forensics_lockers

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

/decl/hierarchy/supply_pack/security/securitybiosuit
	name = "Security biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/under/rank/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/oxygen,
					/obj/item/clothing/gloves/latex)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Security biohazard gear"
	access = access_security

/decl/hierarchy/supply_pack/security/tactical
	name = "Tactical suits"
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/storage/vest/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/tacgoggles,
					/obj/item/weapon/storage/belt/security/tactical,
					/obj/item/clothing/shoes/tactical,
					/obj/item/clothing/gloves/tactical)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Tactical Suit Locker"
	access = access_armory

/decl/hierarchy/supply_pack/security/practicelasers
	name = "Practice Laser Carbines"
	contains = list(/obj/item/weapon/gun/energy/laser/practice = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Practice laser carbine crate"
	access = access_brig
