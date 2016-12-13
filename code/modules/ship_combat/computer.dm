#define MISSILE_COOLDOWN 600
#define MAX_ECM_RANGE 12

/obj/machinery/space_battle/computer
	var/overlay_layer
	var/screen_icon
	icon_state = "computer"

/obj/machinery/space_battle/computer/New()
	overlay_layer = layer
	..()

/obj/machinery/space_battle/computer/proc/update_screen()
	overlays.Cut()
	if(!stat & (BROKEN|NOPOWER))
		overlays += image(icon,screen_icon, overlay_layer)
	else if(stat & BROKEN)
		overlays += image(icon,"computer_broken", overlay_layer)

/obj/machinery/space_battle/computer/update_icon()
	update_screen()

/obj/machinery/space_battle/computer/missile
	name = "fire control computer"
	desc = "A fire control computer."

	screen_icon = "fire_control"
	density = 1
	anchored = 1

	idle_power_usage = 600
	use_power = 1

	var/obj/machinery/space_battle/tube/tube
	var/obj/machinery/space_battle/missile_sensor/hub/sensor

	var/obj/machinery/space_battle/deck_gun/gun

	var/mob/missile_eye/eye
	var/mob/living/carbon/human/eye_owner
	var/mob/living/carbon/human/forced_by

	var/list/starts = list()
	var/index = 1
	var/list/firing_angles = list("Frontal Assault", "Flanking", "Carefully Aimed", "Underhand", "Rapid Fire")
	var/firing_angle = "Frontal Assault"
	var/cooldown = 0 // Cooldown for the missiles

	var/y_offset = 0
	var/x_offset = 0

	Destroy()
		if(eye)
			eye.return_to_owner()
			eye = null
		eye_owner = null
		forced_by = null
		gun = null
		sensor = null
		tube = null
		processing_objects.Remove(src)
		return ..()

	hear_talk(mob/M as mob, text)
		if(eye)
			eye << "<span class='notice'>You hear something about...\"[text]\""
		..()

	show_message(msg, type, alt, alt_type)
		if(eye)
			eye.show_message(msg, type, alt, alt_type)
		return ..()

	proc/cooldown(var/time)
		if(circuit_board)
			time *= get_efficiency(-1, 1)
		else
			time *= 2.5
		cooldown = world.timeofday + time
		update_icon()
		return round(time)

	proc/time_remaining()
		var/time = (cooldown - world.timeofday)/10
		if(time < 0)
			time = 0
		return round(time)

	rename()
		if(!linked) return 0
		var/team = 0
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team
		var/num = 0
		for(var/S in linked.fire_controls)
			var/obj/machinery/space_battle/computer/missile/C = S
			if(C.z == src.z)
				num++
				if(C == src)
					break
		id_num = "[team]-#[num]"
		name = "[initial(name)]([id_num])"
		if(tube)
			tube.rename()
		if(sensor)
			sensor.rename(id_num)

	initialize()
		linked = map_sectors["[z]"]
		if (linked && istype(linked, /obj/effect/overmap/ship))
			var/obj/effect/overmap/ship/ship = linked
			if (!(src in ship.fire_controls))
				ship.fire_controls.Add(src)
		processing_objects.Add(src)
		..()

	proc/find_targets()
		starts.Cut()
		if(!linked)
			return "Incompatible Ship!"
		if(istype(linked, /obj/effect/overmap/ship))
			var/obj/effect/overmap/ship/S = linked
			if(!S.is_still())
				return "Ship is moving!"
		var/list/targettable_z_levels = get_firing_targets()
		if(!targettable_z_levels || !targettable_z_levels.len)
			return "Nothing in range!"
		var/area/ship_battle/us = get_area(src)
		if(!istype(us)) return "Fatal error!"
		for(var/obj/effect/overmap/S in targettable_z_levels)
			if(S.fake_ship)
				starts += S.fake_ship
			else if(S.team != src.team)
				for(var/A in missile_starts)
					var/obj/missile_start/M = A
					if(M.z in S.map_z)
						starts += M
		if(!starts)
			return "Unknown Error: Ships Inexistant"
		else
			return "Unknown Error: Process failure"

	proc/get_firing_targets()
		return sensor ? sensor.get_firing_targets() : 0


	reconnect()
		if(!linked)
			linked = map_sectors["[z]"]
		for(var/obj/machinery/space_battle/tube/T in world)
			if(T.id_tag == id_tag && T.z == src.z)
				tube = T
				T.computer = src
				break
		for(var/M in linked.fire_sensors)
			var/obj/machinery/space_battle/missile_sensor/hub/S = M
			if(S && istype(S) && S.id_tag == id_tag)
				sensor = S
				S.computer = src
				break
		if(!tube)
			for(var/obj/machinery/space_battle/deck_gun/G in world)
				if(G.id_tag == src.id_tag)
					gun = G
					break
		rename()
		return


	attack_hand(var/mob/user, var/forced = 0)
		var/additional_time = 0
		if(eye || eye_owner)
			user << "<span class='warning'>\The [src] is already being used!</span>"
		if(forced)
			additional_time = 500
			forced_by = user
		if(stat & (BROKEN|NOPOWER) && !forced)
			user << "<span class='warning'>\The [src] is not responding!</span>"
			return
		var/find_targets = src.find_targets()
		if(!starts.len)
			user << "<span class='warning'>Scan incomplete: [find_targets]</span>"
		else
			user << "<span class='notice'>Scan Complete...[starts.len] targets found!</span>"
		if(!starts.len) return 0
		if(!sensor)
			for(var/obj/machinery/space_battle/missile_sensor/hub/S in world)
				if(S.id_tag == id_tag)
					sensor = S
					break
			if(!sensor)
				user << "<span class='warning'>There are no connected sensors!</span>"
				return
		if(!tube)
			for(var/obj/machinery/space_battle/tube/T in world)
				if(T.id_tag == src.id_tag)
					tube = T
					break
		else if(!gun)
			for(var/obj/machinery/space_battle/deck_gun/D in world)
				if(D.id_tag == src.id_tag)
					gun = D
					break
		if(!tube && !gun)
			user << "<span class='warning'>There is no weapon connected to this device!</span>"
			return
		var/list/choices = list()
		for(var/obj/S in starts)
			choices.Add(list("[S.name]" = S))
		var/choice = input(user, "Which ship would you like to view?", "Targetting") in choices
		var/obj/missile_start/start = choices[choice]
		if(!start || !istype(start))
			if(istype(start, /datum/fake_ship))
				var/datum/fake_ship/fake_ship = start
				var/obj/machinery/missile/loaded = locate() in get_turf(tube)
				if(loaded && istype(loaded))
					fake_ship.damaged(loaded.damage)
					var/list/R = sensor.has_radars()
					var/radar = 0
					for(var/obj/machinery/space_battle/missile_sensor/radar/M in R)
						if(M.can_sense())
							radar += M.get_efficiency(1,1,1)
						else
							user << "<span class='danger'>NOTICE: [M.name] inactive: [M.can_sense()]!</span>"
					radar = max(1, radar)
					var/wait_time = MISSILE_COOLDOWN
					switch(tube.dir)
						if(8)
							wait_time *= 1.75
						if(1 to 2)
							wait_time *= 1.25
					wait_time = max(50, wait_time / radar)
					if(loaded && istype(loaded))
						wait_time += loaded.delay_time
					wait_time = cooldown(wait_time)
					user << "<span class='notice'>Sensors are now calibrating. Please wait [(wait_time / 10)] seconds.</span>"
					qdel(loaded)
					return
			user << "<span class='warning'>Invalid sensor target!</span>"
			return

		var/mob/missile_eye/M = new()


		var/can_guide = sensor.has_guidance()
		if(tube)
			if(can_guide == 1)
				M.guidance = 1
			else
				user << "<span class='danger'>CAUTION: Missile guidance offline! Fire pattern unpredictable: [can_guide]</span>"
		var/advguidance = sensor.has_advguidance()
		if(sensor.advguidance)
			if(advguidance == 1)
				M.advguidance = 1
			else
				user << "<span class='danger'>NOTICE: Advanced missile guidance offline! Advanced targetting disabled: [can_guide]</span>"
		var/can_track = sensor.has_tracking()
		if(can_track == 1)
			M.tracking = 1
		else
			user << "<span class='danger'>WARNING: Unable to track ship. Only frontal view available: [can_track]</span>"
			if(sensor.tracking && sensor.tracking.stat & NOPOWER)
				M.tracking = 2
		var/can_scan = sensor.has_scanning()
		if(sensor.scanning)
			if(can_scan == 1)
				M.sight |= SEE_TURFS
				M.see_in_dark = 7*sensor.scanning.get_efficiency(1,1)
				user << "<font color='#00FF00'>Advanced scanning unit online. Advanced visuals enabled.</font>"
			else
				user << "<span class='danger'>CAUTION: Advanced radar offline. Visuals unoptimised: [can_scan]</span>"
		var/has_thermal = sensor.has_thermal()
		if(sensor.thermal)
			if(has_thermal)
				M.sight |= SEE_MOBS
				user << "<font color='#00FF00'>Infrared scanning unit online. Infrared visuals enabled</font>"
			else
				user << "<span class='danger'>CAUTION: Infrared scanning unit offline. Visuals unoptimised: [has_thermal]</span>"
		var/has_microwave = sensor.has_microwave()
		if(sensor.microwave)
			if(has_microwave)
				M.sight |= SEE_OBJS
				user << "<font color='#00FF00'>Microwave sensing unit online. Echolocation available.</font>"
			else
				user << "<span class='danger'>CAUTION: Microwave scanning unit offline. Visuals unoptimised: [has_microwave]</span>"
		var/has_xray = sensor.has_xray()
		if(sensor.xray)
			if(has_xray)
				user << "<font color='#00FF00'>X-ray vision enabled. Internal view loaded.</font>"
				M.xray = 1
			else
				user << "<span class='danger'>CAUTION: X-ray module offline. Internal view unavailable: [has_microwave]</span>"

		var/has_eccm = sensor.has_eccm()
		if(sensor.eccm)
			if(isnum(has_eccm) && has_eccm > 1)
				user << "<font color='#00FF00'>ECCM operational at a strength of [has_eccm].</font>"
				M.eccm = has_eccm
			else
				user << "<span class='danger'>NOTICE: ECCM nonfunctional: [has_eccm]</span>"

		if(cooldown >= world.timeofday)
			user << "<span class='warning'>Sensors are recalibrating! [time_remaining()] seconds left!</span>"

		if(tube)
			var/obj/loaded = locate(/obj/machinery/missile) in get_turf(tube)
			if(loaded)
				user << "<span class='notice'>Loaded: [loaded]"
			else
				loaded = locate(/obj/item) in get_turf(tube)
				if(loaded && loaded != tube)
					user << "<span class='notice'>Loaded: [loaded]"
				else
					user << "<span class='warning'>Nothing is loaded!</span>"

		M.key = user.key
		if(!user.key)
			user.key = "@sb[user.key]"
		user.teleop = M

		var/turf/start_loc = get_turf(start)
		var/xo = x_offset
		var/yo = y_offset
		while(xo != 0)
			if(xo < 0)
				start_loc = get_step(start_loc, WEST)
				xo++
			else
				start_loc = get_step(start_loc, EAST)
				xo--
		while(yo != 0)
			if(yo < 0)
				start_loc = get_step(start_loc, SOUTH)
				yo++
			else
				start_loc = get_step(start_loc, NORTH)
				yo--

		M.loc = get_turf(start_loc)

//		user.reset_view(M)
//		M.key = user.ckey
//		user.key = "@sb[user.name]"
//		user.teleop = M
		M.owner = user
		M.linked = src
		M.start_loc = start
		M.wait = additional_time
		process()
		eye = M
		eye_owner = user
		spawn(25)
			eye << "<span class='notice'><b>Targetting Mode engaged. Selected Ship is left of Reticule.</b></span>"

/obj/machinery/space_battle/computer/missile/process()
	if(eye && !(forced_by && forced_by == eye_owner))
		if(eye_owner && (!forced_by || forced_by != eye_owner))
			if(get_dist(eye_owner, src) < 2)
				if(!eye_owner.lying)
					if(!eye_owner.restrained())
						if(!(stat & (NOPOWER|BROKEN)))
							return
						else
							eye << "<span class='warning'>The computer tops responding suddenly!</span>"
					else
						eye << "<span class='warning'>You're restrained!</span>"

				else
					eye << "<span class='warning'>You are not longer able to operate \the [src]</span>"
			else
				eye << "<span class='warning'>You are not adjacent to \the [src]!</span>"
		eye.return_to_owner()
	return ..()

/mob/missile_eye
	name = "Eye"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	alpha = 127
	density = 0
	simulated = 0
	see_in_dark = 2
	status_flags = GODMODE
	invisibility = INVISIBILITY_EYE
	layer = FLY_LAYER

	var/obj/start_loc
	var/mob/owner = null
	var/obj/machinery/space_battle/computer/missile/linked

	var/guidance = 0
	var/advguidance = 0
	var/tracking = 0
	var/xray = 0
	var/mode = 0
	var/eccm = 0

	var/wait = 0
	var/firing = 0

	var/list/allowed_turfs = list(/turf/space, /turf/simulated/floor/airless, /turf/simulated/floor/plating)

	Destroy()
		owner = null
		linked = null
		return ..()

	Move(var/turf/T, dir = 1)
		if(!linked) return ..()
		var/tracking_efficiency = (linked.sensor.tracking ? linked.sensor.tracking.get_efficiency(-1,1) : 0)
		if(prob(1*tracking_efficiency))
			Stagger(src, dir)
			return 0
		if(xray && tracking == 1)
			src.forceMove(T)
			return 1
		if(not_turf_contains_dense_objects(T))
			if(tracking == 1)
				return ..()
			else if(tracking == 2)
				if(prob(80))
					Stagger(src, dir)
				else
					return ..()
		return 0

	Allow_Spacemove()
		if(tracking)
			return 1
		return 0

	touch_map_edge()
		return 0

	New()
		..()
		zone_sel = new(src) // Haxxx
		zone_sel.selecting = "chest"

	say(var/message)
		usr << "<span class='notice'>\The [linked] beeps, \"[message]\"</span>"
		linked.visible_message("<span class='notice'>\The [linked] beeps, \"[message]\"</span>")
		..()

/mob/missile_eye/verb/return_to_owner()
	set name = "Return To Body"
	set desc = "Return to your own body"
	set category = "Fire Control"

	if(owner)
		owner.ckey = null
		owner.ckey = src.ckey
		src.ckey = null
		owner.teleop = null
		owner = null
		linked.eye = null
		linked.eye_owner = null
		spawn(5)
			qdel(src)

/mob/missile_eye/verb/change_firing_mode()
	set name = "Switch Fire Angle"
	set desc = "Switch how your guns fire."
	set category = "Fire Control"

	var/index = linked.firing_angles.Find(linked.firing_angle)
	if(index >= linked.firing_angles.len) index = 1
	else index += 1
	linked.firing_angle = linked.firing_angles[index]
	usr << "<span class='notice'>You are now firing [linked.firing_angle] shots!</span>"

/mob/missile_eye/verb/set_offset()
	set name = "Targetting Offset"
	set desc = "Switch how your guns fire."
	set category = "Fire Control"

	if(linked && linked.tube)
		if(linked.cooldown > world.timeofday)
			usr << "<span class='warning'>The sensors are recalibrating! Please wait another [linked.time_remaining()] seocnds!</span>"
			return
		if(!advguidance)
			var/inp = input(usr, "You have no advanced guidance, this will take a significant amount of time. Are you sure?", "Offset") in list("Yes", "Cancel")
			if(inp == "Cancel") return
		var/xo = input("Enter offset(-3 to 3)", "X") as num
		if(xo > 3 || xo < -3)
			usr << "<span class='warning'>That is not a valid range!</span>"
			return
		var/yo = input("Enter offset(-12 to 12)", "Y") as num
		if(yo > 12 || yo < -12)
			usr << "<span class='warning'>That is not a valid range!</span>"
			return
		if(xo || yo)
			var/cd = 0
			if(advguidance)
				cd = 500 * linked.sensor.advguidance.get_efficiency(-1, 1)
			else
				cd = 2000
			cd = linked.cooldown(cd)
			src << "<span class='notice'>The sensors are now recalibrating! [linked.time_remaining()] seconds remaining.</span>"
			linked.y_offset = yo
			linked.x_offset = xo


/mob/missile_eye/DblClickOn(var/atom/A, params)
	if(firing) return
	firing = 1
	if(linked.tube)
		var/turf/T = A
		var/efficiency = linked.tube.get_efficiency(-1,1)
		var/guidance_efficiency = linked.sensor.guidance ? linked.sensor.guidance.get_efficiency(-1,1) : 2
		if(linked.cooldown > world.timeofday)
			usr << "<span class='warning'>The sensors are recalibrating! [linked.time_remaining()] seconds left!</span>"
			firing = 0
			return
		var/obj/machinery/missile/loaded = locate() in get_turf(linked.tube)
		var/wait_time = MISSILE_COOLDOWN
		var/processed = 0
		var/obj/effect/overmap/them = map_sectors["[T.z]"]
		var/obj/effect/overmap/us = map_sectors["[linked.z]"]
		var/missile_range = 1
		if(loaded)
			missile_range = min(1, round(loaded.range * efficiency * guidance_efficiency, 1))
		if((!them || !us) || get_dist(them, us) > missile_range)
			src << "<span class='warning'>\The [them] is out of missile firing range! (Your range is currently [missile_range])</span>"
			return 0
		if(linked.firing_angle == "Underhand")
			processed = 1
			if(!guidance)
				usr << "<span class='warning'>Guidance is disabled!</span>"
				return
			var/area/ship_battle/area = get_area(start_loc)
			var/list/available_areas = list()
			if(!area || !istype(area)) return
			for(var/area/ar in world)
				if(istype(ar, /area/ship_battle/))
					var/area/ship_battle/S = ar
					if(S.z == start_loc.z && S.team == area.team)
						available_areas += ar.name
						available_areas[ar.name] = ar

			if(available_areas.len)
				var/choice = input(usr, "Where would you like to aim?", "Underhand") in available_areas
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
							usr << "<span class='warning'>You are unable to aim there!</span>"
							return
					if(newloc)
						if(!(prob(50*guidance_efficiency)))
							start_loc = newloc
							var/R
							R = linked.tube.fire_missile(start_loc, start_loc) // Dont move, just go boom.
							if(istext(R))
								usr << "<span class='warning'>[R]</span>"
								return
							else
								usr << "<span class='notice'>Missile launch successful!</span>"
						wait_time *= 10*efficiency // Eyup
				else
					usr << "<span class='warning'>Invalid choice!</span>"
					firing = 0
					return
			else
				usr << "<span class='warning'>No available targets!</span>"
				firing = 0
				return
		var/choice
		if(!processed)
			choice = alert("Are you sure you wish to launch a missile at [T]?", "Missile", "Yes", "No")
		if(choice == "Yes" && !processed)
			var/miss_message = ""
			var/ECM = 0
			var/obj/machinery/space_battle/ecm/E = locate(/obj/machinery/space_battle/ecm) in range(MAX_ECM_RANGE, T)
			if(E && E.can_block(get_dist(T, E)) && E.strength >= eccm)
				ECM = 1
			var/miss_chance = (advguidance ? 10*max(linked.sensor.advguidance.get_efficiency(-1,1), guidance_efficiency) : 25*guidance_efficiency)
			if(ECM || linked.firing_angle == "Flanking" || (!guidance||prob(miss_chance)) && linked.firing_angle != "Carefully Aimed") // Random firing.
				var/turf/newloc = pick_area_turf(get_area(start_loc), list(/proc/is_space, /proc/not_turf_contains_dense_objects))
				if(newloc) start_loc = newloc
				wait_time *= 1.5*efficiency
				if(!guidance)
					wait_time *= 1.5*efficiency
				if(ECM)
					miss_message = "<span class='danger'>Missile guidance failed to designate control target. Firing pattern uncontrolled.</span>"
				else if(linked.firing_angle != "Flanking")
					miss_message = "<span class='warning'>Missile was unable to reach the correct destination: Missed!</span>"
			var/result
			var/turf/newloc = get_turf(start_loc)
			if((linked.firing_angle == "Frontal Assault" || linked.firing_angle == "Carefully Aimed" || linked.firing_angle == "Rapid Fire") && (linked.x_offset || linked.y_offset))
				var/xo = linked.x_offset
				var/yo = linked.y_offset
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
			result = linked.tube.fire_missile(T, newloc)
			if(istext(result))
				usr << "<span class='warning'>[result]</span>"
				firing = 0
				return
			else
				usr << miss_message
				usr << "<span class='notice'>Missile launch successful!</span>"
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
			if(linked.firing_angle == "Carefully Aimed")
				wait_time *= 1.5*efficiency
			if(linked.firing_angle == "Rapid Fire")
				wait_time *= 0.5*efficiency
			processed = 1

		else
			firing = 0

		if(processed)
			var/radar = 0
			var/list/radars = linked.sensor.has_radars()
			for(var/obj/machinery/space_battle/missile_sensor/radar/M in radars)
				if(M.can_sense())
					radar += M.get_efficiency(1,1,1)
				else
					usr << "<span class='danger'>NOTICE: [M.name] inactive: [M.can_sense()]!</span>"
			radar = max(1, radar)
			wait_time += wait
			switch(linked.tube.dir)
				if(8)
					wait_time *= 1.75*efficiency
				if(1 to 2)
					wait_time *= 1.25*efficiency
			wait_time = max(50, wait_time / radar)
			if(loaded && istype(loaded))
				wait_time += loaded.delay_time
			wait_time = linked.cooldown(wait_time)
			usr << "<span class='notice'>Sensors are now calibrating. Please wait [(wait_time / 10)] seconds.</span>"
			firing = 0

	else
		usr << "<span class='notice'>Machine gun found!</span>"
		var/obj/machinery/space_battle/deck_gun/gun = linked.gun
		if(gun.firing)
			usr << "<span class='warning'>\The [gun] is already firing!</span>"
			return
		usr << "<span class='notice'>\The [gun] begins spinning up..</span>"
		gun.visible_message("<span class='notice'>\The [gun] begins spinning up...</span>")
		spawn(10) // Get yo ass on the ground!
			var/to_return = gun.fire_at(A, src)
			if(istext(to_return))
				usr << "<span class='warning'>[to_return]</span>"
				return
			shake_camera(src, 10, 10)
		firing = 0



