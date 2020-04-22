//GALCOMM LANGUAGE LEARN OBJECT//
/obj/item/language_learner
	name = "Galactic Common Language Learner"
	desc = "A dataslate holding information on a single language. Enough to learn the basics of the language with."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	w_class = ITEM_SIZE_SMALL

	var/language_string = "Galactic Common"

/obj/item/language_learner/attack_self(var/mob/living/carbon/human/h)
	to_chat(h,"<span class = 'notice'>You read [name]...</span>")
	for(var/datum/language/lang in h.languages)
		if(lang.name == language_string)
			to_chat(h,"<span class ='notice'>You already know [language_string]</span>")
			return
	to_chat(h,"<span class = 'notice'>You think you've learnt enough to speak [language_string].</span>")
	h.add_language(language_string)
	to_chat(h,"<span class = 'notice'>You discard [name].</span>")
	h.drop_from_inventory(src)
	qdel(src)

/obj/item/language_learner/kigyar_to_common
	name = "Assembled Observations"
	desc = "A paper scrap containing observations of this system's inhabitants, their habits and, most importantly, their valuable goods. Enough of it is written in their language for you to learn the basics."

/obj/item/language_learner/unggoy_to_common
	name = "Heretic Assessment"
	desc = "A sheet of paper holding outdated observations of the viability of this system's inhabitants for integration with the covenant empire. The observations of their language and it's structure seems most useful."
