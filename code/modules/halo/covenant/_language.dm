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

/datum/language/balahese
	name = LANGUAGE_UNGGOY
	desc = "The language of the Unggoy"
	native = 1
	colour = "unggoy"
	syllables = list("nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "B"
	flags = RESTRICTED

/datum/language/ruuhti
	name = LANGUAGE_KIGYAR
	desc = "The language of the Ruuhtian KigYar"
	native = 1
	colour = "ruutian"
	syllables = list("hss","rar","hrar","har","rah","huss","hee","ha","schra","skraw","skree","skrss","hos","hosk")
	key = "R"
	flags = RESTRICTED

/datum/language/doisacci
	name = LANGUAGE_BRUTE
	desc = "The language of the Jiralhanae"
	native = 1
	colour = "jiralhanae"
	syllables = list("ung","ugh","uhh","hss","grss","grah","argh","hng","ung","uss","hoh","rog")
	key = "D"
	flags = RESTRICTED

/datum/language/lekgolo
	name = LANGUAGE_LEKGOLO
	desc = "A language developed by lekgolo colonies to allow for communication."
	speech_verb = "emits a rumbling sound"
	ask_verb = "emits a rumbling sound"
	exclaim_verb = "emits a rumbling sound"
	colour = "lekgolo"
	key = "u"
	flags = RESTRICTED | NO_STUTTER
	native = 1
	syllables = list()
	machine_understands = 0

/datum/language/sanshyuum
	name = LANGUAGE_SANSHYUUM
	desc = "The language of the SanShyuum"
	native = 1
	colour = "sanshyuum"
	syllables = list("nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "P"
	flags = RESTRICTED

/datum/language/tvoai
	name = LANGUAGE_TVOAI
	desc = "The language of the T\'vaoan KigYar"
	native = 1
	colour = "tvaoan"
	syllables = list("hss","rar","hrar","har","rah","huss","hee","ha","schra","skraw","skree","skrss","hos","hosk")
	key = "T"
	flags = RESTRICTED

/datum/language/yanmee_hivemind
	name = LANGUAGE_YANMEE_HIVE
	desc = "The hivemind language of the Yanme e"
	native = 1
	colour = "vox"
	key = "Y"
	flags = RESTRICTED|NO_TALK_MSG|NO_STUTTER|HIVEMIND
