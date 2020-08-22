/datum/chorus_building/set_to_turf/growth/biter
	desc = "A small teeth-filled hole, used to injure and trap prey"
	building_type_to_build = /obj/structure/chorus/biter
	build_time = 20
	build_level = 1
	range = 0
	resource_cost = list(
		/datum/chorus_resource/growth_nutrients = 30
	)


/obj/structure/chorus/biter
	name = "biter"
	desc = "A pit filled with teeth, capable of biting and holding those who step on it."
	icon_state = "growth_biter"
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 5
	gives_sight = FALSE
	health = 1
	density = 0
	var/damage = 15 // Damage dealt during a bite
	var/bite_delay = FALSE // Whether or not the biter is 'resetting' - Set to true when releasing someone or coaxed into biting air, returns to false after the time set in bite_interval
	var/bite_interval = 30 SECONDS // Amount of time between reset and being able to bite someone again
	var/bite_coax_prob = 50 // Probability of coaxing a biter working and of injuring the user on a successful coax. A value of 50 means a 50% chance of no bite, 25% chance of bite and injury, 25% chance of bite and no injury


/obj/structure/chorus/biter/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())


/obj/structure/chorus/biter/user_unbuckle_mob(mob/user)
	if(!buckled_mob || !can_use(user))
		return

	var/user_is_cultist = user_is_cultist(user) // Cultists can coax it open faster. Stored in a var because it's checked multiple times
	if (user_is_cultist)
		user.visible_message(
			SPAN_NOTICE("\The [user] touches \the [src]."),
			SPAN_NOTICE("You reach out and touch \the [src], coaxing it to release \the [buckled_mob].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] begins freeing \the [buckled_mob] from \the [src]."),
			SPAN_NOTICE("You carefully begin to free \the [buckled_mob] from \the [src].")
		)

	var/timer = user_is_cultist ? 10 : 60
	if(do_after(user, timer, src))
		if (!can_use(user))
			return
		if (!buckled_mob)
			to_chat(user, SPAN_WARNING("\The [src] isn't holding anything anymore."))
			return

		if (user_is_cultist)
			user.visible_message(SPAN_NOTICE("\The [src] releases \the [buckled_mob] from its grip."))
		else
			user.visible_message(SPAN_NOTICE("\The [buckled_mob] has been freed from \the [src] by \the [user]."))
		unbuckle_mob()
		set_bite_delay()


/obj/structure/chorus/biter/chorus_click(var/mob/living/chorus/c)
	if (buckled_mob)
		if (!alert(c, "Do you want to release \the [buckled_mob]?", "", "Yes", "No") == "Yes")
			return
		if (!buckled_mob)
			return
		visible_message(SPAN_NOTICE("\The [src] releases \the [buckled_mob] from its grip."))
		to_chat(c, SPAN_NOTICE("\The [buckled_mob] has been released from \the [src]."))
		set_bite_delay()


/obj/structure/chorus/biter/attack_hand(mob/user)
	if (buckled_mob)
		user_unbuckle_mob(user)
	else
		if (!can_use(user))
			return
		if (alert(user, "Do you want to try to trick \the [src] into biting using your bare hand? This could hurt if you're not fast enough!", "", "Yes", "No") != "Yes")
			return

		user.visible_message(
			SPAN_WARNING("\The [user] reaches out toward \the [src], trying to coax it into biting!"),
			SPAN_NOTICE("You carefully reach your hand out toward \the [src], trying to coax it into biting!")
		)

		if (do_after(user, 10, src))
			if (!can_use(user))
				return
			if (buckled_mob)
				to_chat(user, SPAN_NOTICE("\The [src] has bitten and held onto someone else and doesn't respond to your actions."))
				return
			if (bite_delay)
				user.visible_message(
					SPAN_NOTICE("\The [src] doesn't seem ready to bite again and doesn't react.")
				)
				return

			var/coax_success = prob(bite_coax_prob) // Whether or not the biter takes the bait
			var/coax_injury = prob(bite_coax_prob) // Whether or not the biter catches the user's hand
			if (coax_success && coax_injury)
				user.visible_message(
					SPAN_DANGER("\The [src] bites down on \the [user]'s outstretched limb and pulls them in!"),
					SPAN_DANGER("\The [src] bites down on your before you can pull away and pulls you in!")
				)
				handle_bite(user, limb_targets = list(BP_L_HAND, BP_L_ARM, BP_R_HAND, BP_R_ARM))

			else if (coax_success)
				user.visible_message(
					SPAN_WARNING("\The [src] bites down, but \the [user] pulls away just in time!"),
					SPAN_WARNING("\The [src] bites down, but you pull away just in time!")
				)
				set_bite_delay()

			else
				user.visible_message(
					SPAN_NOTICE("\the [user] pulls away before \the [src] does anything."),
					SPAN_NOTICE("You reflexively pull your hand back, but nothing happens.")
				)


/obj/structure/chorus/biter/Initialize(var/maploading, var/o)
	. = ..()
	GLOB.entered_event.register(get_turf(src), src, .proc/bite_victim)


/obj/structure/chorus/biter/Destroy()
	GLOB.entered_event.unregister(get_turf(src), src)
	. = ..()


/obj/structure/chorus/biter/proc/bite_victim(var/atom/a, var/mob/living/L)
	if (buckled_mob || bite_delay || !istype(L) || user_is_cultist(L) || !can_activate(owner))
		return

	visible_message(SPAN_DANGER("\The [src] bites at \the [L]'s feet!"))
	handle_bite(L)


/obj/structure/chorus/biter/proc/handle_bite(mob/living/L, buckle = TRUE, list/limb_targets = list(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG))
	flick("growth_biter_attack", src)

	if(istype(L, /mob/living/carbon/human))
		var/target = pick(limb_targets)
		var/mob/living/carbon/human/H = L
		H.apply_damage(damage, BRUTE, target)
	else
		L.adjustBruteLoss(damage)

	if (buckle)
		bite_delay = TRUE // Prevents double-biting from moving and buckling
		L.move_to_turf(L, get_turf(L), get_turf(src))
		buckle_mob(L)
		bite_delay = FALSE

	if (owner)
		to_chat(owner, SPAN_WARNING("\A [src] has bitten[buckle ? " and is holding onto" : null] \a [L]!"))

	admin_attack_log(owner, L,
		"Bit[buckle ? " and held" : null] their victim with \a [src].",
		"Was bitten[buckle ? " and held" : null] by \a [src].",
		", using \a [src], has bitten[buckle ? " and held" : null]"
	)


/obj/structure/chorus/biter/proc/set_bite_delay()
	if (!bite_delay)
		bite_delay = TRUE
		addtimer(CALLBACK(src, .proc/reset_bite_delay), bite_interval)


/obj/structure/chorus/biter/proc/reset_bite_delay()
	if (bite_delay)
		bite_delay = FALSE
		visible_message(SPAN_WARNING("\The [src] looks ready to bite again!"))
