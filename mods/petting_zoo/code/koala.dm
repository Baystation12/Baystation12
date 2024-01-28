/mob/living/simple_animal/friendly/koala
	name = "space koala"
	desc = "A little grey bear, now much time he gonna sleep today?"
	icon = 'mods/petting_zoo/icons/mobs.dmi'
	icon_state = "koala"
	icon_living = "koala"
	icon_dead = "koala_dead"
	maxHealth = 45
	health = 45
	speed = 4
	speak_emote = list("roar")
	turns_per_move = 10
	see_in_dark = 6
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"

	say_list_type = /datum/say_list/koala

/datum/say_list/koala
	speak = list("Rrr", "Wraarh...", "Pfrrr...")
	emote_hear = list("grunting.","rustling.", "slowly yawns.")
	emote_see = list("slowly turns around his head.", "rises to his feet, and lays to the ground on all fours.")

/mob/living/simple_animal/friendly/koala/samorey
	name = "Haradrim"
	desc = "A lovable koala, named by man who love eucalyptus."
	gender = MALE
