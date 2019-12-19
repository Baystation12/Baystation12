// This system is used to grab a ghost from observers with the required preferences 
// and lack of bans set. See posibrain.dm for an example of how they are called/used.

var/list/ghost_traps

/proc/get_ghost_trap(var/trap_key)
	if(!ghost_traps)
		populate_ghost_traps()
	return ghost_traps[trap_key]

/proc/get_ghost_traps()
	if(!ghost_traps)
		populate_ghost_traps()
	return ghost_traps

/proc/populate_ghost_traps()
	ghost_traps = list()
	for(var/traptype in typesof(/datum/ghosttrap))
		var/datum/ghosttrap/G = new traptype
		ghost_traps[G.object] = G

/datum/ghosttrap
	var/object = "positronic brain"
	var/minutes_since_death = 0     // If non-zero the ghost must have been dead for this many minutes to be allowed to spawn
	var/list/ban_checks = list("AI","Robot")
	var/pref_check = BE_SYNTH
	var/ghost_trap_message = "They are occupying a positronic brain now."
	var/ghost_trap_role = "Positronic Brain"
	var/can_set_own_name = TRUE
	var/list_as_special_role = TRUE	// If true, this entry will be listed as a special role in the character setup

	var/list/request_timeouts

/datum/ghosttrap/New()
	request_timeouts = list()
	..()

// Check for bans, proper atom types, etc.
/datum/ghosttrap/proc/assess_candidate(var/mob/observer/ghost/candidate, var/mob/target, var/feedback = TRUE)
	if(!candidate.MayRespawn(feedback, minutes_since_death))
		return 0
	if(islist(ban_checks))
		for(var/bantype in ban_checks)
			if(jobban_isbanned(candidate, "[bantype]"))
				if(feedback)
					to_chat(candidate, "You are banned from one or more required roles and hence cannot enter play as \a [object].")
				return 0
	return 1

// Print a message to all ghosts with the right prefs/lack of bans.
/datum/ghosttrap/proc/request_player(var/mob/target, var/request_string, var/request_timeout)
	if(request_timeout)
		request_timeouts[target] = world.time + request_timeout
		GLOB.destroyed_event.register(target, src, /datum/ghosttrap/proc/unregister_target)
	else
		unregister_target(target)

	for(var/mob/observer/ghost/O in GLOB.player_list)
		if(!assess_candidate(O, target, FALSE))
			return
		if(pref_check && !O.client.wishes_to_be_role(pref_check))
			continue
		if(O.client)
			to_chat(O, "[request_string] <a href='?src=\ref[src];candidate=\ref[O];target=\ref[target]'>(Occupy)</a> ([ghost_follow_link(target, O)])")

/datum/ghosttrap/proc/unregister_target(var/target)
	request_timeouts -= target
	GLOB.destroyed_event.unregister(target, src, /datum/ghosttrap/proc/unregister_target)

// Handles a response to request_player().
/datum/ghosttrap/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["candidate"] && href_list["target"])
		var/mob/observer/ghost/candidate = locate(href_list["candidate"]) // BYOND magic.
		var/mob/target = locate(href_list["target"])                     // So much BYOND magic.
		if(!target || !candidate)
			return
		if(candidate != usr)
			return
		if(request_timeouts[target] && world.time > request_timeouts[target])
			to_chat(candidate, "This occupation request is no longer valid.")
			return
		if(target.key)
			to_chat(candidate, "The target is already occupied.")
			return
		if(assess_candidate(candidate, target))
			transfer_personality(candidate,target)
		return 1

// Shunts the ckey/mind into the target mob.
/datum/ghosttrap/proc/transfer_personality(var/mob/candidate, var/mob/target)
	if(!assess_candidate(candidate, target))
		return 0
	target.ckey = candidate.ckey
	if(target.mind)
		target.mind.reset()
		target.mind.assigned_role = "[ghost_trap_role]"
	announce_ghost_joinleave(candidate, 0, "[ghost_trap_message]")
	welcome_candidate(target)
	set_new_name(target)
	return 1

// Fluff!
/datum/ghosttrap/proc/welcome_candidate(var/mob/target)
	to_chat(target, "<b>You are a positronic brain, brought into existence on [station_name()].</b>")
	to_chat(target, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(target, "<b>Remember, the purpose of your existence is to serve the crew and the [station_name()]. Above all else, do no harm.</b>")
	to_chat(target, "<b>Use say [target.get_language_prefix()]b to speak to other artificial intelligences.</b>")
	var/turf/T = get_turf(target)
	var/obj/item/organ/internal/posibrain/P = target.loc
	T.visible_message("<span class='notice'>\The [P] chimes quietly.</span>")
	if(!istype(P)) //wat
		return
	P.searching = 0
	P.SetName("positronic brain ([P.brainmob.name])")
	P.update_icon()

// Allows people to set their own name. May or may not need to be removed for posibrains if people are dumbasses.
/datum/ghosttrap/proc/set_new_name(var/mob/target)
	if(!can_set_own_name)
		return

	var/newname = sanitizeSafe(input(target,"Enter a name, or leave blank for the default name.", "Name change",target.real_name) as text, MAX_NAME_LEN)
	if (newname && newname != "")
		target.real_name = newname
		target.SetName(target.real_name)

/***********************************
* Diona pods and walking mushrooms *
***********************************/
/datum/ghosttrap/plant
	object = "living plant"
	ban_checks = list("Dionaea")
	pref_check = BE_PLANT
	ghost_trap_message = "They are occupying a living plant now."
	ghost_trap_role = "Plant"

/datum/ghosttrap/plant/welcome_candidate(var/mob/target)
	to_chat(target, "<span class='alium'><B>You awaken slowly, stirring into sluggish motion as the air caresses you.</B></span>")
	// This is a hack, replace with some kind of species blurb proc.
	if(istype(target,/mob/living/carbon/alien/diona))
		to_chat(target, "<B>You are \a [target], one of a race of drifting interstellar plantlike creatures that sometimes share their seeds with human traders.</B>")
		to_chat(target, "<B>Too much darkness will send you into shock and starve you, but light will help you heal.</B>")
/*****************
* Cortical Borer *
*****************/
/datum/ghosttrap/borer
	object = "cortical borer"
	ban_checks = list(MODE_BORER)
	pref_check = MODE_BORER
	ghost_trap_message = "They are occupying a borer now."
	ghost_trap_role = "Cortical Borer"
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/borer/welcome_candidate(var/mob/target)
	to_chat(target, "<span class='notice'>You are a cortical borer!</span> You are a brain slug that worms its way \
	into the head of its victim. Use stealth, persuasion and your powers of mind control to keep you, \
	your host and your eventual spawn safe and warm.")
	to_chat(target, "You can speak to your victim with <b>say</b>, to other borers with <b>say [target.get_language_prefix()]x</b>, and use your Abilities tab to access powers.")
/********************
* Maintenance Drone *
*********************/
/datum/ghosttrap/drone
	object = "maintenance drone"
	pref_check = BE_PAI
	ghost_trap_message = "They are occupying a maintenance drone now."
	ghost_trap_role = "Maintenance Drone"
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/drone/New()
	minutes_since_death = DRONE_SPAWN_DELAY
	..()

datum/ghosttrap/drone/assess_candidate(var/mob/observer/ghost/candidate, var/mob/target)
	. = ..()
	if(. && !target.can_be_possessed_by(candidate))
		return 0

datum/ghosttrap/drone/transfer_personality(var/mob/candidate, var/mob/living/silicon/robot/drone/drone)
	if(!assess_candidate(candidate))
		return 0
	drone.transfer_personality(candidate.client)

/**************
* personal AI *
**************/
/datum/ghosttrap/pai
	object = "pAI"
	pref_check = BE_PAI
	ghost_trap_message = "They are occupying a pAI now."
	ghost_trap_role = "pAI"

datum/ghosttrap/pai/assess_candidate(var/mob/observer/ghost/candidate, var/mob/target)
	return 0

datum/ghosttrap/pai/transfer_personality(var/mob/candidate, var/mob/living/silicon/robot/drone/drone)
	return 0

/******************
* Wizard Familiar *
******************/
/datum/ghosttrap/familiar
	object = "wizard familiar"
	pref_check = MODE_WIZARD
	ghost_trap_message = "They are occupying a familiar now."
	ghost_trap_role = "Wizard Familiar"
	ban_checks = list(MODE_WIZARD)

/datum/ghosttrap/familiar/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/cult
	object = "cultist"
	ban_checks = list("cultist")
	pref_check = MODE_CULTIST
	can_set_own_name = FALSE
	ghost_trap_message = "They are occupying a cultist's body now."
	ghost_trap_role = "Cultist"

/datum/ghosttrap/cult/welcome_candidate(var/mob/target)
	var/obj/item/device/soulstone/S = target.loc
	if(istype(S))
		if(S.is_evil)
			GLOB.cult.add_antagonist(target.mind)
			to_chat(target, "<b>Remember, you serve the one who summoned you first, and the cult second.</b>")
		else
			to_chat(target, "<b>This soultone has been purified. You do not belong to the cult.</b>")
			to_chat(target, "<b>Remember, you only serve the one who summoned you.</b>")

/datum/ghosttrap/cult/shade
	object = "soul stone"
	ghost_trap_message = "They are occupying a soul stone now."
	ghost_trap_role = "Shade"
