/datum/codex_category/species/Initialize()
	for(var/thing in all_species)
		var/datum/species/species = all_species[thing]
		if(!species.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[species.name] (species)")
			entry.lore_text = species.codex_description
			SScodex.entries_by_string[species.name] = entry