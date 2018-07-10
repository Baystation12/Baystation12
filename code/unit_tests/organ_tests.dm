// ==============================================================================

/datum/unit_test/max_damage_setup
	name = "ORGAN: Max Damage Is Setup"

/datum/unit_test/max_damage_setup/start_test()
	var/list/skipped_organ_types = list(/obj/item/organ/external, /obj/item/organ/internal)

	var/list/failed_organ_types = list()
	for(var/organ_type in (subtypesof(/obj/item/organ) - skipped_organ_types))
		var/obj/item/organ/O = organ_type
		if(!initial(O.max_damage))
			failed_organ_types += O

	if(failed_organ_types.len)
		fail("The following organs have incorrectly setup max damage: [english_list(failed_organ_types)]")
	else
		pass("All organs have a correctly setup max damage")

	return 1

/datum/unit_test/species_organ_creation
	name = "ORGAN: Species Organs are Created Correctly"

/datum/unit_test/species_organ_creation/proc/check_internal_organs(var/mob/living/carbon/human/H, var/datum/species/species)
	. = 1
	for(var/organ_tag in species.has_organ)
		var/obj/item/organ/internal/I = H.internal_organs_by_name[organ_tag]
		if(!istype(I))
			fail("[species.name] failed to register internal organ for tag \"[organ_tag]\" to internal_organs_by_name.")
			. = 0
			continue
		if(!(I in H.internal_organs))
			fail("[species.name] failed to register internal organ for tag \"[organ_tag]\" to internal_organs.")
			. = 0
			continue
		var/req_type = species.has_organ[organ_tag]
		if(!istype(I, req_type))
			fail("[species.name] incorrect type of internal organ created for tag \"[organ_tag]\". Expected [req_type], found [I.type].")
			. = 0
			continue
		if(I.organ_tag != organ_tag)
			fail("[species.name] internal organ tag mismatch. Registered as \"[organ_tag]\", actual tag was \"[I.organ_tag]\".")
			. = 0

/datum/unit_test/species_organ_creation/proc/check_external_organs(var/mob/living/carbon/human/H, var/datum/species/species)
	. = 1
	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/E = H.organs_by_name[organ_tag]
		if(!istype(E))
			fail("[species.name] failed to register external organ for tag \"[organ_tag]\" to organs_by_name.")
			. = 0
			continue
		if(!(E in H.organs))
			fail("[species.name] failed to register external organ for tag \"[organ_tag]\" to organs.")
			. = 0
			continue
		var/list/organ_data = species.has_limbs[organ_tag]
		var/req_type = organ_data["path"]
		if(!istype(E, req_type))
			fail("[species.name] incorrect type of external organ created for tag \"[organ_tag]\". Expected [req_type], found [E.type].")
			. = 0
			continue
		if(E.organ_tag != organ_tag)
			fail("[species.name] internal organ tag mismatch. Registered as \"[organ_tag]\", actual tag was \"[E.organ_tag]\".")
			. = 0

/datum/unit_test/species_organ_creation/proc/check_organ_parents(var/mob/living/carbon/human/H, var/datum/species/species)
	. = 1
	for(var/obj/item/organ/external/E in H.organs)
		if(!E.parent_organ)
			continue
		var/obj/item/organ/external/parent = H.organs_by_name[E.parent_organ]
		if(!istype(parent))
			fail("[species.name] external organ [E] could not find its parent in organs_by_name. Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue
		if(!(parent in H.organs))
			fail("[species.name] external organ [E] could not find its parent in organs. Parent was [parent](parent.type). Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue
		if(E.parent != parent)
			fail("[species.name] external organ [E] parent mismatch. Parent reference was [E.parent] with tag \"[E.parent? E.parent.organ_tag : "N/A"]\". Parent was [parent](parent.type). Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue
		if(!(E in parent.children))
			fail("[species.name] external organ [E] was not found in parent's children. Parent was [parent]. Parent tag was \"[E.parent_organ]\".")
			. = 0
			continue

	for(var/obj/item/organ/internal/I in H.organs)
		if(!I.parent_organ)
			fail("[species.name] internal organ [I] did not have a parent_organ tag.")
			. = 0
			continue
		var/obj/item/organ/external/parent = H.organs_by_name[I.parent_organ]
		if(!istype(parent))
			fail("[species.name] internal organ [I] could not find its parent in organs_by_name. Parent tag was \"[I.parent_organ]\".")
			. = 0
			continue
		if(!(parent in H.organs))
			fail("[species.name] internal organ [I] could not find its parent in organs. Parent was [parent]. Parent tag was \"[I.parent_organ]\".")
			. = 0
			continue
		if(!(I in parent.internal_organs))
			fail("[species.name] internal organ [I] was not found in parent's internal_organs. Parent was [parent]. Parent tag was \"[I.parent_organ]\".")
			. = 0
			continue

/datum/unit_test/species_organ_creation/start_test()
	var/failcount = 0
	for(var/datum/species/species in all_species)
		var/mob/living/carbon/human/test_subject = new(null, species.name)

		var/fail = 0
		fail |= !check_internal_organs(test_subject, species)
		fail |= !check_external_organs(test_subject, species)
		fail |= !check_organ_parents(test_subject, species)

		if(fail) failcount++

	if(failcount)
		fail("[failcount] species mobs were created with invalid organ configuration.")
	else
		pass("All species mobs were created with valid organ configuration.")

	return 1

/datum/unit_test/species_organ_lists_update
	name = "ORGAN: Species Mob Organ Lists Update when Organs are Removed and Replaced."

/datum/unit_test/species_organ_lists_update/proc/check_internal_organ_present(var/mob/living/carbon/human/H, var/obj/item/organ/internal/I)
	if(!(I in H.internal_organs))
		fail("[H.species.name] internal organ [I] not in internal_organs.")
		return 0
	var/found = H.internal_organs_by_name[I.organ_tag]
	if(I != found)
		fail("[H.species.name] internal organ [I] not in internal_organs_by_name. Organ tag was \"[I.organ_tag]\", found [found? found : "nothing"] instead.")
		return 0
	var/obj/item/organ/external/parent = H.organs_by_name[I.parent_organ]
	if(!istype(parent))
		fail("[H.species.name] internal organ [I] could not find its parent in organs_by_name. Parent tag was \"[I.parent_organ]\".")
		return 0
	if(!(I in parent.internal_organs))
		fail("[H.species.name] internal organ [I] was not in parent's internal_organs. Parent was [parent]. Parent tag was \"[I.parent_organ]\".")
		return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/check_internal_organ_removed(var/mob/living/carbon/human/H, var/obj/item/organ/internal/I, var/obj/item/organ/external/old_parent)
	if(I in H.internal_organs)
		fail("[H.species.name] internal organ [I] was not removed from internal_organs.")
		return 0
	var/found = H.internal_organs_by_name[I.organ_tag]
	if(found)
		fail("[H.species.name] internal organ [I] was not removed from internal_organs_by_name. Organ tag was \"[I.organ_tag]\".")
		return 0
	if(I in old_parent.internal_organs)
		fail("[H.species.name] internal organ [I] was not removed from parent's internal_organs. Parent was [old_parent].")
		return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/check_external_organ_present(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)
	if(!(E in H.organs))
		fail("[H.species.name] external organ [E] not in organs.")
		return 0
	var/found = H.organs_by_name[E.organ_tag]
	if(E != found)
		fail("[H.species.name] external organ [E] not in organs_by_name. Organ tag was \"[E.organ_tag]\", found [found? found : "nothing"] instead.")
		return 0
	if(E.parent_organ)
		var/obj/item/organ/external/parent = E.parent
		if(!istype(parent))
			fail("[H.species.name] external organ [E] had no parent. Parent tag was \"[E.parent_organ]\".")
			return 0
		if(parent.organ_tag != E.parent_organ)
			fail("[H.species.name] external organ [E] parent tag mismatch. Parent tag was \"[E.parent_organ]\", actual tag was \"[parent.organ_tag]\".")
			return 0
		if(!(E in parent.children))
			fail("[H.species.name] external organ [E] was not in parent's children. Parent was [parent]. Parent tag was \"[E.parent_organ]\".")
			return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/check_external_organ_removed(var/mob/living/carbon/human/H, var/obj/item/organ/external/E, var/obj/item/organ/external/old_parent = null)
	if(E in H.organs)
		fail("[H.species.name] external organ [E] was not removed from organs.")
		return 0
	var/found = H.organs_by_name[E.organ_tag]
	if(found)
		fail("[H.species.name] external organ [E] was not removed from organs_by_name. Organ tag was \"[E.organ_tag]\".")
		return 0
	if(old_parent)
		if(!(E in old_parent.children))
			fail("[H.species.name] external organ [E] was not removed from parent's children. Parent was [old_parent].")
			return 0
	return 1

/datum/unit_test/species_organ_lists_update/proc/test_internal_organ(var/mob/living/carbon/human/H, var/obj/item/organ/internal/I)
	if(!check_internal_organ_present(H, I))
		fail("[H.species.name] internal organ [I] failed initial presence check.")
		return 0

	var/obj/item/organ/external/parent = H.organs_by_name[I.parent_organ]

	I.removed()
	if(!check_internal_organ_removed(H, I, parent))
		fail("[H.species.name] internal organ [I] was not removed correctly.")
		return 0

	I.replaced(H, parent)
	if(!check_internal_organ_present(H, I))
		fail("[H.species.name] internal organ [I] was not replaced correctly.")
		return 0

	return 1

/datum/unit_test/species_organ_lists_update/proc/test_external_organ(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)
	if(!check_external_organ_removed(H, E))
		fail("[H.species.name] internal organ [E] failed initial presence check.")
		return 0

	var/obj/item/organ/external/parent = E.parent

	E.removed()
	if(!check_internal_organ_removed(H, E, parent))
		fail("[H.species.name] internal organ [E] was not removed correctly.")
		return 0

	E.replaced(H)
	if(!check_internal_organ_present(H, E))
		fail("[H.species.name] internal organ [E] was not replaced correctly.")
		return 0

	return 1

/datum/unit_test/species_organ_lists_update/start_test()
	var/failcount = 0
	for(var/datum/species/species in all_species)
		var/mob/living/carbon/human/test_subject = new(null, species.name)

		for(var/O in test_subject.internal_organs)
			if(!test_internal_organ(test_subject, O))
				failcount++

		for(var/O in test_subject.organs)
			if(!test_external_organ(test_subject, O))
				failcount++

	if(failcount)
		fail("[failcount] organs failed to be removed and replaced correctly.")
	else
		pass("All organs were removed and replaced correctly.")

	return 1