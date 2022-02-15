/datum/antagonist/changeling
	id = MODE_CHANGELING
	role_text = "Flood Infiltrator"
	role_text_plural = "Flood Infiltrators"
	feedback_tag = "changeling_objective"
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg)
	protected_jobs = list()
	welcome_text = "Use say \"#g message\" to communicate with your fellow Infiltrators. Remember: you get all of their absorbed DNA if you absorb them."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudchangeling"

/datum/antagonist/changeling/get_special_objective_text(var/datum/mind/player)
	return "<br><b>Flood Infiltrator ID:</b> [player.changeling.changelingID].<br><b>Genomes Absorbed:</b> [player.changeling.absorbedcount]"

/datum/antagonist/changeling/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_changeling()

/datum/antagonist/changeling/create_objectives(var/datum/mind/changeling)
	if(!..())
		return

	//OBJECTIVES - Always absorb 2-4 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	var/datum/objective/absorb/absorb_objective = new
	absorb_objective.owner = changeling
	absorb_objective.gen_amount_goal(1, 2)
	changeling.objectives += absorb_objective

	var/max_hostile_objs = 2
	var/list/targets = list()

	if(max_hostile_objs)
		for(var/i = 1 to rand(1,max_hostile_objs))
			max_hostile_objs--
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = changeling
			kill_objective.find_target(targets)
			targets += kill_objective.target.current
			changeling.objectives += kill_objective

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
				if(H.species.flags & NO_SCAN)
					return 0
				return 1
			else if(isnewplayer(player.current))
				if(player.current.client && player.current.client.prefs)
					var/datum/species/S = all_species[player.current.client.prefs.species]
					if(S && (S.flags & NO_SCAN))
						return 0
					if(player.current.client.prefs.organ_data[BP_CHEST] == "cyborg") // Full synthetic.
						return 0
					return 1
 	return 0