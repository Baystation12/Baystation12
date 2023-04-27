/*
	Small, mechanically supported physical customisation options.
	Also allows for per-species physical information ('his neck markings are more important than yours').
	ETA till a downstream ports this and adds boob and penis size: 2 days.
*/

/mob/living/carbon/human/proc/show_descriptors_to(mob/user)
	if(LAZYLEN(descriptors))
		if(user == src)
			for(var/entry in descriptors)
				var/datum/mob_descriptor/descriptor = species.descriptors[entry]
				if (!descriptor)
					continue
				LAZYADD(., "[descriptor.get_first_person_message_start()] [descriptor.get_standalone_value_descriptor(descriptors[entry])].")
		else
			for(var/entry in descriptors)
				var/datum/mob_descriptor/descriptor = species.descriptors[entry]

				if (!descriptor)
					continue

				LAZYADD(., descriptor.get_comparative_value_descriptor(descriptors[entry], user, src))

/datum/mob_descriptor
	var/name                                       // String ident.
	var/chargen_label                              // String ident for chargen.
	var/default_value                              // Initial value for this descriptor.
	var/comparison_offset = 0                      // Used for examining similar properties between different species.
	var/comparative_value_descriptor_equivalent    // String for looking at someone with roughly the same property.
	var/list/standalone_value_descriptors          // String set for initial descriptor text.
	var/list/comparative_value_descriptors_smaller // String set for looking at someone smaller than you.
	var/list/comparative_value_descriptors_larger  // String set for looking at someone larger than you.
	var/list/chargen_value_descriptors             // Used for chargen selection of values in cases where there is a hidden meaning.
	var/skip_species_mention

/datum/mob_descriptor/New()
	if(!chargen_label)
		chargen_label = name
	if(!chargen_value_descriptors)
		chargen_value_descriptors = list()
		for(var/i = 1 to LAZYLEN(standalone_value_descriptors))
			chargen_value_descriptors[standalone_value_descriptors[i]] = i
	default_value = ceil(LAZYLEN(standalone_value_descriptors) * 0.5)
	..()

/datum/mob_descriptor/proc/get_third_person_message_start(datum/pronouns/my_pronouns)
	return "[my_pronouns.He] [my_pronouns.is]"

/datum/mob_descriptor/proc/get_first_person_message_start()
	return "You are"

/datum/mob_descriptor/proc/get_standalone_value_descriptor(check_value)
	if(isnull(check_value))
		check_value = default_value
	if(check_value && LAZYLEN(standalone_value_descriptors) >= check_value)
		return standalone_value_descriptors[check_value]

// Build a species-specific descriptor string.
/datum/mob_descriptor/proc/get_initial_comparison_component(mob/me, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns, my_value)
	var/species_text
	if(ishuman(me) && !skip_species_mention)
		var/mob/living/carbon/human/H = me
		var/use_name = "\improper [H.species.name]"
		species_text = " for \a [use_name]"
	. = "[get_third_person_message_start(my_pronouns)] [get_standalone_value_descriptor(my_value)][species_text]"

/datum/mob_descriptor/proc/get_secondary_comparison_component(datum/pronouns/my_pronouns, datum/pronouns/other_pronouns, my_value, comparing_value)
	var/raw_value = my_value
	my_value += comparison_offset
	var/variance = abs((my_value)-comparing_value)
	if(variance < 1)
		. = "[.], [get_comparative_value_string_equivalent(raw_value, my_pronouns, other_pronouns)]"
	else
		variance = variance / LAZYLEN(standalone_value_descriptors)
		if(my_value < comparing_value)
			. = "[.], [get_comparative_value_string_smaller(variance, my_pronouns, other_pronouns)]"
		else if(my_value > comparing_value)
			. = "[.], [get_comparative_value_string_larger(variance, my_pronouns, other_pronouns)]"

/datum/mob_descriptor/proc/get_comparative_value_descriptor(my_value, mob/observer, mob/me)

	// Store our gender info for later.
	var/datum/pronouns/my_pronouns = GLOB.pronouns.by_key[PRONOUNS_THEY_THEM]
	if(observer.knows_target(me))
		my_pronouns = me.choose_from_pronouns()
	var/datum/pronouns/other_pronouns = observer.choose_from_pronouns()

	. = get_initial_comparison_component(me, my_pronouns, other_pronouns, my_value)

	// Append the same-descriptor comparison text.
	var/comparing_value
	if(ishuman(observer))
		var/mob/living/carbon/human/human_observer = observer
		if(LAZYLEN(human_observer.descriptors) && !isnull(human_observer.species.descriptors[name]) && !isnull(human_observer.descriptors[name]))
			var/datum/mob_descriptor/obs_descriptor = human_observer.species.descriptors[name]
			comparing_value = human_observer.descriptors[name] + obs_descriptor.comparison_offset

	if(. && !isnull(comparing_value))
		. = "[.][get_secondary_comparison_component(my_pronouns, other_pronouns, my_value, comparing_value)]"

	// We're done, add a full stop.
	. = "[.]. "

/datum/mob_descriptor/proc/get_comparative_value_string_equivalent(my_value, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns)
	return comparative_value_descriptor_equivalent

/datum/mob_descriptor/proc/get_comparative_value_string_smaller(value, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns)
	var/maxval = LAZYLEN(comparative_value_descriptors_smaller)
	value = clamp(ceil(value * maxval), 1, maxval)
	return comparative_value_descriptors_smaller[value]

/datum/mob_descriptor/proc/get_comparative_value_string_larger(value, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns)
	var/maxval = LAZYLEN(comparative_value_descriptors_larger)
	value = clamp(ceil(value * maxval), 1, maxval)
	return comparative_value_descriptors_larger[value]
