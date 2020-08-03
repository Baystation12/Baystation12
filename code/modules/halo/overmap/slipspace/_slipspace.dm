
/obj/machinery/slipspace_engine
	name = "Slipspace Engine"
	desc = "An advanced machine capable of generating a safe bubble around the ship before entry into slipspace."
	icon = 'code/modules/halo/overmap/slipspace/slipspace_drive_human.dmi'
	icon_state = "slipspace"
	anchored = 1
	density = 1
	bound_width = 64
	bound_height = 64
	ai_access_level = 4
	idle_power_usage = 50
	active_power_usage = SLIPSPACE_ENGINE_POWER_LOAD

	var/datum/sound_token/ambient_sound
	var/stop_charging_sound = 'code/modules/halo/sounds/effects/sparks_shutdown.ogg'
	var/charging_sound = 'code/modules/halo/sounds/effects/ufo_engine_charging.ogg'
	var/charging_sound_id = "alien_chargeup"
	var/running_sound = 'code/modules/halo/sounds/effects/ufo_engine_running.ogg'
	var/running_sound_id = "alien_charged"
	var/current_charge_ticks = 0
	var/target_charge_ticks = 0
	var/emergency_charge_ticks = 2
	var/precision_charge_ticks = 6
	var/long_charge_ticks = 24
	var/jump_type = 0
	var/core_to_spawn = null //The /obj/payload/ subtype to spawn when the engine is overloaded. null = disabled.
	var/core_removed = FALSE
	var/next_jump_at = null
	var/turf/overmap_jump_target
	var/obj/effect/overmap/om_obj
	var/jump_cooldown = SLIPSPACE_ENGINE_JUMP_COOLDOWN
	var/jump_sound = 'code/modules/halo/sounds/effects/slipspace_jump.ogg'
	var/precise_jump = FALSE

	var/slipspace_carryalong_range = 2
	var/list/linked_ships = list()

	var/slipspace_target_status = 1		//1 = nullspace and back to realspace, 2 = nullspace permanently to despawn the ship ("leave the system")
/*
/obj/machinery/slipspace_engine/Initialize()
	. = ..()
	om_obj = map_sectors["[z]"]
	*/

/obj/machinery/slipspace_engine/proc/get_linked_ships()
	. = list()
	var/obj/effect/overmap/ship/om_ship = om_obj
	if(istype(om_ship) && om_ship.our_fleet && om_ship.our_fleet.ships_infleet.len > 1)
		for(var/obj/s in om_ship.our_fleet.ships_infleet)
			. += s
	for(var/obj/effect/overmap/ship/s in range(slipspace_carryalong_range,om_obj.loc)) //No check for null-loc because this should never be called when the ship is in slipspace.
		if(s.anchored)
			continue
		. += s

/obj/machinery/slipspace_engine/proc/check_jump_allowed(var/turf/location, var/mob/user)
	for(var/obj/effect/overmap/om in range(SLIPSPACE_GRAV_WELL_RANGE,location))
		if(om.block_slipspace)
			to_chat(user,"<span class = 'notice'>A nearby gravity well is disrupting [src]'s automated calculation algorithms. \
				Move further away from nearby planets and large objects.</span>")
			return FALSE
	return TRUE
