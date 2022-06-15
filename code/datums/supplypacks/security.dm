/decl/hierarchy/supply_pack/security
	name = "Security"

/decl/hierarchy/supply_pack/security/specialops
	name = "Grenades - Special Ops supplies"
	contains = list(/obj/item/storage/box/emps,
					/obj/item/grenade/smokebomb = 3,
					/obj/item/grenade/chem_grenade/incendiary)
	cost = 20
	containername = "special ops crate"
	hidden = 1

/decl/hierarchy/supply_pack/security/lightarmor
	name = "Armor - Light"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light = 4,
					/obj/item/clothing/head/helmet =4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "light armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/armor
	name = "Armor - Unmarked"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium = 2,
					/obj/item/clothing/head/helmet =2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "armor crate"
	access = access_security

/decl/hierarchy/supply_pack/security/tacticalarmor
	name = "Armor - Tactical"
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/pcarrier/tan/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/tacgoggles,
					/obj/item/storage/belt/holster/security/tactical,
					/obj/item/clothing/shoes/tactical,
					/obj/item/clothing/gloves/tactical)
	cost = 45
	containertype = /obj/structure/closet/crate/secure
	containername = "tactical armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/blackguards
	name = "Armor - Arm and leg guards, black"
	contains = list(/obj/item/clothing/accessory/arm_guards = 2,
					/obj/item/clothing/accessory/leg_guards = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/blueguards
	name = "Armor - Arm and leg guards, blue"
	contains = list(/obj/item/clothing/accessory/arm_guards/blue = 2,
					/obj/item/clothing/accessory/leg_guards/blue = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/greenguards
	name = "Armor - Arm and leg guards, green"
	contains = list(/obj/item/clothing/accessory/arm_guards/green = 2,
					/obj/item/clothing/accessory/leg_guards/green = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/navyguards
	name = "Armor - Arm and leg guards, navy blue"
	contains = list(/obj/item/clothing/accessory/arm_guards/navy = 2,
					/obj/item/clothing/accessory/leg_guards/navy = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/tanguards
	name = "Armor - Arm and leg guards, tan"
	contains = list(/obj/item/clothing/accessory/arm_guards/tan = 2,
					/obj/item/clothing/accessory/leg_guards/tan = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "arm and leg guards crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/riotarmor
	name = "Armor - Riot gear"
	contains = list(/obj/item/shield/riot = 4,
					/obj/item/clothing/head/helmet/riot = 4,
					/obj/item/clothing/suit/armor/riot = 4,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas)
	cost = 80
	containertype = /obj/structure/closet/crate/secure
	containername = "riot armor crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ballisticarmor
	name = "Armor - Ballistic"
	contains = list(/obj/item/clothing/head/helmet/ballistic = 4,
					/obj/item/clothing/suit/armor/bulletproof = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/ablativearmor
	name = "Armor - Ablative"
	contains = list(/obj/item/clothing/head/helmet/ablative = 4,
					/obj/item/clothing/suit/armor/laserproof = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "ablative suit crate"
	access = access_armory

/decl/hierarchy/supply_pack/security/weapons
	name = "Weapons - Security basic"
	contains = list(/obj/item/device/flash = 4,
					/obj/item/reagent_containers/spray/pepper = 4,
					/obj/item/melee/baton/loaded = 4,
					/obj/item/gun/energy/taser = 4)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "weapons crate"
	access = access_security

/decl/hierarchy/supply_pack/security/egun
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/gun/energy/gun/secure = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "energy sidearms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/egun/shady
	name = "Weapons - Energy sidearms (For disposal)"
	contains = list(/obj/item/gun/energy/gun = 4)
	cost = 60
	contraband = 1
	security_level = null

/decl/hierarchy/supply_pack/security/barracuda
	name = "Weapons - Plasma assault rifles"
	contains = list(/obj/item/gun/energy/k342 = 2,
					/obj/item/cell/guncell/medium = 6)
	cost = 110
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "plasma longarms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/orca
	name = "Weapons - Plasma assault rifles (Expeditionary Corps)"
	contains = list(/obj/item/gun/energy/k342/explo = 2,
					/obj/item/cell/guncell/medium = 6)
	cost = 130
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "plasma longarms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/stingray
	name = "Weapons - Plasma sniper rifles"
	contains = list(/obj/item/gun/energy/k342/sniper = 2,
					/obj/item/cell/guncell/medium = 6)
	cost = 180
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "plasma longarms crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/ion
	name = "Weapons - Electromagnetic"
	contains = list(/obj/item/gun/energy/ionrifle = 2,
					/obj/item/storage/box/emps)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "electromagnetic weapons crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shotgun
	name = "Weapons - Shotgun"
	contains = list(/obj/item/gun/projectile/shotgun/pump/combat = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "shotgun crate"
	access = access_armory
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/flashbang
	name = "Weapons - Flashbangs"
	contains = list(/obj/item/storage/box/flashbangs = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "flashbang crate"
	access = access_security

/decl/hierarchy/supply_pack/security/teargas
	name = "Weapons - Tear gas grenades"
	contains = list(/obj/item/storage/box/teargas = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "tear gas grenades crate"
	access = access_security

/decl/hierarchy/supply_pack/security/shotgunammo
	name = "Ammunition - Lethal shells"
	contains = list(/obj/item/storage/box/ammo/shotgunammo = 2,
					/obj/item/storage/box/ammo/shotgunshells = 2)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "lethal shotgun shells crate"
	access = access_security
	security_level = SUPPLY_SECURITY_ELEVATED

/decl/hierarchy/supply_pack/security/shotgunbeanbag
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/storage/box/ammo/beanbags = 3)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "beanbag shotgun shells crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pdwammo
	name = "Ammunition - SMG top mounted"
	contains = list(/obj/item/ammo_magazine/smg_top = 4)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "SMG ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/pdwammorubber
	name = "Ammunition - SMG top mounted rubber"
	contains = list(/obj/item/ammo_magazine/smg_top/rubber = 4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "SMG rubber ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/pdwammopractice
	name = "Ammunition - SMG top mounted practice"
	contains = list(/obj/item/ammo_magazine/smg_top/practice = 8)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "SMG practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/bullpupammo
	name = "Ammunition - military rifle"
	contains = list(/obj/item/ammo_magazine/mil_rifle = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "military rifle ammunition crate"
	access = access_security
	security_level = SUPPLY_SECURITY_HIGH

/decl/hierarchy/supply_pack/security/bullpupammopractice
	name = "Ammunition - military rifle practice"
	contains = list(/obj/item/ammo_magazine/mil_rifle/practice = 8)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "military rifle practice ammunition crate"
	access = access_security

/decl/hierarchy/supply_pack/security/forensics //Not access-restricted so PIs can use it.
	name = "Forensics - Auxiliary tools"
	contains = list(/obj/item/forensics/sample_kit,
					/obj/item/forensics/sample_kit/powder,
					/obj/item/storage/box/swabs = 3,
					/obj/item/reagent_containers/spray/luminol)
	cost = 30
	containername = "auxiliary forensic tools crate"

/decl/hierarchy/supply_pack/security/detectivegear
	name = "Forensics - investigation equipment"
	contains = list(/obj/item/storage/box/evidence = 2,
					/obj/item/device/radio/headset/headset_sec,
					/obj/item/taperoll/police,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/device/camera,
					/obj/item/folder/red,
					/obj/item/folder/blue,
					/obj/item/clothing/gloves/forensic,
					/obj/item/device/taperecorder,
					/obj/item/device/scanner/spectrometer,
					/obj/item/device/camera_film = 2,
					/obj/item/storage/photo_album,
					/obj/item/device/scanner/reagent,
					/obj/item/storage/briefcase/crimekit = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "forensic equipment crate"
	access = access_forensics_lockers

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Equipment - Barrier crate"
	contains = list(/obj/machinery/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "security barrier crate"
	access = access_security

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Equipment - Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 2)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/large
	containername = "wall shield generators crate"
	access = access_brig

/decl/hierarchy/supply_pack/security/securitybiosuit
	name = "Gear - Security biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/oxygen,
					/obj/item/clothing/gloves/latex)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "security biohazard gear crate"
	access = access_security

/decl/hierarchy/supply_pack/security/voidsuit_security
	name = "EVA - Security (armored) voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_brig
