/obj/machinery/space_battle/computer/targeting/missile
	name = "missile targeting computer"
	var/obj/machinery/space_battle/tube/tube

/obj/machinery/space_battle/computer/targeting/missile/Destroy()
	if(tube)
		tube.computer = null
		tube = null
	return ..()

/obj/machinery/space_battle/computer/targeting/missile/rename()
	..()
	if(tube)
		tube.rename()

/obj/machinery/space_battle/computer/targeting/missile/reconnect()
	if(!tube)
		for(var/obj/machinery/space_battle/tube/T in world)
			if(T.id_tag == id_tag && T.z == src.z)
				tube = T
				T.computer = src
				break
	..()

/obj/machinery/space_battle/computer/targeting/missile/check_fire(var/mob/user)
	if(!tube)
		user << "<span class='warning'>No launch tubes connected!</span>"
		return 0
	else
		var/obj/loaded = locate(/obj/machinery/missile) in get_turf(tube)
		if(loaded)
			user << "<span class='notice'>Loaded: [loaded]"
		else
			loaded = locate(/obj/item) in get_turf(tube)
			if(loaded)
				user << "<span class='notice'>Loaded: [loaded]"
			else
				user << "<span class='warning'>Nothing is loaded!</span>"
		var/can_guide = sensor.has_guidance()
		if(can_guide != 1)
			user << "<span class='danger'>CAUTION: Missile guidance offline! Fire pattern unpredictable: [can_guide]</span>"
	return 1


/obj/machinery/space_battle/computer/targeting/missile/fire_at(var/atom/A, params, var/mob/missile_eye/user)
	if(tube)
		var/turf/T = A
		var/efficiency = tube.get_efficiency(-1,1)
		var/guidance_efficiency = sensor.guidance ? sensor.guidance.get_efficiency(-1,1) : 2
		var/obj/machinery/missile/loaded = locate() in get_turf(tube)
		var/wait_time = MISSILE_COOLDOWN
		var/processed = 0
		if(firing_angle == "Underhand")
			processed = 1
			if(!user.guidance)
				user << "<span class='warning'>Guidance is not functioning and is needed for Underhand shots!</span>"
				return
			var/area/ship_battle/area = get_area(user.start_loc)
			var/list/available_areas = list()
			if(!area || !istype(area)) return
			for(var/area/ar in world)
				if(istype(ar, /area/ship_battle/))
					var/area/ship_battle/S = ar
					if(S.z == user.start_loc.z && S.team == area.team)
						available_areas += ar.name
						available_areas[ar.name] = ar

			if(available_areas.len)
				var/choice = input(user, "Where would you like to aim?", "Underhand") in available_areas
				var/area/ship_battle/chosen = available_areas[choice]
				if(prob(50*guidance_efficiency))
					chosen = pick(available_areas)
				else
					var/obj/machinery/space_battle/ecm/ecm = locate() in chosen
					if(ecm && istype(ecm) && ecm.can_block(1))
						chosen = pick(available_areas)
				if(chosen)
					var/turf/newloc = pick_area_turf(chosen)
					if(!newloc)
						newloc = pick_area_turf(chosen)
						if(!newloc)
							user << "<span class='warning'>You are unable to aim there!</span>"
							return
					if(newloc)
						if(!(prob(50*guidance_efficiency)))
							user.start_loc = newloc
							var/R
							R = tube.fire_missile(user.start_loc, user.start_loc) // Dont move, just go boom.
							if(istext(R))
								user << "<span class='warning'>[R]</span>"
								return
							else
								user << "<span class='notice'>Missile launch successful!</span>"
						wait_time *= 10*efficiency // Eyup
				else
					user << "<span class='warning'>Invalid choice!</span>"
					user.firing = 0
					return
			else
				user << "<span class='warning'>No available targets!</span>"
				user.firing = 0
				return
		var/choice
		if(!processed)
			choice = alert(user, "Are you sure you wish to launch a missile at [T]?", "Missile", "Yes", "No")
		if(choice == "Yes" && !processed)
			var/miss_message = ""
			var/ECM = 0
			var/obj/machinery/space_battle/ecm/E = locate(/obj/machinery/space_battle/ecm) in range(MAX_ECM_RANGE, T)
			if(E && E.can_block(get_dist(T, E)) && E.strength >= user.eccm)
				ECM = 1
			var/miss_chance = (user.advguidance ? 10*max(sensor.advguidance.get_efficiency(-1,1), guidance_efficiency) : 25*guidance_efficiency)
			if(ECM || firing_angle == "Flanking" || (!user.guidance||prob(miss_chance)) && firing_angle != "Carefully Aimed") // Random firing.
				var/turf/newloc = pick_area_turf(get_area(user.start_loc), list(/proc/is_space, /proc/not_turf_contains_dense_objects))
				if(newloc) user.start_loc = newloc
				wait_time *= 1.5*efficiency
				if(!user.guidance)
					wait_time *= 1.5*efficiency
				if(ECM)
					miss_message = "<span class='danger'>Missile guidance failed to designate control target. Firing pattern uncontrolled.</span>"
				else if(firing_angle != "Flanking")
					miss_message = "<span class='warning'>Missile was unable to reach the correct destination: Missed!</span>"
			var/result
			var/turf/newloc = get_turf(user.start_loc)
			if((firing_angle == "Frontal Assault" || firing_angle == "Carefully Aimed" || firing_angle == "Rapid Fire") && (x_offset || y_offset))
				var/xo = x_offset
				var/yo = y_offset
				while(xo != 0)
					if(xo < 0)
						newloc = get_turf(get_step(newloc, 	WEST))
						xo++
					else
						newloc = get_turf(get_step(newloc, EAST))
						xo--
				while(yo != 0)
					if(yo < 0)
						newloc = get_turf(get_step(newloc, SOUTH))
						yo++
					else
						newloc = get_turf(get_step(newloc, NORTH))
						yo--
			result = tube.fire_missile(T, newloc)
			if(istext(result))
				user << "<span class='warning'>[result]</span>"
				user.firing = 0
				return
			else
				user << miss_message
				user << "<span class='notice'>Missile launch successful!</span>"
				if(usr.client)
					usr.client.missiles_fired += 1
				for(var/mob/living/mob in world)
					if(mob.z == src.z && !istype(get_turf(mob), /turf/space))
						shake_camera(mob, 5, 5)
						mob << "<span class='warning'>The deck of the ship shakes violently!</span>"
						if(prob(2))
							mob.Weaken(10)
							if(prob(75))
								mob << "<span class='warning'>You fall over as the deck shakes!</span>"
							else
								mob << "<span class='warning'>You fall over as the deck shakes and hit your head hard!</span>"
								mob.emote("scream")
								mob.Paralyse(15)
			if(firing_angle == "Carefully Aimed")
				wait_time *= 1.5*efficiency
			if(firing_angle == "Rapid Fire")
				wait_time *= 0.5*efficiency
			processed = 1

		else
			user.firing = 0

		if(processed)
			var/radar = 0
			var/list/radars = sensor.has_radars()
			for(var/obj/machinery/space_battle/missile_sensor/radar/M in radars)
				if(M.can_sense())
					radar += M.get_efficiency(1,1,1)
				else
					user << "<span class='danger'>NOTICE: [M.name] inactive: [M.can_sense()]!</span>"
			radar = max(1, radar)
			wait_time += user.wait
			switch(tube.dir)
				if(8)
					wait_time *= 1.75*efficiency
				if(1 to 2)
					wait_time *= 1.25*efficiency
			wait_time = max(50, wait_time / radar)
			if(loaded && istype(loaded))
				wait_time += loaded.delay_time
			wait_time = cooldown(wait_time)
			user << "<span class='notice'>Sensors are now calibrating. Please wait [(wait_time / 10)] seconds.</span>"
			user.firing = 0
	else
		user << "<span class='warning'>No tube detected!</span>"
