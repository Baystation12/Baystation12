
/datum/support_option/supply_drop
	name = "Supply Drop"
	desc = "Call in a Supply Drop."
	rank_required = 1
	cooldown_inflict = 2.5 MINUTES
	var/item_to_drop = /obj/structure/closet/crate
	var/arrival_sfx = 'code/modules/halo/sound/start.ogg'
	var/drop_delay = 4 SECONDS //Mostly just to match the fly-over sfx timing
	var/scatter_dist = 4

/datum/support_option/supply_drop/proc/create_drop_item(var/turf/turf_at,var/mob/activator)
	var/obj/dropped = new item_to_drop (turf_at)
	return dropped

/datum/support_option/supply_drop/activate_option(var/turf/origin,var/mob/living/activator)
	var/land_at = origin
	var/list/valids = trange(scatter_dist,origin)
	var/list/holderview = dview(scatter_dist,get_turf(activator))
	for(var/turf/t in valids)
		if(!(t in holderview) || t.density == 1)
			valids -= t
	if(valids.len > 1)
		land_at = pick(valids)

	playsound(land_at,arrival_sfx,100,0,14)
	spawn(drop_delay)
		create_drop_item(land_at,activator)
	return 1

