//Cultists can construct structures fuelled by blood and trolling
/obj/structure/cult
	name = "cultic structure"
	desc = "A very strange structure."

	icon = 'icons/obj/structures/cult.dmi'
	icon_state = "" //Uses a very typical structure

	density = TRUE
	anchored = TRUE

	health_max = 25
	health_min_damage = 5

	//Special name and description that only cultists see
	var/cult_name = "mundane construct"
	var/cult_desc = "It has no particular purpose besides thinning the fabric of reality between us and him."

	var/datum/reagents/infused_blood //Where blood is stored in the structure

/obj/structure/cult/Initialize()
	..()
	infused_blood = new(120, src) //Create the blood storage area

/obj/structure/cult/proc/attempt_restore(mob/user, restore_amount)
	user.visible_message(
		SPAN_DANGER("\The [user] begins to do <b>something</b> with \the [src]."), //Confuse bystanders
		SPAN_NOTICE("You attempt to restore \the [src].")
	)

	if(do_after(user, 4 SECONDS, src, DO_DEFAULT)) //Takes a little bit
		user.visible_message(
			SPAN_WARNING("\The [user] mends  \the [src]."),
			SPAN_NOTICE("You restore \the [src].")
		)

		restore_health(restore_amount)
		return TRUE

	return FALSE

/obj/structure/cult/proc/tome_act(mob/user, obj/item/book/tome/book)
	to_chat(user, SPAN_OCCULT("You accomplish nothing trying to interface with \the [src] using \the [book]."))

/obj/structure/cult/attack_hand(mob/user) //Mostly human-related stuff for attempt_restore
	if(istype(user, /mob/living/carbon/human) && iscultist(user))
		var/mob/living/carbon/human/H = user

		if(health_damaged() && H.a_intent == I_HELP) //Helping will attempt to repair it
			H.remove_blood_simple(get_damage_value() * 0.25) //Sacrifice some blood to repair it
			to_chat(user, SPAN_WARNING("You feel blood seep through the pores of your skin into \the [src]."))

			var/restore_success = attempt_restore(user, get_damage_value() * 0.25)

			if(!restore_success) //Stand still or your blood is wasted
				user.visible_message(
					SPAN_WARNING("Blood runs down \the [src] onto \the [loc]."),
					SPAN_WARNING("Your [H.species.get_blood_name()] disappointingly flows down onto \the [loc]")
				)

				var/obj/effect/decal/cleanable/blood/drip/wasted_blood
				wasted_blood.basecolor = H.species.blood_color
				new wasted_blood(get_turf(src))

		if(H.a_intent == I_GRAB && infused_blood.get_free_space() > 0) //Grabbing will donate blood but not repair it
			to_chat(user, SPAN_WARNING("You feel blood seep through the pores of your skin into \the [src]."))
			H.remove_blood_simple(5)
			infused_blood.add_reagent(/datum/reagent/blood, 5)

		return
	..()

/obj/structure/cult/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/natural_weapon/cult_builder) && health_damaged())
		attempt_restore(user, GLOB.cult.cult_rating + 2) //Constructs get a boost based on cult rating
		return
	if(istype(W, /obj/item/book/tome))
		tome_act(user, W)
		return
	..()

/obj/structure/cult/examine(mob/user)
	. = ..()
	if(iscultist(user)) //check to display cult information
		to_chat(user, SPAN_INFO("This is a <b>[cult_name]</b>. [cult_desc]"))

		if(infused_blood.total_volume > 0)
			to_chat(user, SPAN_INFO("It has <b>[infused_blood.total_volume] units of blood</b> infused into it."))