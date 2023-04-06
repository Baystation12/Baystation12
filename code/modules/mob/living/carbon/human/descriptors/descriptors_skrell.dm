/datum/mob_descriptor/headtail_length
	name = "headtail length"
	chargen_label = "headtails (gender)"
	skip_species_mention = TRUE
	standalone_value_descriptors = list(
		"short",
		"long"
		)
	chargen_value_descriptors = list(
		"short (male)" =  1,
		"long (female)" = 2
		)

/datum/mob_descriptor/headtail_length/get_first_person_message_start()
	. = "Your headtails are"

/datum/mob_descriptor/headtail_length/get_third_person_message_start(datum/pronouns/my_pronouns)
	. = "[my_pronouns.His] headtails are"

/datum/mob_descriptor/headtail_length/get_comparative_value_string_equivalent(my_value, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns)
	. = "indicating [other_pronouns.he] [other_pronouns.is] [my_value == 1 ? "male" : "female"] like you"

/datum/mob_descriptor/headtail_length/get_comparative_value_string_smaller(value, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns)
	. = "indicating [other_pronouns.he] [other_pronouns.is] male"

/datum/mob_descriptor/headtail_length/get_comparative_value_string_larger(value, datum/pronouns/my_pronouns, datum/pronouns/other_pronouns)
	. = "indicating [other_pronouns.he] [other_pronouns.is] female"
