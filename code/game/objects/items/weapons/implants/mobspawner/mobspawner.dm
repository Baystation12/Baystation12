/obj/item/implant/processing/mobspawner
	abstract_type = /obj/item/implant/processing/mobspawner
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_BLUESPACE = 4)
	/// Next minimum world.time to spawn a mob.
	var/process_next_ds = 0
	/// Base mob type of what this is spawning. Used for limiting mob types around the implantee as not to overwhelm them.
	var/base_mob_type = /mob

	// adminbus vars
	/// Average wait time to spawn a mob.
	var/wait_time = 60 SECONDS
	/// Variation added or subtracted to wait_time on when to spawn a mob.
	var/wait_variation = 15 SECONDS
	// Limit of mobs that may be nearby the implantee
	var/mob_limit = 10
	/// Lower random limit of mobs spawned from this implant until it expires. Has no runtime effects.
	var/max_spawned_rand_lower_bound = 5
	/// Upper random limit of mobs spawned from this implant until it expires. Has no runtime effects.
	var/max_spawned_rand_uppser_bound = 7
	/// Number of remaining spawns until it expires.
	var/spawns_remaining

/obj/item/implant/processing/mobspawner/New(loc, ...)
	. = ..()
	spawns_remaining = rand(max_spawned_rand_lower_bound, max_spawned_rand_uppser_bound)

/obj/item/implant/processing/mobspawner/get_data()
	return {"
	<b>Implant Specifications:</b><br>
	This implant will materialize creatures near the implantee.
	First creature will materialize on average every [wait_time / 10] seconds, varied by [wait_variation / 10] seconds.<br>
	"}

/// Returns an exact mob type to spawn. Be sure to override this.
/obj/item/implant/processing/mobspawner/proc/get_mob_type()
	return

/obj/item/implant/processing/mobspawner/Process()
	. = ..()
	if (. == PROCESS_KILL)
		return
	if (process_next_ds > world.time)
		return
	if (imp_in.stat == DEAD)
		return PROCESS_KILL
	set_next_process_time()

	var/list/around_us = oview(7, get_turf(imp_in))
	var/list/mob_types_around = filter_list(around_us, base_mob_type)
	var/mobs_around = 0
	for (var/mob/mob_around in mob_types_around)
		if (mob_around.stat == CONSCIOUS)
			mobs_around++
	if (mobs_around >= mob_limit)
		return // cool off a bit

	var/list/floor_list_near_us = filter_list(around_us, /turf/simulated/floor)
	if (!length(floor_list_near_us))
		return
	var/turf/simulated/floor/floor = pick(floor_list_near_us)
	playsound(floor, 'sound/effects/phasein.ogg', 100, TRUE)
	to_chat(imp_in, FONT_LARGE(SPAN_DANGER("Something inside of you crackles. It feels unpleasant.")))

	var/spawned_type = get_mob_type()
	var/mob/spawned_mob = new spawned_type()
	spawned_mob.loc = floor
	phase_in_anim(spawned_mob)

	if (!spawns_remaining--)
		return PROCESS_KILL

/obj/item/implant/processing/mobspawner/implanted(mob/source)
	. = ..()
	set_next_process_time()

/obj/item/implant/processing/mobspawner/proc/set_next_process_time()
	process_next_ds = world.time + (wait_time + rand(wait_variation * -1, wait_variation))

/obj/item/implant/processing/mobspawner/proc/phase_in_anim(mob/mob)
	return

/obj/item/implant/processing/mobspawner/islegal()
	return FALSE
