/datum/language/xenocommon
	name = "Xenomorph"
	colour = "alien"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "4"
	flags = RESTRICTED
	syllables = list("sss","sSs","SSS")
	machine_understands = 0

/datum/language/xenos
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	colour = "alien"
	key = "a"
	flags = RESTRICTED | HIVEMIND

/datum/language/xenos/check_special_condition(var/mob/other)

	var/mob/living/carbon/M = other
	if(!istype(M))
		return 1
	if(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1

	return 0

/datum/language/ling
	name = "Changeling"
	desc = "Although they are normally wary and suspicious of each other, changelings can commune over a distance."
	speech_verb = "says"
	colour = "changeling"
	key = "g"
	flags = RESTRICTED | HIVEMIND

/datum/language/ling/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(speaker.mind && speaker.mind.changeling)
		..(speaker,message,speaker.mind.changeling.changelingID)
	else
		..(speaker,message)

/datum/language/corticalborer
	name = "Cortical Link"
	desc = "Cortical borers possess a strange link between their tiny minds."
	speech_verb = "sings"
	ask_verb = "sings"
	exclaim_verb = "sings"
	colour = "alien"
	key = "x"
	flags = RESTRICTED | HIVEMIND

/datum/language/corticalborer/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_animal/borer/B

	if(istype(speaker,/mob/living/carbon))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker,/mob/living/simple_animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.truename
	..(speaker,message,speaker_mask)

/datum/language/vox
	name = "Vox-pidgin"
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	ask_verb = "creels"
	exclaim_verb = "SHRIEKS"
	colour = "vox"
	key = "5"
	flags = WHITELISTED
	syllables = list("ti","ti","ti","hi","hi","ki","ki","ki","ki","ya","ta","ha","ka","ya","chi","cha","kah", \
	"SKRE","AHK","EHK","RAWK","KRA","AAA","EEE","KI","II","KRI","KA")
	machine_understands = 0

/datum/language/vox/get_random_name()
	return ..(FEMALE,1,6)

/datum/language/cultcommon
	name = LANGUAGE_CULT
	desc = "The chants of the occult, the incomprehensible."
	speech_verb = "intones"
	ask_verb = "intones"
	exclaim_verb = "chants"
	colour = "cult"
	key = "f"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("ire","ego","nahlizet","certum","veri","jatkaa","mgar","balaq", "karazet", "geeri", \
		"orkan", "allaq", "sas'so", "c'arta", "forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor", \
		"mah'weyh", "pleggh", "at", "e'ntrath", "tok-lyr", "rqa'nap", "g'lt-ulotf", "ta'gh", "fara'qha", "fel", "d'amar det", \
		"yu'gular", "faras", "desdae", "havas", "mithum", "javara", "umathar", "uf'kal", "thenar", "rash'tla", \
		"sektath", "mal'zua", "zasan", "therium", "viortia", "kla'atu", "barada", "nikt'o", "fwe'sh", "mah", "erl", "nyag", "r'ya", \
		"gal'h'rfikk", "harfrandid", "mud'gib", "fuu", "ma'jin", "dedo", "ol'btoh", "n'ath", "reth", "sh'yro", "eth", \
		"d'rekkathnor", "khari'd", "gual'te", "nikka", "nikt'o", "barada", "kla'atu", "barhah", "hra" ,"zar'garis")
	machine_understands = 0

/datum/language/cult
	name = "Occult"
	desc = "The initiated can share their thoughts by means defying all reason."
	speech_verb = "intones"
	ask_verb = "intones"
	exclaim_verb = "chants"
	colour = "cult"
	key = "y"
	flags = RESTRICTED | HIVEMIND

/datum/language/bogani
	name = "Bogani"
	colour = "alien"
	desc = "The language of the Bogani"
	speech_verb = "gurgles"
	ask_verb = "gurgles"
	exclaim_verb = "wails"
	key = "b"
	flags = RESTRICTED
	syllables = list("qy","bok","mok","yok","dy","gly","ryl","byl","dok","paj","kaj","wok","wyl","zak","qum","gyh","thj","qpo","basb","ies","niii",
	"eri","erk","eok","eyl","yyl","hyk","qyb","eon","gni","shaf","bissna","goqqo","xokj","wej","nym","assah","qwssa","nieasl","qyno","shaffar",
	"egyno","bogani","voijs","nekks","bollos","qoulsan","borrksakja","neemen","aka","nikka","qyegno","shafra","beolas","Byno")
	machine_understands = 0