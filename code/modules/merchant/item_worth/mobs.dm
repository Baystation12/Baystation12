/mob/living
	var/item_worth = 100

/mob/living/death()
	station_damage_score += get_worth()
	..()

/mob/living/proc/get_worth()
	return item_worth

/mob/living/carbon/human
	item_worth = 10000

/mob/living/carbon/human/get_worth()
	. = ..()
	if(species)
		. *= species.rarity_value

/mob/living/carbon/slime
	item_worth = 5000

/mob/living/simple_animal
	item_worth = 500

/mob/living/simple_animal/borer
	item_worth = 10000

/mob/living/simple_animal/corgi/Ian
	item_worth = 1000 //Ian is valuable

/mob/living/simple_animal/cow
	item_worth = 2000 //Cow expensive