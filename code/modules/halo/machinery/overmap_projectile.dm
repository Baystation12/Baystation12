
/obj/item/projectile/overmap

	var/obj/effect/projectile/ship_damage_projectile = /obj/item/projectile/overmap_test_round //This is the projectile used when this impacts a ship on the overmap. This is spawned in a random connected z-level of that overmap ship object.
	step_delay = 1 SECOND //These will only be traversing overmap tiles.

/obj/item/projectile/overmap/Move(var/newloc,var/dir)
	if(istype(newloc,/turf/unsimulated/map/edge))
		qdel(src)
		return
	.=..()

/obj/item/projectile/overmap/proc/generate_co_ords_x_start(var/obj/effect/overmap/ship/o_obj)
	var/co_ords = list(1,1)
	co_ords[1] = rand(o_obj.map_bounds[3],o_obj.map_bounds[1])
	co_ords[2] = text2num(pick("[o_obj.map_bounds[2]]","[o_obj.map_bounds[4]]"))
	return co_ords

/obj/item/projectile/overmap/proc/generate_co_ords_y_start(var/obj/effect/overmap/ship/o_obj)
	var/co_ords = list(1,1)
	co_ords[2] = rand(o_obj.map_bounds[4],o_obj.map_bounds[2])
	co_ords[1] = text2num(pick("[o_obj.map_bounds[1]]","[o_obj.map_bounds[3]]"))
	return co_ords

/obj/item/projectile/overmap/proc/generate_co_ords_x_end(var/start_co_ords,var/obj/effect/overmap/ship/o_obj)
	var/co_ords = list(1,1)
	co_ords[1] = start_co_ords[1] + rand(-dispersion,dispersion)
	if(start_co_ords[2] == o_obj.map_bounds[2])
		co_ords[2] = o_obj.map_bounds[4]
		return co_ords
	else if(start_co_ords[2] == o_obj.map_bounds[4])
		co_ords[2] = o_obj.map_bounds[2]
		return co_ords

/obj/item/projectile/overmap/proc/generate_co_ords_y_end(var/start_co_ords,var/obj/effect/overmap/ship/o_obj)
	var/co_ords = list(1,1)
	co_ords[2] = start_co_ords[2] + rand(-dispersion,dispersion)
	if(start_co_ords[1] == o_obj.map_bounds[1])
		co_ords[1] = o_obj.map_bounds[3]
		return co_ords
	else if(start_co_ords[1] == o_obj.map_bounds[3])
		co_ords[1] = o_obj.map_bounds[1]
		return co_ords

/obj/item/projectile/overmap/proc/do_z_level_proj_spawn(var/z_level,var/obj/effect/overmap/ship/overmap_object_hit)
	var/start_co_ords
	var/end_co_ords
	if(overmap_object_hit.fore_dir == EAST || WEST)
		start_co_ords = generate_co_ords_x_start(overmap_object_hit)
		end_co_ords = generate_co_ords_x_end(start_co_ords,overmap_object_hit)
	else if(overmap_object_hit.fore_dir == NORTH || SOUTH)
		start_co_ords = generate_co_ords_y_start(overmap_object_hit)
		end_co_ords = generate_co_ords_y_end(start_co_ords,overmap_object_hit)
	var/turf/proj_spawn_loc = locate(start_co_ords[1],start_co_ords[2],z_level)
	var/turf/proj_end_loc = locate(end_co_ords[1],end_co_ords[2],z_level)
	var/obj/item/projectile/new_proj = new ship_damage_projectile
	new_proj.loc = proj_spawn_loc
	new_proj.launch(proj_end_loc)

/obj/item/projectile/overmap/on_impact(var/atom/impacted)
	var/obj/effect/overmap/ship/overmap_object
	if(istype(impacted,/obj/effect/overmap/ship))
		overmap_object = impacted
	else
		for(var/obj/effect/overmap/ship/o_obj in impacted.loc.contents)
			overmap_object = o_obj
			break
	if(!overmap_object)
		return
	var/chosen_impact_z = pick(overmap_object.map_z)

	do_z_level_proj_spawn(chosen_impact_z,overmap_object)
	qdel(src)
	return 1

//Base Ship Damage Projectile//

/obj/item/projectile/overmap_test_round/on_impact(var/atom/impacted)
	explosion(impacted,1,3,5,10)
