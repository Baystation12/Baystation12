#define FUSION_ENERGY_PER_K        20
#define FUSION_INSTABILITY_DIVISOR 50000
#define FUSION_RUPTURE_THRESHOLD   10000
#define FUSION_REACTANT_CAP        10000

/obj/effect/fusion_em_field
	name = "electromagnetic field"
	desc = "A coruscating, barely visible field of energy. It is shaped like a slightly flattened torus."
	alpha = 30
	layer = 4
	light_color = COLOR_RED

	plane = EFFECTS_ABOVE_LIGHTING_PLANE

	var/size = 1
	var/energy = 0
	var/plasma_temperature = 0
	var/radiation = 0
	var/field_strength = 0.01
	var/tick_instability = 0
	var/percent_unstable = 0

	var/obj/machinery/power/fusion_core/owned_core
	var/list/reactants = list()
	var/list/particle_catchers = list()

	var/list/ignore_types = list(
		/obj/item/projectile,
		/obj/effect,
		/obj/structure/cable,
		/obj/machinery/atmospherics,
		/obj/machinery/air_sensor
		)

	var/light_min_range = 2
	var/light_min_power = 0.2
	var/light_max_range = 18
	var/light_max_power = 1

	var/last_range
	var/last_power

	var/last_reactants = 0

	particles = new/particles/fusion

	var/animating_ripple = FALSE

/obj/effect/fusion_em_field/proc/UpdateVisuals()
	//Take the particle system and edit it

	//size
	var/radius = ((size-1) / 2) * WORLD_ICON_SIZE

	particles.position = generator("circle", radius - size, radius + size, NORMAL_RAND)

	//Radiation affects drift
	var/radiationfactor = clamp((radiation * 0.001), 0, 0.5)
	particles.drift = generator("circle", (0.2 + radiationfactor), NORMAL_RAND)

	particles.spawning = last_reactants * 0.9 + Interpolate(0, 200, clamp(plasma_temperature / 70000, 0, 1))


/obj/effect/fusion_em_field/New(loc, obj/machinery/power/fusion_core/new_owned_core)
	..()

	filters = list(filter(type = "ripple", size = 4, "radius" = 1, "falloff" = 1)
	, filter(type="outline", size = 2, color =  COLOR_RED)
	, filter(type="bloom", size=3, offset = 0.5, alpha = 235))

	set_light(light_min_power, light_min_range / 10, light_min_range)
	last_range = light_min_range
	last_power = light_min_power

	owned_core = new_owned_core
	if(!owned_core)
		qdel(src)
		return

	particles.spawning = 0 //Turn off particles until something calls for it

	//create the gimmicky things to handle field collisions
	var/obj/effect/fusion_particle_catcher/catcher

	catcher = new (locate(src.x,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(1)
	particle_catchers.Add(catcher)

	for(var/iter=1,iter<=6,iter++)
		catcher = new (locate(src.x-iter,src.y,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x+iter,src.y,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x,src.y+iter,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x,src.y-iter,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

	START_PROCESSING(SSobj, src)

/obj/effect/fusion_em_field/Initialize()
	. = ..()
	addtimer(new Callback(src, .proc/update_light_colors), 10 SECONDS, TIMER_LOOP)

/obj/effect/fusion_em_field/proc/update_light_colors()
	var/use_range
	var/use_power
	switch (plasma_temperature)
		if (-INFINITY to 1000)
			light_color = COLOR_RED
			use_range = light_min_range
			use_power = light_min_power
			alpha = 30
		if (100000 to INFINITY)
			light_color = COLOR_VIOLET
			use_range = light_max_range
			use_power = light_max_power
			alpha = 230
		else
			var/temp_mod = ((plasma_temperature-5000)/20000)
			use_range = light_min_range + Ceil((light_max_range-light_min_range)*temp_mod)
			use_power = light_min_power + Ceil((light_max_power-light_min_power)*temp_mod)
			switch (plasma_temperature)
				if (1000 to 6000)
					light_color = COLOR_ORANGE
					alpha = 50
				if (6000 to 20000)
					light_color = COLOR_YELLOW
					alpha = 80
				if (20000 to 50000)
					light_color = COLOR_GREEN
					alpha = 120
				if (50000 to 70000)
					light_color = COLOR_CYAN
					alpha = 160
				if (70000 to 100000)
					light_color = COLOR_BLUE
					alpha = 200

	if (last_range != use_range || last_power != use_power || color != light_color)
		set_light(min(use_power, 1), use_range / 6, use_range) //cap first arg at 1 to avoid breaking lighting stuff.
		last_range = use_range
		last_power = use_power
		//Temperature based color
		particles.gradient = list(0, COLOR_WHITE, 0.85, light_color)
		UNLINT(var/dm_filter/outline = filters[2])
		UNLINT(outline.color = light_color)
		UNLINT(var/dm_filter/bloom = filters[3])
		UNLINT(bloom.alpha = alpha)

/obj/effect/fusion_em_field/Process()
	//make sure the field generator is still intact
	if(QDELETED(owned_core))
		qdel(src)
		return

	// Take some gas up from our environment.
	var/added_particles = FALSE
	var/datum/gas_mixture/uptake_gas = owned_core.loc.return_air()
	if(uptake_gas)
		uptake_gas = uptake_gas.remove_by_flag(XGM_GAS_FUSION_FUEL, rand(50,100))
	if(uptake_gas && uptake_gas.total_moles)
		for(var/gasname in uptake_gas.gas)
			if(uptake_gas.gas[gasname]*10 > reactants[gasname])
				AddParticles(gasname, uptake_gas.gas[gasname]*10)
				uptake_gas.adjust_gas(gasname, -(uptake_gas.gas[gasname]), update=FALSE)
				added_particles = TRUE
		if(added_particles)
			uptake_gas.update_values()

	//let the particles inside the field react
	React()

	// Dump power to our powernet.
	owned_core.add_avail(FUSION_ENERGY_PER_K * plasma_temperature)

	// Energy decay.
	if(plasma_temperature >= 1)
		var/lost = plasma_temperature*0.01
		radiation += lost
		plasma_temperature -= lost

	//handle some reactants formatting
	for(var/reactant in reactants)
		var/amount = reactants[reactant]
		if(amount < 1)
			reactants.Remove(reactant)
		else if(amount >= FUSION_REACTANT_CAP)
			var/radiate = rand(3 * amount / 4, amount / 4)
			reactants[reactant] -= radiate
			radiation += radiate

	check_instability()
	Radiate()
	if(radiation)
		SSradiation.radiate(src, round(radiation*0.001))
	return 1

/obj/effect/fusion_em_field/proc/check_instability()
	if(tick_instability > 0)
		percent_unstable += (tick_instability*size)/FUSION_INSTABILITY_DIVISOR
		tick_instability = 0
		UpdateVisuals()
	else
		if(percent_unstable < 0)
			percent_unstable = 0
		else
			if(percent_unstable > 1)
				percent_unstable = 1
			if(percent_unstable > 0)
				percent_unstable = max(0, percent_unstable-rand(0.01,0.03))
				UpdateVisuals()

	if(percent_unstable >= 1)
		owned_core.Shutdown(force_rupture=1)
	else
		if(percent_unstable > 0.5 && prob(percent_unstable*100))
			var/ripple_radius = (((size-1) / 2) * WORLD_ICON_SIZE) + WORLD_ICON_SIZE
			var/wave_size = 4
			if(plasma_temperature < FUSION_RUPTURE_THRESHOLD)
				visible_message(SPAN_DANGER("\The [src] ripples uneasily, like a disturbed pond."))
			else
				var/flare
				var/fuel_loss
				var/rupture
				if(percent_unstable < 0.7)
					visible_message(SPAN_DANGER("\The [src] ripples uneasily, like a disturbed pond."))
					fuel_loss = prob(5)
				else if(percent_unstable < 0.9)
					visible_message(SPAN_DANGER("\The [src] undulates violently, shedding plumes of plasma!"))
					flare = prob(50)
					fuel_loss = prob(20)
					rupture = prob(5)
					wave_size += 2
				else
					visible_message(SPAN_DANGER("\The [src] is wracked by a series of horrendous distortions, buckling and twisting like a living thing!"))
					flare = 1
					fuel_loss = prob(50)
					rupture = prob(25)
					wave_size += 4

				if(rupture)
					owned_core.Shutdown(force_rupture=1)
				else
					var/lost_plasma = (plasma_temperature*percent_unstable)
					radiation += lost_plasma
					if(flare)
						radiation += plasma_temperature/2
						wave_size += 6
					plasma_temperature -= lost_plasma

					if(fuel_loss)
						for(var/particle in reactants)
							var/lost_fuel = reactants[particle]*percent_unstable
							radiation += lost_fuel
							reactants[particle] -= lost_fuel
							if(reactants[particle] <= 0)
								reactants.Remove(particle)
					Radiate()
			Ripple(wave_size, ripple_radius)
	return

/obj/effect/fusion_em_field/proc/Ripple(_size, _radius)
	if(!animating_ripple)
		UNLINT(var/dm_filter/ripple = filters[1])
		UNLINT(ripple.size = _size)
		animate(filters[1], time = 0, loop = 1, radius = 0, flags=ANIMATION_PARALLEL)
		animate(time = 2 SECONDS, radius = _radius)
		animating_ripple = TRUE
		addtimer(new Callback(src, .proc/ResetRipple), 2 SECONDS, TIMER_CLIENT_TIME)

/obj/effect/fusion_em_field/proc/ResetRipple()
	animating_ripple = FALSE

/obj/effect/fusion_em_field/proc/is_shutdown_safe()
	return plasma_temperature < 1000

/obj/effect/fusion_em_field/proc/Rupture()
	visible_message(SPAN_DANGER("\The [src] shudders like a dying animal before flaring to eye-searing brightness and rupturing!"))
	set_light(1, 0.1, 15, 2, "#ccccff")
	empulse(get_turf(src), Ceil(plasma_temperature/1000), Ceil(plasma_temperature/300))
	sleep(5)
	RadiateAll()
	explosion(get_turf(owned_core), 8, EX_ACT_LIGHT) // Blow out all the windows.
	return

/obj/effect/fusion_em_field/proc/ChangeFieldStrength(new_strength)
	var/calc_size = 1
	if(new_strength <= 50)
		calc_size = 1
	else if(new_strength <= 200)
		calc_size = 3
	else if(new_strength <= 500)
		calc_size = 5
	else if(new_strength <= 1000)
		calc_size = 7
	else if(new_strength <= 2000)
		calc_size = 9
	else if(new_strength <= 5000)
		calc_size = 11
	else
		calc_size = 13
	field_strength = new_strength
	change_size(calc_size)

/obj/effect/fusion_em_field/proc/AddEnergy(a_energy, a_plasma_temperature)
	energy += a_energy
	plasma_temperature += a_plasma_temperature
	if(a_energy && percent_unstable > 0)
		percent_unstable -= a_energy/10000
		if(percent_unstable < 0)
			percent_unstable = 0
	while(energy >= 100)
		energy -= 100
		plasma_temperature += 1
	UpdateVisuals()

/obj/effect/fusion_em_field/proc/AddParticles(name, quantity = 1)
	if(name in reactants)
		reactants[name] += quantity
	else if(name != "proton" && name != "electron" && name != "neutron")
		reactants.Add(name)
		reactants[name] = quantity
	UpdateVisuals()

/obj/effect/fusion_em_field/proc/RadiateAll(ratio_lost = 1)

	// Create our plasma field and dump it into our environment.
	var/turf/T = get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/plasma
		for(var/reactant in reactants)
			if(!gas_data.name[reactant])
				continue
			if(!plasma)
				plasma = new
			plasma.adjust_gas(reactant, max(1,round(reactants[reactant]*0.1)), 0) // *0.1 to compensate for *10 when uptaking gas.
		if(!plasma)
			return
		plasma.temperature = (plasma_temperature/2)
		plasma.update_values()
		T.assume_air(plasma)
		T.hotspot_expose(plasma_temperature)
		plasma = null

	// Radiate all our unspent fuel and energy.
	for(var/particle in reactants)
		radiation += reactants[particle]
		reactants.Remove(particle)
	radiation += plasma_temperature/2
	plasma_temperature = 0

	SSradiation.radiate(src, round(radiation*0.001))
	Radiate()

/obj/effect/fusion_em_field/proc/Radiate()
	if(istype(loc, /turf))
		var/empsev = max(1, min(3, Ceil(size/2)))
		for(var/atom/movable/AM in range(max(1,Floor(size/2)), loc))

			if(AM == src || AM == owned_core || !AM.simulated)
				continue

			var/skip_obstacle
			for(var/ignore_path in ignore_types)
				if(istype(AM, ignore_path))
					skip_obstacle = TRUE
					break
			if(skip_obstacle)
				continue

			AM.visible_message(SPAN_DANGER("The field buckles visibly around \the [AM]!"))
			tick_instability += rand(30,50)
			AM.emp_act(empsev)

	if(owned_core && owned_core.loc)
		var/datum/gas_mixture/environment = owned_core.loc.return_air()
		if(environment && environment.temperature < (T0C+1000)) // Putting an upper bound on it to stop it being used in a TEG.
			environment.add_thermal_energy(plasma_temperature*20000)
	radiation = 0

/obj/effect/fusion_em_field/proc/change_size(newsize = 1)
	var/changed = 0
	if( ((newsize-1)%2==0) && (newsize<=13) )
		size = newsize
		changed = newsize
		UpdateVisuals()

	for(var/obj/effect/fusion_particle_catcher/catcher in particle_catchers)
		catcher.UpdateSize()
	return changed

//the !!fun!! part
/obj/effect/fusion_em_field/proc/React()
	//loop through the reactants in random order
	var/list/react_pool = reactants.Copy()
	last_reactants = 0

	//cant have any reactions if there aren't any reactants present
	if(length(react_pool))
		//determine a random amount to actually react this cycle, and remove it from the standard pool
		//this is a hack, and quite nonrealistic :(
		for(var/reactant in react_pool)
			react_pool[reactant] = rand(Floor(react_pool[reactant]/2),react_pool[reactant])
			reactants[reactant] -= react_pool[reactant]
			if(!react_pool[reactant])
				react_pool -= reactant

		//loop through all the reacting reagents, picking out random reactions for them
		var/list/produced_reactants = new/list
		var/list/p_react_pool = react_pool.Copy()
		while(length(p_react_pool))
			//pick one of the unprocessed reacting reagents randomly
			var/cur_p_react = pick(p_react_pool)
			p_react_pool.Remove(cur_p_react)

			//grab all the possible reactants to have a reaction with
			var/list/possible_s_reacts = react_pool.Copy()
			//if there is only one of a particular reactant, then it can not react with itself so remove it
			possible_s_reacts[cur_p_react] -= 1
			if(possible_s_reacts[cur_p_react] < 1)
				possible_s_reacts.Remove(cur_p_react)

			//loop through and work out all the possible reactions
			var/list/possible_reactions
			for(var/cur_s_react in possible_s_reacts)
				if(possible_s_reacts[cur_s_react] < 1)
					continue
				var/singleton/fusion_reaction/cur_reaction = get_fusion_reaction(cur_p_react, cur_s_react)
				if(cur_reaction && plasma_temperature >= cur_reaction.minimum_energy_level)
					LAZYDISTINCTADD(possible_reactions, cur_reaction)

			//if there are no possible reactions here, abandon this primary reactant and move on
			if(!LAZYLEN(possible_reactions))
				continue

			/// Sort based on reaction priority to avoid deut-deut eating all the deut before deut-trit can run etc.
			sortTim(possible_reactions, /proc/cmp_fusion_reaction_des)

			//split up the reacting atoms between the possible reactions
			while(length(possible_reactions))
				var/singleton/fusion_reaction/cur_reaction = possible_reactions[1]
				possible_reactions.Remove(cur_reaction)

				//set the randmax to be the lower of the two involved reactants
				var/max_num_reactants = react_pool[cur_reaction.p_react] > react_pool[cur_reaction.s_react] ? \
				react_pool[cur_reaction.s_react] : react_pool[cur_reaction.p_react]
				if(max_num_reactants < 1)
					continue

				//make sure we have enough energy
				if(plasma_temperature < cur_reaction.minimum_reaction_temperature)
					continue

				if(plasma_temperature < max_num_reactants * cur_reaction.energy_consumption)
					max_num_reactants = round(plasma_temperature / cur_reaction.energy_consumption)
					if(max_num_reactants < 1)
						continue

				//randomly determined amount to react
				var/amount_reacting = rand(1, max_num_reactants)

				//removing the reacting substances from the list of substances that are primed to react this cycle
				//if there aren't enough of that substance (there should be) then modify the reactant amounts accordingly
				if( react_pool[cur_reaction.p_react] - amount_reacting >= 0 )
					react_pool[cur_reaction.p_react] -= amount_reacting
				else
					amount_reacting = react_pool[cur_reaction.p_react]
					react_pool[cur_reaction.p_react] = 0
				//same again for secondary reactant
				if(react_pool[cur_reaction.s_react] - amount_reacting >= 0 )
					react_pool[cur_reaction.s_react] -= amount_reacting
				else
					react_pool[cur_reaction.p_react] += amount_reacting - react_pool[cur_reaction.p_react]
					amount_reacting = react_pool[cur_reaction.s_react]
					react_pool[cur_reaction.s_react] = 0

				plasma_temperature -= max_num_reactants * cur_reaction.energy_consumption  // Remove the consumed energy.
				plasma_temperature += max_num_reactants * cur_reaction.energy_production   // Add any produced energy.
				radiation +=   max_num_reactants * cur_reaction.radiation           // Add any produced radiation.
				tick_instability += max_num_reactants * cur_reaction.instability
				last_reactants += amount_reacting

				// Create the reaction products.
				for(var/reactant in cur_reaction.products)
					var/success = 0
					for(var/check_reactant in produced_reactants)
						if(check_reactant == reactant)
							produced_reactants[reactant] += cur_reaction.products[reactant] * amount_reacting
							success = 1
							break
					if(!success)
						produced_reactants[reactant] = cur_reaction.products[reactant] * amount_reacting

				// Handle anything special. If this proc returns true, abort the current reaction.
				if(cur_reaction.handle_reaction_special(src))
					return

				// This reaction is done, and can't be repeated this sub-cycle.
				possible_reactions.Remove(cur_reaction.s_react)

		// Loop through the newly produced reactants and add them to the pool.
		for(var/reactant in produced_reactants)
			AddParticles(reactant, produced_reactants[reactant])

		// Check whether there are reactants left, and add them back to the pool.
		for(var/reactant in react_pool)
			AddParticles(reactant, react_pool[reactant])

	UpdateVisuals()

/obj/effect/fusion_em_field/Destroy()
	set_light(0)
	RadiateAll()
	QDEL_NULL_LIST(particle_catchers)
	if(owned_core)
		owned_core.owned_field = null
		owned_core = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/fusion_em_field/bullet_act(obj/item/projectile/Proj)
	AddEnergy(Proj.damage)
	update_icon()
	return 0

#undef FUSION_INSTABILITY_DIVISOR
#undef FUSION_RUPTURE_THRESHOLD
#undef FUSION_REACTANT_CAP
