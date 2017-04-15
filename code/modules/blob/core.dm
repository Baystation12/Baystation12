/obj/structure/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_core"

	max_health = 200
	regen_rate = 2

	layer = BLOB_CORE_LAYER

/obj/structure/blob/core/New()
	. = ..()
	health = max_health
	update_icon()

// Rough icon state changes that reflect the core's health
/obj/structure/blob/core/update_icon()
	var/health_percent = (health / max_health) * 100
	switch(health_percent)
		if(66 to INFINITY)
			icon_state = "blob_core"
		if(33 to 66)
			icon_state = "blob_node"
		if(-INFINITY to 33)
			icon_state = "blob_factory"

/obj/structure/blob/core/New(loc)
	processing_objects.Add(src)
	return ..(loc)

/obj/structure/blob/core/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/structure/blob/core/process()
	regen()
	pulse()

/obj/structure/blob/core/proc/pulse()
	var/strength = CORE_STRENGTH
	for(var/i = 1 to BLOB_MAX_SIZE)
		strength = pulse_nodes(i, strength)
		strength -= STRENGTH_DISTANCE_LOSS
		if(strength <= 0)
			return

/obj/structure/blob/core/proc/pulse_nodes(var/range, var/strength)
	var/list/turf/turfs = list()
	var/list/obj/structure/blob/blobs = list()

	for(var/turf/T in get_turfs(range))
		var/obj/structure/blob/old_blob = locate() in T
		if(old_blob)
			blobs += old_blob
			strength += old_blob.get_strength()
		else
			turfs += T

	if(turfs.len && (strength >= NODE_COST)) // Fill the gaps/expand/attack
		turfs = shuffle(turfs)
		while(turfs.len && (strength >= NODE_COST))
			var/turf/T = turfs[1]
			if(try_expand(T))
				var/obj/structure/blob/new_node = new(T)
				new_node.health = NODE_STARTING_HEALTH
				new_node.update_icon()
				strength -= NODE_COST
			turfs -= T

	if(blobs.len)
		blobs = shuffle(blobs)
		var/i = 1
		while(strength >= REGEN_COST && i <= blobs.len) // Heal the nodes
			var/obj/structure/blob/node = blobs[i]
			if(node.health < node.max_health)
				node.regen()
				strength -= REGEN_COST
			++i

		blobs = shuffle(blobs) // Make shields
		i = 1
		while(strength >= SHIELD_COST && i <= blobs.len)
			var/obj/structure/blob/node = blobs[i]
			if(node.shieldable())
				node.make_shield()
				strength -= SHIELD_COST
			++i

		blobs = shuffle(blobs) // Develop factories
		i = 1
		while(strength > 0 && i <= blobs.len)
			var/obj/structure/blob/factory/node = blobs[i]
			if(istype(node))
				var/use = min(SECONDARY_CORE_SPEED, SECONDARY_CORE_TOTAL_COST - node.build_progress)
				if(strength <= use)
					node.build_progress += strength
					return 0
				else
					strength -= use
					node.build_progress += use
			++i

		if(range < BLOB_MAX_SIZE)
			blobs = shuffle(blobs) // Make factories
			i = 1
			while(strength > SECONDARY_CORE_COST && i <= blobs.len)
				var/obj/structure/blob/node = blobs[i]
				if(node.factorable())
					node.make_factory()
					strength -= SECONDARY_CORE_COST
				++i

	return strength

/obj/structure/blob/core/proc/get_turfs(var/range)
	. = list()
	for(var/turf/T in range(range, src))
		if(get_dist(src, T) < range)
			continue
		var/obj/structure/blob/source
		for(var/i in list(NORTH, SOUTH, WEST, EAST))
			source = locate() in get_step(T, i)
			if(source && source.health == source.max_health)
				. += T
				break

/obj/structure/blob/core/factorable()
	return 0

/obj/structure/blob/core/shieldable()
	return 0
