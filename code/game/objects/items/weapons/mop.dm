/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 5
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	var/mopping = 0
	var/mopcount = 0
	var/mopspeed = 40
	var/list/moppable_types = list(
		/obj/effect/decal/cleanable,
		/obj/effect/rune,
		/obj/structure/catwalk
		)

/obj/item/mop/Initialize()
	. = ..()
	create_reagents(30)

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	var/moppable
	if(istype(A, /turf))
		var/turf/T = A
		var/obj/effect/fluid/F = locate() in T
		if(F && F.fluid_amount > 0)
			if(F.fluid_amount > FLUID_SHALLOW)
				to_chat(user, SPAN_WARNING("There is too much water here to be mopped up."))
			else
				user.visible_message("<span class='notice'>\The [user] begins to mop up \the [T].</span>")
				if(do_after(user, mopspeed, T, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS) && F && !QDELETED(F))
					if(F.fluid_amount > FLUID_SHALLOW)
						to_chat(user, SPAN_WARNING("There is too much water here to be mopped up."))
					else
						qdel(F)
						to_chat(user, "<span class='notice'>You have finished mopping!</span>")
			return
		moppable = TRUE

	else if(is_type_in_list(A,moppable_types))
		moppable = TRUE

	if(moppable)
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='notice'>Your mop is dry!</span>")
			return
		var/turf/T = get_turf(A)
		if(!T)
			return

		user.visible_message("<span class='warning'>\The [user] begins to clean \the [T].</span>")

		if(do_after(user, mopspeed, T, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
			if(T)
				T.clean(src, user)
			to_chat(user, "<span class='notice'>You have finished mopping!</span>")


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	..()

/obj/item/mop/advanced
	desc = "The most advanced tool in a custodian's arsenal, with a cleaner synthesizer to boot! Just think of all the viscera you will clean up with this!"
	name = "advanced mop"
	icon_state = "advmop"
	item_state = "mop"
	force = 6
	throwforce = 11
	mopspeed = 20
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 1 //Rate per process() tick mop refills itself
	var/refill_reagent = /datum/reagent/space_cleaner //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, "<span class='notice'>You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position.</span>")
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/mop/advanced/Process()
	if(reagents.total_volume < 30)
		reagents.add_reagent(refill_reagent, refill_rate)

/obj/item/mop/advanced/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>.</span>")

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()