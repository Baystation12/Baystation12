
/obj/item/projectile/overmap
	var/obj/effect/projectile/ship_damage_projectile = /obj/item/projectile/overmap_test_round //This is the projectile used when this impacts a ship on the overmap. This is spawned in a random connected z-level of that overmap ship object.
	step_delay = 1 SECOND //These will only be traversing overmap tiles.
	var/obj/effect/overmap/overmap_fired_by

/obj/item/projectile/overmap/New(var/obj/spawner)
	if(map_sectors["[spawner.z]"])
		overmap_fired_by = map_sectors["[spawner.z]"]

/obj/item/projectile/overmap/Move(var/newloc,var/dir)
	if(istype(newloc,/turf/unsimulated/map/edge))
		qdel(src)
		return
	.=..()

/obj/item/projectile/overmap/proc/generate_co_ords_x_start(var/list/bounds_list)
	var/co_ords = list(1,1)
	co_ords[1] = rand(bounds_list[3],bounds_list[1])
	co_ords[2] = text2num(pick("[bounds_list[2]]","[bounds_list[4]]"))
	return co_ords

/obj/item/projectile/overmap/proc/generate_co_ords_y_start(var/list/bounds_list)
	var/co_ords = list(1,1)
	co_ords[2] = rand(bounds_list[4],bounds_list[2])
	co_ords[1] = text2num(pick("[bounds_list[1]]","[bounds_list[3]]"))
	return co_ords

/obj/item/projectile/overmap/proc/generate_co_ords_x_end(var/start_co_ords,var/list/bounds_list)
	var/co_ords = list(1,1)
	co_ords[1] = start_co_ords[1] + rand(-dispersion,dispersion)
	if(start_co_ords[2] == bounds_list[2])
		co_ords[2] = bounds_list[4]
		return co_ords
	else if(start_co_ords[2] == bounds_list[4])
		co_ords[2] = bounds_list[2]
		return co_ords

/obj/item/projectile/overmap/proc/generate_co_ords_y_end(var/start_co_ords,var/list/bounds_list)
	var/co_ords = list(1,1)
	co_ords[2] = start_co_ords[2] + rand(-dispersion,dispersion)
	if(start_co_ords[1] == bounds_list[1])
		co_ords[1] = bounds_list[3]
		return co_ords
	else if(start_co_ords[1] == bounds_list[3])
		co_ords[1] = bounds_list[1]
		return co_ords

/obj/item/projectile/overmap/proc/do_sector_hit(var/z_level,var/obj/effect/overmap/object_hit)
	var/list/hit_bounds = object_hit.map_bounds
	if(prob(15))
		hit_bounds  = pick(object_hit.weapon_locations)

	sector_hit_effects(z_level,object_hit,hit_bounds)

/obj/item/projectile/overmap/proc/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	var/turf/turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	if(istype(turf_to_explode,/turf/simulated/open)) // if the located place is an open space it goes to the next z-level
		z_level--
	turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	explosion(turf_to_explode,9,15,21,30) //explosion(turf_to_explode,3,5,7,10) original tiny explosion

/obj/item/projectile/overmap/proc/do_z_level_proj_spawn(var/z_level,var/obj/effect/overmap/ship/overmap_object_hit)
	var/start_co_ords
	var/end_co_ords
	if(overmap_object_hit.fore_dir == EAST || WEST)
		start_co_ords = generate_co_ords_x_start(overmap_object_hit.map_bounds)
		end_co_ords = generate_co_ords_x_end(start_co_ords,overmap_object_hit.map_bounds)
	else if(overmap_object_hit.fore_dir == NORTH || SOUTH)
		start_co_ords = generate_co_ords_y_start(overmap_object_hit.map_bounds)
		end_co_ords = generate_co_ords_y_end(start_co_ords,overmap_object_hit.map_bounds)
	var/turf/proj_spawn_loc = locate(start_co_ords[1],start_co_ords[2],z_level)
	var/turf/proj_end_loc = locate(end_co_ords[1],end_co_ords[2],z_level)
	var/obj/item/projectile/new_proj = new ship_damage_projectile
	new_proj.loc = proj_spawn_loc
	new_proj.launch(proj_end_loc)

/obj/item/projectile/overmap/on_impact(var/atom/impacted)
	var/obj/effect/overmap/overmap_object = impacted
	var/chosen_impact_z

	if(isnull(overmap_object))
		return
	if(!(starting in range(1,impacted)) && prob(overmap_object.weapon_miss_chance * (1- accuracy/100))) //accuracy = 1 means miss chance is multiplied by 0.99
		visible_message("<span class = 'warning'>[src] flies past [impacted].</span>")
		return 0
	if(istype(impacted,/obj/effect/overmap/ship/npc_ship))
		var/obj/effect/overmap/ship/npc_ship/ship = impacted
		if(ship.unload_at)
			ship.take_projectiles(src,0)
			chosen_impact_z = pick(overmap_object.map_z)
			do_z_level_proj_spawn(chosen_impact_z,overmap_object)
			qdel(src)
		else
			ship.take_projectiles(src)
			return 0
	chosen_impact_z = pick(overmap_object.map_z)
	if(istype(impacted,/obj/effect/overmap/sector))
		do_sector_hit(overmap_object.map_z[1],impacted) //this is so it only hits the upper z-levels in planets
		if(istype(src,/obj/item/projectile/overmap/mac))
			overmap_object.hit++

	else if(istype(impacted,/obj/effect/overmap/ship))
		do_z_level_proj_spawn(chosen_impact_z,overmap_object)
	qdel(src)
	return 1

//Base Ship Damage Projectile//

/obj/item/projectile/overmap_test_round/on_impact(var/atom/impacted)
	explosion(impacted,1,3,5,10)
