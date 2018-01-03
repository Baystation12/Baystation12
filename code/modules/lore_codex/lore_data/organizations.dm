/datum/lore/codex/category/organizations
	name = "Major Governments"
	data = "These are the two major governments that represent most of Humanity's interests, Sol Gov, and the Terran Confederacy."
	children = list(
		/datum/lore/codex/page/sol_gov,
		/datum/lore/codex/page/terran_confederacy
		)

/datum/lore/codex/page/sol_gov/add_content()
	name = "Sol Gov"
	keywords += list("Sol Gov", "SCG")
	data = "The Sol Central Government, commonly referred to as SolGov, the SCG, or Sol Central is a federal republic composed of numerous human states across many solar systems.\
	 Sol Gov governs, directly or indirectly, the majority of human space. Its primary governing bodies are the Assemblies, which are in turn led by the Secretary-General. \
	 Member states have a great degree of freedom in handling their internal affairs, while the SCG manages civil rights, security, economy, and diplomacy for \
	 its citizens. It has a diverse population, including many non-humans, and encompasses a wide range of systems, territories, habitats, and stellar bodies. The Sol Central Government \
	 and its member states make up one of the more advanced and powerful civilizations in the known galaxy."

/datum/lore/codex/page/terran_confederacy/add_content()
	name = "Terran Confederacy"
	keywords += list("Terran", "TC", "Confederacy")
	data = "The Terran Confederacy is a union of independent human colonies spread over a wide region near SolGov space. Living conditions and systems of government \
	vary widely across the Confederacy because of its loose, federalist system of control, however most colonies have joined the Confederacy as an alternative to membership in the \
	Sol Central Government, or for protection."