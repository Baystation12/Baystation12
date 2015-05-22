/obj/machinery/portable_atmospherics/hydroponics/process()

	// Handle nearby smoke if any.
	for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.total_volume)
			smoke.reagents.trans_to_obj(src, 5, copy = 1)

	//Do this even if we're not ready for a plant cycle.
	process_reagents()

	// Update values every cycle rather than every process() tick.
	if(force_update)
		force_update = 0
	else if(world.time < (lastcycle + cycledelay))
		return
	lastcycle = world.time

	// Mutation level drops each main tick.
	mutation_level -= rand(2,4)

	// Weeds like water and nutrients, there's a chance the weed population will increase.
	// Bonus chance if the tray is unoccupied.
	if(waterlevel > 10 && nutrilevel > 2 && prob(isnull(seed) ? 5 : 1))
		weedlevel += 1 * HYDRO_SPEED_MULTIPLIER

	// There's a chance for a weed explosion to happen if the weeds take over.
	// Plants that are themselves weeds (weed_tolerance > 10) are unaffected.
	if (weedlevel >= 10 && prob(10))
		if(!seed || weedlevel >= seed.get_trait(TRAIT_WEED_TOLERANCE))
			weed_invasion()

	// If there is no seed data (and hence nothing planted),
	// or the plant is dead, process nothing further.
	if(!seed || dead)
		if(mechanical) update_icon() //Harvesting would fail to set alert icons properly.
		return

	// Advance plant age.
	if(prob(30)) age += 1 * HYDRO_SPEED_MULTIPLIER

	//Highly mutable plants have a chance of mutating every tick.
	if(seed.get_trait(TRAIT_IMMUTABLE) == -1)
		var/mut_prob = rand(1,100)
		if(mut_prob <= 5) mutate(mut_prob == 1 ? 2 : 1)

	// Other plants also mutate if enough mutagenic compounds have been added.
	if(!seed.get_trait(TRAIT_IMMUTABLE))
		if(prob(min(mutation_level,100)))
			mutate((rand(100) < 15) ? 2 : 1)
			mutation_level = 0

	// Maintain tray nutrient and water levels.
	if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0 && nutrilevel > 0 && prob(25))
		nutrilevel -= max(0,seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) * HYDRO_SPEED_MULTIPLIER)
	if(seed.get_trait(TRAIT_WATER_CONSUMPTION) > 0 && waterlevel > 0 && prob(25))
		waterlevel -= max(0,seed.get_trait(TRAIT_WATER_CONSUMPTION) * HYDRO_SPEED_MULTIPLIER)

	// Make sure the plant is not starving or thirsty. Adequate
	// water and nutrients will cause a plant to become healthier.
	var/healthmod = rand(1,3) * HYDRO_SPEED_MULTIPLIER
	if(seed.get_trait(TRAIT_REQUIRES_NUTRIENTS) && prob(35))
		health += (nutrilevel < 2 ? -healthmod : healthmod)
	if(seed.get_trait(TRAIT_REQUIRES_WATER) && prob(35))
		health += (waterlevel < 10 ? -healthmod : healthmod)

	// Check that pressure, heat and light are all within bounds.
	// First, handle an open system or an unconnected closed system.
	var/turf/T = loc
	var/datum/gas_mixture/environment
	// If we're closed, take from our internal sources.
	if(closed_system && (connected_port || holding))
		environment = air_contents
	// If atmos input is not there, grab from turf.
	if(!environment && istype(T)) environment = T.return_air()
	if(!environment) return

	// Seed datum handles gasses, light and pressure.
	if(mechanical && closed_system)
		health -= seed.handle_environment(T,environment,tray_light)
	else
		health -= seed.handle_environment(T,environment)

	// If we're attached to a pipenet, then we should let the pipenet know we might have modified some gasses
	if (closed_system && connected_port)
		update_connected_network()

	// Toxin levels beyond the plant's tolerance cause damage, but
	// toxins are sucked up each tick and slowly reduce over time.
	if(toxins > 0)
		var/toxin_uptake = max(1,round(toxins/10))
		if(toxins > seed.get_trait(TRAIT_TOXINS_TOLERANCE))
			health -= toxin_uptake
		toxins -= toxin_uptake

	// Check for pests and weeds.
	// Some carnivorous plants happily eat pests.
	if(pestlevel > 0)
		if(seed.get_trait(TRAIT_CARNIVOROUS))
			health += HYDRO_SPEED_MULTIPLIER
			pestlevel -= HYDRO_SPEED_MULTIPLIER
		else if (pestlevel >= seed.get_trait(TRAIT_PEST_TOLERANCE))
			health -= HYDRO_SPEED_MULTIPLIER

	// Some plants thrive and live off of weeds.
	if(weedlevel > 0)
		if(seed.get_trait(TRAIT_PARASITE))
			health += HYDRO_SPEED_MULTIPLIER
			weedlevel -= HYDRO_SPEED_MULTIPLIER
		else if (weedlevel >= seed.get_trait(TRAIT_WEED_TOLERANCE))
			health -= HYDRO_SPEED_MULTIPLIER

	// Handle life and death.
	// When the plant dies, weeds thrive and pests die off.
	check_health()

	// If enough time (in cycles, not ticks) has passed since the plant was harvested, we're ready to harvest again.
	if((age > seed.get_trait(TRAIT_MATURATION)) && \
	 ((age - lastproduce) > seed.get_trait(TRAIT_PRODUCTION)) && \
	 (!harvest && !dead))
		harvest = 1
		lastproduce = age

	// If we're a vine which is not in a closed tray and is at least half mature, and there's no vine currently on our turf: make one (maybe)
	if(!closed_system && \
	 seed.get_trait(TRAIT_SPREAD) == 2 && \
	 2 * age >= seed.get_trait(TRAIT_MATURATION) && \
	 !(locate(/obj/effect/plant) in get_turf(src)) && \
	 prob(2 * seed.get_trait(TRAIT_POTENCY)))
		new /obj/effect/plant(get_turf(src), seed)

	if(prob(3))  // On each tick, there's a chance the pest population will increase
		pestlevel += 0.1 * HYDRO_SPEED_MULTIPLIER

	// Some seeds will self-harvest if you don't keep a lid on them.
	if(seed && seed.can_self_harvest && harvest && !closed_system && prob(5))
		harvest()

	check_health()
	return
