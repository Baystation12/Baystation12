/datum/job/unscaegis_ship_crew
	title = "UNSC Aegis Ship Crew"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/aegiscrew
	alt_titles = list("UNSC Aegis Engineer"= /decl/hierarchy/outfit/job/UNSC_ship/aegistechnician,
	"UNSC Aegis Helmsman"= /decl/hierarchy/outfit/job/UNSC_ship/aegishelmsman,
	"UNSC Aegis Bridge Crew"= /decl/hierarchy/outfit/job/UNSC_ship/aegisbridgecrew ,
	"UNSC Aegis Janitor"= /decl/hierarchy/outfit/job/UNSC_ship/aegisjanitor ,)
	total_positions = 3
	spawn_positions = 3
	selection_color = "#0A0A95"
	access = list(142,309)
	spawnpoint_override = "UNSC Aegis Ship Crew Spawn"
	is_whitelisted = 1

/datum/job/unscaegis_co
	title = "UNSC Aegis Commanding Officer"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/aegisCO
	total_positions = 1
	spawn_positions = 1
	selection_color = "#0A0A95"
	access = list(142,309,143,144,145)
	spawnpoint_override = "UNSC Aegis Ship Crew Spawn"
	is_whitelisted = 1

//UNSC Aegis ODST Jobs

/datum/job/aegisODSTONI
	title = "''ONI'' Orbital Drop Shock Trooper"
	total_positions = 5
	spawn_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/aegisfacil_ODST
	alt_titles = list("Private First Class"= /decl/hierarchy/outfit/job/aegisODSTCQC,
	"Lance Corporal"= /decl/hierarchy/outfit/job/aegisODSTengineer,
	"Corporal"= /decl/hierarchy/outfit/job/aegisfacil_ODST,
	"Petty Officer Third Class"= /decl/hierarchy/outfit/job/aegisODSTMedic,
	"Sergeant"= /decl/hierarchy/outfit/job/aegisODSTSharpshooter,
	"Staff Sergeant"= /decl/hierarchy/outfit/job/aegisODSTstaffsergeant,
	"Gunnery Sergeant"= /decl/hierarchy/outfit/job/aegisODSTgunnerysergeant,
	"Master Sergeant" = /decl/hierarchy/outfit/job/aegisODSTFireteamLead)

	selection_color = "#0A0A95"
	access = list(142,144,110,192,309,310)
	spawnpoint_override = "UNSC Aegis ODST Spawn"
	is_whitelisted = 1

/datum/job/aegisODSTOONI
	title = "''ONI'' Orbital Drop Shock Trooper Officer"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/aegisODSTsecondlieutenant
	alt_titles = list("Second Lieutenant" = /decl/hierarchy/outfit/job/aegisODSTsecondlieutenant,
	"First Lieutenant" = /decl/hierarchy/outfit/job/aegisODSTfirstlieutenant,
	"Captain" = /decl/hierarchy/outfit/job/aegisODSTcaptain,
	"Major" = /decl/hierarchy/outfit/job/aegisODSTmajor,
	"Lieutenant Colonel" = /decl/hierarchy/outfit/job/aegisODSTltcolonel,
	"Colonel" = /decl/hierarchy/outfit/job/aegisODSTcolonel)
	selection_color = "#0A0A95"
	access = list(142,144,145,110,192,300,306,309,310,311)
	spawnpoint_override = "UNSC Aegis ODST Officer Spawn"
	is_whitelisted = 1
