
/datum/map/first_contact
	allowed_jobs = list(\
		/datum/job/researchdirector,\
		/datum/job/researcher,\
		/datum/job/ONIGUARD,\
		/datum/job/ONIGUARDS,\
		/datum/job/IGUARD,\
		/datum/job/Emsville_Colonist,\
		/datum/job/Emsville_Marshall,\
		/datum/job/ship_crew_innie,\
		/datum/job/ship_cap_innie,\
		/datum/job/URF_commando,\
		/datum/job/URF_commando_officer,\
		/datum/job/UNSC_ship/commander,\
		/datum/job/UNSC_ship/exo,\
		/datum/job/UNSC_ship/cag,\
		/datum/job/UNSC_ship/bridge,
		/datum/job/UNSC_ship/mechanic_chief,\
		/datum/job/UNSC_ship/mechanic,\
		/datum/job/UNSC_ship/logistics_chief,\
		/datum/job/UNSC_ship/logistics,\
		/datum/job/UNSC_ship/marine_co,\
		/datum/job/UNSC_ship/marine_xo,\
		/datum/job/UNSC_ship/marine_sl,\
		/datum/job/UNSC_ship/weapons,\
		/datum/job/UNSC_ship/marine,\
		/datum/job/UNSC_ship/marine/driver,\
		/datum/job/UNSC_ship/medical_chief,\
		/datum/job/UNSC_ship/medical,\
		/datum/job/UNSC_ship/security_chief,\
		/datum/job/UNSC_ship/unsc_security,\
		/datum/job/UNSC_ship/ops_chief,\
		/datum/job/UNSC_ship/ops,\
		/datum/job/UNSC_ship/cmdr_wing,\
		/datum/job/UNSC_ship/cmdr_sqr,\
		/datum/job/UNSC_ship/pilot,\
		/datum/job/UNSC_ship/ai,\
		/datum/job/UNSC_ship/gunnery_chief,\
		/datum/job/UNSC_ship/gunnery,\
		/datum/job/UNSC_ship/technician_chief,\
		/datum/job/UNSC_ship/technician,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyarmajor,\
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
		"UNSC Aegis ODST Officer Spawn",\
		"AI")

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
