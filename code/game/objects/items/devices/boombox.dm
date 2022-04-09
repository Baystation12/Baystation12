#define BOOMBOX_PANEL 1
#define BOOMBOX_BROKEN 2

/obj/item/boombox
	name = "boombox"
	desc = "A device used to emit rhythmic sounds, colloquialy refered to as a 'boombox'. It's in a retro style (massive), and absolutely unwieldy."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "off"
	item_state = "boombox"
	force = 7
	w_class = ITEM_SIZE_HUGE //forbid putting something that emits loud sounds forever into a backpack
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

	var/jukebox/jukebox
	var/boombox_flags


/obj/item/boombox/Initialize()
	. = ..()
	jukebox = new(src, "boombox.tmpl", "HEXABEATRON&trade;", 400, 150)


/obj/item/boombox/Destroy()
	QDEL_NULL(jukebox)
	. = ..()


/obj/item/boombox/on_update_icon()
	icon_state = jukebox?.playing ? "on" : "off"


/obj/item/boombox/attack_self(mob/user)
	playsound(src, "switch", 30)
	if (GET_FLAGS(boombox_flags, BOOMBOX_BROKEN))
		return
	jukebox.ui_interact(user)


/obj/item/boombox/MouseDrop(mob/user)
	jukebox.ui_interact(user)


/obj/item/boombox/emp_act(severity)
	if (GET_FLAGS(boombox_flags, BOOMBOX_BROKEN))
		return
	audible_message(SPAN_WARNING("\The [src]'s speakers pop with a sharp crack!"))
	playsound(src, 'sound/effects/snap.ogg', 100, 1)
	SET_FLAGS(boombox_flags, BOOMBOX_BROKEN)
	jukebox.Stop()


/obj/item/boombox/examine(mob/user, distance)
	. = ..()
	if (distance > 3)
		return
	var/message
	if (GET_FLAGS(boombox_flags, BOOMBOX_PANEL))
		message = "[message?" ":""]The front panel is open."
		if (GET_FLAGS(boombox_flags, BOOMBOX_BROKEN))
			message += "[message?" ":""]It's broken."
	if (!message)
		return
	to_chat(user, SPAN_ITALIC(message))


/obj/item/boombox/attackby(obj/item/item, mob/user)
	set waitfor = FALSE
	if(isScrewdriver(item))
		var/item_loc = item.loc
		if (GET_FLAGS(boombox_flags, BOOMBOX_PANEL))
			user.visible_message(
				SPAN_ITALIC("\The [user] closes the service panel on \the [src]."),
				SPAN_NOTICE("You close the service panel on \the [src]."),
				range = 3
			)
			CLEAR_FLAGS(boombox_flags, BOOMBOX_PANEL)
		else if (!GET_FLAGS(boombox_flags, BOOMBOX_BROKEN))
			if (jukebox.playing)
				to_chat(user, SPAN_WARNING("You can't adjust the player head while it's in use."))
				return TRUE
			var/data = input(user, "Adjust player head screw?", "Adjust Head") as null | anything in list("tighten", "loosen")
			if (item_loc == item.loc)
				var/old_frequency = jukebox.frequency
				switch (data)
					if ("tighten") jukebox.frequency = max(jukebox.frequency - 0.1, 0.5)
					if ("loosen") jukebox.frequency = min(jukebox.frequency + 0.1, 1.5)
				if (jukebox.frequency == old_frequency)
					to_chat(user, SPAN_WARNING("Try as you might, the screw won't turn further."))
					return TRUE
				user.visible_message(
					SPAN_ITALIC("\The [user] uses \the [item] to fiddle with \the [src]."),
					SPAN_NOTICE("You [data] the player head screw inside \the [src]."),
					range = 3
				)
		else if (!GET_FLAGS(boombox_flags, BOOMBOX_PANEL))
			user.visible_message(
				SPAN_ITALIC("\The [user] opens the service panel on \the [src]."),
				SPAN_NOTICE("You open the service panel on \the [src]."),
				range = 3
			)
			SET_FLAGS(boombox_flags, BOOMBOX_PANEL)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		return TRUE
	if (istype(item, /obj/item/stack/nanopaste))
		if (!GET_FLAGS(boombox_flags, BOOMBOX_PANEL))
			to_chat(user, SPAN_WARNING("The panel on \the [src] is not open."))
			return TRUE
		if (!GET_FLAGS(boombox_flags, BOOMBOX_BROKEN))
			to_chat(user, SPAN_WARNING("\The [src] is not broken."))
			return TRUE
		var/obj/item/stack/paste = item
		if (!paste.use(1))
			to_chat(user, SPAN_WARNING("\The [paste] is empty."))
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] uses \the [item] to repair \the [src]."),
			SPAN_NOTICE("You repair \the [src] with \the [item]."),
			range = 3
		)
		CLEAR_FLAGS(boombox_flags, BOOMBOX_BROKEN)
		return TRUE
	. = ..()



/obj/random_multi/single_item/boombox
	name = "boombox spawnpoint"
	id = "boomtastic"
	item_path = /obj/item/boombox



#undef BOOMBOX_PANEL
#undef BOOMBOX_BROKEN
