/obj/structure/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'icons/obj/storage.dmi'
	icon_state = "stasis_cage"
	density = 1
	layer = ABOVE_OBJ_LAYER

	var/mob/living/simple_animal/contained

/obj/structure/stasis_cage/Initialize()
	. = ..()

	var/mob/living/simple_animal/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/stasis_cage/attack_hand(var/mob/user)
	try_release(user)

/obj/structure/stasis_cage/attack_robot(var/mob/user)
	if(Adjacent(user))
		try_release(user)

/obj/structure/stasis_cage/proc/try_release(mob/user)
	if(!contained)
		to_chat(user, SPAN_NOTICE("There's no animals inside \the [src]"))
		return
	user.visible_message("[user] begins undoing the locks and latches on \the [src].")
	if(do_after(user, 20, src))
		user.visible_message("[user] releases \the [contained] from \the [src]!")
		release()

/obj/structure/stasis_cage/on_update_icon()
	if(contained)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/structure/stasis_cage/examine(mob/user)
	. = ..()
	if(contained)
		to_chat(user, "\The [contained] is kept inside.")

/obj/structure/stasis_cage/proc/contain(var/mob/living/simple_animal/animal)
	if(contained || !istype(animal))
		return

	contained = animal
	animal.forceMove(src)
	animal.in_stasis = 1
	update_icon()

/obj/structure/stasis_cage/proc/release()
	if(!contained)
		return

	contained.dropInto(src)
	contained.in_stasis = 0
	contained = null
	update_icon()

/obj/structure/stasis_cage/Destroy()
	release()
	return ..()

/mob/living/simple_animal/MouseDrop(var/obj/structure/stasis_cage/over_object)
	if(istype(over_object) && Adjacent(over_object) && CanMouseDrop(over_object, usr))

		if(!stat && !istype(src.buckled, /obj/effect/energy_net))
			to_chat(usr, "It's going to be difficult to convince \the [src] to move into \the [over_object] without capturing it in a net.")
			return

		usr.visible_message("[usr] begins stuffing \the [src] into \the [over_object].", "You begin stuffing \the [src] into \the [over_object].")
		Bumped(usr)
		if(do_after(usr, 20, over_object))
			usr.visible_message("[usr] has stuffed \the [src] into \the [over_object].", "You have stuffed \the [src] into \the [over_object].")
			over_object.contain(src)
	else
		return ..()