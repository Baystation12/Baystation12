/obj/item/dehydrated_carp
	name = "carp plushie"
	desc = "A plushie of an elated carp! Straight from the wilds of the Nyx frontier, now right here in your hands."
	icon = 'icons/obj/toy.dmi'
	icon_state = "carpplushie"
	var/spawned_mob = /mob/living/simple_animal/hostile/carp

/obj/item/dehydrated_carp/attack_self(mob/user)
	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("\The [user] hugs [src]!"), SPAN_NOTICE("You hug [src]!"))
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("\The [user] punches [src]!"), SPAN_WARNING("You punch [src]!"))
	else if (user.a_intent == I_GRAB)
		user.visible_message(SPAN_WARNING("\The [user] attempts to strangle [src]!"), SPAN_WARNING("You attempt to strangle [src]!"))
	else
		user.visible_message(SPAN_NOTICE("\The [user] pokes [src]."), SPAN_NOTICE("You poke [src]."))

/obj/item/dehydrated_carp/attackby(obj/O, mob/user)
	if (istype(O, /obj/item/reagent_containers/glass) || istype(O, /obj/item/reagent_containers/food/drinks))
		if (O.reagents)
			if (O.reagents.total_volume < 1)
				to_chat(user, "\The [O] is empty.")
			else if (O.reagents.total_volume >= 1)
				if (O.reagents.has_reagent(/datum/reagent/water, 1))
					visible_message(SPAN_WARNING("\The [src] begins to shake as the liquid touches it."))
					addtimer(CALLBACK(src, .proc/carpify), 5 SECONDS)

/obj/item/dehydrated_carp/proc/carpify()
	visible_message(SPAN_WARNING("\The [src] rapidly expands into a living space carp!"))
	new spawned_mob(get_turf(src))
	qdel(src)

/obj/item/dehydrated_carp/get_antag_info()
	. = ..()
	. += "You can add water to this plushie to hydrate it, transforming it into a living space carp after a short delay. Be careful, as the carp will be hostile to you too!"
