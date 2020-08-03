
/obj/machinery/slipspace_engine/process()
	if(current_charge_ticks)
		if(powered())
			if(current_charge_ticks < target_charge_ticks)
				current_charge_ticks++
				if(current_charge_ticks == target_charge_ticks)
					charge_ready()
		else
			stop_charging()
	/*
	if(jump_charging == 2)
		var/obj/effect/overmap/ship/om_ship = om_obj
		if(istype(om_ship))
			om_ship.speed = list(0,0)
	if(jump_charging == (1 || 2))
		var/area/area_contained = loc.loc
		if(!istype(area_contained))
			return
		var/datum/powernet/area_powernet = area_contained.apc.terminal.powernet
		if(isnull(area_powernet))
			return
		if(area_powernet.avail-area_powernet.load < SLIPSPACE_ENGINE_POWER_LOAD)
			set_next_jump_allowed(jump_cooldown)//Reset the cooldown if we can't pull enough power.
			return
		area_powernet.draw_power(SLIPSPACE_ENGINE_POWER_LOAD)
	if(world.time > next_jump_at && jump_charging != -1)
		jump_charging = 0
		*/
