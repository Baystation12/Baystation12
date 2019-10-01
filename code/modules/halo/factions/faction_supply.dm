
/datum/faction
	var/contraband_gear			//this is gear restricted to this faction
	var/list/supply_category_names = list()
	var/list/supply_category_contents = list()

/datum/faction/proc/generate_supply_categories()
	supply_category_names = list()
	supply_category_contents = list()
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.contraband && sp.contraband != contraband_gear)
			continue
		if(sp.is_category() && !sp.is_hidden_category())
			generate_supply_category_contents(sp)

/datum/faction/proc/generate_supply_category_contents(var/decl/hierarchy/supply_pack/sp)
	supply_category_names.Add(sp.name)
	var/list/category[0]
	for(var/decl/hierarchy/supply_pack/spc in sp.children)
		if(spc.hidden)
			continue
		if(spc.contraband && spc.contraband != contraband_gear)
			continue
		category.Add(list(list(
			"name" = spc.name,
			"cost" = spc.cost * CARGO_CRATE_COST_MULTI,
			"ref" = "\ref[spc]"
		)))
	supply_category_contents[sp.name] = category

/datum/faction/proc/update_reputation_gear(var/datum/faction/rep_faction)
	var/new_reputation = rep_faction.get_faction_reputation(src.name)
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.contraband && sp.contraband != contraband_gear)
			continue
		if(sp.is_category() && sp.name == rep_faction.name)
			//remove the old ui entries
			supply_category_names -= sp.name
			sp.hidden = 1

			//remake the ui entries
			var/list/category[0]
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				if(spc.contraband && spc.contraband != contraband_gear)
					continue
				spc.hidden = 1
				if(new_reputation >= spc:rep_unlock)
					spc.hidden = 0
					category.Add(list(list(
						"name" = spc.name,
						"cost" = spc.cost * CARGO_CRATE_COST_MULTI,
						"ref" = "\ref[spc]"
					)))
			if(category.len)
				sp.hidden = 0
				supply_category_names.Add(sp.name)
				supply_category_contents[sp.name] = category

			break
