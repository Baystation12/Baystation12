/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	var/cost = null //negative numbers will always be placed, with lower (negative) numbers being placed first; positive and 0 numbers will be placed randomly

	var/prefix = null
	var/suffixes = null
	template_flags = 0 // No duplicates by default

	// !! Currently only implemented for away sites
	var/list/force_ruins // Listed ruins are always spawned unless disallowed by flags.
	var/list/allow_ruins // Listed ruins are added to the set of available spawns.
	var/list/ban_ruins   // Listed ruins are removed from the set of available spawns. Beats allowed.

/datum/map_template/ruin/New()
	if (suffixes)
		mappaths = list()
		for (var/suffix in suffixes)
			mappaths += (prefix + suffix)

	..()
