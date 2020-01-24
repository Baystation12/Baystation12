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
	whitelisted_species = list(/datum/job/achlys/sangheili)
	spawnpoint_override = "Achlys Prison"
	faction_whitelist = "Covenant"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are a prisoner on a human ship, captured and intended to be used for experiments until one of your brothers escaped and sprung the entire ship from captivity, human and sangheili alike. Unfortunately, the Flood escaped with you."

/datum/job/achlys/prisoner
	title = "Prisoner"
	total_positions = 10
	spawn_positions = 10
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/prisoner
	whitelisted_species = list(/datum/species/human)
	spawnpoint_override = "Achlys Prison"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are a prisoner on the UNSC Achlys where something terrible has happened. You've been drifting in space for what felt like days but something changed with the monsters. Something big is happening in engineering."

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
	whitelisted_species = list(/datum/species/human)
	access = list(142)
	spawnpoint_override = "Dante Enlisted"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are a Marine. The lowest rank in the branch, your objective is to follow the orders of your Commander and Squad Leader. Cole Protocol must be enacted on the UNSC Achlys resulting in the destruction of two nav consoles. Survival is not guaranteed."

/datum/job/achlys/marine/operative
	title = "ONI Operative"
	total_positions = 6
	spawn_positions = 6
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/marine/operative
	whitelisted_species = list(/datum/species/human)
	access = list(142)
	spawnpoint_override = "Dante Enlisted"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are an ONI Operative disguised as a marine. Do not allow anyone else to know your true identity. Your job is to kill anyone who sets foot on the UNSC Achlys after you sit through a briefing and collect your loadout. There must be no survivors and you are considered expendable. You must complete your mission of retrieving the documents to the blackbox in Prep and eliminating all witnesses to the events onboard the Achlys. Execute with extreme prejudice."

/datum/job/achlys/SL
	title = "Squad Leader"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#0A0A95"
	outfit_type = /decl/hierarchy/outfit/job/unsc_achlys/SL
	whitelisted_species = list(/datum/species/human)
	access = list(142,143)
	spawnpoint_override = "Dante Enlisted"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are the Squad Leader. Your job is to delegate tasks to marines and ensure they are doing their jobs when on the UNSC Achlys. Ensure they ride a pelican over after a possible briefing from the Commander and preparing with a loadout below the briefing room towards the aft of the ship."

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
	whitelisted_species = list(/datum/species/human)
	access = list(144)
	spawnpoint_override = "Dante Pilot"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are a pilot. Your job is to fly one of the two dropships and transport the marines between the two ships. You may become makeshift messengers in the event of a comms malfunction. Do not die."

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
	whitelisted_species = list(/datum/species/human)
	access = list(142,143,144,145)
	spawnpoint_override = "Dante Officer"
	latejoin_at_spawnpoints = TRUE
	intro_blurb = "You are the Commander of the marine detachment aboard the UNSC Dante. Your objective is to make sure your marines destroy two navigation consoles on the UNSC Achlys and return research documents to the blackbox in the prep room. Expect communication issues and unknown hostiles. Do not die."

/datum/map/unsc_achlys
	allowed_jobs = list(/datum/job/achlys/CO,/datum/job/achlys/pilot,/datum/job/achlys/SL,/datum/job/achlys/marine,/datum/job/achlys/marine/operative,/datum/job/achlys/prisoner,/datum/job/achlys/sangheili)
	allowed_spawns = list("Dante Officer","Dante Pilot","Dante Enlisted","Achlys Prison")

	species_to_job_whitelist = list(/datum/species/sangheili = list(/datum/job/achlys/sangheili))
	species_to_job_blacklist = list(/datum/species/human = list(/datum/job/achlys/sangheili))
