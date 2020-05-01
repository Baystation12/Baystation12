
/datum/game_mode/firefight/stranded
	name = "Stranded"
	config_tag = "stranded"
	enemy_faction_name = "Flood"
	votable = 1
	round_description = "Build a base in order to survive. The Flood is coming..."
	extended_round_description = "Your ship has crash landed on a distant alien world. Now waves of Flood are attacking and there is only limited time to setup defences. Can you survive until the rescue team arrives?"
	assault_landmark_type = /obj/effect/landmark/assault_target/flood

	wave_message = "Flood spawns have started! Get back to your base and dig in..."
	rest_message = "Flood have been destroyed! Get back to your base and repair your defences..."
	evac_message = "The pelican has arrived! Protect it until it is ready to liftoff!"

	list/resupply_procs = list(\
		/datum/game_mode/firefight/proc/spawn_resupply,\
		/datum/game_mode/firefight/proc/spawn_ship_debris)

	disabled_jobs_types = list(\
		//Covenant jobs
		/datum/job/covenant/brute_captain,\
		/datum/job/covenant/brute_major,\
		/datum/job/covenant/brute_minor,\
		//
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyar_marksman,\
		/datum/job/covenant/kigyar_sniper,\
		//
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_ranger,\
		/datum/job/covenant/sangheili_specops,\
		/datum/job/covenant/sangheili_zealot,\
		//
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/skirmcommando,\
		//
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/unggoy_ultra,\
		/datum/job/covenant/unggoy_deacon,\
		//
		/datum/job/covenant/yanmee_minor,\
		/datum/job/covenant/yanmee_major,\
		/datum/job/covenant/yanmee_ultra,\
		/datum/job/covenant/yanmee_leader,\

		//UNSC jobs
		/datum/job/firefight_unsc_marine,\
		/datum/job/firefight_colonist\
		/*
		//UNSC survivor jobs
		/datum/job/stranded/unsc_marine,\
		/datum/job/stranded/unsc_tech,\
		/datum/job/stranded/unsc_medic,\
		/datum/job/stranded/unsc_crew,\
		/datum/job/stranded/unsc_civ\
		*/
		)

/datum/game_mode/firefight/stranded/pre_setup()
	. = ..()
	allowed_ghost_roles += list(/datum/ghost_role/flood_combat_form)
