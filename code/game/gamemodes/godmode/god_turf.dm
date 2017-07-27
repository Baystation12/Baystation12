/turf/simulated/floor/deity
	var/mob/living/deity/linked_god

/turf/simulated/floor/deity/proc/sync_god(var/god)
	if(god)
		linked_god = god
		linked_god.adjust_source(1,src)
		set_flooring(get_flooring_data(linked_god.form.floor_decl))
		update_icon(1)
		levelupdate()
		linked_god.form.sync_structure(src)

/turf/simulated/floor/deity/Destroy() //Just in case
	make_plating(1)
	return ..()

//If we are being made into plating, our current turf is being 'destroyed', so do removal of power n stuff.
/turf/simulated/floor/deity/make_plating(var/place_product, var/defer_icon_update)
	if(flooring && linked_god)
		linked_god.adjust_source(-1,src)
		linked_god = null
	..()