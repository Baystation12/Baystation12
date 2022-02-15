var/datum/antagonist/revolutionary/revs

/datum/antagonist/revolutionary
	id = MODE_REVOLUTIONARY
	role_text = "Head Revolutionary"
	role_text_plural = "Revolutionaries"
	feedback_tag = "rev_objective"
	antag_indicator = "hudheadrevolutionary"
	welcome_text = "You have a cause of your own you champion, worth more than the beliefs you held before."
	victory_text = "As a group, the revolutionaries achieved their goals. The revolutionaries win!"
	loss_text = "The revolutionaries failed in their goals."
	victory_feedback_tag = "win - rev"
	loss_feedback_tag = "loss - rev"
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
	faction_welcome = "Champion your cause. Do not harm your staunch allies."
	faction_indicator = "hudrevolutionary"
	faction_invisible = 1

	blacklisted_jobs = list()
	restricted_jobs = list()
	protected_jobs = list()


/datum/antagonist/revolutionary/New()
	..()
	revs = src

/datum/antagonist/revolutionary/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	var/list/players_temp = GLOB.player_list.Copy()
	for(var/i = 1 to rand(2,5))
		if(players_temp.len == 0)
			break
		var/mob/living/carbon/human/player = pick(players_temp)
		players_temp -= player
		if(!istype(player) || !player.loc || !player.mind || player.mind in current_antagonists || player.stat == DEAD)
			continue
		var/datum/objective/rev/rev_obj = new
		rev_obj.target = player.mind
		if(!(locate(/datum/objective/survive/targeted) in player.mind.objectives))
			var/datum/objective/t = new /datum/objective/survive/targeted
			t.owner = player.mind
			player.mind.objectives.Add(t)
			show_objectives(player.mind)
		rev_obj.explanation_text = "Assassinate, capture or convert [player.real_name], the [player.mind.assigned_role]."
		global_objectives += rev_obj
