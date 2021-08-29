/mob/living/carbon/alien/chorus
	var/construct_speed = 1
	var/datum/chorus_building/selected_building
	var/is_building = FALSE

/mob/living/carbon/alien/chorus/proc/set_selected_building(var/n_build)
	selected_building = n_build
	var/datum/hud/chorus/C = hud_used
	C.update_selected(n_build)

/mob/living/carbon/alien/chorus/proc/start_building(var/atom/a)
	if(is_building)
		to_chat(src, SPAN_WARNING("You're already building something!"))
		return
	var/turf/T
	if(a)
		T = get_turf(a)
		if(get_dist(src, a) > 1)
			to_chat(src, SPAN_WARNING("You can only build next to yourself."))
			return
	else
		T = get_step(src, src.dir)
	if(!selected_building)
		to_chat(src,SPAN_WARNING("You don't have a building selected"))
		return
	if(selected_building.can_build(src, T, TRUE))
		var/real_construct_speed = 25 * construct_speed / (24 + construct_speed)
		is_building = TRUE
		if(do_after(src, round(selected_building.build_time / real_construct_speed), T))
			selected_building.build(T, src, TRUE)
		is_building = FALSE

/mob/living/carbon/alien/chorus/Life()
	. = ..()
	if(stat != DEAD && health < maxHealth) //Construct speed also goes for regen
		health = min(maxHealth, health + construct_speed)