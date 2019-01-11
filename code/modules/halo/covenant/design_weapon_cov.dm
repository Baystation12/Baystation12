
/datum/craft_blueprint/cov_weapon/plasmapistol
	name = "plasma pistol"
	id = "cov_plasmapistol"
	materials = list("plasteel" = 30, "phglass" = 10)
	build_path = /obj/item/weapon/gun/energy/plasmapistol
	components = list("plasma clocker" = /obj/item/plasma_clocker, "noble gas packet" = /obj/item/gas_packet/noble, "covenant power cell" = /obj/item/weapon/cell/covenant)

/datum/craft_blueprint/cov_weapon/plasmarifle
	name = "plasma rifle"
	id = "cov_plasmarifle"
	materials = list("plasteel" = 60, "phglass" = 10, "osmium-carbide plasteel" = 10)
	build_path = /obj/item/weapon/gun/energy/plasmarifle
	components = list("plasma oscillator" = /obj/item/plasma_oscillator, "noble gas packet" = /obj/item/gas_packet/noble, "covenant power cell" = /obj/item/weapon/cell/covenant)

/datum/craft_blueprint/cov_weapon/bruteplasmarifle
	name = "overcharged plasma rifle"
	id = "cov_plasmarifle_brute"
	materials = list("plasteel" = 60, "phglass" = 10, "osmium-carbide plasteel" = 10)
	build_path = /obj/item/weapon/gun/energy/plasmarifle/brute
	components = list("plasma oscillator" = /obj/item/plasma_oscillator, "plasma clocker" = /obj/item/plasma_clocker, "noble gas packet" = /obj/item/gas_packet/noble, "covenant power cell" = /obj/item/weapon/cell/covenant)

/datum/craft_blueprint/cov_weapon/plasmagrenade
	name = "plasma grenade"
	id = "cov_plasmagrenade"
	materials = list("plasteel" = 10, "phglass" = 10, "kemocite" = 5)
	build_path = /obj/item/weapon/grenade/plasma
	components = list("plasma core" = /obj/item/plasma_core, "plasma clocker" = /obj/item/plasma_clocker, "covenant power cell" = /obj/item/weapon/cell/covenant)

/datum/craft_blueprint/cov_weapon/edagger
	name = "energy dagger"
	id = "cov_edagger"
	materials = list("plasteel" = 10, "phglass" = 10)
	build_path = /obj/item/weapon/melee/energy/elite_sword/dagger
	components = list("crystal matrix" = /obj/item/crystal_matrix, "covenant power cell" = /obj/item/weapon/cell/covenant)

/datum/craft_blueprint/cov_weapon/plasma_carbine
	name = "plasma carbine"
	id = "cov_plascarbine"
	materials = list("plasteel" = 75, "phglass" = 20, "duridium" = 5)
	build_path = /obj/item/weapon/gun/projectile/type51carbine
	components = list("plasma modulator" = /obj/item/plasma_modulator, "crystal matrix" = /obj/item/crystal_matrix, "covenant power cell" = /obj/item/weapon/cell/covenant)

/datum/craft_blueprint/cov_weapon/beam_rifle
	name = "plasma carbine"
	id = "cov_beamrifle"
	materials = list("plasteel" = 100, "phglass" = 20, "nanolaminate" = 10)
	build_path = /obj/item/weapon/gun/energy/beam_rifle
	components = list("plasma modulator" = /obj/item/plasma_modulator, "plasma focus" = /obj/item/plasma_focus, "covenant power cell" = /obj/item/weapon/cell/covenant)
