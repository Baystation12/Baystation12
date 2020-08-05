
/datum/job/covenant/AI
	title = "Covenant AI"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/halo_ai_smart
	//faction_whitelist = "Covenant" //Uncomment this once testing is done.
	whitelisted_species = list()
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 0.5
