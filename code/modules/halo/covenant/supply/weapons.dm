
/decl/hierarchy/supply_pack/covenant_weapons
	name = "Covenant Weapons"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"
	containertype = /obj/structure/closet/crate/covenant



/* WEAPON SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_weapons/plaspistol
	name = "Type-25 Directed Energy Pistol (3)"
	contains = list(/obj/item/weapon/gun/energy/plasmapistol = 3)
	cost = 900
	containername = "\improper Type-25 Directed Energy Pistol crate"

/decl/hierarchy/supply_pack/covenant_weapons/needler
	name = "Type-33 Guided Munitions Launcher (3)"
	contains = list(/obj/item/weapon/gun/projectile/needler = 3, /obj/item/ammo_magazine/needles = 3)
	cost = 900
	containername = "\improper Type-33 Guided Munitions Launcher crate"

/decl/hierarchy/supply_pack/covenant_weapons/melee
	name = "Mixed melee weapons (4)"
	contains = list(/obj/item/weapon/melee/energy/elite_sword/dagger = 1, /obj/item/weapon/melee/blamite/dagger = 1)
	cost = 400
	containername = "\improper Melee weapons crate (mixed)"
	num_contained = 4
	supply_method = /decl/supply_method/randomized
