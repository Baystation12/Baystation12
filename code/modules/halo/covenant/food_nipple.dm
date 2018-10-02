
/obj/structure/food_nipple
	name = "Grunt food nipple"
	desc = "Boy I sure hope you worked up a big grunty thirst!"
	icon = 'food_nipple.dmi'
	icon_state = "food nipple"
	density = 1
	anchored = 1

/obj/structure/food_nipple/attack_hand(var/mob/living/carbon/user)
	if(istype(user, /mob/living/carbon/human))
		var/turf/T = user.loc
		var/turf/forward = get_step(src,dir)
		if(T != forward)
			to_chat(user,"<span class='info'>You must be in front of [src] to drink from it.</span>")
		else
			if(user.nutrition < 375)
				user.nutrition = 400
				visible_message("<span class='info'>[user] takes a long drink from [src].</span>")
			else
				to_chat(user,"<span class='info'>You aren't thirsty right now.</span>")
	else
		to_chat(user,"<span class='warning'>There's no way you are touching that.</span>")
