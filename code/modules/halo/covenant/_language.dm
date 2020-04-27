
#define LANGUAGE_SANGHEILI "Sangheili"

/datum/language/sangheili
	name = LANGUAGE_SANGHEILI
	desc = "The ancient language of the Sangheili and common language of the Covenant."
	native = 1
	colour = "vox"
	syllables = list("ree","wortwortwort","wort","nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "S"
	flags = RESTRICTED
	//var/icon/cov_alphabet = 'code/modules/halo/covenant/cov_language.dmi'
	//var/list/syllable_names
/*
/datum/language/sangheili/New()
	. = ..()
	cov_alphabet = new(cov_alphabet)
	cov_alphabet.Crop(1,1,24,24)
	syllables = list()
	syllable_names = icon_states(cov_alphabet)
	for(var/symbol_name in syllable_names)
		syllables.Add("<IMG CLASS=icon SRC=\ref[cov_alphabet] ICONSTATE='[symbol_name]'>")
*/
