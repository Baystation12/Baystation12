/datum/trait
	var/name
	var/desc = "Contact a developer if you see this trait."

	var/list/var_changes	// A list to apply to the custom species vars.
	var/list/excludes		// Store a list of paths of traits to exclude, but done automatically if they change the same vars.

//Proc can be overridden lower to include special changes, make sure to call up though for the vars changes
/datum/trait/proc/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/obj/item/organ/external/head/G)
	ASSERT(S)
	if(var_changes)
		for(var/V in var_changes)
			S.vars[V] = var_changes[V]
	return

//Similar to the above, but for removing. Probably won't be called often/ever.
/datum/trait/proc/remove(var/datum/species/S)
	ASSERT(S)
	return

//	List of traits are located in traits_positve/negative/neutral. Note that there is no explicit flagging or categorization, as the traits are automagically defined as
//	negative, positive, or neutral based off their cost.