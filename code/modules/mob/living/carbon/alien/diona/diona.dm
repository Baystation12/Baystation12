/mob/living/carbon/alien/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	adult_form = /mob/living/carbon/human
	speak_emote = list("chirrups")
	icon_state = "nymph"
	language = "Rootspeak"

	universal_understand = 1
	universal_speak = 0      // Dionaea do not need to speak to people other than other dionaea.
	holder_type = /obj/item/weapon/holder/diona

/mob/living/carbon/alien/diona/New()

	..()
	species = all_species["Diona"]
	verbs += /mob/living/carbon/alien/diona/proc/merge