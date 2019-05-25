
/datum/job/ODST
	title = "Orbital Drop Shock Trooper"
	spawn_faction = "UNSC"
	total_positions = 8
	spawn_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/facil_ODST
	alt_titles = list("Private First Class"= /decl/hierarchy/outfit/job/ODSTCQC,
	"Lance Corporal"= /decl/hierarchy/outfit/job/ODSTengineer,
	"Corporal"= /decl/hierarchy/outfit/job/facil_ODST,
	"Petty Officer Third Class"= /decl/hierarchy/outfit/job/ODSTMedic,
	"Sergeant"= /decl/hierarchy/outfit/job/ODSTSharpshooter,
	"Staff Sergeant"= /decl/hierarchy/outfit/job/ODSTstaffsergeant,
	"Gunnery Sergeant"= /decl/hierarchy/outfit/job/ODSTgunnerysergeant,
	"Master Sergeant" = /decl/hierarchy/outfit/job/ODSTFireteamLead)

	selection_color = "#008000"
	access = list(142,144,110,300,301,309,311,313)
	spawnpoint_override = "UNSC Base Spawns"
	is_whitelisted = 1

/datum/job/ODSTO
	title = "Orbital Drop Shock Trooper Officer"
	spawn_faction = "UNSC"
	total_positions = 2
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ODSTsecondlieutenant
	alt_titles = list("Second Lieutenant" = /decl/hierarchy/outfit/job/ODSTsecondlieutenant,
	"First Lieutenant" = /decl/hierarchy/outfit/job/ODSTfirstlieutenant,
	"Captain" = /decl/hierarchy/outfit/job/ODSTcaptain,
	"Major" = /decl/hierarchy/outfit/job/ODSTmajor,
	"Lieutenant Colonel" = /decl/hierarchy/outfit/job/ODSTltcolonel,
	"Colonel" = /decl/hierarchy/outfit/job/ODSTcolonel)
	selection_color = "#008000"
	access = list(142,144,110,300,301,306,309,310,311,313)
	spawnpoint_override = "UNSC Base Spawns"
	is_whitelisted = 1
