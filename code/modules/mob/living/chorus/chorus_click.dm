/mob/living/chorus
	var/self_click_cooldown = 30
	var/last_click = 0

/mob/living/chorus/ClickOn(var/atom/A, var/params)
	if(stat == DEAD)
		return
	if(istype(A, /obj/structure/chorus))
		if(selected_building == deletion)
			deletion.build(A, src)
		else
			var/obj/structure/chorus/C = A
			C.chorus_click(src)
	else if(A == src)
		self_click()
	else if (istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if (!H.mind || (H.mind in followers))
			return
		for (var/obj/structure/chorus/converter/converter in get_turf(H))
			converter.activate()
			return
	else if(phase == CHORUS_PHASE_EGG)
		if(selected_building)
			start_building(selected_building, A)
		else if(istype(A, /obj/structure/chorus_blueprint))
			var/obj/structure/chorus_blueprint/cb = A
			if(cb.owner == src)
				to_chat(src, SPAN_NOTICE("You cancel building \the [cb]."))
				cb.visible_message(SPAN_NOTICE("\The [cb] stops growing and withers away!"))
				stop_building(cb)

/mob/living/chorus/proc/self_click()
	if(last_click + self_click_cooldown < world.time)
		last_click = world.time
		return TRUE
	return FALSE
