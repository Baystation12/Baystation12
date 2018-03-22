/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/id = null // For blacklisting purposes, all ruins need an id
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	var/cost = null //negative numbers will always be placed, with lower (negative) numbers being placed first; positive and 0 numbers will be placed randomly

	var/prefix = null
	var/suffixes = null

/datum/map_template/ruin/New()
	if(!name && id)
		name = id

	if (suffixes)
		mappaths = list()
		for (var/suffix in suffixes)
			mappaths += (prefix + suffix)

	..()
