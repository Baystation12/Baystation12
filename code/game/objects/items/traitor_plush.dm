/obj/item/reagent_containers/food/snacks/dehydrated_carp
	name = "carp plushie"
	desc = "A plushie of an elated carp! Straight from the wilds of the Nyx frontier, now right here in your hands."
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	icon = 'icons/obj/toy.dmi'
	icon_state = "carpplushie"
	filling_color = "#522666"

	var/spawned_mob = /mob/living/simple_animal/hostile/carp

/obj/item/reagent_containers/food/snacks/dehydrated_carp/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)

/obj/item/reagent_containers/food/snacks/dehydrated_carp/attack(mob/M, mob/user, def_zone)
	return

/obj/item/reagent_containers/food/snacks/dehydrated_carp/attack_self(mob/user)
	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("\The [user] hugs [src]!"), SPAN_NOTICE("You hug [src]!"))
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("\The [user] punches [src]!"), SPAN_WARNING("You punch [src]!"))
	else if (user.a_intent == I_GRAB)
		user.visible_message(SPAN_WARNING("\The [user] attempts to strangle [src]!"), SPAN_WARNING("You attempt to strangle [src]!"))
	else
		user.visible_message(SPAN_NOTICE("\The [user] pokes [src]."), SPAN_NOTICE("You poke [src]."))

/obj/item/reagent_containers/food/snacks/dehydrated_carp/on_reagent_change()
	if (reagents.has_reagent(/datum/reagent/water))
		visible_message(SPAN_WARNING("\The [src] begins to shake as the liquid touches it."))
		addtimer(CALLBACK(src, .proc/expand), 5 SECONDS)

/obj/item/reagent_containers/food/snacks/dehydrated_carp/proc/expand()
	visible_message(SPAN_WARNING("\The [src] rapidly expands into a living space carp!"))
	new spawned_mob(get_turf(src))
	qdel(src)

/obj/item/reagent_containers/food/snacks/dehydrated_carp/get_antag_info()
	. = ..()
	. += "You can add water to this plushie to hydrate it, transforming it into a living space carp after a short delay. Be careful, as the carp will be hostile to you too!"

/obj/item/plushbomb
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs it's way right into your heart."
	icon = 'icons/obj/toy.dmi'
	icon_state = "kittenplushie"
	var/phrase

/obj/item/plushbomb/Initialize()
	. = ..()
	GLOB.listening_objects += src

/obj/item/plushbomb/Destroy()
	GLOB.listening_objects -= src
	return ..()

/obj/item/plushbomb/attack_self(mob/user)
	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("\The [user] hugs [src]!"), SPAN_NOTICE("You hug [src]!"))
	else if (user.a_intent == I_GRAB)
		if (!phrase)
			phrase = sanitize_phrase(input("Choose activation phrase:") as text)
			to_chat(user, SPAN_NOTICE("You set the activation phrase to be '[phrase]'."))
		else
			user.visible_message(SPAN_WARNING("\The [user] attempts to strangle [src]!"), SPAN_WARNING("You attempt to strangle [src]!"))
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("\The [user] punches [src]!"), SPAN_WARNING("You punch [src]!"))
	else
		user.visible_message(SPAN_NOTICE("\The [user] pokes [src]."), SPAN_NOTICE("You poke [src]."))

/obj/item/plushbomb/hear_talk(mob/M, msg)
	if (!phrase)
		return
	if (findtext(sanitize_phrase(msg), phrase))
		addtimer(CALLBACK(src, .proc/activate), 5 SECONDS)
		visible_message(SPAN_DANGER("\The [src] begins to beep ominously!"))
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

/obj/item/plushbomb/proc/sanitize_phrase(phrase)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	return replace_characters(phrase, replacechars)

/obj/item/plushbomb/proc/activate()
	explosion(src.loc, 0, 0, 3, 3)
	qdel(src)

/obj/item/plushbomb/get_antag_info()
	. = ..()
	. += "Set an activation phrase by using the plush on grab intent. Upon hearing the trigger phrase, the plush will explode after a 5 second countdown."

/obj/item/plushbomb/nymph
	name = "diona nymph plush"
	desc = "A plushie of an adorable diona nymph! While its level of self-awareness is still being debated, its level of cuteness is not."
	icon_state = "nymphplushie"

/obj/item/plushbomb/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has eight legs - all the better to hug you with."
	icon_state = "spiderplushie"

/obj/item/plushbomb/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Straight from the wilds of the Nyx frontier, now right here in your hands."
	icon_state = "carpplushie"
