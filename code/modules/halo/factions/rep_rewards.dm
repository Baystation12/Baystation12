
/datum/faction
	var/list/locked_rep_rewards = list()
	var/list/unlocked_rep_rewards = list()

/datum/faction/proc/generate_rep_rewards(var/player_reputation = 0)
	locked_rep_rewards = list()
	unlocked_rep_rewards = list()
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.name == src.name)
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				if(spc:rep_unlock < player_reputation)
					unlocked_rep_rewards.Add(list(list(
						"name" = spc.name,
						"cost" = "[spc.cost * CARGO_CRATE_COST_MULTI] credits",
						"rep" = spc:rep_unlock,
						"type" = "supply"
					)))
				else
					locked_rep_rewards.Add(list(list(
						"name" = spc.name,
						"cost" = "[spc.cost * CARGO_CRATE_COST_MULTI] credits",
						"rep" = spc:rep_unlock,
						"type" = "supply"
					)))
			break
