
/decl/hierarchy/supply_pack/covenant_ammo_grenades
	name = "Ammunition and Grenades"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"
	containertype = /obj/structure/closet/crate/covenant



/* AMMO SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_carbine
	name = "Type-51 Carbine magazines (6)"
	contains = list(/obj/item/ammo_magazine/type51mag = 6)
	cost = 500
	containername = "\improper Type-51 Carbine Magazines crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_needlerifle
	name = "Type-31 Needle Rifle magazines (6)"
	contains = list(/obj/item/ammo_magazine/rifleneedlepack = 6)
	cost = 500
	containername = "\improper Type-31 Needle Rifle magazines crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_fuelrod
	name = "Type-33 Light Anti-Armor Weapon magazines (2)"
	contains = list(/obj/item/ammo_magazine/fuel_rod = 2)
	cost = 1000
	containername = "\improper Type-33 Light Anti-Armor Weapon magazine crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_concrifle
	name = "Type-50 Directed Energy Rifle / Heavy magazines (2)"
	contains = list(/obj/item/ammo_magazine/concussion_rifle = 2)
	cost = 1000
	containername = "Type-50 Directed Energy Rifle / Heavy magazine crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_mauler
	name = "Type-52 Mauler magazines (6)"
	contains = list(/obj/item/ammo_magazine/mauler = 6)
	cost = 500
	containername = "Type-52 Mauler magazine crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_spiker
	name = "Type-25 Spiker magazines (6)"
	contains = list(/obj/item/ammo_magazine/spiker = 6)
	cost = 500
	containername = "Type-25 Spiker magazine crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/mags_bruteshot
	name = "Type-25 antipersonnel grenade belts (24)"
	contains = list(/obj/item/weapon/grenade/brute_shot = 2)
	cost = 1000
	containername = "Type-25 antipersonnel grenade belt crate"



/* GRENADE SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_ammo_grenades/grenade_plasma
	name = "Type-1 plasma antipersonnel grenades (6)"
	contains = list(/obj/item/weapon/grenade/plasma = 6)
	cost = 750
	containername = "Type-1 plasma antipersonnel grenades crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/grenade_spike
	name = "Type-2 spike antipersonnel grenades (6)"
	contains = list(/obj/item/weapon/grenade/frag/spike = 6)
	cost = 750
	containername = "Type-2 spike antipersonnel grenades crate"

/decl/hierarchy/supply_pack/covenant_ammo_grenades/grenade_toxic
	name = "Toxic gas grenades (6)"
	contains = list(/obj/item/weapon/grenade/toxic_gas = 6)
	cost = 750
	containername = "Toxic gas grenades crate"
