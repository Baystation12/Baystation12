
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

/datum/objective/kill_mayor
	short_text = "Kill the colony Mayor"
	explanation_text = "The Mayor is a UEG stooge. Kill him to open the way for colonial independance."
	win_points = 100

/datum/objective/kill_policechief
	short_text = "Kill the colony Police Chief"
	explanation_text = "The Police Chief is an oppressive tyrant. Kill him to free our people."
	win_points = 100

/* done */

/datum/objective/destroy_ship/innie
	short_text = "Destroy the UNSC warship"
	explanation_text = "UNSC warships are deadly, carrying special weapons and soldiers to crush many revolts before they can begin. Don't allow this one to escape."

/datum/objective/destroy_ship/innie/find_target()
	target_ship = GLOB.UNSC.get_flagship()
	return target_ship

/datum/objective/assassinate/kill_unsc_leader
	short_text = "Kill UNSC commander"
	explanation_text = "We must cut the head off the snake to delay the UNSC efforts in this system. Kill the UNSC commander."
	win_points = 50
	find_specific_target = 1

/datum/objective/assassinate/kill_unsc_leader/find_target()
	target = GLOB.UNSC.get_commander()
	if(target)
		explanation_text = "Kill [target.current.real_name], the [target.assigned_role]."
	return target

/datum/objective/assassinate/kill_unsc_leader/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || isbrain(target.current) || !target.current.ckey)
			return 1
	return 0

/datum/objective/protect_colony/innie
	short_text = "Protect the human colony"
	explanation_text = "Earth has abandoned us, but we will never stop fighting. Someone has to save these civilians."

/datum/objective/protect/innie_leader
	short_text = "Protect the Insurrectionist commander"
	explanation_text = "Protect the Insurrectionist Commander. Without their inspirational lead, the Insurrection will fall apart."
	lose_points = 50
	find_specific_target = 1

/datum/objective/protect/innie_leader/find_target()
	target = GLOB.INSURRECTION.get_commander()
	if(target)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
	return target

/datum/objective/colony_capture/innie
	short_text = "Colonial revolt"
	explanation_text = "Raise the colony in revolt! We must remove the UNSC from our world."
