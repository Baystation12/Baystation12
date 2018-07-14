/datum/design/item/weapon
	category_items = "Weapons"

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
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TAAAA"

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TAAAB"

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 500, "silver" = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TAAAC"

/datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TABAA"

/datum/design/item/weapon/anti_photon
	id = "anti_photon"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 1000)
	build_path = /obj/item/weapon/grenade/anti_photon
	sort_string = "TABAB"

/datum/design/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TACAA"
	category_items = "Misc"

/datum/design/item/weapon/advancedflash
	id = "advancedflash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 500)
	build_path = /obj/item/device/flash/advanced
	sort_string = "TADAA"

/datum/design/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TADAB"

/datum/design/item/weapon/stunrifle
	id = "stun_rifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000, "silver" = 500)
	build_path = /obj/item/weapon/gun/energy/stunrevolver/rifle
	sort_string = "TADAC"

/datum/design/item/weapon/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAEAA"

/datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	sort_string = "TAEAB"

/datum/design/item/weapon/xraypistol
	id = "xraypistol"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 500, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/xray/pistol
	sort_string = "TAFAA"

/datum/design/item/weapon/xrayrifle
	id = "xrayrifle"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "uranium" = 1000)
	build_path = /obj/item/weapon/gun/energy/xray
	sort_string = "TAFAB"

/datum/design/item/weapon/grenadelauncher
	id = "grenadelauncher"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/grenade
	sort_string = "TAGAA"

/datum/design/item/weapon/pneumatic
	id = "pneumatic"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2000, "silver" = 500)
	build_path = /obj/item/weapon/gun/launcher/pneumatic
	sort_string = "TAGAB"

/datum/design/item/weapon/railgun
	id = "railgun"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "gold" = 2000, "silver" = 2000)
	build_path = /obj/item/weapon/gun/magnetic/railgun
	sort_string = "TAHAA"

/datum/design/item/weapon/flechette
	id = "flechette"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "gold" = 4000, "silver" = 4000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/magnetic/railgun/flechette
	sort_string = "TAHAB"

/datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAJAA"

/datum/design/item/weapon/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list("gold" = 5000,"uranium" = 10000, "mutagen" = 40)
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAJAB"

/datum/design/item/weapon/smg
	id = "smg"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "silver" = 2000, "diamond" = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	sort_string = "TAPAA"

/datum/design/item/weapon/wt550
	id = "wt550"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "silver" = 3000, "diamond" = 1500)
	build_path = /obj/item/weapon/gun/projectile/automatic/wt550
	sort_string = "TAPAB"

/datum/design/item/weapon/bullpup
	id = "bullpup"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "silver" = 5000, "diamond" = 3000)
	build_path = /obj/item/weapon/gun/projectile/automatic/z8
	sort_string = "TAPAC"

/datum/design/item/weapon/ammunition/ammo_9mm
	id = "ammo_9mm"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3750, "silver" = 100)
	build_path = /obj/item/ammo_magazine/box/c9mm
	sort_string = "TBAAA"

/datum/design/item/weapon/ammunition/stunshell
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TBAAB"

/datum/design/item/weapon/ammunition/ammo_emp_38
	id = "ammo_emp_38"
	desc = "A .38 round with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "uranium" = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp
	sort_string = "TBAAC"

/datum/design/item/weapon/ammunition/ammo_emp_45
	id = "ammo_emp_45"
	desc = "A .45 round with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "uranium" = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/c45
	sort_string = "TBAAD"

/datum/design/item/weapon/ammunition/ammo_emp_10
	id = "ammo_emp_10"
	desc = "A .10mm round with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "uranium" = 750)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/a10mm
	sort_string = "TBAAE"

/datum/design/item/weapon/ammunition/ammo_emp_slug
	id = "ammo_emp_slug"
	desc = "A shotgun slug with an integrated EMP charge."
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "uranium" = 1000)
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/emp
	sort_string = "TBAAF"