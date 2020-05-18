/datum/unit_test/submaps_shall_have_a_unique_descriptor
	name = "SUBMAPS: Archetypes shall have a valid, unique descriptor."

/datum/unit_test/submaps_shall_have_a_unique_descriptor/start_test()
	var/list/checked_submaps = list()
	var/list/non_unique_descriptors = list()
	for(var/archetype in SSmapping.submap_archetypes)
		var/decl/submap_archetype/arch = SSmapping.submap_archetypes[archetype]
		if(!arch.descriptor)
			non_unique_descriptors += "[arch.type] - no descriptor set"
		else if(checked_submaps[arch.descriptor])
			non_unique_descriptors += "[arch.type] - [arch.descriptor]"
			non_unique_descriptors |= "[checked_submaps[arch.descriptor]] - [arch.descriptor]"
		else
			checked_submaps[arch.descriptor] = arch.type
	if(LAZYLEN(non_unique_descriptors))
		fail("Some submap archetypes do not have unique descriptors:\n[jointext(non_unique_descriptors, "\n")].")
	else
		pass("All submap archetypes had unique descriptors.")
	return 1
