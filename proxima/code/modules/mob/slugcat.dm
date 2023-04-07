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
	maxbodytemp = 395 // Above 121 Degree Celsius. Yes, hot bath for a slugcat.
	holder_type = /obj/item/holder/cat/fluff/slugcat/newt
	say_list_type = /datum/say_list/cat/slugcat

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
