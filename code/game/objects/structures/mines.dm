/obj/structure/mine
	name = "mine"
	desc = "An explosive device that tends to detonate if you look at it wrong."
	anchored = TRUE
	icon = 'icons/obj/weapons/mines.dmi'
	icon_state = "uglymine"

	/// Boolean. If set, the mine is already triggered and won't trigger again. Used for both preventing duplicate activations, and for mines which have a delayed or ongoing effect.
	var/activated = FALSE


/obj/structure/mine/debug
	name = "debug mine"


/obj/structure/mine/Crossed(mob/living/M)
	. = ..()
	if (!istype(M))
		return
	M.show_message(
		SPAN_WARNING("Your foot steps down on \the [src]... Uh oh..."),
		VISIBLE_MESSAGE,
		SPAN_WARNING("You feel your foot step down on something, and get a very bad feeling...")
	)
	if (!activated)
		activate()


/obj/structure/mine/bullet_act(obj/item/projectile/P, def_zone)
	if (prob(P.original == src ? 30 : 10)) // Small target, hard to hit on purpose, even harder to hit on accident
		if (!activated)
			activate()
		return FALSE
	return TRUE


/obj/structure/mine/ex_act(severity, turf_breaker)
	if (!activated)
		activate()


/obj/structure/mine/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	user.visible_message(
		SPAN_WARNING("\The [user] hits \the [src] with \a [weapon]!"),
		SPAN_DANGER("You hit \the [src] with \the [weapon]. This was a bad idea.")
	)
	if (!activated)
		activate()
	return TRUE


/obj/structure/mine/proc/activate(mob/living/victim)
	activated = TRUE
	visible_message(
		SPAN_DANGER("\The [src] explodes!"),
		SPAN_DANGER("You hear an explosion!")
	)
	explosion(get_turf(src), 3, EX_ACT_HEAVY)
	qdel_self()


/obj/structure/mine/debug/activate(mob/living/victim)
	log_debug("[src] triggered by [victim]")
