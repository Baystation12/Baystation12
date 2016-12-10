/mob/living/carbon/alien/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	adult_form = /mob/living/carbon/human
	can_namepick_as_adult = 1
	adult_name = "diona gestalt"
	speak_emote = list("chirrups")
	icon_state = "nymph"
	item_state = "nymph"
	language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	only_species_language = 1
	death_msg = "expires with a pitiful chirrup..."
	universal_understand = 0
	universal_speak = 0      // Dionaea do not need to speak to people other than other dionaea.

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/weapon/holder/diona
	possession_candidate = 1
	var/obj/item/hat

/mob/living/carbon/alien/diona/New()

	..()
	species = all_species["Diona"]
	verbs += /mob/living/carbon/alien/diona/proc/merge

/mob/living/carbon/alien/diona/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

/mob/living/carbon/alien/diona/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.loc = src
	update_icons()

