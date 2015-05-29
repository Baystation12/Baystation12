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
	flags = ANTAG_VOTABLE | ANTAG_RANDSPAWN //Randspawn needed otherwise it won't start at all.
	max_antags = 1
	max_antags_round = 3


/datum/antagonist/rogue_ai/New()
	..()
	malf = src


/datum/antagonist/rogue_ai/get_candidates()
	..()
	for(var/datum/mind/player in candidates)
		if(player.assigned_role != "AI")
			candidates -= player
	if(!candidates.len)
		return list()
	return candidates


// Ensures proper reset of all malfunction related things.
/datum/antagonist/rogue_ai/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(..(player,show_message,implanted))
		var/mob/living/silicon/ai/p = player.current
		if(istype(p))
			p.stop_malf()
		return 1
	return 0

// Malf setup things have to be here, since game tends to break when it's moved somewhere else. Don't blame me, i didn't design this system.
/datum/antagonist/rogue_ai/greet(var/datum/mind/player)

	// Initializes the AI's malfunction stuff.
	spawn(0)
		if(!..())
			return

		var/mob/living/silicon/ai/A = player.current
		if(!istype(A))
			error("Non-AI mob designated malf AI! Report this.")
			world << "##ERROR: Non-AI mob designated malf AI! Report this."
			return 0

		A.setup_for_malf()
		A.laws = new /datum/ai_laws/nanotrasen/malfunction


		var/mob/living/silicon/ai/malf = player.current

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
