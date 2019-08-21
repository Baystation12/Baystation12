
/obj/effect/fire
	//Icon for fire on turfs.

	anchored = 1

	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	light_color = "#ED9200"

	var/firelevel = 1 //Calculated by gas_mixture.calculate_firelevel()

/obj/effect/fire/New(newLoc,fl = 1)
	. = ..()

	if(!istype(loc, /turf))
		qdel(src)
		return

	var/datum/gas_mixture/air_contents = loc.return_air()

	set_dir(pick(GLOB.cardinal))
	set_light(3, 1, light_color)
	firelevel = fl
	GLOB.processing_objects.Add(src)

	//ignite all the fuel
	for(var/obj/effect/decal/cleanable/liquid_fuel/fuel in src.loc)
		fuel.invisibility = INVISIBILITY_SYSTEM

	//burn anything here
	for(var/mob/living/L in loc)
		L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the mobs!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

/obj/effect/fire/proc/fire_color(var/env_temperature)
	var/temperature = max(4000*sqrt(firelevel/vsc.fire_firelevel_multiplier), env_temperature)
	return heat2color(temperature)

/obj/effect/fire/process()
	. = 1

	var/turf/simulated/my_tile = get_turf(loc)
	var/datum/gas_mixture/air_contents = my_tile.return_air()
	var/datum/gas_mixture/burn_gas = air_contents.remove_ratio(vsc.fire_consuption_rate, 1)

	var/firelevel = burn_gas.zburn(my_tile.zone, force_burn = 1, no_check = 1, target_turf = my_tile)

	air_contents.merge(burn_gas)

	/*
	if(firelevel > 6)
		icon_state = "3"
		set_light(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(5, 2)
	else
		icon_state = "1"
		set_light(3, 1)
		*/

	for(var/mob/living/L in loc)
		L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the mobs!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in GLOB.cardinal)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(!enemy_tile.zone)// || enemy_tile.fire)
					continue
				var/obj/effect/fire/F = locate() in enemy_tile
				if(F)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/gas_mixture/acs = enemy_tile.return_air()
				var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in enemy_tile
				if(!acs || !acs.check_combustability(liquid))
					continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection + FIRE_PROTECTION_TIME < world.time)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob( 50 + 50 * (firelevel/vsc.fire_firelevel_multiplier) ) && my_tile.CanPass(null, enemy_tile, 0,0) && enemy_tile.CanPass(null, my_tile, 0,0))
					//enemy_tile.create_fire(firelevel)
					var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in enemy_tile
					if(fuel)
						new /obj/effect/fire(enemy_tile, 1)

			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	if(firelevel <= 0)
		qdel(src)
	else
		set_light(3, 1, light_color)

/obj/effect/fire/Destroy()
	//in case there is any fuel left... fires could go out from extinguisher spray or lack of oxygen
	for(var/obj/effect/decal/cleanable/liquid_fuel/fuel in src.loc)
		if(fuel.amount <= FIRE_LIQUD_MIN_BURNRATE)
			qdel(fuel)
		else
			fuel.invisibility = initial(fuel.invisibility)
	var/turf/T = loc
	if (istype(T))
		set_light(0)
	GLOB.processing_objects.Remove(src)

	. = ..()

/obj/effect/fire/Crossed(atom/movable/O)
	. = ..()

	//get put out
	if(istype(O, /obj/effect/effect/water))
		qdel(src)

	else
		//burn anything crossing over us
		var/turf/simulated/my_tile = get_turf(loc)
		var/datum/gas_mixture/air_contents = my_tile.return_air()
		if(isliving(O))
			var/mob/living/L = O
			L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the mobs!
		O.fire_act(air_contents, air_contents.temperature, air_contents.volume)
