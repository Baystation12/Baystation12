
/datum/game_mode/firefight/crusade
	resupply_procs = list(/datum/game_mode/firefight/crusade/spawn_resupply)

	supply_obj_types = list(\
		/obj/structure/closet/crate/random/covenant/weapons,\
		/obj/structure/closet/crate/random/covenant/marksman,\
		/obj/structure/closet/crate/random/covenant/weapons_brute,\
		/obj/structure/closet/crate/random/covenant/fuel_rod,\
		/obj/structure/closet/crate/random/covenant/food,\
		/obj/structure/closet/crate/random/covenant/medical,\
		/obj/structure/closet/crate/random/covenant/energy_barricades,\
		/obj/structure/closet/crate/random/covenant/construction,\
		/obj/structure/bed/roller/covenant,\
		/obj/machinery/autosurgeon/covenant,\
		/obj/structure/weapon_rack,\
		/obj/structure/repair_bench/cov,\
		/obj/machinery/floodlight/covenant)

	many_players_bonus = list(/obj/structure/closet/crate/random/covenant/weapons)

	flare_type = /obj/item/device/flashlight/glowstick/covenant

	supply_always_spawn = list()

/datum/game_mode/firefight/crusade/spawn_resupply(var/turf/epicentre)
	..()

	. = "Munitions have been deposited to the %DIRTEXT%. \
		[pick("Kill some humans for me!","Slay these vermin with them.")]"
