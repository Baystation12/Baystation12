
/* INSURRECTION */

/* todo */

/datum/objective/takeover_colony
	short_text = "Raise the colony in revolt for the Insurrection"
	explanation_text = "We must throw off the yoke of the United Earth Government and their lackeys the UNSC."
	win_points = 200

/datum/objective/recruit_pirates
	short_text = "Recruit pirates/mercs to the Insurrection"
	explanation_text = "To take control of space, we'll need the help of these locals."
	win_points = 50

/datum/objective/recruit_scientists
	short_text = "Recruit scientists to the Insurrection"
	explanation_text = "We need to augment our forces with advanced new weaponry to combat the UNSC."
	win_points = 50

/* done */

/datum/objective/destroy_unsc_ship/innie
	short_text = "Destroy the UNSC warship"
	explanation_text = "UNSC warships are deadly, carrying special weapons and soldiers to crush many revolts before they can begin. Don't allow this one to escape."

/datum/objective/assassinate/kill_unsc_leader
	short_text = "Kill UNSC commander"
	explanation_text = "We must cut the head off the snake to delay the UNSC efforts in this system. Kill the UNSC commander."
	win_points = 50
	find_specific_target = 1

/datum/objective/assassinate/kill_unsc_leader/find_target_specific(var/datum/mind/check_mind)
	if(check_mind)
		if(!target)
			if(check_mind.assigned_role == "UNSC Heavens Above Commanding Officer")
				target = check_mind
			else if(check_mind.assigned_role == "UNSC Bertels Commanding Officer")
				target = check_mind
			if(target)
				. = 1
	else
		find_target_by_role("UNSC Heavens Above Commanding Officer")
		if(!target)
			find_target_by_role("UNSC Bertels Commanding Officer")
		if(target)
			. = 1
	if(explanation_text == "Free Objective")
		explanation_text  = "Kill the UNSC commander."

/datum/objective/assassinate/kill_unsc_leader/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || isbrain(target.current) || !target.current.ckey)
			return 1
	return 0

/datum/objective/protect_colony/innie
	short_text = "Protect the human colony"
	explanation_text = "Earth has abandoned us, but we will never stop fighting. Someone has to save these civilians."

/datum/objective/destroy_cov_ship/innie
	short_text = "Destroy the Covenant warship"
	explanation_text = "Soon to be nothing but high tech scrap."

/datum/objective/protect/protect_innie_leader
	short_text = "Protect the Insurrectionist commander"
	explanation_text = "Without their inspirational lead, the Insurrection will fall apart. Protect the Insurrectionist Commander."
	lose_points = 50
	find_specific_target = 1

/datum/objective/protect/protect_innie_leader/find_target_specific(var/datum/mind/check_mind)
	if(check_mind)
		if(!target)
			if(check_mind.assigned_role == "Insurrectionist Commander")
				target = check_mind
			if(target)
				. = 1
	else
		find_target_by_role("Insurrectionist Commander")
		if(target)
			. = 1

	if(explanation_text == "Free Objective")
		explanation_text  = "Protect the Insurrectionist Commander."

/datum/objective/colony_capture/innie
	short_text = "Colonial revolt"
	explanation_text = "Raise the colony in revolt! We must remove the UNSC from our world."
