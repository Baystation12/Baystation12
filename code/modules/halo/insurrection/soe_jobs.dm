/datum/job/soe_commando
	title = "SOE Commando"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	generate_email = 1
	account_allowed = 1
	outfit_type = /decl/hierarchy/outfit/job/soe_commando
	alt_titles = list("SOE Initiate",\
	"SOE Trooper",\
	"SOE Corporal",\
	"SOE Surgeon")

	total_positions = 6
	spawn_positions = 6
	open_slot_on_death = 1
	selection_color = "#ff0000"
	access = list(access_innie,access_innie_prowler,access_innie_asteroid,access_soe)
	faction_whitelist = "Insurrection"
	fallback_spawnpoint = "Innie Base Fallback Spawns"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

	radio_speech_size = RADIO_SPEECH_SPECIALIST

/datum/job/soe_commando_officer
	title = "SOE Commando Officer"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	generate_email = 1
	account_allowed = 1
	outfit_type = /decl/hierarchy/outfit/job/soe_commando_officer
	alt_titles = list("SOE Sergeant",\
	"SOE Adjutant",\
	"SOE Lieutenant")

	total_positions = 2
	spawn_positions = 2
	selection_color = "#ff0000"
	access = list(access_innie,access_innie_prowler,access_innie_asteroid,access_innie_asteroid_boss,access_soe,access_soe_officer,access_innie_cargo)
	faction_whitelist = "Insurrection"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

	radio_speech_size = RADIO_SPEECH_LEADER

/datum/job/soe_commando_captain
	title = "SOE Commando Captain"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	generate_email = 1
	account_allowed = 1
	outfit_type = /decl/hierarchy/outfit/job/soe_commando_captain
	alt_titles = list("SOE Commander",\
	"SOE Captain")

	total_positions = 1
	spawn_positions = 1
	selection_color = "#ff0000"
	access = list(access_innie,access_innie_prowler,access_innie_asteroid,access_innie_asteroid_boss,access_soe,access_soe_officer,access_soe_captain,access_innie_cargo)
	faction_whitelist = "Insurrection"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

	radio_speech_size = RADIO_SPEECH_LEADER
