/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"

	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	maxHealth = 25
	health = 25

	var/adult_form = /mob/living/carbon/human
	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/can_namepick_as_adult = 0
	var/adult_name

/mob/living/carbon/alien/larva/New()
	..()
	time_of_birth = world.time
	add_language("Xenophage") //Bonus language.
	internal_organs |= new /obj/item/organ/internal/xeno/hivenode(src)
	create_reagents(100)

/mob/living/carbon/alien/larva/update_icons()

	var/state = 0
	if(amount_grown > max_grown*0.75)
		state = 2
	else if(amount_grown > max_grown*0.25)
		state = 1

	if(stat == DEAD)
		icon_state = "[initial(icon_state)][state]_dead"
	else if (stunned)
		icon_state = "[initial(icon_state)][state]_stun"
	else if(lying || resting)
		icon_state = "[initial(icon_state)][state]_sleep"
	else
		icon_state = "[initial(icon_state)][state]"
