
#define GAS_CLOUD_EMP_CHANCE 30
#define OVERCHARGE_EXPLOSION_CHANCE 20

/obj/effect/overmap/hazard
	var/list/hazard_datums = list()
	occupy_range = 1

/obj/effect/overmap/hazard/Crossed(var/obj/effect/overmap/ship/crosser)
	if(!istype(crosser))
		return
	for(var/datum in hazard_datums)
		var/datum/overmap_effect/curr = locate(datum) in crosser.active_effects
		if(curr)
			curr.calc_lifetime()
		else
			curr = new datum (crosser)

/obj/effect/overmap/hazard/random
	name = "Unknown Hazard"
	icon_state = "event"

/obj/effect/overmap/hazard/random/Initialize()
	. = ..()
	hazard_datums += pick(typesof(/datum/overmap_effect) -  /datum/overmap_effect)

/datum/overmap_effect
	var/effect_name = "Effect"
	var/announcement_text = null //Should the ship / sector alert the occupants to this taking place and what message should we display.
	var/obj/effect/overmap/target
	var/lifetime = 5 MINUTES
	var/live_until = 0

/datum/overmap_effect/New(var/effect_targ)
	. = ..()
	if(!effect_targ)
		return INITIALIZE_HINT_QDEL
	target = effect_targ
	calc_lifetime()
	if(announcement_text)
		do_announcement()
	if(!effect_created())
		return INITIALIZE_HINT_QDEL
	target.active_effects += src

/datum/overmap_effect/proc/calc_lifetime()
	live_until = world.time + lifetime

/datum/overmap_effect/proc/do_announcement(var/text_display = announcement_text)
	for(var/z_level in target.map_z)
		for(var/mob/player in GLOB.mobs_in_sectors[map_sectors["[z_level]"]])
			to_chat(player,"<span class = 'danger'>[text_display]</span>")

/datum/overmap_effect/proc/effect_created()

/datum/overmap_effect/proc/process_effect()
	if(world.time >= live_until)
		return 0
	return 1

/obj/item/projectile/overmap/meteor
	name = "you shouldn't see this"
	damage = 250
	var/obj/asteroid_spawn = null

/obj/item/projectile/overmap/meteor/New(var/loc,var/ast_type)
	. = ..()
	asteroid_spawn = ast_type

/obj/item/projectile/overmap/meteor/do_z_level_proj_spawn(var/z_level,var/obj/effect/overmap/ship/overmap_object_hit)
	var/list/start_co_ords
	var/list/end_co_ords
	if(overmap_object_hit.fore_dir == EAST || WEST)
		start_co_ords = generate_co_ords_x_start(overmap_object_hit.map_bounds)
		end_co_ords = generate_co_ords_x_end(start_co_ords,overmap_object_hit.map_bounds)
	else if(overmap_object_hit.fore_dir == NORTH || SOUTH)
		start_co_ords = generate_co_ords_y_start(overmap_object_hit.map_bounds)
		end_co_ords = generate_co_ords_y_end(start_co_ords,overmap_object_hit.map_bounds)
	var/turf/proj_spawn_loc = locate(start_co_ords[1],start_co_ords[2],z_level)
	var/turf/proj_end_loc = locate(end_co_ords[1],end_co_ords[2],z_level)

	var/obj/roid = new asteroid_spawn (proj_spawn_loc)
	walk_towards(roid,proj_end_loc,1)
	return 1

/datum/overmap_effect/asteroids
	effect_name = "Asteroid Field"
	announcement_text = "We have entered an asteroid field. Brace for meteorite impact."
	lifetime = 2 MINUTES

/datum/overmap_effect/asteroids/process_effect()
	. = ..()
	if(!.)
		return
	var/obj/asteroid = pick(typesof(/obj/effect/meteor) - /obj/effect/meteor/tunguska)
	var/obj/item/projectile/overmap/om_proj = new /obj/item/projectile/overmap/meteor (target.loc,asteroid)
	om_proj.starting = target.loc
	om_proj.on_impact(target)
	return 1

/datum/overmap_effect/gas_cloud
	effect_name = "Gas Cloud"
	announcement_text = "We have entered a vision-obscuring gas cloud. Hostiles will have a harder time hitting us. Brace for periodic EMP effects."
	lifetime = 2 MINUTES
	var/olddodge = 0

/datum/overmap_effect/gas_cloud/effect_created()
	olddodge = target.weapon_miss_chance
	target.weapon_miss_chance = max(25,target.weapon_miss_chance * 1.5)
	return 1

/datum/overmap_effect/gas_cloud/process_effect()
	. = ..()
	if(!.)
		target.weapon_miss_chance = olddodge
		return
	if(prob(GAS_CLOUD_EMP_CHANCE))
		var/turf/emp_center = locate(rand(target.map_bounds[1],target.map_bounds[3]),rand(target.map_bounds[2],target.map_bounds[4]),pick(target.map_z))
		empulse(emp_center, rand(2, 7), rand(7, 14))
	return 1

/datum/overmap_effect/engine_overcharge
	effect_name = "engine overcharge"
	announcement_text = "Engine power output spiking. Speed safeties overridden, acceleration potential increased beyond safe measures. Brace for ship-wide damage."
	lifetime = 2 MINUTES
	var/oldmax = 0

/datum/overmap_effect/engine_overcharge/effect_created()
	var/obj/effect/overmap/ship/targ_ship = target
	if(!istype(targ_ship))
		return 0
	oldmax = targ_ship.ship_max_speed
	targ_ship.ship_max_speed *= 1.5
	targ_ship.my_pixel_transform.set_new_maxspeed(targ_ship.ship_max_speed)
	return 1

/datum/overmap_effect/engine_overcharge/process_effect()
	. = ..()
	if(!.)
		var/obj/effect/overmap/ship/targ_ship = target
		targ_ship.ship_max_speed = oldmax
		targ_ship.my_pixel_transform.set_new_maxspeed(targ_ship.ship_max_speed)
		return
	if(prob(OVERCHARGE_EXPLOSION_CHANCE))
		var/turf/explode_center = locate(rand(target.map_bounds[1],target.map_bounds[3]),rand(target.map_bounds[2],target.map_bounds[4]),pick(target.map_z))
		explosion(explode_center,-1,1,5,10)

#undef GAS_CLOUD_EMP_CHANCE
#undef OVERCHARGE_EXPLOSION_CHANCE