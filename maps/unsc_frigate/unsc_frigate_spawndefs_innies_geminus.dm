
/datum/map/unsc_frigate
	allowed_jobs = list(/datum/job/Insurrectionist,/datum/job/Insurrectionist_leader,/datum/job/ship_crew_innie,/datum/job/ship_cap_innie,/datum/job/cop,/datum/job/police,/datum/job/innie_sympathiser,\
	/datum/job/insurrectionist_recruiter,/datum/job/colonist_mayor,/datum/job/colonist,/datum/job/ship_crew_civ,/datum/job/ship_cap_civ,/datum/job/UNSC_ship/commander,/datum/job/UNSC_ship/exo,\
	/datum/job/UNSC_ship/bridge,\
/datum/job/UNSC_ship/marine_co,/datum/job/UNSC_ship/marine_xo,\
/datum/job/UNSC_ship/marine_sl,/datum/job/UNSC_ship/weapons,/datum/job/UNSC_ship/marine,/datum/job/bertelsODST,/datum/job/bertelsODSTO,\
/datum/job/UNSC_ship/medical_chief,/datum/job/UNSC_ship/medical,/datum/job/UNSC_ship/security_chief,/datum/job/UNSC_ship/security,\
/datum/job/UNSC_ship/cmdr_sqr,\
/datum/job/UNSC_ship/pilot,/datum/job/UNSC_ship/ai,\
/datum/job/UNSC_ship/technician_chief,/datum/job/UNSC_ship/technician,\
/datum/job/covenant/kigyarminor,/datum/job/covenant/kigyarmajor,/datum/job/covenant/kigyarcorvette/captain,/datum/job/covenant/unggoy_minor,/datum/job/covenant/unggoy_major)
	allowed_spawns = list("UNSC Frigate","UNSC Bertels ODST Spawn","UNSC Bertels ODST Officer Spawn","Colony Arrival Shuttle","Insurrectionist","Insurrectionist Leader","Innie Crew","Corvette Crew","Corvette Crew Captain","Civilian Ship Crew","Civ Ship Cap Crew","Sangheili Corvette Spawn","Kig-Yar Corvette Spawn","Unggoy Corvette Spawn","Research Facility Spawn","Research Facility Director Spawn","Research Facility Security Spawn","Research Facility Comms Spawn","Depot Guard Spawn","Emsville Spawn",,"Emsville Spawn Marshall","Listening Post Spawn","Listening Post Commander Spawn","Mining Asteroid Spawn",)
	base_turf_by_z = list("6" = /turf/simulated/floor/planet/dirt)


	species_to_job_whitelist = list(/datum/species/kig_yar = list(/datum/job/covenant/kigyarminor,/datum/job/covenant/kigyarmajor,/datum/job/covenant/kigyarcorvette/captain),/datum/species/unggoy = list(/datum/job/covenant/unggoy_minor,/datum/job/covenant/unggoy_major))

	species_to_job_blacklist = list(/datum/species/human = list(/datum/job/covenant/kigyarminor,/datum/job/covenant/kigyarmajor,/datum/job/covenant/kigyarcorvette/captain,/datum/job/covenant/unggoy_minor,/datum/job/covenant/unggoy_major))



//jobs below are cut from the list above because they have yet to be implemented
//when implemented simply cut and paste from below into the list above with proper slashes and commas respectively
//
//,/datum/job/UNSC_ship/cag
///datum/job/UNSC_ship/mechanic_chief,
///datum/job/UNSC_ship/mechanic,
///datum/job/UNSC_ship/logistics_chief,
///datum/job/UNSC_ship/logistics,
///datum/job/UNSC_ship/marine/driver,
///datum/job/UNSC_ship/ops_chief,
///datum/job/UNSC_ship/ops,
///datum/job/UNSC_ship/cmdr_wing,
///datum/job/UNSC_ship/gunnery_chief,
///datum/job/UNSC_ship/gunnery,



