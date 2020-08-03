
/datum/game_mode/outer_colonies/reclamation
	name = "Reclamation"
	config_tag = "reclamation"
	round_description = "The Covenant ransack the outer edges of human space for Forerunner artifacts."
	extended_round_description = "The Covenant ransack the outer edges of human space for Forerunner artifacts."
	required_players = 0
	end_conditions_required = 2
	factions = list(/datum/faction/unsc, /datum/faction/covenant)
	//overmap_hide = list(/obj/effect/overmap/sector/exo_listen, /obj/effect/overmap/ship/urf_flagship)
	faction_balance = list(/datum/faction/covenant,/datum/faction/unsc)
	disabled_jobs_types = list(\
		/datum/job/soe_commando,\
		/datum/job/soe_commando_officer,\
		/datum/job/soe_commando_captain,\
		/datum/job/geminus_x52/researcher,\
		/datum/job/geminus_x52/research_director,\
		/datum/job/geminus_innie,\
		/datum/job/geminus_innie/officer,\
		/datum/job/geminus_innie/commander,\
		/datum/job/geminus_innie/orion_defector,\
		/datum/job/insurrectionist_ai,\
		/datum/job/colonist/police,\
		/datum/job/colonist/police/chief,\
		/datum/job/colonist,\
		/datum/job/colonist/mayor,\
		/datum/job/colony_ai)

	votable = 1

/datum/game_mode/outer_colonies/reclamation/setup_objectives()
	/*
	. = ..()

	//in rev and rec, UNSC keep some objectives but they aren't tracked as the faction doesnt exist
	//this is to prevent metagaming if the mode is secret

	var/list/fake_objective_types = list(\
		/datum/objective/capture_innies,\
		/datum/objective/overmap/unsc_innie_ship,\
	)

	for(var/datum/objective/obj in GLOB.UNSC.all_objectives)
		if(fake_objective_types.Find(obj.type))
			obj.fake = 1
	*/

	//setup covenant objectives
	var/list/objective_types = list(\
		/datum/objective/protect/leader,\
		/datum/objective/overmap/covenant_ship,\
		/datum/objective/overmap/covenant_odp,\
		/datum/objective/phase2_scan,\
		/datum/objective/retrieve/artifact,\
		/datum/objective/glass_colony)
	GLOB.COVENANT.setup_faction_objectives(objective_types)
	GLOB.COVENANT.has_flagship = TRUE

	//setup unsc objectives
	objective_types = list(\
		/datum/objective/protect/leader,\
		/datum/objective/overmap/unsc_cov_ship,\
		/datum/objective/overmap/unsc_odp,\
		/datum/objective/phase2_scan_unsc,\
		/datum/objective/protect_colony)
	GLOB.UNSC.setup_faction_objectives(objective_types)
	GLOB.UNSC.has_base = TRUE
