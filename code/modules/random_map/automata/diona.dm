/turf/simulated/wall/diona/New(var/newloc)
	..(newloc,"biomass")

/turf/simulated/wall/diona/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(istype(user, /mob/living/carbon/alien/diona))
		if(can_open == WALL_OPENING)
			return
		can_open = WALL_CAN_OPEN
		user.visible_message("<span class='alium'>\The [user] strokes its feelers against \the [src] and the biomass [density ? "moves aside" : "closes up"].</span>")
		toggle_open(user)
		sleep(15)
		if(can_open == WALL_CAN_OPEN) can_open = 0
	else
		return ..(user, damage, attack_message)

/obj/structure/diona
	icon = 'icons/obj/diona.dmi'
	anchored = 1
	density = 1
	opacity = 0
	layer = TURF_LAYER + 0.01

/obj/structure/diona/vines
	name = "alien vines"
	desc = "Thick, heavy vines of some sort."
	icon_state = "vines3"
	var/growth = 0

/obj/structure/diona/vines/proc/spread()
	var/turf/origin = get_turf(src)
	for(var/turf/T in range(src,2))
		if(T.density || T == origin || istype(T, /turf/space))
			continue
		var/new_growth = 1
		switch(get_dist(origin,T))
			if(0)
				new_growth = 3
			if(1)
				new_growth = 2
		var/obj/structure/diona/vines/existing = locate() in T
		if(!istype(existing)) existing = PoolOrNew(/obj/structure/diona/vines, T)
		if(existing.growth < new_growth)
			existing.growth = new_growth
			existing.update_icon()

/obj/structure/diona/vines/update_icon()
	icon_state = "vines[growth]"

/obj/structure/diona/bulb
	name = "glow bulb"
	desc = "A glowing bulb of some sort."
	icon_state = "glowbulb"

/obj/structure/diona/bulb/New(var/newloc)
	..()
	set_light(3,3,"#557733")

/datum/random_map/automata/diona
	iterations = 3
	descriptor = "diona gestalt"
	limit_x = 32
	limit_y = 32

	wall_type = /turf/simulated/wall/diona
	floor_type = /turf/simulated/floor/diona

// This is disgusting.
/datum/random_map/automata/diona/proc/search_neighbors_for(var/search_val, var/x, var/y)
	var/current_cell = get_map_cell(x-1,y-1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x-1,y)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x-1,y+1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x,y-1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x,y+1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x+1,y-1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x+1,y)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x+1,y+1)
	if(current_cell && map[current_cell] == search_val) return 1
	return 0

/datum/random_map/automata/diona/cleanup()

	// Hollow out the interior spaces.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell) continue
			if(map[current_cell] == WALL_CHAR)
				if(!search_neighbors_for(FLOOR_CHAR,x,y) && !search_neighbors_for(DOOR_CHAR,x,y) && !(x == 1 || y == 1 || x == limit_x || y == limit_y))
					map[current_cell] = EMPTY_CHAR

	// Prune exposed floor turfs away from the edges.
	var/changed = 1
	while(changed)
		for(var/x = 1, x <= limit_x, x++)
			for(var/y = 1, y <= limit_y, y++)
				changed = 0
				var/current_cell = get_map_cell(x,y)
				if(!current_cell) continue
				if(map[current_cell] == EMPTY_CHAR)
					if((search_neighbors_for(FLOOR_CHAR,x,y)) || (x == 1 || y == 1 || x == limit_x || y == limit_y))
						map[current_cell] = FLOOR_CHAR
						changed = 1

	// Count and track the floors.
	var/list/floor_turfs = list()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell) continue
			if(map[current_cell] == EMPTY_CHAR)
				floor_turfs |= current_cell

	// Add vine decals.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell || map[current_cell] != EMPTY_CHAR) continue
			if(search_neighbors_for(WALL_CHAR,x,y))
				map[current_cell] = DOOR_CHAR

	// Add bulbs and doona nymphs.
	if(floor_turfs.len)
		var/bulb_count = rand(round(floor_turfs.len/10),round(floor_turfs.len/8))
		while(floor_turfs.len && bulb_count)
			var/cell = pick(floor_turfs)
			floor_turfs -= cell
			map[cell] = ARTIFACT_CHAR
			bulb_count--
		if(floor_turfs.len)
			var/nymph_count = rand(round(floor_turfs.len/10),round(floor_turfs.len/8))
			while(floor_turfs.len && nymph_count)
				var/cell = pick(floor_turfs)
				floor_turfs -= cell
				map[cell] = MONSTER_CHAR
				nymph_count--
	return

/datum/random_map/automata/diona/get_appropriate_path(var/value)
	switch(value)
		if(EMPTY_CHAR, DOOR_CHAR, MONSTER_CHAR, ARTIFACT_CHAR)
			return floor_type
		if(WALL_CHAR)
			return wall_type

/datum/random_map/automata/diona/get_additional_spawns(var/value, var/turf/T)

	if(value != FLOOR_CHAR)
		for(var/thing in T)
			if(istype(thing, /atom))
				var/atom/A = thing
				if(A.simulated)
					continue
			qdel(thing)

	switch(value)
		if(ARTIFACT_CHAR)
			PoolOrNew(/obj/structure/diona/bulb,T)
		if(MONSTER_CHAR)
			spawn_diona_nymph(T)
		if(DOOR_CHAR)
			var/obj/structure/diona/vines/V = PoolOrNew(/obj/structure/diona/vines,T)
			V.growth = 3
			V.update_icon()
			spawn(1)
				V.spread()