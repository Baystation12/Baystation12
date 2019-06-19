
/datum/job/URF_commando
	title = "URF Commando"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	outfit_type = /decl/hierarchy/outfit/job/URF_commando
	alt_titles = list("Recruit",\
	"Velites",\
	"Hastari",\
	"Principes",\
	"Triarii",\
	"Decanus",\
	"Tessearius")

	total_positions = 8
	spawn_positions = 8
	selection_color = "#ff0000"
	access = list(252,632)
	is_whitelisted = 1

/datum/job/URF_commando_officer
	title = "URF Commando Officer"
	spawn_faction = "Insurrection"
	latejoin_at_spawnpoints = 1
	outfit_type = /decl/hierarchy/outfit/job/URF_commando_officer
	alt_titles = list("Optio",\
	"Centurion",\
	"Tribune",\
	"Legio",\
	"Legate")

	total_positions = 2
	spawn_positions = 1
	selection_color = "#ff0000"
	access = list(252,632)
	is_whitelisted = 1
