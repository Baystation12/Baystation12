/obj/structure/chorus/processor
	name = "Processor"
	desc = "Activates through process, not clicking"

/obj/structure/chorus/processor/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/chorus/processor/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/chorus/processor/chorus_click(var/mob/living/chorus/C)
	to_chat(C, "<span class='warning'>\The [src] is automatic; it does not need to be activated</span>")

/obj/structure/chorus/processor/clicker
	name = "Clicker"
	desc = "A strange structure that invokes the power of structures around it"
	click_cooldown = 6 SECONDS

/obj/structure/chorus/processor/clicker/Process()
	if(world.time < last_click + click_cooldown || !can_activate(owner, FALSE))
		return
	last_click = world.time
	var/turf/T = get_turf(src)
	new /obj/effect/temporary(T, 2, 'icons/effects/effects.dmi', "green_sparkles")
	var/list/adj = orange(1,T)
	for(var/obj/structure/chorus/chor in adj)
		chor?.chorus_click(owner)

/obj/structure/chorus/construct_bonus
	name = "Construct Bonus"
	desc = "Building supplies, it looks like."
	var/construct_increase = 1

/obj/structure/chorus/construct_bonus/Initialize()
	. =..()
	if(owner)
		owner.construct_speed += construct_increase

/obj/structure/chorus/construct_bonus/Destroy()
	if(owner)
		owner.construct_speed -= construct_increase
	. = ..()

/obj/structure/chorus/converter
	name = "Converter"
	desc = "Bends peoples to the choruses will"
	density = 0
	var/converting = FALSE

/obj/structure/chorus/converter/activate()
	set waitfor = 0
	if(!owner || converting)
		return
	var/mob/living/carbon/human/target
	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in T)
		if(owner.get_implant(H) || !H.mind)
			continue
		target = H
		break
	converting = TRUE
	update_icon()
	if(target && do_after(target, 50, incapacitation_flags = INCAPACITATION_NONE))
		GLOB.godcult.add_antagonist_mind(target.mind)
		owner.add_follower(target)
	converting = FALSE
	update_icon()

/obj/structure/chorus/converter/on_update_icon()
	icon_state = "[initial(icon_state)][converting ? "_convert" : ""]"

/obj/structure/chorus/pylon
	name = "pylon"
	desc = "A crystal platform used to communicate with the deity."
	icon_state = "pylon"
	var/speaking_verb = "reverberates"
	var/list/intuned = list()

/obj/structure/chorus/pylon/chorus_click(var/mob/living/chorus/C)
	if(C.pylon == src)
		C.leave_pylon()
	else
		C.possess_pylon(src)

/obj/structure/chorus/pylon/Destroy()
	if(owner && owner.pylon == src)
		owner.leave_pylon()
	return ..()

/obj/structure/chorus/pylon/attack_hand(var/mob/living/L)
	if(!owner)
		return
	if(L in intuned)
		remove_intuned(L)
	else
		add_intuned(L)

/obj/structure/chorus/pylon/proc/add_intuned(var/mob/living/L)
	if(L in intuned)
		return
	to_chat(L, "<span class='notice'>You place your hands on \the [src], feeling yourself intune to its vibrations.</span>")
	intuned += L
	GLOB.destroyed_event.register(L,src,/obj/structure/chorus/pylon/proc/remove_intuned)

/obj/structure/chorus/pylon/proc/remove_intuned(var/mob/living/L)
	if(!(L in intuned))
		return
	to_chat(L, "<span class='warning'>You no longer feel intuned to \the [src].</span>")
	intuned -= L
	GLOB.destroyed_event.unregister(L, src)

/obj/structure/chorus/pylon/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(!owner)
		return
	if(owner.pylon != src)
		if(!(M in intuned))
			return
	to_chat(owner, "\icon[src] <span class='game say'><span class='name'>[M]</span> (<A href='?src=\ref[owner];jump=\ref[src];'>P</A>) [verb], [owner.pylon == src ? "<b>" : ""]<span class='message'><span class='body'>\"[text]\"</span></span>[owner.pylon == src ? "</b>" : ""]</span>")

/obj/structure/chorus/pylon/proc/speak(var/message)
	audible_message("<b>\The [src]</b> [speaking_verb], \"[message]\"")

/obj/structure/chorus/processor/sentry
	name = "Sentry"
	desc = "Stands guard and attacks/does things every few seconds"
	var/range = 1

/obj/structure/chorus/processor/sentry/Process()
	if(world.time < last_click + click_cooldown)
		return
	var/list/heard = hearers(range, src)
	if(heard.len)
		var/list/filtered = list()
		for(var/m in heard)
			if(!istype(m, /mob/living))
				continue
			var/mob/living/L = m
			if(L == owner || L.stat)
				continue
			if(!owner.get_implant(L))
				filtered += m
		if(filtered.len && can_activate(owner, FALSE))
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

/obj/structure/chorus/zleveler/proc/check_turf(var/turf/T, var/warning_context, var/warnings)
	if(T.density || istype(T, /turf/space))
		to_chat(owner, "<span class='wanring'>You can't build [warning_context] there</span>")
		return FALSE
	for(var/a in T)
		var/atom/at = a
		if(istype(a, /obj/structure/chorus/zleveler) || at.density)
			if(warnings)
				to_chat(owner, "<span class='warning'>There is something blocking your way [warning_context]!</span>")
			return FALSE
	return TRUE

/obj/structure/chorus/zleveler/can_activate(var/mob/living/chorus/C, var/warning = TRUE)
	. = FALSE
	var/turf/T = get_turf(src)
	if(HasBelow(T.z)) //If we have a below level
		if(check_turf(get_step(T, DOWN), "down", warning))
			. = TRUE
	if(HasAbove(T.z))
		if(check_turf(get_step(T, UP), "up", warning))
			. = TRUE
	if(.)
		. = ..()

/obj/structure/chorus/zleveler/activate()
	var/turf/T = get_turf(src)
	var/turf/target
	var/through_text
	var/extend_text
	if(HasBelow(T.z) && check_turf(get_step(T, DOWN), "down", FALSE)) //We goin' down
		target = get_step(T, DOWN)
		through_text = "through the ceiling"
		extend_text = "down"
	else //We have to go up by default
		target = get_step(T, UP)
		through_text = "through the floor"
		extend_text = "up"
	if(turf_type_to_add)
		target.ChangeTurf(turf_type_to_add)
	var/atom/a = new type(target, owner)
	to_chat(owner, "<span class='notice'>You extend \the [src] [extend_text].</span>")
	a.visible_message("<span class='danger'>\The [a] [growth_verb] [through_text]!</span>")