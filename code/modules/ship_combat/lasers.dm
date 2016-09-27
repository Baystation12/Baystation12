//Unlike missiles/bombs/deck guns, lasers cannot be targetted manually.

/obj/machinery/space_battle/computer/laser
	name = "laser firing control"
	desc = "A fire control computer."
	screen_icon = "laser"

	var/list/laser_emitters = list()

	reconnect()
		laser_emitters.Cut()
		for(var/obj/machinery/space_battle/laser_emitter/L in world)
			if(L.id_tag == src.id_tag && L.z == src.z)
				laser_emitters.Add(L)

	initialize()
		..()
		reconnect()

/obj/machinery/space_battle/computer/laser/attack_hand(var/mob/user)
	var/list/targets = find_targets()
	if(!targets.len)
		user << "<span class='warning'>No targets found!</span>"
		return
	var/obj/effect/overmap/target = input(user, "What would you like to target?", "Laser Control") in targets
	if(!target)
		user << "<span class='warning'>Invalid choice!</span>"
		return
	var/desired_damage = input(user, "How much damage would you like the lasers to do?", "Laser Control") as num
	desired_damage = between(3, desired_damage, 100)
	for(var/obj/machinery/space_battle/laser_emitter/L in laser_emitters)
		user << L.fire_laser(target)
		sleep(5)

/obj/machinery/space_battle/computer/laser/proc/find_targets()
	if(!linked)
		return null
	if(istype(linked, /obj/effect/overmap/ship))
		var/obj/effect/overmap/ship/S = linked
		if(!S.is_still())
			return null
	var/list/targets = list()
	for(var/obj/effect/overmap/possible_target in range(3, linked))
		if(possible_target.team != linked.team)
			targets.Add(possible_target)

	return targets

/obj/machinery/space_battle/laser_emitter
	name = "laser emitter"
	desc = "Fires a controlled high-power laser."
	icon_state = "laser_emitter"
	var/stored_charge = 0
	var/max_stored_charge = 500 KILOWATTS
	var/charging = 1
	var/damage_per_laser = 10
	var/charge_ticks = 0
	idle_power_usage = 50
	var/obj/machinery/space_battle/missile_sensor/tracking/sensor

/obj/machinery/space_battle/laser_emitter/New()
	..()
	for(var/obj/machinery/space_battle/missile_sensor/tracking/S in world)
		if(S.id_tag == src.id_tag)
			sensor = S

/obj/machinery/space_battle/laser_emitter/process()
	if(charging)
		charge_ticks++
		if(charge_ticks >= 5)
			charge()
			charge_ticks = 0
	else if(stored_charge)
		stored_charge -= rand(0,10)
	..()

/obj/machinery/space_battle/laser_emitter/proc/charge()
	if(stat & BROKEN) return 0
	if(stored_charge >= max_stored_charge)
		stored_charge = max_stored_charge
		return
	var/datum/powernet/powernet
	var/turf/T = src.loc
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)	powernet = C.powernet
	if(powernet)
		stored_charge += powernet.draw_power(5 KILOWATTS)
	for(var/obj/machinery/space_battle/laser_feed/feed in orange(1))
		stored_charge += feed.charge()

/obj/machinery/space_battle/laser_emitter/proc/fire_laser(var/obj/effect/overmap/target)
	if(stat & BROKEN)
		return "<span class='warning'>Emitter apparatus damaged!</span>"
	if(!stored_charge)
		return "<span class='warning'>Emitter has no charge!</span>"
	if(!sensor || !sensor.can_sense())
		return "<span class='warning'>Sensor inactive: [sensor ? sensor.can_sense() : "No sensor linked!"]</span>"
	var/base_damage = round(stored_charge / 5000)
	var/list/focals = get_focals()
	base_damage *= (1+focals.len*0.1)
	var/return_message = ""
	if(target.fake_ship)
		target.fake_ship.damaged(base_damage)
	else
		var/shots = round(base_damage / damage_per_laser)
		var/shooting_z = target.map_z[1]
		var/list/available_areas = list()
		for(var/area/ar in world)
			if(istype(ar, /area/ship_battle/))
				var/area/ship_battle/S = ar
				if(S.z == shooting_z)
					available_areas += ar
		var/list/shields = list()
		for(var/obj/machinery/space_battle/shield_generator/generator in world)
			if(generator.z == shooting_z)
				shields |= generator.shields
				break

		for(var/i=1 to shots)
			var/obj/effect/adv_shield/S
			if(shields.len)
				S = pick(shields)
			if(!S || S.take_damage(damage_per_laser))
				var/area/chosen = pick(available_areas)
				var/turf/firing_at = pick_area_turf(chosen)
				explosion(firing_at, 0, round(damage_per_laser / 10), round(damage_per_laser / 5), damage_per_laser)
				return_message += "<br><span class='notice'>Laser #[i] reached it's target! ([firing_at.x],[firing_at.y])</span>"
			else
				return_message += "<br><span class='warning'>Laser #[i] intercepted by shielding!</span>"
		return_message += "<br><span class='notice'>Laser fire successful!</span>"
		stored_charge = 0
		return return_message


/obj/machinery/space_battle/laser_emitter/proc/get_focals()
	var/obj/machinery/space_battle/laser_focal_lens/next = locate() in get_turf(get_step(src, dir))
	var/list/focals = list()
	if(next)
		var/counting = 1
		while(counting)
			if(!next)
				break
			if(next.stat & BROKEN)
				break
			focals.Add(next)
			var/turf/T = get_step(next.loc,dir)
			next = locate() in T
	return focals

/obj/machinery/space_battle/laser_feed
	name = "laser feed"
	desc = "Feeds electricity into a laser emitter."
	idle_power_usage = 150
	icon_state = "capacitor"

/obj/machinery/space_battle/laser_feed/proc/charge()
	if(stat & (BROKEN|NOPOWER)) return 0
	var/datum/powernet/powernet
	var/turf/T = src.loc
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)	powernet = C.powernet
	if(powernet)
		return powernet.draw_power(15 KILOWATTS)
	return 0


/obj/machinery/space_battle/laser_focal_lens
	name = "focal lens"
	desc = "Focuses a laser emitter, increasing it's output significantly."
	icon_state = "rail"