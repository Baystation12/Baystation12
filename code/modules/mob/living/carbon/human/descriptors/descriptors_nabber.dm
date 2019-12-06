/datum/mob_descriptor/body_length
	name = "body length"
	comparative_value_descriptor_equivalent = "around the same length as yours"
	standalone_value_descriptors = list(
		"short and stubby",
		"rather short",
		"of average length",
		"quite long",
		"extremely long"
		)
	comparative_value_descriptors_smaller = list(
		"a bit shorter in length than yours",
		"shorter in length than yours",
		"much shorter in length than yours",
		"tiny in comparison to yours"
		)
	comparative_value_descriptors_larger = list(
		"slightly longer than yours",
		"longer than yours",
		"much longer than yours",
		"easily twice your length"
		)


/datum/mob_descriptor/body_length/get_first_person_message_start()
	return "Your body is"

/datum/mob_descriptor/body_length/get_third_person_message_start(var/datum/gender/my_gender)
	return "[my_gender.His] body is"