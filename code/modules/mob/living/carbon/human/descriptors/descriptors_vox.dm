/datum/mob_descriptor/vox_markings
	name = "neck markings"
	chargen_label = "neck markings (rank)"
	skip_species_mention = TRUE
	standalone_value_descriptors = list(
		"very simplistic",
		"rather simple",
		"complex",
		"moderately complex",
		"bewilderingly complex"
		)
	chargen_value_descriptors = list(
		"servitor"  =     1,
		"labourer" =      2,
		"cannon fodder" = 3,
		"raider" =        4,
		"leader" =        5
		)
	comparative_value_descriptor_equivalent = "around the same importance as yours"
	comparative_value_descriptors_smaller = list(
		"slightly less important than yours",
		"much less important than yours",
		"insignificant and beneath your notice"
		)
	comparative_value_descriptors_larger = list(
		"slightly more important than yours",
		"much more important than yours",
		"commanding your unquestioning obedience and respect"
		)

/datum/mob_descriptor/vox_markings/get_first_person_message_start()
	. = "Your neck markings are"

/datum/mob_descriptor/vox_markings/get_third_person_message_start(var/datum/gender/my_gender)
	. = "[my_gender.His] neck markings are"
