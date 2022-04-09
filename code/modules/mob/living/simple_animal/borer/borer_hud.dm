/mob/living/simple_animal/borer
	var/list/hud_elements = list()
	var/obj/screen/intent/hud_intent_selector
	var/obj/screen/borer/toggle_host_control/hud_toggle_control
	var/obj/screen/borer/inject_chemicals/hud_inject_chemicals
	var/obj/screen/borer/leave_host/hud_leave_host

/mob/living/simple_animal/borer/proc/reset_ui_callback()
	if(world.time >= last_special)
		for(var/obj/thing in hud_elements)
			thing.color = null

/obj/screen/borer
	icon = 'icons/mob/borer_ui.dmi'
	alpha = 0
	invisibility = INVISIBILITY_MAXIMUM

/obj/screen/borer/Click(location, control, params)
	if(!istype(usr, /mob/living/simple_animal/borer))
		return FALSE
	if(usr.stat == DEAD)
		return FALSE
	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.host)
		return FALSE
	return TRUE

/obj/screen/borer/toggle_host_control
	name = "Seize Control"
	icon_state = "seize_control"
	screen_loc = "WEST-3,NORTH-1"

/obj/screen/borer/toggle_host_control/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.can_use_borer_ability())
		return

	if(worm.neutered)
		to_chat(worm, SPAN_WARNING("You cannot do that."))
		return

	to_chat(worm, SPAN_NOTICE("You begin delicately adjusting your connection to the host brain..."))
	if(!do_after(worm, 100+(worm.host.getBrainLoss()*5) || !worm.host || !worm.can_use_borer_ability()))
		return

	to_chat(worm, SPAN_DANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
	to_chat(worm.host, SPAN_DANGER("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))
	worm.host.add_language(LANGUAGE_BORER_GLOBAL)

	// host -> brain
	var/h2b_id = worm.host.computer_id
	var/h2b_ip=  worm.host.lastKnownIP
	worm.host.computer_id = null
	worm.host.lastKnownIP = null
	qdel(worm.host_brain)
	worm.host_brain = new(worm)
	worm.host_brain.ckey = worm.host.ckey
	worm.host_brain.SetName(worm.host.name)
	if(!worm.host_brain.computer_id)
		worm.host_brain.computer_id = h2b_id
	if(!worm.host_brain.lastKnownIP)
		worm.host_brain.lastKnownIP = h2b_ip

	// self -> host
	var/s2h_id = worm.computer_id
	var/s2h_ip= worm.lastKnownIP
	worm.computer_id = null
	worm.lastKnownIP = null
	worm.host.ckey = worm.ckey
	if(!worm.host.computer_id)
		worm.host.computer_id = s2h_id
	if(!worm.host.lastKnownIP)
		worm.host.lastKnownIP = s2h_ip
	worm.controlling = TRUE
	worm.host.verbs += /mob/living/carbon/proc/release_control
	worm.host.verbs += /mob/living/carbon/proc/punish_host
	worm.host.verbs += /mob/living/carbon/proc/spawn_larvae

	return TRUE
	
/obj/screen/borer/inject_chemicals
	name = "Inject Chemicals"
	icon_state = "inject_chemicals"
	screen_loc = "WEST-2,NORTH-1"

/obj/screen/borer/inject_chemicals/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.can_use_borer_ability())
		return

	if(worm.chemicals < 50)
		to_chat(worm, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/chem = input("Select a chemical to secrete.", "Chemicals") as null|anything in worm.chemical_types
	if(!chem || !worm.chemical_types[chem] || !worm || QDELETED(worm) || worm.chemicals < 50 || !worm.can_use_borer_ability())
		return

	to_chat(worm, SPAN_NOTICE("You squirt a measure of [chem] from your reservoirs into \the [worm.host]'s bloodstream."))
	worm.host.reagents.add_reagent(worm.chemical_types[chem], 10)
	worm.chemicals -= 50
	return TRUE

/obj/screen/borer/leave_host
	name = "Leave Host"
	icon_state = "leave_host"
	screen_loc = "WEST-1,NORTH-1"

/obj/screen/borer/leave_host/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.can_use_borer_ability())
		return

	to_chat(worm, SPAN_NOTICE("You begin disconnecting from \the [worm.host]'s synapses and prodding at their internal ear canal."))
	if(worm.host.stat == CONSCIOUS)
		to_chat(worm.host, SPAN_WARNING("An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."))

	if(!do_after(worm, 10 SECONDS) || !worm.can_use_borer_ability())
		return

	if(worm.host)
		to_chat(worm, SPAN_WARNING("You wiggle out of [worm.host]'s ear and plop to the ground."))
		if(worm.host.stat != DEAD)
			to_chat(worm.host, SPAN_DANGER("Something slimy wiggles out of your ear and plops to the ground!"))
			if(!worm.neutered)
				to_chat(worm.host, SPAN_DANGER("As though waking from a dream, you shake off the insidious mind control of the brain worm. Your thoughts are your own again."))
		worm.detatch()
		worm.leave_host()

	return TRUE