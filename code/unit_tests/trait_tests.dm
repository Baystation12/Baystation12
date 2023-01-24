/datum/unit_test/trait
	name = "TRAIT - Template"
	template = /datum/unit_test/trait

/datum/unit_test/trait/New()
	name = "TRAIT: " + name


/datum/unit_test/trait/all_traits_shall_have_valid_names
	name = "All traits shall have valid names"

/datum/unit_test/trait/all_traits_shall_have_valid_names/start_test()
	var/list/invalid_traits = list()
	for(var/trait in GET_SINGLETON_SUBTYPE_LIST(/singleton/trait))
		var/singleton/trait/T = trait
		if(!T.name || !istext(T.name)) // Empty strings are valid texts
			invalid_traits += T.type

	if(length(invalid_traits))
		fail("Following trait types have invalid names: " + english_list(invalid_traits))
	else
		pass("All traits have valid names")

	return TRUE


/datum/unit_test/trait/traits_with_incompabilities_shall_list_each_other
	name = "Traits with incompabilities shall list each other"

/datum/unit_test/trait/traits_with_incompabilities_shall_list_each_other/start_test()
	var/list/invalid_traits = list()

	var/traits_by_type = GET_SINGLETON_SUBTYPE_MAP(/singleton/trait)
	for (var/trait_type in traits_by_type)
		var/singleton/trait/trait = traits_by_type[trait_type]
		for (var/incompatible_trait_type in trait.incompatible_traits)
			var/singleton/trait/incompatible_trait = traits_by_type[incompatible_trait_type]
			if (!(trait_type in incompatible_trait.incompatible_traits))
				invalid_traits += trait_type

	if (length(invalid_traits))
		fail("Following trait types have invalid incompability setups: " + english_list(invalid_traits))
	else
		pass("All traits have valid incompatibility setups")

	return TRUE


/datum/unit_test/trait/all_traits_shall_have_unique_name
	name = "All traits shall have unique names"

/datum/unit_test/trait/all_traits_shall_have_unique_name/start_test()
	var/list/trait_names = list()

	for(var/trait in GET_SINGLETON_SUBTYPE_LIST(/singleton/trait))
		var/singleton/trait/T = trait
		group_by(trait_names, T.name, T.type)

	var/number_of_issues = number_of_issues(trait_names, "Names")
	if(number_of_issues)
		fail("[number_of_issues] duplicate trait name\s found")
	else
		pass("All traits have unique names")
	return 1


/datum/unit_test/trait/all_traits_shall_have_valid_levels
	name = "All traits shall have valid levels"

/datum/unit_test/trait/all_traits_shall_have_valid_levels/start_test()
	var/list/invalid_traits = list()
	for(var/trait in GET_SINGLETON_SUBTYPE_LIST(/singleton/trait))
		var/singleton/trait/T = trait
		if(!length(T.levels) || (length(T.levels) > 1 && (TRAIT_LEVEL_EXISTS in T.levels)))
			invalid_traits += T.type

	if(length(invalid_traits))
		fail("Following trait types have invalid ranges: " + english_list(invalid_traits))
	else
		pass("All traits have valid ranges")

	return TRUE


/datum/unit_test/trait/all_species_shall_have_valid_trait_levels
	name = "All species shall have valid trait levels"

/datum/unit_test/trait/all_species_shall_have_valid_trait_levels/start_test()
	var/list/invalid_species = list()
	for(var/species_name in all_species)
		var/datum/species/S = all_species[species_name]
		for(var/trait_type in S.traits)
			var/trait_level = S.traits[trait_type]
			var/singleton/trait/T = GET_SINGLETON(trait_type)
			if(!T.Validate(trait_level))
				invalid_species += S.type
				break

	if(length(invalid_species))
		fail("Following species have invalid ranges: " + english_list(invalid_species))
	else
		pass("All species have valid trait levels")

	return TRUE


/datum/unit_test/trait/all_species_shall_have_valid_trait_compatibilities
	name = "All species shall have valid trait compatibilities"

/datum/unit_test/trait/all_species_shall_have_valid_trait_compatibilities/start_test()
	var/list/invalid_species = list()

	for (var/species_name in all_species)
		var/datum/species/S = all_species[species_name]
		for (var/trait_type in S.traits)
			var/singleton/trait/T = GET_SINGLETON(trait_type)
			for (var/incompatible_trait_type in T.incompatible_traits)
				if (incompatible_trait_type in S.traits)
					invalid_species.Add(S.type)
					break

	if (length(invalid_species))
		fail("Following species have invalid trait compatibilities: " + english_list(invalid_species))
	else
		pass("All species have valid trait compatibilities")

	return TRUE
