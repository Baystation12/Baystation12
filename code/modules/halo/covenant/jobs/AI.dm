
/datum/job/covenant/AI
	title = "Covenant AI"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#80080"
	outfit_type = /decl/hierarchy/outfit/halo_ai_smart
	//faction_whitelist = "Covenant" //Uncomment this once testing is done.
	whitelisted_species = list()
	access = list(access_covenant, access_covenant_command)
