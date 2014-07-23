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


turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
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

		create_fire(1000)
	return igniting

/zone/proc/process_fire()
	if(!air.check_combustability())
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.fire))
				T.fire.RemoveFire()
			T.fire = null
		fire_tiles.Cut()

	if(!fire_tiles.len)
		air_master.active_fire_zones.Remove(src)
		return

	var/datum/gas_mixture/burn_gas = air.remove_ratio(vsc.fire_consuption_rate, fire_tiles.len)
	var/gm = burn_gas.group_multiplier

	burn_gas.group_multiplier = 1
	burn_gas.zburn(force_burn = 1, no_check = 1)
	burn_gas.group_multiplier = gm

	air.merge(burn_gas)

	var/firelevel = air.calculate_firelevel()

	for(var/turf/T in fire_tiles)
		if(T.fire)
			T.fire.firelevel = firelevel
		else
			fire_tiles -= T

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl)
	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		return 1

	if(!zone)
		return 1

	fire = new(src, fl)
	zone.fire_tiles |= src
	air_master.active_fire_zones |= zone
	return 0

/obj/fire
	//Icon for fire on turfs.

	anchored = 1
	mouse_opacity = 0

	//luminosity = 3

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	l_color = "#ED9200"
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
		SetLuminosity(7)
	else if(firelevel > 2.5)
		icon_state = "2"
		SetLuminosity(5)
	else
		icon_state = "1"
		SetLuminosity(3)

	//im not sure how to implement a version that works for every creature so for now monkeys are firesafe
	for(var/mob/living/carbon/human/M in loc)
		M.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the humans!

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

				if(!enemy_tile.zone.fire_tiles.len)
					var/datum/gas_mixture/acs = enemy_tile.return_air()
					if(!acs || !acs.check_combustability())
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

/obj/fire/New(newLoc,fl)
	..()

	if(!istype(loc, /turf))
		del src

	dir = pick(cardinal)
	SetLuminosity(3)
	firelevel = fl
	air_master.active_hotspots.Add(src)


/obj/fire/Del()
	if (istype(loc, /turf/simulated))
		SetLuminosity(0)

		loc = null
	air_master.active_hotspots.Remove(src)

	..()

/obj/fire/proc/RemoveFire()
	if (istype(loc, /turf))
		SetLuminosity(0)
		loc = null
	air_master.active_hotspots.Remove(src)


turf/simulated/var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.
turf/proc/apply_fire_protection()
turf/simulated/apply_fire_protection()
	fire_protection = world.time


datum/gas_mixture/proc/zburn(obj/effect/decal/cleanable/liquid_fuel/liquid, force_burn, no_check = 0)
	. = 0
	if((temperature > PHORON_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check ||check_recombustability(liquid)))
		var/total_fuel = 0
		var/total_oxidizers = 0

		for(var/g in gas)
			if(gas_data.flags[g] & XGM_GAS_FUEL)
				total_fuel += gas[g]
			if(gas_data.flags[g] & XGM_GAS_OXIDIZER)
				total_oxidizers += gas[g]

		if(liquid)
		//Liquid Fuel
			if(liquid.amount <= 0.1)
				del liquid
			else
				total_fuel += liquid.amount

		if(total_fuel == 0)
			return 0

		//Calculate the firelevel.
		var/firelevel = calculate_firelevel(liquid, total_fuel, total_oxidizers, force = 1)

		//get the current inner energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine the amount of oxygen used
		var/used_oxidizers = min(total_oxidizers, 2 * total_fuel)

		//determine the amount of fuel actually used
		var/used_fuel_ratio = min(total_oxidizers / 2 , total_fuel) / total_fuel
		total_fuel = total_fuel * used_fuel_ratio

		var/total_reactants = total_fuel + used_oxidizers

		//determine the amount of reactants actually reacting
		var/used_reactants_ratio = min(max(total_reactants * firelevel / vsc.fire_firelevel_multiplier, 0.2), total_reactants) / total_reactants

		//remove and add gasses as calculated
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers * used_reactants_ratio)
		remove_by_flag(XGM_GAS_FUEL, total_fuel * used_reactants_ratio * 3)

		adjust_gas("carbon_dioxide", max(2 * total_fuel, 0))

		if(liquid)
			liquid.amount -= (liquid.amount * used_fuel_ratio * used_reactants_ratio) * 5 // liquid fuel burns 5 times as quick

			if(liquid.amount <= 0) del liquid

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + vsc.fire_fuel_energy_release * total_fuel) / heat_capacity()

		update_values()
		. = total_reactants * used_reactants_ratio

datum/gas_mixture/proc/check_recombustability(obj/effect/decal/cleanable/liquid_fuel/liquid)
	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(liquid)
		return 1

	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL && gas[g] >= 0.1)
			. = 1
			break

datum/gas_mixture/proc/check_combustability(obj/effect/decal/cleanable/liquid_fuel/liquid)
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

datum/gas_mixture/proc/calculate_firelevel(obj/effect/decal/cleanable/liquid_fuel/liquid, total_fuel = null, total_oxidizers = null, force = 0)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	if(force || check_recombustability(liquid))
		if(isnull(total_fuel))
			for(var/g in gas)
				if(gas_data.flags[g] & XGM_GAS_FUEL)
					total_fuel += gas[g]
				if(gas_data.flags[g] & XGM_GAS_OXIDIZER)
					total_oxidizers += gas[g]
			if(liquid)
				total_fuel += liquid.amount

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
