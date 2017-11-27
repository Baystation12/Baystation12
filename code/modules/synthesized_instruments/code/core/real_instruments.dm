/obj/structure/synthesized_instrument
	var/namespace/synthesized_instruments/player/player


/obj/structure/synthesized_instrument/Topic(href, href_list)
	if (..())
		return 1

	return player.Topic(href, href_list)


/obj/structure/synthesized_instrument/Destroy()
	qdel(src.player)
	return ..()


/obj/structure/synthesized_instrument/attack_hand(mob/user)
	src.ui_interact(user)


/obj/structure/synthesized_instrument/ui_interact(mob/user)
	return 0


/obj/structure/synthesized_instrument/proc/shouldStopPlaying(mob/user)
	return 0



/obj/item/device/synthesized_instrument
	var/namespace/synthesized_instruments/player/player


/obj/item/device/synthesized_instrument/Topic(href, href_list)
	if (..())
		return 1

	return player.Topic(href, href_list)


/obj/item/device/synthesized_instrument/Destroy()
	qdel(src.player)
	return ..()


/obj/item/device/synthesized_instrument/attack_hand(mob/user)
	src.ui_interact(user)


/obj/item/device/synthesized_instrument/ui_interact(mob/user)
	return 0


/obj/item/device/synthesized_instrument/proc/shouldStopPlaying(mob/user)
	return 0
