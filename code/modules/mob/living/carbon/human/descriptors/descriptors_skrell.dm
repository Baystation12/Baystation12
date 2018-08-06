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

/datum/mob_descriptor/headtail_length/get_third_person_message_start(var/datum/gender/my_gender)
	. = "[my_gender.His] headtails are"

/datum/mob_descriptor/headtail_length/get_comparative_value_string_equivalent(var/my_value, var/datum/gender/my_gender, var/datum/gender/other_gender)
	. = "indicating [other_gender.he] [other_gender.is] [my_value == 1 ? "male" : "female"] like you"

/datum/mob_descriptor/headtail_length/get_comparative_value_string_smaller(var/value, var/datum/gender/my_gender, var/datum/gender/other_gender)
	. = "indicating [other_gender.he] [other_gender.is] male"

/datum/mob_descriptor/headtail_length/get_comparative_value_string_larger(var/value, var/datum/gender/my_gender, var/datum/gender/other_gender)
	. = "indicating [other_gender.he] [other_gender.is] female"
