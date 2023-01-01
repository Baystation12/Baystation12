/*--------------------------------------------------------------------------------------------------------------*/
/* For species_exp saving (check /datum/controller/subsystem/statistics and proc/update_player_exp for details) */
/*--------------------------------------------------------------------------------------------------------------*/

// We hardcode it, because current system for saving is not expandable or shrinkable.
// Otherwise some of the saved experience will be lost
GLOBAL_LIST_INIT(species_to_save_experice_for, list(
	SPECIES_VOX,
	SPECIES_DIONA,
	SPECIES_IPC,
	SPECIES_SKRELL,
	SPECIES_TAJARA,
	SPECIES_RESOMI,
	SPECIES_ADHERENT,
	SPECIES_NABBER,
	SPECIES_UNATHI,
	SPECIES_HUMAN
))

GLOBAL_LIST_INIT(species_to_names_map, init_species_to_names_map())

/**
 * Get species initial names by path.
 *
 * Arguments
 ** species_paths - paths of species datums, for which to find initial name. Default list(/datum/species)
 */
/proc/get_species_names(list/datum/species/species_paths = list(/datum/species))
	var/list/species_names = list()

	// We use as anything for path, to bypass type check, as this doesn't work for path
	for (var/datum/species/path as anything in species_paths)
		var/initial_name = initial(path.name)
		if (initial_name)
			species_names |= initial_name

	return species_names

/**
 * Initialize species archetype name to all subtypes names map.
 */
/proc/init_species_to_names_map()
	var/list/species_to_names_map = list()
	var/list/datum/species/species_paths = typesof(/datum/species)

	// We use as anything for path, to bypass type check, as this doesn't work for path
	for (var/datum/species/path as anything in species_paths)
		var/initial_name = initial(path.name)
		if (initial_name in GLOB.species_to_save_experice_for)
			species_to_names_map[initial_name] = get_species_names(typesof(path))

	return species_to_names_map
