#define TRACK_PROJECTILE_IMPACT_RESET_DELAY 30

/obj/item/projectile/overmap
	var/obj/effect/projectile/ship_damage_projectile = /obj/item/projectile/overmap_test_round //This is the projectile used when this impacts a ship on the overmap. This is spawned in a random connected z-level of that overmap ship object.
	step_delay = 1 SECOND //These will only be traversing overmap tiles.
	var/obj/effect/overmap/overmap_fired_by
	var/obj/machinery/overmap_weapon_console/console_fired_by = null
	var/sound/ship_hit_sound //This sound is played across the entire impacted ship when the overmap projectile spawns the ship_damage_projectile
	var/list/target_bounds = null
	accuracy = 100

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
	if(!isnull(overmap_fired_by) && object_hit == overmap_fired_by.targeting_datum.current_target)
		var/list/new_bounds = overmap_fired_by.targeting_datum.get_target_location_coord_list()
		hit_bounds = new_bounds
	sector_hit_effects(z_level,object_hit,hit_bounds)

/obj/item/projectile/overmap/proc/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	var/turf/turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	if(istype(turf_to_explode,/turf/simulated/open)) // if the located place is an open space it goes to the next z-level
		var/prev_index = hit.map_z.Find(z_level)
		if(hit.map_z.len > 1 && prev_index != 1)
			z_level = hit.map_z[prev_index++]
	turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	explosion(turf_to_explode,9,15,21,30, adminlog = 0) //explosion(turf_to_explode,3,5,7,10) original tiny explosion
	var/obj/effect/overmap/sector/S = map_sectors["[src.z]"]
	S.adminwarn_attack()

/obj/item/projectile/overmap/proc/do_z_level_proj_spawn(var/z_level,var/obj/effect/overmap/ship/overmap_object_hit)
	var/start_co_ords
	var/end_co_ords
	var/list/bounds_to_use = overmap_object_hit.map_bounds
	if(!isnull(overmap_fired_by) && overmap_object_hit == overmap_fired_by.targeting_datum.current_target)
		var/list/new_bounds = overmap_fired_by.targeting_datum.get_target_location_coord_list()
		var/prob_hit_newbounds
		if(overmap_object_hit.fore_dir == EAST || WEST)
			prob_hit_newbounds = ((new_bounds[3] - new_bounds[1])/(bounds_to_use[3] - bounds_to_use[1])) * 100
		else
			prob_hit_newbounds = ((new_bounds[4] - new_bounds[2])/(bounds_to_use[4] - bounds_to_use[2])) * 100
		if(prob(prob_hit_newbounds))
			bounds_to_use = new_bounds
		else
			return 0

	if(overmap_object_hit.fore_dir == EAST || WEST)
		start_co_ords = generate_co_ords_x_start(bounds_to_use)
		end_co_ords = generate_co_ords_x_end(start_co_ords,bounds_to_use)
	else if(overmap_object_hit.fore_dir == NORTH || SOUTH)
		start_co_ords = generate_co_ords_y_start(bounds_to_use)
		end_co_ords = generate_co_ords_y_end(start_co_ords,bounds_to_use)
	var/turf/proj_spawn_loc = locate(start_co_ords[1],start_co_ords[2],z_level)
	var/turf/proj_end_loc = locate(end_co_ords[1],end_co_ords[2],z_level)
	var/obj/item/projectile/new_proj = new ship_damage_projectile (proj_spawn_loc)
	new_proj.starting = proj_spawn_loc
	new_proj.original = proj_end_loc
	new_proj.firer = firer
	if(damage > new_proj.damage)
		new_proj.damage = damage

	if(istype(console_fired_by) && console_fired_by.do_track_fired_proj && isnull(console_fired_by.currently_tracked_proj))
		var/obj/item/projectile/camera_track/camera_track_proj = new /obj/item/projectile/camera_track (proj_spawn_loc)
		console_fired_by.currently_tracked_proj = camera_track_proj
		camera_track_proj.firer = firer
		camera_track_proj.penetrating = new_proj.penetrating
		camera_track_proj.source_console = console_fired_by
		camera_track_proj.launch(proj_end_loc)

	new_proj.launch(proj_end_loc)
	if(ship_hit_sound)
		for(var/z_level_om in overmap_object_hit.map_z)
			playsound(locate(new_proj.x,new_proj.y,z_level_om), ship_hit_sound, 25,1, 255,,1)
	return 1

/obj/item/projectile/overmap/on_impact(var/atom/impacted)
	var/obj/effect/overmap/overmap_object = impacted
	var/chosen_impact_z

	if(!istype(overmap_object))
		return 0
	if(!(starting in trange(1,impacted)) && prob(overmap_object.weapon_miss_chance * (1- accuracy/100))) //accuracy = 1 means miss chance is multiplied by 0.99
		visible_message("<span class = 'warning'>[src] flies past [impacted].</span>")
		return 0
	if(istype(impacted,/obj/effect/overmap/ship/npc_ship))
		var/obj/effect/overmap/ship/npc_ship/ship = impacted
		if(ship.unload_at)
			ship.take_projectiles(src,0)
			if(overmap_object.map_z.len > 0)
				chosen_impact_z = pick(overmap_object.map_z)
				do_z_level_proj_spawn(chosen_impact_z,overmap_object)
			qdel(src)
			return
		else
			ship.take_projectiles(src)
			return 0
	if(overmap_object.map_z.len == 0)
		return
	chosen_impact_z = pick(overmap_object.map_z)
	if(istype(impacted,/obj/effect/overmap/sector))
		do_sector_hit(overmap_object.map_z[1],impacted) //this is so it only hits the upper z-levels in planets

	else if(istype(impacted,/obj/effect/overmap/ship))
		do_z_level_proj_spawn(chosen_impact_z,overmap_object)
	qdel(src)
	return 1

//Placeholder "camera track" projectile
/obj/item/projectile/camera_track
	invisibility = 101
	step_delay = 0.7
	nodamage = 1
	var/obj/machinery/overmap_weapon_console/source_console

/obj/item/projectile/camera_track/proc/firer_using_console()
	var/mob/living/carbon/human/firer_h = firer
	if(istype(firer_h.l_hand,/obj/item/weapon/gun/aim_tool) || istype(firer_h.r_hand,/obj/item/weapon/gun/aim_tool))
		return 1
	return 0

/obj/item/projectile/camera_track/launch(var/atom/launchat)
	if(firer_using_console())
		firer.reset_view(src)
	. = ..()

/obj/item/projectile/camera_track/on_impact(var/atom/impacted)
	if(impacted.loc == null || loc == null)
		return ..()
	var/obj/item/projectile/camera_track/r = new /obj/item/projectile/camera_track/residual (loc)
	r.firer = firer
	r.penetrating = penetrating
	r.source_console = source_console
	r.original = impacted
	firer.reset_view(firer)
	firer.reset_view(r)
	r.launch(original)
	. = ..()

/obj/item/projectile/camera_track/residual/launch() //This is left over for a short time when camera_track projectiles impact other objects.
	spawn(TRACK_PROJECTILE_IMPACT_RESET_DELAY)
		source_console.currently_tracked_proj = null
		if(firer_using_console())
			firer.reset_view(map_sectors["[source_console.z]"])
		qdel()

//Base Ship Damage Projectile//

/obj/item/projectile/overmap_test_round/on_impact(var/atom/impacted)
	explosion(impacted,1,3,5,10)

#undef TRACK_PROJECTILE_IMPACT_RESET_DELAY
