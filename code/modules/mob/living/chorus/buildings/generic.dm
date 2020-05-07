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
		if(owner.get_implant(H))
			continue
		target = H
		break
	converting = TRUE
	update_icon()
	if(target && do_after(target, 50, incapacitation_flags = INCAPACITATION_NONE))
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
			if(L.stat)
				continue
			if(!owner.get_implant(L))
				filtered += m
		if(filtered.len && can_activate(owner, FALSE))
			trigger_effect(filtered)
			last_click = world.time

/obj/structure/chorus/processor/sentry/proc/trigger_effect(var/list/possible_targets)
	return