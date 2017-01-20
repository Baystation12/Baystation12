// ==============================================================================

datum/unit_test/species_organ_creation
	name = "ORGAN: Species Organs are Created Correctly"

datum/unit_test/species_organ_creation/proc/check_internal_organs(var/mob/living/carbon/human/H, var/datum/species/species)
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

datum/unit_test/species_organ_creation/proc/check_external_organs(var/mob/living/carbon/human/H, var/datum/species/species)
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

datum/unit_test/species_organ_creation/proc/check_organ_parents(var/mob/living/carbon/human/H, var/datum/species/species)
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

datum/unit_test/species_organ_creation/start_test()
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
