/*

Making Bombs with ZAS:
Make burny fire with lots of burning
Draw off 5000K gas from burny fire
Separate gas into oxygen and phoron components
Obtain phoron and oxygen tanks filled up about 50-75% with normal-temp gas
Fill rest with super hot gas from separated canisters, they should be about 125C now.
Attach to transfer valve and open. BOOM.

*/

/turf/var/obj/fire/fire = null

//Some legacy definitions so fires can be started.
atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null


turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)


/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return 0
	if(locate(/obj/fire) in src)
		return 1
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PHORON_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src

	if(air_contents.check_combustability(liquid))
		igniting = 1

		create_fire(vsc.fire_firelevel_multiplier)
	return igniting

/zone/proc/process_fire()
	var/datum/gas_mixture/burn_gas = air.remove_ratio(vsc.fire_consuption_rate, fire_tiles.len)

	var/firelevel = burn_gas.zburn(src, fire_tiles, force_burn = 1, no_check = 1)
	//world << "[src]: firelevel [firelevel]"

	air.merge(burn_gas)

	if(firelevel)
		for(var/turf/T in fire_tiles)
			if(T.fire)
				T.fire.firelevel = firelevel
			else
				var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
				fire_tiles -= T
				fuel_objs -= fuel
	else
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.fire))
				T.fire.RemoveFire()
			T.fire = null
		fire_tiles.Cut()
		fuel_objs.Cut()

	if(!fire_tiles.len)
		air_master.active_fire_zones.Remove(src)

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl)
	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		return 1

	if(!zone)
		return 1

	fire = new(src, fl)
	air_master.active_fire_zones |= zone

	var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in src
	zone.fire_tiles |= src
	if(fuel) zone.fuel_objs += fuel

	return 0

/obj/fire
	//Icon for fire on turfs.

	anchored = 1
	mouse_opacity = 0

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ED9200"
	layer = TURF_LAYER

	var/firelevel = 10000 //Calculated by gas_mixture.calculate_firelevel()

/obj/fire/process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone)
		if(my_tile.fire == src)
			my_tile.fire = null
		RemoveFire()
		return 1

	var/datum/gas_mixture/air_contents = my_tile.return_air()

	if(firelevel > 6)
		icon_state = "3"
		set_light(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(5, 2)
	else
		icon_state = "1"
		set_light(3, 1)

	//im not sure how to implement a version that works for every creature so for now monkeys are firesafe
	for(var/mob/living/L in loc)
		L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the mobs!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in cardinal)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(!enemy_tile.zone || enemy_tile.fire)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/gas_mixture/acs = enemy_tile.return_air()
				var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in enemy_tile
				if(!acs || !acs.check_combustability(liquid))
					continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob( 50 + 50 * (firelevel/vsc.fire_firelevel_multiplier) ) && my_tile.CanPass(null, enemy_tile, 0,0) && enemy_tile.CanPass(null, my_tile, 0,0))
					enemy_tile.create_fire(firelevel)

			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	animate(src, color = heat2color(air_contents.temperature), 5)
	set_light(l_color = color)

/obj/fire/New(newLoc,fl)
	..()

	if(!istype(loc, /turf))
		qdel(src)

	set_dir(pick(cardinal))
	
	var/datum/gas_mixture/air_contents = loc.return_air()
	color = heat2color(air_contents.temperature)
	set_light(3, 1, color)

	firelevel = fl
	air_master.active_hotspots.Add(src)


/obj/fire/Destroy()
	if (istype(loc, /turf/simulated))
		RemoveFire()

	..()

/obj/fire/proc/RemoveFire()
	if (istype(loc, /turf))
		set_light(0)

		loc = null
	air_master.active_hotspots.Remove(src)


/turf/simulated/var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.
/turf/proc/apply_fire_protection()
/turf/simulated/apply_fire_protection()
	fire_protection = world.time

//Returns the firelevel
/datum/gas_mixture/proc/zburn(zone/zone, force_burn, no_check = 0)
	. = 0
	if((temperature > PHORON_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check ||check_recombustability(zone? zone.fuel_objs : null)))
		var/gas_fuel = 0 //in the case of mixed gas/liquid fires, the gas burns first.
		var/liquid_fuel = 0
		var/total_fuel = 0
		var/total_oxidizers = 0

		//*** Get the fuel and oxidizer amounts
		for(var/g in gas)
			if(gas_data.flags[g] & XGM_GAS_FUEL)
				gas_fuel += gas[g]
			if(gas_data.flags[g] & XGM_GAS_OXIDIZER)
				total_oxidizers += gas[g]
		gas_fuel *= group_multiplier
		total_oxidizers *= group_multiplier

		//Liquid Fuel
		if(zone)
			for(var/obj/effect/decal/cleanable/liquid_fuel/fuel in zone.fuel_objs)
				liquid_fuel += fuel.amount*LIQUIDFUEL_AMOUNT_TO_MOL

		total_fuel = gas_fuel + liquid_fuel
		if(total_fuel <= 0.005)
			return 0

		//*** Determine how fast the fire burns

		//calculate the firelevel.
		var/firelevel = calculate_firelevel(zone? zone.fuel_objs : null, total_fuel, total_oxidizers, force = 1)

		//get the current thermal energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine how far the reaction can progress
		var/reaction_limit = min(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

		//determine the actual rate of reaction, as measured by the amount of fuel reacting

		//vapour fuels are extremely volatile! The reaction progress is a percentage of the total fuel (similar to old zburn).
		var/gas_reaction_progress = max(0.2*group_multiplier, (firelevel/vsc.fire_firelevel_multiplier)*gas_fuel)*FIRE_GAS_BURNRATE_MULT
		//liquid fuels are not as volatile, and the reaction progress depends on the size of the area that is burning (which is sort of accounted for by firelevel). Having more fuel means a longer burn.
		var/liquid_reaction_progress = (firelevel/vsc.fire_firelevel_multiplier)*FIRE_LIQUID_BURNRATE_MULT

		//world << "liquid_reaction_progress = [liquid_reaction_progress]"
		//world << "gas_reaction_progress = [gas_reaction_progress]"

		var/total_reaction_progress = gas_reaction_progress + liquid_reaction_progress
		var/used_fuel = min(total_reaction_progress, reaction_limit)
		var/used_oxidizers = used_fuel*(FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)
		//world << "used_fuel = [used_fuel]; used_oxidizers = [used_oxidizers]; reaction_limit=[reaction_limit]"

		//if the reaction is progressing too slow then it isn't self-sustaining anymore and burns out
		if(zone && zone.fuel_objs.len)
			if(used_fuel <= FIRE_LIQUD_MIN_BURNRATE)
				return 0
		else if(used_fuel <= FIRE_GAS_MIN_BURNRATE*group_multiplier) //purely gas fires have more stringent criteria
			return 0


		//*** Remove fuel and oxidizer, add carbon dioxide and heat

		//remove and add gasses as calculated
		var/used_gas_fuel = min(used_fuel*(gas_reaction_progress/total_reaction_progress), gas_fuel) //remove in proportion to the relative reaction progress
		var/used_liquid_fuel = between(0, used_fuel-used_gas_fuel, liquid_fuel)

		//remove_by_flag() and adjust_gas() handle the group_multiplier for us.
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers)
		remove_by_flag(XGM_GAS_FUEL, used_gas_fuel)
		adjust_gas("carbon_dioxide", used_oxidizers)

		//As a simplification, we remove fuel equally from all fuel sources. It might be that some fuel sources have more fuel, some have less, but whatever.
		if(zone && zone.fuel_objs.len)
			var/fuel_to_remove = used_liquid_fuel/(zone.fuel_objs.len*LIQUIDFUEL_AMOUNT_TO_MOL) //convert back to liquid volume units
			//world << "used gas fuel = [used_gas_fuel]; used other fuel = [used_fuel-used_gas_fuel]; fuel_to_remove = [fuel_to_remove]"
			var/liquidonly = !check_combustability()
			for(var/O in zone.fuel_objs)
				var/obj/effect/decal/cleanable/liquid_fuel/fuel = O
				if(!istype(fuel))
					zone.fuel_objs -= fuel
					continue

				fuel.amount -= fuel_to_remove
				if(fuel.amount <= 0)
					zone.fuel_objs -= fuel
					if(liquidonly)
						var/turf/T = fuel.loc
						if(istype(T) && T.fire) qdel(T.fire)
					qdel(fuel)

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + vsc.fire_fuel_energy_release * used_fuel) / heat_capacity()

		update_values()
		return firelevel

datum/gas_mixture/proc/check_recombustability(list/fuel_objs)
	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(fuel_objs && fuel_objs.len)
		return 1

	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL && gas[g] >= 0.1)
			. = 1
			break

/datum/gas_mixture/proc/check_combustability(obj/effect/decal/cleanable/liquid_fuel/liquid=null)
	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && QUANTIZE(gas[g] * vsc.fire_consuption_rate) >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(liquid)
		return 1

	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL && QUANTIZE(gas[g] * vsc.fire_consuption_rate) >= 0.1)
			. = 1
			break

//Returns a value between 0 and vsc.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(list/fuel_objs, total_fuel, total_oxidizers, force = 0)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	if(force || check_recombustability(fuel_objs))
		var/total_combustables = (total_fuel + total_oxidizers)

		if(total_combustables > 0)
			//slows down the burning when the concentration of the reactants is low
			var/dampening_multiplier = total_combustables / total_moles
			//calculates how close the mixture of the reactants is to the optimum
			var/mix_multiplier = 1 / (1 + (5 * ((total_oxidizers / total_combustables) ** 2)))
			//toss everything together
			firelevel = vsc.fire_firelevel_multiplier * mix_multiplier * dampening_multiplier

	return max( 0, firelevel)


/mob/living/proc/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5*mx, BURN)


/mob/living/carbon/human/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	for(var/obj/item/clothing/C in src)
		if(l_hand == C || r_hand == C)
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & HEAD)
				head_exposure = 0
			if(C.body_parts_covered & UPPER_TORSO)
				chest_exposure = 0
			if(C.body_parts_covered & LOWER_TORSO)
				groin_exposure = 0
			if(C.body_parts_covered & LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(2.5*mx*head_exposure, BURN, "head", 0, 0, "Fire")
	apply_damage(2.5*mx*chest_exposure, BURN, "chest", 0, 0, "Fire")
	apply_damage(2.0*mx*groin_exposure, BURN, "groin", 0, 0, "Fire")
	apply_damage(0.6*mx*legs_exposure, BURN, "l_leg", 0, 0, "Fire")
	apply_damage(0.6*mx*legs_exposure, BURN, "r_leg", 0, 0, "Fire")
	apply_damage(0.4*mx*arms_exposure, BURN, "l_arm", 0, 0, "Fire")
	apply_damage(0.4*mx*arms_exposure, BURN, "r_arm", 0, 0, "Fire")
