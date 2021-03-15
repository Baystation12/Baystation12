/obj/machinery/vr_pod
	name = "\improper VR pod"
	desc = "An advanced machine that simulates lifelike environments and scenarios for its occupant. Useful for hands-on training as well as recreation."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = TRUE
	anchored = TRUE
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	base_type = /obj/machinery/vr_pod
	construct_state = /decl/machine_construction/default/panel_closed
	idle_power_usage = 15
	active_power_usage = 1 KILOWATTS
	
	var/mob/living/carbon/human/occupant	// The person using the pod.
	var/hatch_locked						// If TRUE, the occupant can't exit.

/obj/machinery/vr_pod/Destroy()
	if (occupant)
		eject()
	..()

/obj/machinery/vr_pod/attack_hand(mob/user)
	if (SSvirtual_reality.virtual_mobs_to_occupants[user] == occupant)
		unsimulate()
		return
	if (occupant != user)
		if (user.a_intent == I_HURT && occupant != user)
			user.visible_message(
				SPAN_DANGER("\The [user] bangs on \the [src]'s glass!"),
				SPAN_DANGER("You bang on \the [src]'s glass!")
			)
			user.do_attack_animation(src)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			playsound(loc, 'sound/effects/glassknock.ogg', 80, TRUE)
			var/mob/living/L = SSvirtual_reality.virtual_occupants_to_mobs[occupant]
			if (L)
				to_chat(L, SPAN_DANGER(FONT_LARGE("You hear loud thumping as someone bangs on the glass to your pod!")))
				L.playsound_local(L.loc, 'sound/effects/glassknock.ogg', 80, TRUE)
			return
		if (user.a_intent == I_GRAB && occupant)
			if (hatch_locked)
				to_chat(user, SPAN_WARNING("\The [src]'s hatch is locked!"))
				return
			user.visible_message(
				SPAN_WARNING("\The [user] opens \the [src]'s hatch, ejecting \the [occupant]!"),
				SPAN_WARNING("You eject \the [occupant] from \the [src].")
			)
			eject()
			return
	. = ..()

/obj/machinery/vr_pod/attackby(obj/item/I, mob/living/user)
	if (isCrowbar(I) && user.a_intent != I_HELP)
		if (!hatch_locked)
			eject()
		else
			user.visible_message(
				SPAN_WARNING("\The [user] starts prying open \the [src]'s hatch!"),
				SPAN_DANGER("You start trying to pry open \the [src]...")
			)
			playsound(loc,'sound/machines/airlock_creaking.ogg', 75)
			var/mob/living/L = SSvirtual_reality.virtual_occupants_to_mobs[occupant]
			if (L)
				to_chat(L, SPAN_DANGER(FONT_LARGE("You hear a loud groaning sound as something starts trying to force open your pod!")))
				L.playsound_local(L.loc,'sound/machines/airlock_creaking.ogg', 75)
			if (!do_after(user, 4 SECONDS, src))
				return
			user.visible_message(
				SPAN_WARNING("\The [user] pries open \the [src]!"),
				SPAN_DANGER("You force open \the [src], ejecting its occupant.")
			)
			playsound(loc, 'sound/items/Deconstruct.ogg', 75)
			eject()
		return
	. = ..()

/obj/machinery/vr_pod/examine(mob/user)
	. = ..()
	if (occupant)
		to_chat(user, SPAN_NOTICE("\icon[occupant] You can see \the [occupant] inside."))

/obj/machinery/vr_pod/MouseDrop_T(mob/living/target, mob/living/user)
	if (!CanMouseDrop(target, user))
		return
	if (!istype(target))
		return
	if (target.buckled)
		to_chat(user, SPAN_WARNING("\The [target] is buckled to \the [target.buckled]!"))
		return
	if (panel_open)
		to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel is open!"))
		return
	if (occupant)
		to_chat(user, SPAN_WARNING("\The [src] is occupied!"))
		return
	enter_pod(target, user)

/obj/machinery/vr_pod/proc/enter_pod(mob/living/target, mob/living/user)
	if (stat & (BROKEN|NOPOWER))
		return
	if (user == target)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts climbing into \the [src]."),
			SPAN_NOTICE("You start climbing into \the [src].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] starts putting \the [target] into \the [src]."),
			SPAN_NOTICE("You start putting \the [target] into \the [src].")
		)
	if (!do_after(user, 3 SECONDS, target))
		if (occupant)
			to_chat(user, SPAN_WARNING("Someone entered \the [src] before you[user == target ? "" : " finished"]!"))
		return
	set_occupant(target)
	return TRUE

/obj/machinery/vr_pod/proc/exit_pod(forced = FALSE)
	if (!occupant)
		return
	if (hatch_locked && !forced)
		to_chat(occupant, SPAN_WARNING("\The [src]'s hatch is locked!"))
		return
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	if (!forced)
		occupant.visible_message(
			SPAN_NOTICE("\The [occupant] climbs out of \the [src]."),
			SPAN_NOTICE("You exit \the [src].")
		)
	else
		hatch_locked = FALSE
	set_occupant(null)

	for(var/obj/O in (contents - component_parts))
		O.dropInto(loc)

/obj/machinery/vr_pod/proc/eject(forceful)
	if (SSvirtual_reality.virtual_occupants_to_mobs[occupant])
		SSvirtual_reality.remove_virtual_mob(occupant)
		to_chat(occupant, SPAN_DANGER(FONT_LARGE("You're abruptly ripped back to reality as [QDELETED(src) ? "you're thrown out of your pod" : "your pod's hatch opens"]!")))
	else
		to_chat(occupant, SPAN_DANGER("You're forced out of your pod!"))
	occupant.Weaken(3)
	exit_pod(forceful)

/obj/machinery/vr_pod/relaymove(mob/living/user)
	..()
	exit_pod()

/obj/machinery/vr_pod/proc/set_occupant(mob/living/new_occupant)
	occupant = new_occupant
	update_icon()
	if (!new_occupant)
		SetName(initial(name))
		update_use_power(POWER_USE_IDLE)
		playsound(loc, 'sound/machines/windowdoor.ogg', 50, TRUE)
		return
	to_chat(new_occupant, SPAN_NOTICE("\The [src] hisses shut, cutting off the outside world. A touchscreen menu appears on the glass above you. \
	\n<i>Interact with \the [src] from inside to configure it and begin a simulation."))
	playsound(loc, 'sound/machines/windowdoor.ogg', 50, TRUE)
	new_occupant.forceMove(src)
	new_occupant.stop_pulling() 
	if (new_occupant.client)
		new_occupant.client.perspective = EYE_PERSPECTIVE
		new_occupant.client.eye = src
	SetName("[name] ([new_occupant])")
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/vr_pod/proc/simulate(mob_type)
	playsound(src, 'sound/machines/signal.ogg', 100, FALSE)
	var/mob/living/simulated_mob = SSvirtual_reality.create_virtual_mob(occupant, mob_type)
	simulated_mob.visible_message(
		SPAN_NOTICE("The world shimmers and distorts. There's a small *pop* as \the [simulated_mob] appears from nothing."),
		SPAN_NOTICE("Your pod fills with light and sound. You feel weightless and disoriented. And then, as soon as it started, you're someone else!")
	)
	audible_message(SPAN_NOTICE("\The [src] emits a series of beeping and clicks as it shunts its occupant into a virtual mind."))

/obj/machinery/vr_pod/proc/unsimulate()
	SSvirtual_reality.remove_virtual_mob(occupant)
	audible_message(SPAN_NOTICE("\The [src] chimes as it drags its occupant back to the real world."))
	playsound(src, 'sound/machines/chime.ogg', 100, FALSE)

/obj/machinery/vr_pod/CanUseTopic(mob/user)
	if(user != occupant && !SSvirtual_reality.virtual_occupants_to_mobs[user])
		to_chat(user, SPAN_WARNING("You can only control \the [src] from the inside."))
		return STATUS_CLOSE
	. = ..()

/obj/machinery/vr_pod/OnTopic(mob/user, href_list, datum/topic_state/state)
	if (href_list["toggle_lock"])
		hatch_locked = !hatch_locked
		to_chat(user, SPAN_NOTICE("You [hatch_locked ? "" : "un"]lock \the [src]'s hatch."))
		if (hatch_locked) // Can't support inline conditionals here due to needing explicit file references
			playsound(loc, 'sound/machines/bolts_down.ogg', 50)
		else
			playsound(loc, 'sound/machines/bolts_up.ogg', 50)
		return TOPIC_REFRESH
	if (href_list["simulate"])
		simulate(user.type)
		return TOPIC_HANDLED

/obj/machinery/vr_pod/interface_interact(mob/user)
	var/dat = ""
	dat += "<a href='?src=\ref[src];toggle_lock=1'>[hatch_locked ? "Unlock" : "Lock"] Hatch</a><br><br>"
	dat += "<a href='?src=\ref[src];simulate=1'><b>Begin Simulation</b></a>"

	var/datum/browser/popup = new(usr, "vrpod", "[initial(name)]", 450, 550)
	popup.set_content(dat)
	popup.open()

	//ui_interact(user)
	/*if (!SSvirtual_reality.virtual_occupants_to_mobs[user])
		simulate(/mob/living/carbon/human)
	else 
		unsimulate()*/
	return TRUE

/obj/machinery/vr_pod/on_update_icon()
	if(!occupant)
		icon_state = "sleeper_0"
	else if(stat & (BROKEN|NOPOWER))
		icon_state = "sleeper_1"
	else
		icon_state = "sleeper_2"

// VR verbs. Being completely virtual, people controlling VR mobs can do a bunch of stuff.
/mob/living/proc/exit_vr_mob()
	set name = "Exit VR"
	set desc = "Exits your virtual mob, and returns to your normal body."
	set category = "VR"
	set src = usr

	SSvirtual_reality.remove_virtual_mob(src)

/mob/living/proc/clear_reagents_vr()
	set name = "Clear Reagents"
	set desc = "Removes any reagents in your stomach and bloodstream."
	set category = "VR"
	set src = usr

	if (reagents)
		to_chat(usr, SPAN_NOTICE("You clear your virtual body of reagents."))
		reagents.clear_reagents()

/mob/living/proc/rejuvenate_self_vr()
	set name = "Rejuvenate"
	set desc = "Fully undoes any kind of damage on your body, as well as clearing reagents and stuns."
	set category = "VR"
	set src = usr

	rejuvenate()
	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		usr.client.prefs.copy_to(H) // Redo hair, augments, and limbs after rejuvenating
		H.set_nutrition(400)
		H.set_hydration(400)
	to_chat(usr, SPAN_NOTICE("You fully rejuvenate your virtual body."))
