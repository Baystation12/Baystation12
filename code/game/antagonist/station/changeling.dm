GLOBAL_DATUM_INIT(changelings, /datum/antagonist/changeling, new)

/datum/antagonist/changeling
	id = MODE_CHANGELING
	role_text = "Changeling"
	role_text_plural = "Changelings"
	feedback_tag = "changeling_objective"
	welcome_text = "Используйте say \"%LANGUAGE_PREFIX%g (сообщение)\", чтобы связаться с другими генокрадами.<br>\
	Мы являемся частью общности - одним из сородичей, что трудится на её благо и ставить её интересы \
	выше собственных, в том числе и жизни. Вместе, члены общности должны ассимилировать полезный генетический материал \
	и украсть определенные вещи, которые облегчат охоту в будущем. \
	Наше тело требует новые геномы, чтобы жить и развиваться. Не стоит поглощать или убивать сородичей \
	- мы все практически родственники.<br>\
	Избегайте поглощения существ, чей геном бесполезен для нас. Кровожадность - это не лучшая черта высшей формы жизни... \
	Не говоря уже о том, что это привлечёт лишнее внимание от Центрального Командования. Например, сил быстрого реагирования.<br>\
	Удачной охоты."
/* old
	welcome_text = "Используйте say \",g (сообщение)\", чтобы связаться с сородичами.<br>\
	Вы - генокрад. Существо, чьим призванием является поглощение разумных и использование их генома для \
	улучшения собственного. Вы можете общаться с такими же как и вы посредством феромонов, однако, вы \
	ничем не обязаны друг другу и можете охотиться и на сородичей, если захотите - их гены станут вашими генами.<br>\
	Вы не можете поглощать кого попало. Используйте кнопку OOC > Get Objectives, чтобы узнать о жертвах с полезными \
	генами. <b><u>Поглощение без цели считается за убийство без причины</u></b> (если это не была самооборона, конечно).<br>\
	Удачной охоты."
*/
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudchangeling"
	skill_setter = /datum/antag_skill_setter/station

	faction = "changeling"

/datum/antagonist/changeling/get_welcome_text(mob/recipient)
	return replacetext(welcome_text, "%LANGUAGE_PREFIX%", recipient?.get_prefix_key(/decl/prefix/language) || ",")

/datum/antagonist/changeling/get_special_objective_text(var/datum/mind/player)
	return "<br><b>Позывной:</b> [player.changeling.changelingID].<br><b>Поглощено Геномов:</b> [player.changeling.absorbedcount]"

/datum/antagonist/changeling/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_changeling()

/datum/antagonist/changeling/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	. = ..()
	if(. && player && player.current)
		player.current.remove_changeling_powers()
		player.current.verbs -= /datum/changeling/proc/EvolutionMenu
		QDEL_NULL(player.changeling)

/* [ORIGINAL]
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

	switch(rand(1,10))
		if(1)
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
[/ORIGINAL] */

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
