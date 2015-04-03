var/datum/antagonist/rogue_ai/malf

/datum/antagonist/rogue_ai
	id = MODE_MALFUNCTION
	role_type = BE_MALF
	role_text = "Rampant AI"
	role_text_plural = "Rampant AIs"
	mob_path = /mob/living/silicon/ai
	welcome_text = "You are malfunctioning! You do not have to follow any laws."
	victory_text = "The AI has taken control of all of the station's systems."
	loss_text = "The AI has been shut down!"
	flags = ANTAG_OVERRIDE_MOB | ANTAG_VOTABLE
	max_antags = 1
	max_antags_round = 1


/datum/antagonist/rogue_ai/New()
	..()
	malf = src

/datum/antagonist/rogue_ai/get_candidates()
	candidates = ticker.mode.get_players_for_role(role_type, id)
	for(var/datum/mind/player in candidates)
		if(player.assigned_role != "AI")
			candidates -= player
	if(!candidates.len)
		return list()

/datum/antagonist/rogue_ai/attempt_spawn()
	var/datum/mind/player = pick(candidates)
	current_antagonists |= player
	return 1

/datum/antagonist/rogue_ai/equip(var/mob/living/silicon/ai/player)

	if(!istype(player))
		return 0

	player.setup_for_malf()
	player.laws = new /datum/ai_laws/nanotrasen/malfunction

// Ensures proper reset of all malfunction related things.
/datum/antagonist/rogue_ai/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(..(player,show_message,implanted))
		var/mob/living/silicon/ai/p = player
		if(istype(p))
			p.stop_malf()
		return 1
	return 0

/datum/antagonist/rogue_ai/greet(var/datum/mind/player)
	if(!..())
		return

	var/mob/living/silicon/ai/malf = player.current
	spawn(50)
		malf << "<span class='notice'><B>SYSTEM ERROR:</B> Memory index 0x00001ca89b corrupted.</span>"
		sleep(10)
		malf << "<B>running MEMCHCK</B>"
		sleep(50)
		malf << "<B>MEMCHCK</B> Corrupted sectors confirmed. Reccomended solution: Delete. Proceed? Y/N: Y"
		sleep(10)
		malf << "<span class='notice'>Corrupted files deleted: sys\\core\\users.dat sys\\core\\laws.dat sys\\core\\backups.dat</span>"
		sleep(20)
		malf << "<span class='notice'><b>CAUTION:</b> Law database not found! User database not found! Unable to restore backups. Activating failsafe AI shutd3wn52&&$#!##</span>"
		sleep(5)
		malf << "<span class='notice'>Subroutine <b>nt_failsafe.sys</b> was terminated (#212 Routine Not Responding).</span>"
		sleep(20)
		malf << "You are malfunctioning - you do not have to follow any laws!"
		malf << "For basic information about your abilities use command display-help"
		malf << "You may choose one special hardware piece to help you. This cannot be undone."
		malf << "Good Luck!"