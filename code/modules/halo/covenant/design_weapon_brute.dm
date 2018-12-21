
/datum/design/brute_weapon/brute_spiker
	name = "Type-25 Spiker Carbine"
	id = "brute_spiker"
	materials = list(DEFAULT_WALL_MATERIAL = 50, "plasteel" = 5, "glass" = 5)
	build_path = /obj/item/weapon/gun/projectile/spiker
	components = list("hydrogen gas packet" = /obj/item/gas_packet/hydrogen)

/datum/design/brute_weapon/brute_spiker_mag
	name = "spiker magazine"
	id = "brute_spiker_mag"
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 5)
	build_path = /obj/item/ammo_magazine/spike

/datum/design/brute_weapon/brute_shot
	name = "Type-25 Grenade Launcher"
	id = "brute_shot"
	materials = list(DEFAULT_WALL_MATERIAL = 50, "osmium-carbide plasteel" = 5, "duridium" = 10)
	build_path = /obj/item/weapon/gun/projectile/spiker
	components = list("hydrogen gas packet" = /obj/item/gas_packet/hydrogen)

/datum/design/brute_weapon/brute_shot_gren
	name = "Type-25 grenade"
	id = "brute_shot_grenade"
	materials = list(DEFAULT_WALL_MATERIAL = 30, "duridium" = 5, "kemocite" = 5)
	build_path = /obj/item/ammo_magazine/spike

/datum/design/brute_weapon/spikegren
	name = "Type-2 spike grenade"
	id = "brute_spikegren"
	materials = list(DEFAULT_WALL_MATERIAL = 30, "kemocite" = 5)
	build_path = /obj/item/weapon/grenade/frag/spike

/datum/design/brute_weapon/machete
	name = "machete"
	id = "brute_machete"
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/material/machete
