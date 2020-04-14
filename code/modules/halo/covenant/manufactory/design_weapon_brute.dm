
/datum/craft_blueprint/brute_weapon/brute_spiker
	name = "Type-25 Spiker Carbine"
	id = "brute_spiker"
	materials = list(DEFAULT_WALL_MATERIAL = 50, "plasteel" = 5, "glass" = 5)
	build_path = /obj/item/weapon/gun/projectile/spiker
	components = list("hydrogen gas packet" = /obj/item/gas_packet/hydrogen)

/datum/craft_blueprint/brute_weapon/brute_spiker_mag
	name = "spiker magazine"
	id = "brute_spiker_mag"
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 5)
	build_path = /obj/item/ammo_magazine/spiker

/datum/craft_blueprint/brute_weapon/brute_mauler
	name = "Type-52 Mauler sidearm"
	id = "brute_mauler"
	materials = list(DEFAULT_WALL_MATERIAL = 50, "plasteel" = 5, "glass" = 5)
	build_path = /obj/item/weapon/gun/projectile/mauler
	components = list("hydrogen gas packet" = /obj/item/gas_packet/hydrogen)

/datum/craft_blueprint/brute_weapon/brute_mauler_mag
	name = "mauler magazine"
	id = "brute_mauler_mag"
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 5)
	build_path = /obj/item/ammo_magazine/mauler

/datum/craft_blueprint/brute_weapon/brute_shot
	name = "Type-25 Grenade Launcher"
	id = "brute_shot"
	materials = list(DEFAULT_WALL_MATERIAL = 50, "osmium-carbide plasteel" = 5, "duridium" = 10)
	build_path = /obj/item/weapon/gun/launcher/grenade/brute_shot
	components = list("hydrogen gas packet" = /obj/item/gas_packet/hydrogen)

/datum/craft_blueprint/brute_weapon/brute_shot_gren
	name = "Type-25 grenade"
	id = "brute_shot_grenade"
	materials = list(DEFAULT_WALL_MATERIAL = 5, "plasteel" = 1, "kemocite" = 10)
	build_path = /obj/item/weapon/grenade/brute_shot/single

/datum/craft_blueprint/brute_weapon/spikegren
	name = "Type-2 spike grenade"
	id = "brute_spikegren"
	materials = list(DEFAULT_WALL_MATERIAL = 30, "kemocite" = 5)
	build_path = /obj/item/weapon/grenade/frag/spike

/datum/craft_blueprint/brute_weapon/machete
	name = "machete"
	id = "brute_machete"
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/material/machete

/datum/craft_blueprint/brute_weapon/grenade_chlorine
	name = "chlorine grenade"
	id = "toxgas_chlorine"
	materials = list(DEFAULT_WALL_MATERIAL = 15, "duridium" = 5, "kemocite" = 5)
	build_path = /obj/item/weapon/grenade/toxic_gas/chlorine
	components = list("chlorine gas packet" = /obj/item/gas_packet/chlorine)

/datum/craft_blueprint/brute_weapon/grenade_carbonmonoxide
	name = "carbon monoxide grenade"
	id = "toxgas_carbmonox"
	materials = list(DEFAULT_WALL_MATERIAL = 15, "duridium" = 5, "kemocite" = 5)
	build_path = /obj/item/weapon/grenade/toxic_gas/carbon_monodixe
	components = list("carbon monoxide gas packet" = /obj/item/gas_packet/carbonmonoxide)

/datum/craft_blueprint/brute_weapon/grenade_sulfurdioxide
	name = "sulfur dioxide grenade"
	id = "toxgas_sulfdiox"
	materials = list(DEFAULT_WALL_MATERIAL = 15, "duridium" = 5, "kemocite" = 5)
	build_path = /obj/item/weapon/grenade/toxic_gas/sulfur_dioxide
	components = list("sulfur dioxide gas packet" = /obj/item/gas_packet/sulfurdioxide)

/datum/craft_blueprint/brute_weapon/landmine
	name = "explosive landmine"
	id = "landmine_expl"
	materials = list(DEFAULT_WALL_MATERIAL = 10, "kemocite" = 20)
	build_path = /obj/item/device/landmine
	components = list("carbon dioxide gas packet" = /obj/item/gas_packet/carbondioxide)
