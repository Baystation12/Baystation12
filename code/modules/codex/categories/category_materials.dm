/datum/codex_category/materials/Initialize()

	for(var/thing in SSmaterials.materials)
		var/material/mat = thing
		if(!mat.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[mat.display_name] (material)")
			entry.lore_text = mat.lore_text
			entry.antag_text = mat.antag_text
			entry.mechanics_text = mat.mechanics_text ? mat.mechanics_text : ""
			SScodex.entries_by_string[entry.display_name] = entry
