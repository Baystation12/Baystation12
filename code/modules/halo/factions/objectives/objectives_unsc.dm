
/* UNSC */

/datum/objective/overmap/unsc_ship
	short_text = "Protect the UNSC warship"
	target_faction_name = "UNSC"
	explanation_text = "Although cheaper than a MJOLNIR suit, even Spartans need a way to leave atmosphere. Protect the UNSC ship."
	lose_points = 100

//see objectives_cov.dm
/datum/objective/retrieve/nav_data/cole_protocol
	short_text = "Do not allow Covenant capture of human nav data"
	explanation_text = "We lose more colonies every year. Soon Earth will be all we have left. Do not allow navchips to be captured by the Covenant."
	points_per_item = 150
	lose_points = 150
	slipspace_affected = 1

/datum/objective/retrieve/nav_data/cole_protocol/check_completion()
	. = ..()
	lose_points = win_points
	win_points = 0
	return !.

/datum/objective/retrieve/steal_ai/cole_protocol
	points_per_item = 150
	short_text = "Do not allow Covenant capture of UNSC AI"
	explanation_text = "Destruction or capture of shipboard AI is absolutely unacceptable. They'll learn everything: weapons research, force deployments, Earth."
	slipspace_affected = 1

/datum/objective/retrieve/steal_ai/cole_protocol/check_completion()
	. = ..()
	lose_points = win_points
	win_points = 0
	return !.

//todo: oni agent job role

/*/datum/objective/capture_innies
	short_text = "Capture Insurrectionists for ONI interrogation"
	explanation_text = "The Insurrection worsens every year. Put some on ice in ONI cryopods for later black site interrogation. Kill the rest"
	var/points_per_capture = 50
	var/points_per_kill = 10
	var/list/minds_captured = list()
	var/list/minds_killed = list()

/datum/objective/capture_innies/check_completion()
	win_points = 0
	win_points += minds_captured.len * points_per_capture
	win_points += minds_killed.len * points_per_kill
	return win_points > 0
*/

/datum/objective/retrieve/artifact/unsc
	short_text = "Secure the alien artifact"
	explanation_text = "ONI reports a high value unidentified alien artifact in the sector. It must be secured by the UNSC to prevent falling into the wrong hands."

/datum/objective/protect_colony
	short_text = "Protect the UEG colony from destruction"
	explanation_text = "There are a million innocent civilians on that colony. Prevent its destruction by any means necessary."
	lose_points = 100

/datum/objective/protect_colony/check_completion()
	var/obj/effect/overmap/human_colony = GLOB.HUMAN_CIV.get_base()
	if(human_colony && (human_colony.nuked || human_colony.glassed))
		return 0
	return 1

/datum/objective/overmap/unsc_cov_ship
	short_text = "Destroy the Covenant warship"
	explanation_text = "We cannot allow any Covenant warship to escape to threaten Earth. Take them out before they can retreat from the system."
	slipspace_affected = 1
	objective_type = 0
	target_faction_name = "Covenant"
	win_points = 150

/datum/objective/colony_capture/unsc
	short_text = "Hold the UEG colony"
	explanation_text = "We draw the line here. Do not allow rebels or aliens to capture our world."
	radio_name = "UNSC Overwatch"

/datum/objective/overmap/unsc_innie_base
	short_text = "Eliminate the URF Flagship."
	explanation_text = "Without a command center, the Insurrectionists will be less organized in their defiance. Destroy their flagship."
	target_faction_name = "Insurrection"
	objective_type = 0
	overmap_type = 1
	win_points = 100
