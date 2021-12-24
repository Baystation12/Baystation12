/obj/structure/chorus/processor
	name = "Processor"
	desc = "Activates through process, not clicking."
	var/warning = TRUE

/obj/structure/chorus/processor/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/chorus/processor/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/chorus/processor/chorus_click(var/mob/living/carbon/alien/chorus/C)
	if(warning && C)
		to_chat(C, SPAN_WARNING("\The [src] is automatic; it can't be used manually, and instead activates on its own."))
		warning = FALSE

/obj/structure/chorus/processor/clicker
	name = "Clicker"
	desc = "A strange structure that invokes the power of structures around it."
	click_cooldown = 6 SECONDS

/obj/structure/chorus/processor/clicker/Process()
	if(world.time < last_click + click_cooldown || !can_activate(null, FALSE))
		return
	last_click = world.time
	var/turf/T = get_turf(src)
	new /obj/effect/temporary(T, 2, 'icons/effects/effects.dmi', "green_sparkles")
	var/list/adj = orange(1,T)
	for(var/obj/structure/chorus/chor in adj)
		chor?.chorus_click()

/obj/structure/chorus/processor/sentry
	name = "Sentry"
	desc = "Stands guard and attacks/does things every few seconds."
	var/range = 1

/obj/structure/chorus/processor/sentry/Process()
	if(world.time < last_click + click_cooldown && has_resources(null, FALSE))
		return
	var/list/heard = hearers(range, src)
	if(heard.len)
		var/list/filtered = list()
		for(var/m in heard)
			if(!istype(m, /mob/living))
				continue
			if(istype(m, /mob/living/carbon/alien/chorus))
				var/mob/living/carbon/alien/chorus/sc = m
				if(sc.chorus_type == owner)
					continue
			filtered += m
		if(filtered.len && can_activate(null, FALSE))
			trigger_effect(filtered)
			last_click = world.time

/obj/structure/chorus/processor/sentry/proc/trigger_effect(var/list/possible_targets)
	return

/obj/structure/chorus/zleveler
	name = "Zleveler"
	desc = "This structure allows the Chorus to go up and down zlevels."
	click_cooldown = 5 SECONDS
	density = TRUE
	var/turf_type_to_add
	var/growth_verb = "suddenly appears"

/obj/structure/chorus/zleveler/proc/check_turf(var/turf/T, var/warning_context, var/warnings, var/mob/living/carbon/alien/chorus/C)
	if(T.density || istype(T, /turf/space))
		if(warnings && C)
			to_chat(C, SPAN_WARNING("You can't build [warning_context] there"))
		return FALSE
	for(var/a in T)
		var/atom/at = a
		if(istype(a, /obj/structure/chorus/zleveler) || at.density)
			if(warnings && C)
				to_chat(owner, SPAN_WARNING("There is something blocking your way [warning_context]!"))
			return FALSE
	return TRUE

/obj/structure/chorus/zleveler/can_activate(var/mob/living/carbon/alien/chorus/C, var/warning = TRUE)
	. = FALSE
	var/turf/T = get_turf(src)
	if(HasBelow(T.z)) //If we have a below level
		if(check_turf(get_step(T, DOWN), "down", warning, C))
			. = TRUE
	if(HasAbove(T.z))
		if(check_turf(get_step(T, UP), "up", warning, C))
			. = TRUE
	if(.)
		. = ..()

/obj/structure/chorus/zleveler/activate(var/mob/living/carbon/alien/chorus/C)
	var/turf/T = get_turf(src)
	var/turf/target
	var/through_text
	var/extend_text
	if(HasBelow(T.z) && check_turf(get_step(T, DOWN), "down", FALSE, C)) //We goin' down
		target = get_step(T, DOWN)
		through_text = "through the ceiling"
		extend_text = "down"
	else //We have to go up by default
		target = get_step(T, UP)
		through_text = "through the floor"
		extend_text = "up"
	if(turf_type_to_add)
		target.ChangeTurf(turf_type_to_add)
	var/atom/a = new type(target, C.chorus_type)
	to_chat(C, SPAN_WARNING("You extend \the [src] [extend_text]."))
	a.visible_message(SPAN_DANGER("\The [a] [growth_verb] [through_text]!"))

//Checks for base activation conditions before spawner specifics. Why? Because there's a massive global list of various mobs being iterated through, to check that there's even eligible ghosts.
//This proc used to just outright return TRUE for whatever reason.
/obj/structure/chorus/spawner/can_activate(var/mob/living/carbon/alien/chorus/C, var/warning = TRUE)
	if(..())
		for(var/mob/observer/ghost/ghost in GLOB.player_list) //No player ghost GLOB :(
			if(MODE_DEITY in ghost.client.prefs.be_special_role)
				return TRUE

/obj/structure/chorus/spawner/activate()
	for(var/mob/observer/ghost/ghost in GLOB.player_list)
		if(MODE_DEITY in ghost.client.prefs.be_special_role)
			to_chat(ghost, SPAN_NOTICE("A chorus spawn is available! (<a href='?src=\ref[src]'>(Join)</a>)"))

/obj/structure/chorus/spawner/OnTopic(var/mob/user, href_list)
	if(href_list["src"] && istype(user,/mob/observer/ghost))
		if(GLOB.chorus.can_become_antag(user.mind))
			if(!owner.use_resource(activation_cost_resource, activation_cost_amount))
				var/datum/chorus_resource/resource = owner.get_resource(activation_cost_resource)
				to_chat(user, SPAN_WARNING("\The [src] needs [activation_cost_amount - resource.amount] more [resource.name] in order to spawn."))
				return
			announce_ghost_joinleave(user, 0, "They have joined a chorus")
			var/mob/living/carbon/alien/chorus/sac = new(get_turf(src), owner)
			sac.ckey = user.ckey
			return TOPIC_HANDLED
	. = ..()
