#define DEFAULT_SEED "glowshroom"

/obj/effect/plant
	name = "plant"
	anchored = 1
	opacity = 0
	density = 0
	icon = 'icons/obj/hydroponics_growing.dmi'
	icon_state = "bush4-1"
	layer = 2.1

	var/health = 100
	var/max_health = 100

	var/obj/effect/plant/parent
	var/datum/seed/seed
	var/floor = 0
	var/spread_chance = 40
	var/spread_into_adjacent = 60
	var/evolve_chance = 2
	var/last_tick = 0
	var/hibernating = 0

/obj/effect/plant/single
	spread_chance = 0

/obj/effect/plant/New(var/newloc, var/datum/seed/newseed)

	..()
	if(!newseed)
		newseed = DEFAULT_SEED
	seed = newseed
	if(!seed)
		del(src)
		return

	max_health = seed.get_trait(TRAIT_ENDURANCE)
	health = max_health

	set_dir(calc_dir())
	update_icon()
	processing_objects |= src
	last_tick = world.timeofday

/obj/effect/plant/update_icon()

	// TODO: convert this to an icon cache.
	icon_state = "[seed.get_trait(TRAIT_PLANT_ICON)]-[rand(1,max(1,round(seed.growth_stages/2)))]"
	color = seed.get_trait(TRAIT_PLANT_COLOUR)
	if(!floor)
		// This should make the plant grow flush against the wall it's meant to be growing from.
		pixel_y = -(rand(8,12))
		src.transform = null
		var/matrix/M = matrix()
		switch(dir)
			if(WEST)
				M.Turn(90)
			if(NORTH)
				M.Turn(180)
			if(EAST)
				M.Turn(270)
		src.transform = M

	// Apply colour and light from seed datum.
	if(seed.get_trait(TRAIT_BIOLUM))
		SetLuminosity(1+round(seed.get_trait(TRAIT_POTENCY)/10))
		if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
			l_color = seed.get_trait(TRAIT_BIOLUM_COLOUR)
		else
			l_color = null
		return
	else
		SetLuminosity(0)

/obj/effect/plant/Del()
	processing_objects -= src
	..()

/obj/effect/plant/proc/die_off()
	// Kill off any of our children (and add an added bonus, other plants in this area)
	for(var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant in get_turf(src))
		plant.dead = 1
		plant.update_icon()
	// Cause the plants around us to update.
	for(var/obj/effect/plant/neighbor in view(1,src))
		neighbor.hibernating = 0
	del(src)

/obj/effect/plant/process()

	if(!seed)
		die_off()

	// Handle life.
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		health -= seed.handle_environment(T, T.return_air(),1)

	// Hibernating or too far from parent, no chance of spreading.
	if(hibernating || (parent && (get_dist(parent,src) > seed.get_trait(TRAIT_POTENCY)/15)))
		return

	// Count our neighbors and possible locations for spreading.
	var/list/possible_locs = list()
	var/count = 0
	for(var/turf/simulated/floor/floor in view(1,src))
		if(!floor.Adjacent(src) || floor.density || (locate(/obj/effect/plant) in floor.contents))
			count++
			continue
		possible_locs |= floor

	//Entirely surrounded, spawn an actual plant.
	if(count>=8)
		hibernating = 1 // Suspend processing for now.
		if(!(locate(/obj/machinery/portable_atmospherics/hydroponics/soil/invisible) in T.contents))
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/new_plant = new(T,seed)
			new_plant.age = seed.get_trait(TRAIT_MATURATION)
			new_plant.update_icon()

	if(prob(spread_chance))
		for(var/i=1,i<=seed.get_trait(TRAIT_YIELD),i++)
			if(!possible_locs.len)
				break
			if(prob(spread_into_adjacent))
				var/turf/target_turf = pick(possible_locs)
				possible_locs -= target_turf
				var/obj/effect/plant/child = new(target_turf, seed)
				child.parent = get_root()

/obj/effect/plant/proc/get_root()
	if(parent)
		return parent.get_root()
	else
		return src

/obj/effect/plant/proc/calc_dir(turf/location = loc)
	set background = 1
	var/direction = 16

	for(var/wallDir in cardinal)
		var/turf/newTurf = get_step(location,wallDir)
		if(newTurf.density)
			direction |= wallDir

	for(var/obj/effect/plant/shroom in location)
		if(shroom == src)
			continue
		if(shroom.floor) //special
			direction &= ~16
		else
			direction &= ~shroom.dir

	var/list/dirList = list()

	for(var/i=1,i<=16,i <<= 1)
		if(direction & i)
			dirList += i

	if(dirList.len)
		var/newDir = pick(dirList)
		if(newDir == 16)
			floor = 1
			newDir = 1
		return newDir

	floor = 1
	return 1

/obj/effect/plant/attackby(var/obj/item/weapon/W, var/mob/user)

	if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		if(!seed)
			user << "There is nothing to take a sample from in \the [src]."
			return
		// Create a sample.
		seed.harvest(user,0,1)
		health -= (rand(3,5)*10)
	else
		..()
		if(W.force)
			health -= W.force
	check_health()

/obj/effect/plant/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
		else
	return

/obj/effect/plant/proc/check_health()
	if(health <= 0)
		del(src)