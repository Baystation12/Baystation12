
/datum/support_option/supply_drop/evac
	name = "Call For Evac (UNSC)"
	desc = "Requests an evacuation transport at your current position. Will take you back to a safe area, usually."
	rank_required = 1
	cooldown_inflict = 6 MINUTES
	scatter_dist = 1
	item_to_drop = /obj/effect/evac_area
	var/evac_stay_duration = 20 SECONDS
	var/tag_evac_to = "unscevachere"
	var/fallbacks = 1 //The amount of "fallbacks" it should check if it cannot find the first evac tag.

/datum/support_option/supply_drop/evac/create_drop_item(var/turf/turf_at,var/mob/activator)
	. = ..()
	var/obj/effect/evac_area/a = .
	a.set_evac_time(evac_stay_duration)
	var/atom/evac_to = locate("[tag_evac_to]")
	if(!evac_to)
		if(fallbacks > 0)
			for(var/i = 1 to fallbacks + 1)
				evac_to = locate("[tag_evac_to][i]")//unscevachere1,unscevachere2 etc etc
				if(evac_to)
					break
			return
	a.set_evac_to(get_turf(evac_to))

/obj/effect/evac_area
	name = "Evacuation Zone"
	desc = "Stepping into this will prompt you to evacuate, stunning you for a duration as you board the evacuation craft."
	icon = 'code/modules/halo/icons/evac_zones.dmi'
	icon_state = "evac"
	bounds = "96,96"
	mouse_opacity = 0
	opacity = 0
	density = 0

	var/evac_end_at = 0
	var/evac_to = null
	var/evac_delay = 5 //This is in seconds.

/obj/effect/evac_area/proc/set_evac_time(var/time)
	evac_end_at = world.time + time
	GLOB.processing_objects += src

/obj/effect/evac_area/proc/set_evac_to(var/to_spot)
	evac_to = to_spot

/obj/effect/evac_area/proc/evac_mob(var/mob/to_evac)
	if(!evac_to)
		return
	to_evac.forceMove(evac_to)

/obj/effect/evac_area/process()
	if(world.time > evac_end_at)
		qdel(src)

/obj/effect/evac_area/Crossed(var/mob/living/crosser)
	. = ..()
	if(crosser.stat == CONSCIOUS && crosser.client && crosser.grabbed_by.len == 0)
		spawn()
			if(alert(crosser,"Proceed to evacuation?","Evacuate?","Yes","No") == "Yes")
				visible_message("<span class = 'warning'>[crosser] starts preparing to evacuate...</span>")
				crosser.Stun(evac_delay)
				sleep(evac_delay SECONDS)
				if(crosser.stat == CONSCIOUS && crosser.loc in locs)
					evac_mob(crosser)
					visible_message("<span class = 'warning'>[crosser] evacuates the area.</span>")


/datum/support_option/supply_drop/evac/cov
	name = "Call For Evac (Covenant)"
	arrival_sfx = 'code/modules/halo/sound/sprit_flyby.ogg'
	drop_delay = 2 SECONDS
	tag_evac_to = "covevacto"
	fallbacks = 0
