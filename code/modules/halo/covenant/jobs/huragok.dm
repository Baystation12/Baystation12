
/datum/job/covenant/huragok
	title = "Covenant Huragok"
	total_positions = 2
	spawn_positions = 2
	faction_whitelist = "Covenant"
	outfit_type = /decl/hierarchy/outfit/huragok_cov
	whitelisted_species = list(/mob/living/silicon/robot/huragok)
	access = list(access_covenant, access_covenant_command)
	pop_balance_mult = 0.5
