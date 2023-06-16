/obj/item/holder/cat/fluff/slugcat
	name = "slugcat"
	desc = "It's a slugcat! Wawawawawawawa."
	gender = MALE
	icon = 'proxima/icons/mob/slugcat.dmi'
	icon_state = "slugcat"

/mob/living/simple_animal/passive/cat/fluff/slugcat
	name = "slugcat"
	desc = "That's a cat-like slug creature, found on a rainy exoplanet of V1D30-CT. Wawawawawawawa."
	gender = MALE
	icon_state = "slugcat"
	item_state = "slugcat"
	icon_living = "slugcat"
	icon_dead = "slugcat_dead"
	speak_emote = list("мурлычет", "мяукает", "булькает")
	minbodytemp = 53
	maxbodytemp = 395 // Above 121 Degree Celsius. Yes, hot bath for a slugcat.
	holder_type = /obj/item/holder/cat/fluff/slugcat/newt
	say_list_type = /datum/say_list/cat/slugcat
	var/prey_list = list(/mob/living/simple_animal/passive/mouse,
		/mob/living/simple_animal/passive/chick,
		/mob/living/simple_animal/passive/chicken,
		/mob/living/simple_animal/passive/opossum)

/datum/say_list/cat/slugcat
	speak = list("Мьяу!","Мяу!","Мрррррх!","Шшшш...","Вавававававава!")
	emote_hear = list("мяучит","мурчит","булькает")
	emote_see = list("трясет головой", "трется", "вздрагивает")

/obj/item/holder/cat/fluff/slugcat/newt
	name = "Newt"
	desc = "It's Newt! Wawawawawawawa."
	gender = FEMALE

/mob/living/simple_animal/passive/cat/fluff/slugcat/newt
	name = "Newt"
	desc = "That's a cat-like slug creature, found on a rainy exoplanet of V1D30-CT and adopted by Expeditionary Corps just to be soon kidnapped by Fleet. Wawawawawawawa."
	gender = FEMALE
	holder_type = /obj/item/holder/cat/fluff/slugcat/newt
	say_list_type = /datum/say_list/cat/slugcat

/mob/living/simple_animal/passive/cat/fluff/slugcat/Life()
	var/mob/living/potential_prey
	. = ..()
	if(!.)
		return FALSE
	//HUNT PREY! Да, слизнекот будет охотиться на мышей, цыплят, курей и опоссумов (позже, возможно, и нимф дион).
	if((src.loc) && isturf(src.loc))
		if(!resting && !buckled)
			if((locate(potential_prey) in view(src,5)) && (is_type_in_list (potential_prey, prey_list)))
				if(!potential_prey.stat)
					potential_prey.death()
					visible_emote(pick("кусает [potential_prey]!","играет с [potential_prey].","откусывает [potential_prey]!"))
					movement_target = null
					set_AI_busy(FALSE)
					return

/mob/living/simple_animal/passive/cat/fluff/slugcat/death()
	var/deathsfx = pick(
		'proxima/sound/effects/slugpipe.ogg',
		'proxima/sound/effects/slugmeow.ogg',
		'proxima/sound/effects/slughitmarker.ogg',
		'proxima/sound/effects/slugslap.ogg')

	if(hiding)
		hiding = FALSE
	playsound(src, deathsfx, 50, 0)
	. = ..()
