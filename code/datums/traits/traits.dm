/mob/living/proc/HasTrait(trait_type)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return (trait_type in GetTraits())

///Gets severity level with associated trait. Does not work for traits that have an additional_list set.
/mob/living/proc/GetTraitLevel(trait_type)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/singleton/trait/trait = GET_SINGLETON(trait_type)
	if (length(trait.additional_list))
		crash_with("Tried to check severity level on trait ([trait]) with additional_list.")
		return
	var/traits = GetTraits()
	if(!traits)
		return null
	return traits[trait_type]

/mob/living/proc/GetTraits()
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	return traits

/mob/living/carbon/human/GetTraits()
	if(traits)
		return traits
	return species.traits

/mob/living/proc/SetTrait(trait_type, trait_level, additional_option)
	SHOULD_NOT_SLEEP(TRUE)
	var/singleton/trait/trait = GET_SINGLETON(trait_type)
	if(!trait.Validate(trait_level, additional_option))
		return FALSE

	if (!LAZYISIN(traits, trait_type))
		for (var/existing_trait_types in traits)
			var/singleton/trait/existing = GET_SINGLETON(existing_trait_types)
			if (trait_type in existing.incompatible_traits)
				return FALSE

	if (length(trait.additional_list))
		var/list/interim = list()
		if (!LAZYISIN(traits, trait_type))
			LAZYSET(traits, trait_type, interim)

		var/list/existing_additional_options = traits[trait_type]
		if (existing_additional_options[additional_option] == trait_level)
			return FALSE
		LAZYSET(existing_additional_options, additional_option, trait_level)
		LAZYSET(traits, trait_type, existing_additional_options)
	else
		LAZYSET(traits, trait_type, trait_level)
	return TRUE

/mob/living/carbon/human/SetTrait(trait_type, trait_level, additional_option)
	var/singleton/trait/T = GET_SINGLETON(trait_type)
	if(!T.Validate(trait_level, additional_option))
		return FALSE

	if(!traits) // If traits haven't been setup before, check if we need to do so now
		var/species_level = species.traits[trait_type]
		if(species_level == trait_level) // Matched the default species trait level, ignore
			return TRUE
		traits = species.traits.Copy() // The setup is to simply copy the species list of traits

	return ..(trait_type, trait_level, additional_option)

/mob/living/proc/RemoveTrait(trait_type, additional_option)
	if (additional_option)
		var/list/interim = traits[trait_type]
		LAZYREMOVE(interim, additional_option)
		if (length(interim)) //If there remains other associations with the singleton, stop removing. Else; also remove the singleton.
			return

	LAZYREMOVE(traits, trait_type)

/mob/living/carbon/human/RemoveTrait(trait_type, additional_option)
	// If traits haven't been setup, but we're trying to remove a trait that exists on the species then setup traits
	if(!traits && (trait_type in species.traits))
		traits = species.traits.Copy()

	..(trait_type, additional_option) // Could go through the trouble of nulling the traits list if it's again equal to the species list but eh
	traits = traits || list() // But we do ensure that humans don't null their traits list, to avoid copying from species again

/singleton/trait
	var/name
	var/description
	/// Should either only contain TRAIT_LEVEL_EXISTS or a set of the other TRAIT_LEVEL_* levels
	var/list/levels = list(TRAIT_LEVEL_EXISTS)
	/// Additional list with unique paths to associate singleton with. if needed. Currently used for reagents in allergies only.
	var/list/additional_list = list()
	///Prompts seen when adding/removing additional traits; only for traits with additional_list set
	var/addprompt = "Select a property to add."
	var/remprompt = "Select a property to remove."

	/// These trait types may not co-exist on the same mob/species
	var/list/incompatible_traits
	abstract_type = /singleton/trait

/singleton/trait/New()
	if(type == abstract_type)
		CRASH("Invalid initialization")

/singleton/trait/proc/Validate(level, additional_option)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if (length(additional_list))
		return (level in levels) && (additional_option in additional_list)
	else
		return (level in levels)

/singleton/trait/proc/get_levels()
	return levels
