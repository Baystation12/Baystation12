GLOBAL_DATUM_INIT(changelings, /datum/antagonist/changeling, new)

/datum/antagonist/changeling
	id = MODE_CHANGELING
	role_text = "Changeling"
	role_text_plural = "Changelings"
	feedback_tag = "changeling_objective"
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/submap)
	protected_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/captain, /datum/job/hos)
	welcome_text = "Use say \"#g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudchangeling"

	faction = "changeling"

/datum/antagonist/changeling/get_special_objective_text(var/datum/mind/player)
	return "<br><b>Changeling ID:</b> [player.changeling.changelingID].<br><b>Genomes Absorbed:</b> [player.changeling.absorbedcount]"

/datum/antagonist/changeling/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_changeling()

/datum/antagonist/changeling/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	. = ..()
	if(. && player && player.current)
		player.current.remove_changeling_powers()
		player.current.verbs -= /datum/changeling/proc/EvolutionMenu
		QDEL_NULL(player.changeling)

/datum/antagonist/changeling/create_objectives(var/datum/mind/changeling)
	if(!..())
		return

	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	var/datum/objective/absorb/absorb_objective = new
	absorb_objective.owner = changeling
	absorb_objective.gen_amount_goal(2, 3)
	changeling.objectives += absorb_objective

	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = changeling
	kill_objective.find_target()
	changeling.objectives += kill_objective

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = changeling
	steal_objective.find_target()
	changeling.objectives += steal_objective

	switch(rand(1,100))
		if(1 to 80)
			if (!(locate(/datum/objective/escape) in changeling.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = changeling
				changeling.objectives += escape_objective
		else
			if (!(locate(/datum/objective/survive) in changeling.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = changeling
				changeling.objectives += survive_objective
	return

/datum/antagonist/changeling/can_become_antag(var/datum/mind/player, var/ignore_role)
	if(..())
		if(player.current)
			if(ishuman(player.current))
				var/mob/living/carbon/human/H = player.current
				if(H.isSynthetic())
					return 0
				if(H.species.species_flags & SPECIES_FLAG_NO_SCAN)
					return 0
				return 1
			else if(isnewplayer(player.current))
				if(player.current.client && player.current.client.prefs)
					var/datum/species/S = all_species[player.current.client.prefs.species]
					if(S && (S.species_flags & SPECIES_FLAG_NO_SCAN))
						return 0
					if(player.current.client.prefs.organ_data[BP_CHEST] == "cyborg") // Full synthetic.
						return 0
					return 1
 	return 0