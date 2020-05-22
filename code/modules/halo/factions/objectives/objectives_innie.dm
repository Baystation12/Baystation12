
/* INSURRECTION */




/* todo */

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

/datum/objective/overmap/innie_unsc_ship
	short_text = "Destroy the UNSC warship"
	explanation_text = "UNSC warships are deadly, carrying special weapons and soldiers to crush many revolts before they can begin. Don't allow this one to escape."
	target_faction_name = "UNSC"
	objective_type = 0
	win_points = 100

/datum/objective/overmap/innie_base
	short_text = "Protect Base"
	explanation_text = "Protect your hidden base. From there you can launch the campaign to take over Geminus and beyond!"
	target_faction_name = "Insurrection"
	overmap_type = 0
	lose_points = 100

/datum/objective/overmap/innie_ship
	short_text = "Protect Flagship"
	explanation_text = "Protect your flagship. From there you can launch the campaign to take over Geminus and beyond!"
	target_faction_name = "Insurrection"
	overmap_type = 1
	lose_points = 100

/datum/objective/protect_colony/innie
	short_text = "Protect the human colony"
	explanation_text = "Earth has abandoned us, but we will never stop fighting. Someone has to save these civilians."

/datum/objective/protect/leader/innie
	short_text = "Protect the Insurrectionist commander"
	explanation_text = "Protect the Insurrectionist Commander. Without their inspirational lead, the Insurrection will fall apart."
	lose_points = 50

/datum/objective/colony_capture/innie
	short_text = "Colonial revolt"
	explanation_text = "Raise the colony in revolt! We must remove the UNSC from our world."
	radio_name = "Insurrection Overwatch"
	win_points = 150

/datum/objective/assassinate/leader/innies_unsc
	explanation_text = "Assassinate the leader of the UNSC"
	target_faction_name = "UNSC"

/datum/objective/overmap/innie_odp
	short_text = "Destroy the UNSC defence platform"
	explanation_text = "The orbital defence platform is a symbol of UNSC dominance in orbit. Bring it down"
	target_faction_name = "UNSC"
	objective_type = 0
	overmap_type = 0
	win_points = 50

/datum/objective/overmap/innie_ship
	short_text = "Protect URF ship"
	explanation_text = "Our ship lets us strike from space where the UNSC least expects it. Do not let it get destroyed!"
	target_faction_name = "Insurrection"
	lose_points = 150
