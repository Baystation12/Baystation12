
/turf/simulated/wall/r_wall/demo
	name = "Structural Wall"
	icon_state = "steel"
	var/demolished = FALSE
	var/datum/demolition_manager/manager
	var/image/segment_image

/turf/simulated/wall/r_wall/demo/New(var/newloc)
	. = ..(newloc, "plasteel","plasteel")

	manager = GLOB.DEMOLITION_MANAGER_LIST["[z]"]
	if(!manager)
		manager = new/datum/demolition_manager
		GLOB.DEMOLITION_MANAGER_LIST["[z]"] = manager

	manager.wall_added(src)

	segment_image = image('code/modules/halo/overmap/hull_segments.dmi', "hull_segment_marker")
	update_icon()

/turf/simulated/wall/r_wall/demo/examine(mob/user)
	. = ..()
	to_chat(user, "<span slass='info'>This wall is a key support. Destroying it will endanger the entire structure.</span>")

/turf/simulated/wall/r_wall/demo/update_material()
	. = ..()
	name = "structural [name]"

/turf/simulated/wall/r_wall/demo/update_icon()
	. = ..()
	overlays |= segment_image

/turf/simulated/wall/r_wall/demo/dismantle_wall(var/devastated, var/explode, var/no_product)
	manager.wall_destroyed(src)

	return ..()
/*
/turf/simulated/wall/r_wall/demo/update_icon()

	//override our parent proc so we dont do smooth walls
	overlays.Cut()

	if(damage != 0)
		var/integrity = max_health()

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		overlays += damage_overlays[overlay]
	return
*/

/turf/simulated/wall/r_wall/demo/proc/buckle(var/buckle_damage)
	//work out the damage
	var/max_health = max_health()

	//chat log warning
	var/warning_message = "[src] buckles under the strain!"
	if(max_health - buckle_damage <= max_health / 2)
		warning_message += " It won't last much longer..."
	src.visible_message("<span class='warning'>[warning_message]</span>")

	//audio effect
	playsound(src, 'sound/machines/airlock_creaking.ogg', 50, 1)

	//visual effect
	var/datum/effect/effect/system/spark_spread/spark = new
	spark.set_up(1,0,src)
	spark.attach(src)
	spark.start(1)

	//apply the damage
	take_damage(buckle_damage)
