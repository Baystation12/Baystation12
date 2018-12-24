
/datum/language/covenant
	name = "Sangheili"
	desc = "The ancient language of the Sangheili and common language of the Covenant."
	key = "1"
	flags = WHITELISTED
	var/icon/cov_alphabet = 'cov_language.dmi'
	var/list/syllable_names

/datum/language/covenant/New()
	. = ..()
	cov_alphabet = new(cov_alphabet)
	cov_alphabet.Crop(1,1,24,24)
	syllables = list()
	syllable_names = icon_states(cov_alphabet)
	for(var/symbol_name in syllable_names)
		syllables.Add("<IMG CLASS=icon SRC=\ref[cov_alphabet] ICONSTATE='[symbol_name]'>")
