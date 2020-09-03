/decl/hierarchy/supply_pack/unsc_weapons
	name = "UNSC Weapons"
	containertype = /obj/structure/closet/crate/secure/weapon

/* GRENADES */

/decl/hierarchy/supply_pack/unsc_weapons/fragnade
	name = "M9 Fragmentation grenades (2 boxes)"
	contains = list(/obj/item/weapon/storage/box/m9_frag = 2)
	cost = 1250
	containername = "\improper M9 grenades crate"

/decl/hierarchy/supply_pack/unsc_weapons/smokenade
	name = "Smoke grenades (6)"
	contains = list(/obj/item/weapon/grenade/smokebomb = 6)
	cost = 650
	containername = "\improper Smoke grenades crate"

/* MELEE */

/decl/hierarchy/supply_pack/unsc_weapons/melee
	name = "Mixed melee (6)"
	cost = 300
	contains = list(
		/obj/item/weapon/material/knife/combat_knife = 2,
		/obj/item/weapon/melee/baton/humbler = 2,
		/obj/item/weapon/material/machete = 2)
	containername = "\improper Mixed melee crate"

/* M6D */

/decl/hierarchy/supply_pack/unsc_weapons/m6d
	name = "M6D Magnum (3)"
	cost = 1300
	contains = list(
		/obj/item/weapon/gun/projectile/m6d_magnum = 3)
	containername = "\improper M6D Magnum crate"

/* TURRETS */

/decl/hierarchy/supply_pack/unsc_weapons/hmg_kit
	name = "HMG Turret Kit"
	cost = 800
	contains = list(/obj/item/turret_deploy_kit/HMG = 1)
	containername = "\improper HMG Turret Kit crate"
