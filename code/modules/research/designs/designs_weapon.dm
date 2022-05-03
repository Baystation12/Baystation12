/datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer
	sort_string = "TAAAA"

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid
	sort_string = "TAAAB"

/datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	sort_string = "TABAA"

/datum/design/item/weapon/anti_photon
	id = "anti_photon"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/grenade/anti_photon
	sort_string = "TABAB"

/datum/design/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun
	sort_string = "TACAA"

/datum/design/item/weapon/advancedflash
	id = "advancedflash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_SILVER = 500)
	build_path = /obj/item/device/flash/advanced
	sort_string = "TADAA"

/datum/design/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	sort_string = "TADAB"

/datum/design/item/weapon/stunrifle
	id = "stun_rifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 500)
	build_path = /obj/item/gun/energy/stunrevolver/rifle
	sort_string = "TADAC"

/datum/design/item/weapon/confuseray
	id = "confuseray"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/energy/confuseray
	sort_string = "TADAD"

/datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	sort_string = "TAEAB"

/datum/design/item/weapon/xraypistol
	id = "xraypistol"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ESOTERIC = 2)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_GLASS = 500, MATERIAL_URANIUM = 500)
	build_path = /obj/item/gun/energy/xray/pistol
	sort_string = "TAFAA"

/datum/design/item/weapon/xrayrifle
	id = "xrayrifle"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ESOTERIC = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 1000)
	build_path = /obj/item/gun/energy/xray
	sort_string = "TAFAB"

/datum/design/item/weapon/grenadelauncher
	id = "grenadelauncher"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/launcher/grenade
	sort_string = "TAGAA"

/datum/design/item/weapon/flechette
	id = "flechette"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_GOLD = 4000, MATERIAL_SILVER = 4000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/gun/magnetic/railgun/flechette
	sort_string = "TAHAA"

/datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/gun/energy/toxgun
	sort_string = "TAJAA"

/datum/design/item/weapon/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MATERIAL_GOLD = 5000,MATERIAL_URANIUM = 10000)
	chemicals = list(/datum/reagent/mutagen = 40)
	build_path = /obj/item/gun/energy/decloner
	sort_string = "TAJAB"

/datum/design/item/weapon/wt550
	id = "wt550"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_SILVER = 3000, MATERIAL_DIAMOND = 1500)
	build_path = /obj/item/gun/projectile/automatic/sec_smg
	sort_string = "TAPAA"

/datum/design/item/weapon/smg
	id = "smg"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/gun/projectile/automatic
	sort_string = "TAPAB"

/datum/design/item/weapon/bullpup
	id = "bullpup"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_SILVER = 5000, MATERIAL_DIAMOND = 3000)
	build_path = /obj/item/gun/projectile/automatic/bullpup_rifle
	sort_string = "TAPAC"

/datum/design/item/weapon/ammunition/AssembleDesignName()
	..()
	name = "Ammunition prototype ([item_name])"

/datum/design/item/weapon/ammunition/ammo_small
	id = "ammo_small"
	desc = "A box of small pistol rounds."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 3750, MATERIAL_SILVER = 100)
	build_path = /obj/item/ammo_magazine/box/smallpistol
	sort_string = "TBAAA"

/datum/design/item/weapon/ammunition/ammo_flechette
	id = "ammo_flechette"
	desc = "A high capacity magazine of armor piercing flechette."
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_SILVER = 500, MATERIAL_DIAMOND = 200)
	build_path = /obj/item/ammo_magazine/proto_smg
	sort_string = "TBAAB"

/datum/design/item/weapon/ammunition/stunshell
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TBAAC"

/datum/design/item/weapon/ammunition/ammo_emp_small
	name = "haywire 7mm"
	id = "ammo_emp_small"
	desc = "A box of small pistol rounds with integrated EMP charges."
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_URANIUM = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/smallpistol
	sort_string = "TBAAD"

/datum/design/item/weapon/ammunition/ammo_emp_pistol
	name = "haywire 10mm"
	id = "ammo_emp_pistol"
	desc = "A box of pistol rounds fitted with integrated EMP charges."
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_URANIUM = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/pistol
	sort_string = "TBAAF"

/datum/design/item/weapon/ammunition/ammo_emp_slug
	id = "ammo_emp_slug"
	desc = "A shotgun slug with an integrated EMP charge."
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_URANIUM = 1000)
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/emp
	sort_string = "TBAAG"
