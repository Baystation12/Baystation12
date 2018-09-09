
/mob/living/simple_animal/engineer
	name = "Huragok"
	desc = "Gas sacs on its back enable it to float. It has a long snakelike neck and multiple tentacles extending into fine cilia."
	icon = 'engineer.dmi'
	icon_state = "engineer"
	icon_dead = "engineer_dead"
	speak = list()
	emote_hear = list("chirrups","emits a flubber of gas")
	emote_see = list("peers around with its long neck", "bobs gently","waves its tentacles")
	speak_chance = 15
	turns_per_move = 4

/mob/living/simple_animal/engineer/New()
	. = ..()
	update_floating()

/mob/living/simple_animal/engineer/check_solid_ground()
	return 0

/mob/living/simple_animal/engineer/Allow_Spacemove()
	return 1

/mob/living/simple_animal/engineer/death(gibbed, deathmessage = "dies!", show_dead_message)
	. = ..()

	//except when dead :(
	make_floating(0)
