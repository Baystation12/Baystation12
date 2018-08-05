/*
	Small, mechanically supported physical customisation options.
	Also allows for per-species physical information ('his neck markings are more important than yours').
	ETA till a downstream ports this and adds boob and penis size: 2 days.
*/

/mob/living/carbon/human/proc/show_descriptors_to(var/mob/user)
	if(LAZYLEN(descriptors))
		if(user == src)
			for(var/entry in descriptors)
				var/datum/mob_descriptor/descriptor = species.descriptors[entry]
				LAZYADD(., "[descriptor.get_first_person_message_start()] [descriptor.get_standalone_value_descriptor(descriptors[entry])].")
		else
			var/mob/living/carbon/human/observer = user
			for(var/entry in descriptors)
				var/datum/mob_descriptor/descriptor = species.descriptors[entry]
				if(istype(observer) && LAZYLEN(observer.descriptors) && observer.descriptors[entry])
					var/datum/mob_descriptor/obs_descriptor = observer.species.descriptors[entry]
					LAZYADD(., descriptor.get_comparative_value_descriptor(descriptors[entry], observer.descriptors[entry]+obs_descriptor.comparison_offset, src))
				else
					LAZYADD(., descriptor.get_comparative_value_descriptor(descriptors[entry], null, src))

/datum/mob_descriptor
	var/name                                       // String ident.
	var/default_value                              // Initial value for this descriptor.
	var/comparison_offset = 0                      // Used for examining similar properties between different species.
	var/comparative_value_descriptor_equivalent    // String for looking at someone with roughly the same property.
	var/list/standalone_value_descriptors          // String set for initial descriptor text.
	var/list/comparative_value_descriptors_smaller // String set for looking at someone smaller than you.
	var/list/comparative_value_descriptors_larger  // String set for looking at someone larger than you.

/datum/mob_descriptor/New()
	default_value = ceil(LAZYLEN(standalone_value_descriptors) * 0.5)
	..()

/datum/mob_descriptor/proc/get_third_person_message_start(var/datum/gender/my_gender)
	return "[my_gender.He] [my_gender.is]"

/datum/mob_descriptor/proc/get_first_person_message_start()
	return "You are"

/datum/mob_descriptor/proc/get_standalone_value_descriptor(var/check_value)
	if(isnull(check_value))
		check_value = default_value
	if(check_value && LAZYLEN(standalone_value_descriptors) >= check_value)
		return standalone_value_descriptors[check_value]

/datum/mob_descriptor/proc/get_comparative_value_descriptor(var/my_value, var/comparing, var/mob/me)
	var/datum/gender/my_gender = gender_datums[me.get_gender()]
	var/species_text
	if(ishuman(me))
		var/mob/living/carbon/human/H = me
		var/use_name = "\improper [H.species.name]"
		species_text = " for \a [use_name]"
	. = "[get_third_person_message_start(my_gender)] [get_standalone_value_descriptor(my_value)][species_text]"
	if(. && !isnull(comparing))
		my_value += comparison_offset
		var/variance = abs((my_value)-comparing)
		if(variance < 1)
			. = "[.], [comparative_value_descriptor_equivalent]"
		else
			variance = variance / LAZYLEN(standalone_value_descriptors)
			if(my_value < comparing && LAZYLEN(comparative_value_descriptors_smaller))
				var/maxval = LAZYLEN(comparative_value_descriptors_smaller)
				variance = Clamp(ceil(variance * maxval), 1, maxval)
				. = "[.], [comparative_value_descriptors_smaller[variance]]"
			else if(my_value > comparing && LAZYLEN(comparative_value_descriptors_larger))
				var/maxval = LAZYLEN(comparative_value_descriptors_larger)
				variance = Clamp(ceil(variance * maxval), 1, maxval)
				. = "[.], [comparative_value_descriptors_larger[variance]]"
	. = "[.]. "

/datum/mob_descriptor/height
	name = "height"
	standalone_value_descriptors = list(
		"very short",
		"short",
		"of average height",
		"tall",
		"very tall"
		)
	comparative_value_descriptor_equivalent = "around the same height as you"
	comparative_value_descriptors_smaller = list(
		"slightly shorter than you",
		"shorter than you",
		"much shorter than you",
		"tiny and insignificant next to you"
		)
	comparative_value_descriptors_larger = list(
		"slightly taller than you",
		"taller than you",
		"much taller than you",
		"towering over you"
		)

/datum/mob_descriptor/build
	name = "build"
	comparative_value_descriptor_equivalent = "around the same build as you"
	standalone_value_descriptors = list(
		"rail thin",
		"thin",
		"of average build",
		"broad-shouldered",
		"heavily built"
		)
	comparative_value_descriptors_smaller = list(
		"a bit smaller in build than you",
		"smaller in build than you",
		"much smaller in build than you",
		"dwarfed by your height"
		)
	comparative_value_descriptors_larger = list(
		"slightly larger than you in build",
		"built larger than you",
		"built much larger than you",
		"dwarfing you"
		)
