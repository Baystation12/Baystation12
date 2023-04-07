/**
	Helpers related to /datum/species
*/


/// Null, or a species if thing is a species, a species path, or a species name
/proc/resolve_species(datum/species/thing)
	RETURN_TYPE(/datum/species)
	if (ispath(thing, /datum/species))
		thing = initial(thing.name)
	if (istext(thing))
		thing = all_species[thing]
	if (istype(thing))
		return thing
