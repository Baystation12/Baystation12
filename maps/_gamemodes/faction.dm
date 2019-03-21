
/datum/faction
	var/name = "Unknown faction"
	var/points = 0
	var/datum/objective/main_objective
	var/list/other_objectives = list()
	var/list/all_objectives = list()
	var/list/assigned_minds = list()
	var/list/living_minds = list()
	var/max_points = 0

/datum/faction/proc/players_alive()
	return living_minds.len

/datum/faction/covenant
	name = "Covenant"
	var/list/objective_types = list()

/datum/faction/unsc
	name = "UNSC"

/datum/faction/insurrection
	name = "Insurrection"
