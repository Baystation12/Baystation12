
/datum/map/first_contact
	allowed_jobs = list(\
		/datum/job/unscbertels_co,\
		/datum/job/unscbertels_xo,\
		/datum/job/unscbertels_ship_crew,\
		/datum/job/unscbertels_medical_crew,\
		/datum/job/bertelsunsc_ship_marine,\
		/datum/job/unsc_ship_marineplatoon,\
		/datum/job/bertelsODST,\
		/datum/job/bertelsODSTO,\
		/datum/job/unscaegis_co,\
		/datum/job/unscaegis_ship_crew,\
		/datum/job/aegisODSTONI,\
		/datum/job/aegisODSTOONI,\
		/datum/job/researchdirector,\
		/datum/job/researcher,\
		/datum/job/ONIGUARD,\
		/datum/job/ONIGUARDS,\
		/datum/job/IGUARD,\
		/datum/job/ship_crew_civ,\
		/datum/job/ship_cap_civ,\
		/datum/job/ship_crew_medic,\
		/datum/job/ship_cap_medic,\
		/datum/job/Emsville_Colonist,\
		/datum/job/Emsville_Marshall,\
		/datum/job/ship_crew_innie,\
		/datum/job/ship_cap_innie,\
		/datum/job/URF_commando,\
		/datum/job/URF_commando_officer,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyarmajor,
		/datum/job/covenant/kigyarcorvette/captain,\
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/sangheili_shipmaster)

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID,\
		"Innie Base Spawns",\
		"UNSC Base Spawns",\
		"Covenant Base Spawns",\
		"Civilian Ship Crew",\
		"Civ Ship Cap Crew",\
		"Medical Ship Crew",\
		"Medical Ship Cap Crew",\
		"Emsville Spawn",\
		"Emsville Spawn Marshall",\
		"Research Facility Spawn",\
		"Research Facility Director Spawn",\
		"Research Facility Security Spawn",\
		"Listening Post Spawn",\
		"Listening Post Commander Spawn",\
		"Depot Guard Spawn",\
		"UNSC Aegis Ship Crew Spawn",\
		"UNSC Aegis ODST Spawn",\
		"UNSC Aegis ODST Officer Spawn")

	default_spawn = DEFAULT_SPAWNPOINT_ID

	species_to_job_whitelist = list(\
		/datum/species/kig_yar = list(/datum/job/covenant/kigyarminor,/datum/job/covenant/kigyarmajor,/datum/job/covenant/kigyarcorvette/captain),\
		/datum/species/unggoy = list(/datum/job/covenant/unggoy_minor,/datum/job/covenant/unggoy_major),\
		/datum/species/sangheili = list(/datum/job/covenant/sangheili_minor,/datum/job/covenant/sangheili_major,/datum/job/covenant/sangheili_ultra,/datum/job/covenant/sangheili_shipmaster),\
		/datum/species/kig_yar_skirmisher = list(/datum/job/covenant/skirmminor,/datum/job/covenant/skirmmajor,/datum/job/covenant/skirmmurmillo,/datum/job/covenant/skirmcommando),\
		/datum/species/spartan = list(),\
		/datum/species/brutes = list(),\
		/datum/species/sanshyuum = list()\
		)
