/datum/job/soe_commando
	title = "SOE Commando"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	outfit_type = /decl/hierarchy/outfit/job/soe_commando
	alt_titles = list("SOE Initiate",\
	"SOE Trooper",\
	"SOE Corporal",\
	"SOE Surgeon")

	total_positions = 8
	spawn_positions = 8
	selection_color = "#ff0000"
	access = list(access_innie_prowler,access_innie_asteroid)
	is_whitelisted = 1
	whitelisted_species = list(/datum/species/human)

/datum/job/soe_commando_officer
	title = "SOE Commando Officer"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	outfit_type = /decl/hierarchy/outfit/job/soe_commando_officer
	alt_titles = list("SOE Sergeant",\
	"SOE Adjutant",\
	"SOE Lieutenant")

	total_positions = 2
	spawn_positions = 2
	selection_color = "#ff0000"
	access = list(access_innie_prowler,access_innie_asteroid,access_innie_asteroid_boss)
	is_whitelisted = 1
	whitelisted_species = list(/datum/species/human)

/datum/job/soe_commando_captain
	title = "SOE Commando Captain"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	outfit_type = /decl/hierarchy/outfit/job/soe_commando_captain
	alt_titles = list("SOE Commander",\
	"SOE Captain")

	total_positions = 1
	spawn_positions = 1
	selection_color = "#ff0000"
	access = list(access_innie_prowler,access_innie_asteroid,access_innie_asteroid_boss)
	is_whitelisted = 1
	whitelisted_species = list(/datum/species/human)
