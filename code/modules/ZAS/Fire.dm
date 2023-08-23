/*

Making Bombs with ZAS:
Get gas to react in an air tank so that it gains pressure. If it gains enough pressure, it goes boom.
The more pressure, the more boom.
If it gains pressure too slowly, it may leak or just rupture instead of exploding.
*/

//#define FIREDBG

/turf/var/obj/hotspot/hotspot = null

/atom/movable/proc/is_burnable()
	return FALSE

/mob/is_burnable()
	return simulated

/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)


/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return 0
	if(locate(/obj/hotspot) in src)
		return 1
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PHORON_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src
	if(liquid && air_contents.check_combustability(liquid))
		IgniteTurf(liquid.amount * 10)
		QDEL_NULL(liquid)
	if(air_contents.check_combustability())
		igniting = 1
		create_fire(exposed_temperature)
	return igniting

/zone/proc/process_fire()
	var/datum/gas_mixture/burn_gas = air.remove_ratio(vsc.fire_consuption_rate, length(fire_tiles))

	var/firelevel = burn_gas.react(src, fire_tiles, force_burn = 1, no_check = 1)

	air.merge(burn_gas)

	if(firelevel)
		for(var/turf/T in fire_tiles)
			if(T.hotspot)
				T.hotspot.firelevel = firelevel
			else
				fire_tiles -= T
	else
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.hotspot))
				qdel(T.hotspot)
		fire_tiles.Cut()

	if(!length(fire_tiles))
		SSair.active_fire_zones.Remove(src)

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl)

	if(submerged())
		return 1

	if(hotspot)
		hotspot.firelevel = max(fl, hotspot.firelevel)
		return 1

	if(!zone)
		return 1

	hotspot = new(src, fl)
	SSair.active_fire_zones |= zone

	zone.fire_tiles |= src

	return 0

/obj/hotspot
	//Icon for gas fire on turfs.
	//Different from turf fires

	anchored = TRUE
	mouse_opacity = 0

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ed9200"
	layer = FIRE_LAYER

	var/firelevel = 1 //Calculated by gas_mixture.calculate_firelevel()

/obj/hotspot/Process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone || my_tile.submerged())
		if(my_tile && my_tile.hotspot == src)
			my_tile.hotspot = null
		qdel(src)
		return PROCESS_KILL

	var/datum/gas_mixture/air_contents = my_tile.return_air()

	if(firelevel > 6)
		icon_state = "3"
		set_light(1, 2, 7)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(0.7, 2, 5)
	else
		icon_state = "1"
		set_light(0.5, 1, 3)

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
				if(!enemy_tile.zone || enemy_tile.hotspot)
					continue

				//if(!length(enemy_tile.zone.fire_tiles)) TODO - optimize
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

	animate(src, color = fire_color(air_contents.temperature), 5)
	set_light(l_color = color)

/obj/hotspot/New(newLoc,fl)
	..()

	if(!istype(loc, /turf))
		qdel(src)
		return

	set_dir(pick(GLOB.cardinal))

	var/datum/gas_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)
	set_light(0.5, 1, 3, l_color = color)

	firelevel = fl
	SSair.active_hotspots.Add(src)

	//If this is a turf and it can burn maybe it should be ignited too - Lingering fire effect of sorts
	var/turf/simulated/floor/F = loc
	if(istype(F) && F.flooring && F.flooring.flags & TURF_CAN_BURN)
		if(prob(30))
			F.IgniteTurf(rand(8,22))

/obj/hotspot/proc/fire_color(env_temperature)
	var/temperature = max(4000*sqrt(firelevel/vsc.fire_firelevel_multiplier), env_temperature)
	return heat2color(temperature)

/obj/hotspot/Destroy()
	var/turf/T = loc
	if (istype(T))
		set_light(0)
		T.hotspot = null
	SSair.active_hotspots.Remove(src)
	. = ..()

/turf/simulated/var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.
/turf/proc/apply_fire_protection()
/turf/simulated/apply_fire_protection()
	fire_protection = world.time

//Returns the firelevel
/datum/gas_mixture/proc/react(zone/zone, force_burn, no_check = 0)
	. = 0
	if((temperature > PHORON_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check || check_combustability()))

		#ifdef FIREDBG
		log_debug("***************** FIREDBG *****************")
		log_debug("Burning [zone? zone.name : "zoneless gas_mixture"]!")
		#endif

		var/gas_fuel = 0
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

		total_fuel = gas_fuel
		if(total_fuel <= 0.005)
			return 0

		//*** Determine how fast the fire burns

		//get the current thermal energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine how far the reaction can progress
		var/reaction_limit = min(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

		//vapour fuels are extremely volatile! The reaction progress is a percentage of the total fuel (similar to old zburn).)
		var/gas_firelevel = calculate_firelevel(gas_fuel, total_oxidizers, reaction_limit, volume*group_multiplier) / vsc.fire_firelevel_multiplier
		var/min_burn = 0.30*volume*group_multiplier/CELL_VOLUME //in moles - so that fires with very small gas concentrations burn out fast
		var/gas_reaction_progress = min(max(min_burn, gas_firelevel*gas_fuel)*FIRE_GAS_BURNRATE_MULT, gas_fuel)

		var/firelevel = (gas_fuel*gas_firelevel)/total_fuel

		var/total_reaction_progress = gas_reaction_progress
		var/used_fuel = min(total_reaction_progress, reaction_limit)
		var/used_oxidizers = used_fuel*(FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)

		#ifdef FIREDBG
		log_debug("gas_fuel = [gas_fuel], total_oxidizers = [total_oxidizers]")
		log_debug("fuel_area = [fuel_area], total_fuel = [total_fuel], reaction_limit = [reaction_limit]")
		log_debug("firelevel -> [firelevel] (gas: [gas_firelevel]")
		log_debug("gas_reaction_progress = [gas_reaction_progress]")
		log_debug("total_reaction_progress = [total_reaction_progress]")
		log_debug("used_fuel = [used_fuel], used_oxidizers = [used_oxidizers]; ")
		#endif

		//if the reaction is progressing too slow then it isn't self-sustaining anymore and burns out
		if(zone) //be less restrictive with canister and tank reactions
			if((!gas_fuel || used_fuel <= FIRE_GAS_MIN_BURNRATE*length(zone.contents)))
				return 0


		//*** Remove fuel and oxidizer, add carbon dioxide and heat

		//remove and add gasses as calculated
		var/used_gas_fuel = min(max(0.25, used_fuel*(gas_reaction_progress/total_reaction_progress)), gas_fuel) //remove in proportion to the relative reaction progress


		//remove_by_flag() and adjust_gas() handle the group_multiplier for us.
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers)
		var/datum/gas_mixture/burned_fuel = remove_by_flag(XGM_GAS_FUEL, used_gas_fuel)
		for(var/g in burned_fuel.gas)
			adjust_gas(gas_data.burn_product[g], burned_fuel.gas[g])

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + vsc.fire_fuel_energy_release * (used_gas_fuel)) / heat_capacity()
		update_values()

		#ifdef FIREDBG
		log_debug("used_gas_fuel = [used_gas_fuel];")
		log_debug("new temperature = [temperature]; new pressure = [return_pressure()]")
		#endif

		if (temperature<220)
			firelevel = 0

		return firelevel

/datum/gas_mixture/proc/check_recombustability(list/fuel_objs)
	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(fuel_objs && length(fuel_objs))
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

//returns a value between 0 and vsc.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, gas_volume)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	var/total_combustables = (total_fuel + total_oxidizers)
	var/active_combustables = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_moles && total_combustables > 0)
		//slows down the burning when the concentration of the reactants is low
		var/damping_multiplier = min(1, active_combustables / (total_moles/group_multiplier))

		//weight the damping mult so that it only really brings down the firelevel when the ratio is closer to 0
		damping_multiplier = 2*damping_multiplier - (damping_multiplier*damping_multiplier)

		//calculates how close the mixture of the reactants is to the optimum
		//fires burn better when there is more oxidizer -- too much fuel will choke the fire out a bit, reducing firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustables) ** 2)))

		#ifdef FIREDBG
		ASSERT(damping_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everything together -- should produce a value between 0 and fire_firelevel_multiplier
		firelevel = vsc.fire_firelevel_multiplier * mix_multiplier * damping_multiplier

	return max( 0, firelevel)


/mob/living/proc/FireBurn(firelevel, last_temperature, pressure)
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5 * mx, DAMAGE_BURN)
	return mx


/mob/living/carbon/human/FireBurn(firelevel, last_temperature, pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	for(var/obj/item/clothing/C in src)
		if (IsHolding(C))
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
	//minimize this for low-pressure environments
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(0.9*mx*head_exposure,  DAMAGE_BURN, BP_HEAD,  used_weapon =  "Fire")
	apply_damage(2.5*mx*chest_exposure, DAMAGE_BURN, BP_CHEST, used_weapon =  "Fire")
	apply_damage(2.0*mx*groin_exposure, DAMAGE_BURN, BP_GROIN, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure,  DAMAGE_BURN, BP_L_LEG, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure,  DAMAGE_BURN, BP_R_LEG, used_weapon =  "Fire")
	apply_damage(0.4*mx*arms_exposure,  DAMAGE_BURN, BP_L_ARM, used_weapon =  "Fire")
	apply_damage(0.4*mx*arms_exposure,  DAMAGE_BURN, BP_R_ARM, used_weapon =  "Fire")

	//return a truthy value of whether burning actually happened
	return mx * (head_exposure + chest_exposure + groin_exposure + legs_exposure + arms_exposure)
