
/obj/effect/step_trigger/auto_aa
	stopper = 0
	var/obj/structure/automated_anti_air/our_AA

/obj/effect/step_trigger/auto_aa/Trigger(var/atom/movable/A)
	var/obj/vehicles/air/v = A
	if(istype(v) && v.elevation > BASE_ELEVATION && v.faction != our_AA.faction_nofire)
		our_AA.add_target(v)

/obj/structure/automated_anti_air
	name = "Automated Anti-Air Emplacement"
	desc = "Fires at air vehicles within its range."
	icon = 'code/modules/halo/weapons/icons/automated_anti_air.dmi'
	icon_state = "flakthurm"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	anchored = 1

	var/list/targets_tracking = list() //target = first detected time
	var/list/our_triggers = list()
	var/trigger_type = /obj/effect/step_trigger/auto_aa
	var/fire_anim_state = "flakthurm_active"
	var/fire_sfx = null
	var/faction_nofire = null
	var/base_dispersion = 7
	var/max_range = 21
	var/max_lockon_time = 7.5 SECONDS
	var/active = 1
	var/processing = 0

/obj/structure/automated_anti_air/unsc
	name = "Automated Anti-Air Emplacement"
	desc = "Fires at air vehicles within its range."
	icon = 'code/modules/halo/weapons/icons/automated_anti_air.dmi'
	icon_state = "flakthurm"
	fire_anim_state = "flakthurm_active"
	faction_nofire = "unsc"
	pixel_x = -7

/obj/structure/automated_anti_air/Initialize()
	. = ..()
	create_triggers()

/obj/structure/automated_anti_air/proc/create_triggers()
	for(var/turf/t in trange(max_range,loc))
		var/obj/effect/step_trigger/auto_aa/trigger = new trigger_type (t)
		trigger.our_AA = src
		our_triggers += trigger

/obj/structure/automated_anti_air/proc/add_target(var/targ)
	if(targ in targets_tracking)
		return
	targets_tracking[targ] = world.time
	if(!processing)
		GLOB.processing_objects += src
		processing = 1

/obj/structure/automated_anti_air/proc/remove_target(var/targ)
	targets_tracking -= targ
	if(targets_tracking.len == 0)
		GLOB.processing_objects -= src
		processing = 0

/obj/structure/automated_anti_air/proc/check_target_still_valid(var/atom/targ)
	if(isnull(targ.loc))
		return 0
	var/obj/vehicles/v = targ
	if(v.movement_destroyed)
		return 0
	return 1

/obj/structure/automated_anti_air/proc/do_AA_effect_at(var/turf/location)
	explosion(location,-1,1,-1,10)

/obj/structure/automated_anti_air/process()
	if(!active)
		return
	for(var/atom/movable/target in targets_tracking)
		if(!check_target_still_valid(target) || get_dist(get_turf(src),get_turf(target)) > max_range)
			remove_target(target)
			continue
		var/dispersion = 0
		var/time_locked_on = world.time - targets_tracking[target]
		if(time_locked_on > max_lockon_time)
			dispersion = 0
		else
			dispersion = round(base_dispersion * (1 - (time_locked_on/max_lockon_time)))//base dispersion value * (1 - (CURR TIME / LOCKON TIME) 1/5
		var/offset_x = prob(50) ? -dispersion : dispersion
		var/offset_y = prob(50) ? -dispersion : dispersion
		var/turf/start_loc = get_turf(target)
		var/turf/effect_at = locate(start_loc.x + offset_x, start_loc.y + offset_y,start_loc.z)
		if(effect_at)
			do_AA_effect_at(effect_at)
			if(fire_anim_state)
				flick(fire_anim_state,src)
