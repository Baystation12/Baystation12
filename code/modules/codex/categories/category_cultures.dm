/datum/codex_category/cultures/
	name = "Factions and Culture"
	desc = "Prominent planets, cultures, factions and religions of known space."

/datum/codex_category/cultures/Initialize()

	for(var/thing in SSculture.cultural_info_by_name)
		var/decl/cultural_info/culture = SSculture.cultural_info_by_name[thing]
		if(!culture.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[culture.name] ([lowertext(culture.desc_type)])")
			entry.lore_text = culture.description
			entry.update_links()
			SScodex.add_entry_by_string(culture.name, entry)
			items += culture.name
	..()