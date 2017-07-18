var/datum/antagonist/revolutionary/revs

/datum/antagonist/revolutionary
	id = MODE_REVOLUTIONARY
	role_text = "Head Revolutionary"
	role_text_plural = "Revolutionaries"
	feedback_tag = "rev_objective"
	antag_indicator = "hudheadrevolutionary"
	welcome_text = "Down with the capitalists! Down with the Bourgeoise!"
	victory_text = "The heads of staff were relieved of their posts! The revolutionaries win!"
	loss_text = "The heads of staff managed to stop the revolution!"
	victory_feedback_tag = "win - heads killed"
	loss_feedback_tag = "loss - rev heads killed"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	antaghud_indicator = "hudrevolutionary"

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	//Inround revs.
	faction_role_text = "Revolutionary"
	faction_descriptor = "Revolution"
	faction_verb = /mob/living/proc/convert_to_rev
	faction_welcome = "Help the cause overturn the ruling class. Do not harm your fellow freedom fighters."
	faction_indicator = "hudrevolutionary"
	faction_invisible = 1
	faction = "revolutionary"

	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg)
	restricted_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/hos, /datum/job/chief_engineer, /datum/job/rd, /datum/job/cmo, /datum/job/lawyer)
	protected_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/detective)


/datum/antagonist/revolutionary/New()
	..()
	revs = src

/datum/antagonist/revolutionary/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(!player.mind || player.stat==2 || !(player.mind.assigned_role in command_positions))
			continue
		var/datum/objective/rev/rev_obj = new
		rev_obj.target = player.mind
		rev_obj.explanation_text = "Assassinate, capture or convert [player.real_name], the [player.mind.assigned_role]."
		global_objectives += rev_obj
