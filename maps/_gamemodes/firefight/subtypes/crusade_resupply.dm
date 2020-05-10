
/datum/game_mode/firefight/crusade
	resupply_procs = list(/datum/game_mode/firefight/crusade/spawn_resupply)

	supply_crate_procs = list(\
		/datum/game_mode/firefight/crusade/proc/cov_wep_crate = 4,\
		/datum/game_mode/firefight/crusade/proc/brute_wep_crate = 3,\
		/datum/game_mode/firefight/crusade/proc/energy_barricades_crate = 3,\
		/datum/game_mode/firefight/crusade/proc/cov_marksman_crate = 2,\
		/datum/game_mode/firefight/crusade/proc/cov_weapon_rack = 1,\
		/datum/game_mode/firefight/crusade/proc/fuel_rod_crate = 1,\
		)

/datum/game_mode/firefight/crusade/spawn_resupply(var/turf/epicentre)
	..()

	. = "Munitions have been deposited to the %DIRTEXT%. \
		[pick("Kill some humans for me!","Slay these vermin with them.")]"

/datum/game_mode/firefight/crusade/proc/cov_wep_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/covenant/C = new(spawn_turf)
	C.name = "Covenant weapons crate"

	var/list/random_weapons = list(\
		/obj/item/weapon/gun/energy/plasmarifle,\
		/obj/item/weapon/gun/energy/plasmapistol,\
		/obj/item/weapon/gun/energy/plasmarepeater,\
		/obj/item/weapon/gun/projectile/needler,\
		/obj/item/ammo_magazine/needles,\
		/obj/item/weapon/grenade/plasma,\
		/obj/item/weapon/melee/energy/elite_sword/dagger,\
		/obj/item/weapon/melee/blamite/cutlass,\
		/obj/item/weapon/melee/blamite/dagger,\
		)

	for(var/i=0,i<5,i++)
		var/picked_weapon = pick(random_weapons)
		new picked_weapon(C)

/datum/game_mode/firefight/crusade/proc/cov_marksman_crate(var/turf/spawn_turf)
	var/obj/structure/closet/covenant/C = new(spawn_turf)
	C.name = "Covenant marksman crate"

	var/list/random_weapons = list(\
		/obj/item/weapon/gun/energy/beam_rifle,\
		/obj/item/weapon/gun/projectile/type51carbine,\
		/obj/item/ammo_magazine/type51mag,\
		/obj/item/weapon/gun/projectile/type31needlerifle,\
		/obj/item/ammo_magazine/rifleneedlepack\
		)

	for(var/i=0,i<3,i++)
		var/picked_weapon = pick(random_weapons)
		new picked_weapon(C)

/datum/game_mode/firefight/crusade/proc/brute_wep_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/covenant/C = new(spawn_turf)
	C.name = "Jiralhanae weapons crate"

	var/list/random_weapons = list(\
		/obj/item/weapon/grenade/frag/spike,\
		/obj/item/weapon/gun/projectile/spiker,\
		/obj/item/ammo_magazine/spiker,\
		/obj/item/weapon/gun/projectile/mauler,\
		/obj/item/ammo_magazine/mauler,\
		/obj/item/weapon/gun/energy/plasmarifle/brute
		)

	for(var/i=0,i<5,i++)
		var/picked_weapon = pick(random_weapons)
		new picked_weapon(C)

/datum/game_mode/firefight/crusade/proc/cov_weapon_rack(var/turf/spawn_turf)
	new /obj/structure/weapon_rack(spawn_turf)

/datum/game_mode/firefight/crusade/proc/fuel_rod_crate(var/turf/spawn_turf)
	var/obj/structure/closet/covenant/C = new(spawn_turf)
	C.name = "Fuel Road crate"

	new /obj/item/weapon/gun/projectile/fuel_rod_launcher(C)

/datum/game_mode/firefight/crusade/proc/energy_barricades_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/covenant/C = new(spawn_turf)
	C.name = "Energy barricades crate"

	for(var/i=0,i<3,i++)
		new /obj/item/energybarricade(C)
