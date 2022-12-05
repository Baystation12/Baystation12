/obj/random_multi/single_item/punitelly
	name = "Multi Point - Warrant Officer Punitelli"
	id = "Punitelli"
	item_path = /mob/living/carbon/human/monkey/punitelli

/mob/living/carbon/human/monkey/punitelli/New()
	..()
	name = "Warrant Officer Punitelli"
	real_name = name
	var/obj/item/clothing/C
	C = new /obj/item/clothing/under/solgov/utility/expeditionary/monkey(src)
	equip_to_appropriate_slot(C)
	put_in_hands(new /obj/item/reagent_containers/food/drinks/glass2/coffeecup/punitelli)
	equip_to_appropriate_slot(new /obj/item/clothing/mask/smokable/cigarette/jerichos)

/obj/random_multi/single_item/space_rabbit
	name = "Multi Point - White Space Rabbit"
	id = "Rabbit"
	item_path = /mob/living/simple_animal/rabbit/space/sierra

/mob/living/simple_animal/rabbit/space/sierra
	name = "\improper Edwin"
	desc = "The hippiest hop around. On it's back you can see a small black letters: Aldrin."

	say_list_type = /datum/say_list/rabbit/sierra

/datum/say_list/rabbit/sierra
	emote_see = list("hops around","bounces up and down","says something in imaginated headset")
