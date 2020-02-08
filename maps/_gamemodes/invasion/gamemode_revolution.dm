
/datum/game_mode/outer_colonies/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "In an outer colony on the edge of human space, a revolution is brewing."
	extended_round_description = "In an outer colony on the edge of human space, a revolution is brewing."
	required_players = 0
	end_conditions_required = 1
	factions = list(/datum/faction/unsc, /datum/faction/insurrection)
	overmap_hide = list(/obj/effect/overmap/sector/exo_research, /obj/effect/overmap/sector/exo_listen, /obj/effect/overmap/ship/covenant_light_cruiser)
	disabled_jobs_types = list(\
		/datum/job/researchdirector,\
		/datum/job/researcher,\
		/datum/job/ONIGUARD,\
		/datum/job/ONIGUARDS,\
		/datum/job/covenant/huragok,\
		/datum/job/covenant/AI,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/unggoy_minor,
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/unggoy_ultra,\
		/datum/job/covenant/unggoy_deacon,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/skirmcommando,\
		/datum/job/covenant/brute_minor,\
		/datum/job/covenant/brute_major,\
		/datum/job/covenant/brute_captain,\
		/datum/job/covenant/yanmee_minor,\
		/datum/job/covenant/yanmee_major,\
		/datum/job/covenant/yanmee_ultra,\
		/datum/job/covenant/yanmee_leader,\
		/datum/job/ONI_Spartan_II,)

/datum/game_mode/outer_colonies/revolution/setup_objectives()
	. = ..()

	var/datum/objective/retrieve/steal_ai/cole_protocol/obj = locate() in GLOB.UNSC.all_objectives
	obj.fake = 1

	var/datum/objective/retrieve/nav_data/cole_protocol/obj2 = locate() in GLOB.UNSC.all_objectives
	obj2.fake = 1

	var/datum/objective/overmap/unsc_cov_ship/obj3 = locate() in GLOB.UNSC.all_objectives
	obj3.fake = 1

	var/datum/objective/retrieve/artifact/unsc/obj4 = locate() in GLOB.UNSC.all_objectives
	obj4.fake = 1
