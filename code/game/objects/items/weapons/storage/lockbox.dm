/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 32
	req_access = list(access_armory)
	var/locked = TRUE
	var/broken = FALSE
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


/obj/item/storage/lockbox/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/card/id))
		if (broken)
			to_chat(user, SPAN_WARNING("It seems to be broken!"))
		else if (!allowed(user))
			to_chat(user, SPAN_WARNING("Access denied!"))
		else if ((locked = !locked))
			to_chat(user, SPAN_NOTICE("You lock \the [src]!"))
			close_all()
		else
			icon_state = icon_closed
			to_chat(user, SPAN_NOTICE("You lock \the [src]!"))
		return
	else if (!broken && istype(I, /obj/item/melee/energy/blade))
		var/success = emag_act(INFINITY, user, I, null, "You hear metal being sliced and sparks flying.")
		if (success)
			var/datum/effect/effect/system/spark_spread/spark_system = new
			spark_system.set_up(5, 0, loc)
			spark_system.start()
			playsound(loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(loc, "sparks", 50, 1)
	if (locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
		return
	..()


/obj/item/storage/lockbox/show_to(mob/user)
	if (locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
	else
		..()


/obj/item/storage/lockbox/emag_act(remaining_charges, mob/user, emag_source, visual_feedback, audible_feedback)
	if (broken)
		return
	broken = TRUE
	locked = FALSE
	desc = "It appears to be broken."
	icon_state = icon_broken
	if (user)
		if (!visual_feedback)
			visual_feedback = "\The [src] has been sliced open by \the [user] with \an [emag_source]!"
		visual_feedback = SPAN_WARNING(visual_feedback)
		if (!audible_feedback)
			audible_feedback = "You hear a faint electrical spark."
		audible_feedback = SPAN_WARNING(audible_feedback)
		visible_message(visual_feedback, audible_feedback)
	return TRUE


/obj/item/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)
	startswith = list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty = 1
	)


/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)
	startswith = list(
		/obj/item/grenade/flashbang/clusterbang = 1
	)
