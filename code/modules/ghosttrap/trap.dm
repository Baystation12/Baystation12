// This system is used to grab a ghost from observers with the required preferences and
// lack of bans set. See posibrain.dm for an example of how they are called/used. ~Z

var/list/ghost_traps

proc/get_ghost_trap(var/trap_key)
	if(!ghost_traps)
		populate_ghost_traps()
	return ghost_traps[trap_key]

proc/populate_ghost_traps()
	ghost_traps = list()
	for(var/traptype in typesof(/datum/ghosttrap))
		var/datum/ghosttrap/G = new traptype
		ghost_traps[G.object] = G

/datum/ghosttrap
	var/object = "positronic brain"
	var/list/ban_checks = list("AI","Cyborg")
	var/pref_check = BE_AI
	var/ghost_trap_message = "They are occupying a positronic brain now."
	var/ghost_trap_role = "Positronic Brain"

// Check for bans, proper atom types, etc.
/datum/ghosttrap/proc/assess_candidate(var/mob/dead/observer/candidate)
	if(!istype(candidate) || !candidate.client || !candidate.ckey)
		return 0
	if(!candidate.MayRespawn())
		candidate << "You have made use of the AntagHUD and hence cannot enter play as \a [object]."
		return 0
	if(islist(ban_checks))
		for(var/bantype in ban_checks)
			if(jobban_isbanned(candidate, "[bantype]"))
				candidate << "You are banned from one or more required roles and hence cannot enter play as \a [object]."
				return 0
	return 1

// Print a message to all ghosts with the right prefs/lack of bans.
/datum/ghosttrap/proc/request_player(var/mob/target, var/request_string)
	if(!target)
		return
	for(var/mob/dead/observer/O in player_list)
		if(!O.MayRespawn())
			continue
		if(islist(ban_checks))
			for(var/bantype in ban_checks)
				if(jobban_isbanned(O, "[bantype]"))
					continue
		if(pref_check && !(O.client.prefs.be_special & pref_check))
			continue
		if(O.client)
			O << "[request_string]<a href='?src=\ref[src];candidate=\ref[O];target=\ref[target]'>Click here</a> if you wish to play as this option."

// Handles a response to request_player().
/datum/ghosttrap/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["candidate"] && href_list["target"])
		var/mob/dead/observer/candidate = locate(href_list["candidate"]) // BYOND magic.
		var/mob/target = locate(href_list["target"])                     // So much BYOND magic.
		if(!target || !candidate)
			return
		if(candidate == usr && assess_candidate(candidate) && !target.ckey)
			transfer_personality(candidate,target)
		return 1

// Shunts the ckey/mind into the target mob.
/datum/ghosttrap/proc/transfer_personality(var/mob/candidate, var/mob/target)
	if(!assess_candidate(candidate))
		return 0
	target.ckey = candidate.ckey
	if(target.mind)
		target.mind.assigned_role = "[ghost_trap_role]"
	announce_ghost_joinleave(candidate, 0, "[ghost_trap_message]")
	welcome_candidate(target)
	set_new_name(target)
	return 1

// Fluff!
/datum/ghosttrap/proc/welcome_candidate(var/mob/target)
	target << "<b>You are a positronic brain, brought into existence on [station_name()].</b>"
	target << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	target << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	target << "<b>Use say :b to speak to other artificial intelligences.</b>"
	var/turf/T = get_turf(target)
	T.visible_message("<span class='notice'>\The [src] chimes quietly.</span>")
	var/obj/item/device/mmi/digital/posibrain/P = target.loc
	if(!istype(P)) //wat
		return
	P.searching = 0
	P.name = "positronic brain ([P.brainmob.name])"
	P.icon_state = "posibrain-occupied"

// Allows people to set their own name. May or may not need to be removed for posibrains if people are dumbasses.
/datum/ghosttrap/proc/set_new_name(var/mob/target)
	var/newname = sanitizeSafe(input(target,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
	if (newname != "")
		target.real_name = newname
		target.name = target.real_name

// Doona pods and walking mushrooms.
/datum/ghosttrap/plant
	object = "living plant"
	ban_checks = list("Dionaea")
	pref_check = BE_PLANT
	ghost_trap_message = "They are occupying a living plant now."
	ghost_trap_role = "Plant"

/datum/ghosttrap/plant/welcome_candidate(var/mob/target)
	target << "<span class='alium><B>You awaken slowly, stirring into sluggish motion as the air caresses you.</B></span>"
	// This is a hack, replace with some kind of species blurb proc.
	if(istype(host,/mob/living/carbon/alien/diona))
		target << "<B>You are \a [target], one of a race of drifting interstellar plantlike creatures that sometimes share their seeds with human traders.</B>"
		target << "<B>Too much darkness will send you into shock and starve you, but light will help you heal.</B>"