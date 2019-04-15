var/global/list/roundstart_augs = list(
	SPECIES_SKRELL = list(
		CULTURE_SKRELL_QERR = list(

		),
		CULTURE_SKRELL_MALISH = list(

		),
		CULTURE_SKRELL_KANIN = list(

		),
		CULTURE_SKRELL_TALUM = list(

		),
		CULTURE_SKRELL_RASKINTA = list(

		),
		
	)
	SPECIES_HUMAN = list(

	)
)

/datum/preferences
	var/list/aug_list = list()

/datum/category_item/player_setup_item/physical/augments
	name = "Augments"
	sort_order = 5

/datum/category_item/player_setup_item/physical/augments/load_character(var/savefile/S)
	from_file(S["aug_list"], pref.aug_list)

/datum/category_item/player_setup_item/physical/augments/save_character(var/savefile/S)
	to_file(S["aug_list"], pref.aug_list)

/datum/category_item/player_setup_item/physical/augments/sanitize_character()

/datum/category_item/player_setup_item/physical/augments/content(var/mob/user)
	var/list/potential_augs
	if(islist(roundstart_augs[pref.species])) 
		var/list/species_augs
		species_augs = roundstart_augs[pref.species]

		for(var/token in tokens)
			if(!isnull(species_augs[pref.cultural_info[token]]))

		. += "<hr>"
		. += "<b>Augments:</b><br>"



	else
		. += "<hr>"
		. += "No augments available for [pref.species].<br>"
