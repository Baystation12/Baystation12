GLOBAL_LIST_EMPTY(achlys_prison_spawns)

/datum/spawnpoint/achlys_prison
	display_name =  "Achlys Prison"
	restrict_job = list("Prisoner","Sangheili Prisoner")

/datum/spawnpoint/achlys_prison/New()
	..()
	turfs = GLOB.achlys_prison_spawns

/obj/effect/landmark/start/achlys_prison
	name = "Achlys Prison"

/obj/effect/landmark/start/achlys_prison/New()
	..()
	GLOB.achlys_prison_spawns += loc

/datum/job/achlys/sangheili
	title = "Sangheili Prisoner"
	total_positions = 10
	spawn_positions = 10
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/job/unsc_anchlys/sangheili
	spawnpoint_override = "Achlys Prison"
	faction_whitelist = "Covenant"
	latejoin_at_spawnpoints = TRUE

/datum/job/achlys/prisoner
	title = "Prisoner"
	total_positions = 10
	spawn_positions = 10
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/prisoner
	spawnpoint_override = "Achlys Prison"
	latejoin_at_spawnpoints = TRUE

GLOBAL_LIST_EMPTY(dante_enlisted_spawns)

/datum/spawnpoint/dante_enlisted
	display_name =  "Dante Enlisted"
	restrict_job = list("Marine","Squad Leader","ONI Operative")

/datum/spawnpoint/dante_enlisted/New()
	..()
	turfs = GLOB.dante_enlisted_spawns

/obj/effect/landmark/start/dante_enlisted
	name = "Dante Enlisted"

/obj/effect/landmark/start/dante_enlisted/New()
	..()
	GLOB.dante_enlisted_spawns += loc

/datum/job/achlys/marine
	title = "Marine"
	total_positions = 18
	spawn_positions = 18
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/marine
	access = list(142)
	spawnpoint_override = "Dante Enlisted"
	latejoin_at_spawnpoints = TRUE

/datum/job/achlys/marine/operative
	title = "ONI Operative"
	total_positions = 6
	spawn_positions = 6
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/marine/operative
	access = list(142)
	spawnpoint_override = "Dante Enlisted"
	latejoin_at_spawnpoints = TRUE

/datum/job/achlys/SL
	title = "Squad Leader"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/SL
	access = list(142,143)
	spawnpoint_override = "Dante Enlisted"
	latejoin_at_spawnpoints = TRUE

GLOBAL_LIST_EMPTY(dante_pilot_spawns)

/datum/spawnpoint/dante_pilot
	display_name =  "Dante Pilot"
	restrict_job = list("Pelican Pilot")

/datum/spawnpoint/dante_pilot/New()
	..()
	turfs = GLOB.dante_pilot_spawns

/obj/effect/landmark/start/dante_pilot
	name = "Dante Pilot"

/obj/effect/landmark/start/dante_pilot/New()
	..()
	GLOB.dante_pilot_spawns += loc

/datum/job/achlys/pilot
	title = "Pelican Pilot"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/pilot
	access = list(144)
	spawnpoint_override = "Dante Pilot"
	latejoin_at_spawnpoints = TRUE

GLOBAL_LIST_EMPTY(dante_officer_spawns)

/datum/spawnpoint/dante_officer
	display_name =  "Dante Officer"
	restrict_job = list("UNSC Dante CO")

/datum/spawnpoint/dante_officer/New()
	..()
	turfs = GLOB.dante_officer_spawns

/obj/effect/landmark/start/dante_officer
	name = "Dante Officer"

/obj/effect/landmark/start/dante_officer/New()
	..()
	GLOB.dante_officer_spawns += loc

/datum/job/achlys/CO
	title = "UNSC Dante CO"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/CO
	access = list(142,143,144,145)
	spawnpoint_override = "Dante Officer"
	latejoin_at_spawnpoints = TRUE

/datum/map/unsc_achlys
	allowed_jobs = list(/datum/job/achlys/CO,/datum/job/achlys/pilot,/datum/job/achlys/SL,/datum/job/achlys/marine,/datum/job/achlys/marine/operative,/datum/job/achlys/prisoner,/datum/job/achlys/sangheili)
	allowed_spawns = list("Dante Officer","Dante Pilot","Dante Enlisted","Achlys Prison")

	species_to_job_whitelist = list(/datum/species/sangheili = list(/datum/job/achlys/sangheili))

	species_to_job_blacklist = list(/datum/species/human = list(/datum/job/achlys/sangheili))
