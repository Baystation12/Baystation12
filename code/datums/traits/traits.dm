
/mob/living/proc/HasTrait(trait_type)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return (trait_type in GetTraits())

/mob/living/proc/GetTraitLevel(trait_type, meta_option)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/singleton/trait/trait = GET_SINGLETON(trait_type)
	var/traits = GetTraits()
	if(!traits)
		return null

	if (length(trait.metaoptions))
		if (!meta_option)
			return
		var/list/interim = traits[trait_type]
		return interim[meta_option]

	else return traits[trait_type]

/mob/living/proc/GetTraits()
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	return traits

/mob/living/carbon/human/GetTraits()
	if(traits)
		return traits
	return species.traits

/mob/living/proc/GetMetaOptions(trait_type)
	RETURN_TYPE(/list)
	if (!HasTrait(trait_type))
		return
	var/singleton/trait/trait = GET_SINGLETON(trait_type)
	if (!trait.metaoptions)
		return

	return traits[trait_type]

/mob/living/proc/SetTrait(trait_type, trait_level, meta_option)
	SHOULD_NOT_SLEEP(TRUE)
	var/singleton/trait/trait = GET_SINGLETON(trait_type)
	if(!trait.Validate(trait_level, meta_option))
		return FALSE

	for (var/existing_trait_types in traits)
		var/singleton/trait/existing = GET_SINGLETON(existing_trait_types)
		if (LAZYISIN(existing.incompatible_traits, trait_type) || LAZYISIN(trait.incompatible_traits, existing_trait_types))
			return FALSE

	if (length(trait.metaoptions))
		var/list/interim = list()
		if (!LAZYISIN(traits, trait_type))
			LAZYSET(traits, trait_type, interim)

		var/list/existing_meta_options = traits[trait_type]
		if (existing_meta_options[meta_option] == trait_level)
			return FALSE
		LAZYSET(existing_meta_options, meta_option, trait_level)
		LAZYSET(traits, trait_type, existing_meta_options)
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

/proc/LetterizeSeverity(severity)
	switch (severity)
		if (TRAIT_LEVEL_EXISTS)
			severity = "Exists"
		if (TRAIT_LEVEL_MINOR)
			severity = "Minor"
		if (TRAIT_LEVEL_MODERATE)
			severity = "Moderate"
		if (TRAIT_LEVEL_MAJOR)
			severity = "Severe"
		else
			crash_with("Inappopriate arguments fed into proc.")
	return severity

/proc/sanitize_trait_prefs(list/preferences)
	RETURN_TYPE(/list)
	var/list/final_preferences = list()
	if (isnull(preferences))
		return list()
	if (!islist(preferences))
		crash_with("Inappropriate argument fed into proc.")
		return
	if (!length(preferences))
		return list()

	for (var/trait in preferences)
		var/trait_type = istext(trait) ? text2path(trait) : trait
		var/singleton/trait/selected = GET_SINGLETON(trait_type)
		var/severity
		if (length(selected.metaoptions))
			var/list/interim = preferences[trait]
			var/list/final_interim = list()
			for (var/metaoption in interim)
				var/metaoption_type = istext(metaoption) ? text2path(metaoption) : metaoption
				severity = interim[metaoption]
				LAZYSET(final_interim, metaoption_type, severity)
			LAZYSET(final_preferences, trait_type, final_interim)

		else
			severity = preferences[trait]
			LAZYSET(final_preferences, trait_type, severity)
	return final_preferences

/singleton/trait
	var/name
	var/description
	/// Should either only contain TRAIT_LEVEL_EXISTS or a set of the other TRAIT_LEVEL_* levels
	var/list/levels = list(TRAIT_LEVEL_EXISTS)
	/// Additional list with unique paths to associate singleton with. if needed. Currently used for reagents in allergies only.
	var/list/metaoptions = list()
	///Prompts seen when adding/removing additional traits; only for traits with metaoptions set
	var/addprompt = "Select a property to add."
	var/remprompt = "Select a property to remove."

	/// These trait types may not co-exist on the same mob/species
	var/list/incompatible_traits
	abstract_type = /singleton/trait

	///List of species in which this trait is forbidden.
	var/list/forbidden_species = list()
	///Determines if trait can be selected in character setup
	var/selectable = FALSE

/singleton/trait/New()
	if(type == abstract_type)
		CRASH("Invalid initialization")

/singleton/trait/proc/Validate(level, meta_option)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if (length(metaoptions))
		return (level in levels) && (meta_option in metaoptions)
	else
		return (level in levels)
