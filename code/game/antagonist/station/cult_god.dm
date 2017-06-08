var/datum/antagonist/godcultist/godcult

/datum/antagonist/godcultist
	id = MODE_GODCULTIST
	role_text = "God Cultist"
	role_text_plural = "Cultists"
	restricted_jobs = list("Internal Affairs Agent", "Head of Security", "Captain")
	protected_jobs = list("Security Officer", "Warden", "Detective")
	blacklisted_jobs = list("AI", "Cyborg", "Chaplain")
	feedback_tag = "godcult_objective"
	antag_indicator = "hudcultist"
	welcome_text = "You are under the guidance of a powerful otherwordly being. Spread its will and keep your faith."
	victory_text = "The cult wins! It has succeeded in serving its dark masters!"
	loss_text = "The staff managed to stop the cult!"
	victory_feedback_tag = "win - cult win"
	loss_feedback_tag = "loss - staff stopped the cult"
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 6
	initial_spawn_req = 2
	initial_spawn_target = 2
	antaghud_indicator = "hudcultist"

/datum/antagonist/godcultist/New()
	..()
	godcult = src

/datum/antagonist/godcultist/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)
	if(!..())
		return 0
	if(!deity || !deity.current_antagonists.len)
		return 0

	var/count = current_antagonists.len //We should be added to said antagonists, so we could say that we are this number in line.
	if(count > deity.current_antagonists.len) //Prolly a better way of doing this
		count %= deity.current_antagonists.len
		if(count == 0)
			count = deity.current_antagonists.len
	var/datum/mind/mind = deity.current_antagonists[count]
	var/mob/living/deity/d = mind.current
	d.change_follower(player.current, adding = 1) //add a follower
	return 1

/datum/antagonist/godcultist/add_antagonist_mind(var/datum/mind/player, var/ignore_role, var/nonstandard_role_type, var/nonstandard_role_msg, var/mob/living/deity/specific_god)
	if(!..())
		return 0

	if(specific_god)
		specific_god.change_follower(player.current, adding = 1)
		player.current.add_language(LANGUAGE_CULT)

	return 1

/datum/antagonist/godcultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return 0
	for(var/m in deity.current_antagonists)
		var/datum/mind/mind = m
		var/mob/living/deity/god = mind.current
		if(god.is_follower(player.current,1))
			god.change_follower(player.current, adding = 0)
			break
	player.current.remove_language(LANGUAGE_CULT)
	return 1