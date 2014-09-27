/mob/living/carbon/alien/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	adult_form = /mob/living/carbon/human
	speak_emote = list("chirrups")
	icon_state = "nymph1"

	amount_grown = 0
	max_grown = 5 // Target number of donors.

	var/list/donors = list()
	var/last_checked_stage = 0

	universal_understand = 0 // Dionaea do not need to speak to people
	universal_speak = 0      // before becoming an adult. Use *chirp.
	holder_type = /obj/item/weapon/holder/diona

/mob/living/carbon/alien/diona/New()

	..()
	gender = NEUTER
	add_language("Rootspeak")
	src.verbs += /mob/living/carbon/alien/diona/proc/merge