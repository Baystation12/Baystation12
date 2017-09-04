/obj/item/weapon/mop
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


/obj/item/weapon/mop/New()
	create_reagents(30)

/obj/item/weapon/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || istype(A, /obj/effect/rune))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='notice'>Your mop is dry!</span>")
			return
		var/turf/T = get_turf(A)
		if(!T)
			return

		user.visible_message("<span class='warning'>[user] begins to clean \the [T].</span>")

		if(do_after(user, 40, T))
			if(T)
				T.clean(src, user)
			to_chat(user, "<span class='notice'>You have finished mopping!</span>")


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/soap))
		return
	..()
