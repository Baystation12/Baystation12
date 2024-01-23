/obj/item/flora/pottedplantsmall
	name = "small potted plant"
	desc = "This is a pot of assorted small flora. Some look familiar."
	icon = 'icons/obj/flora/plants.dmi'
	icon_state = "plant-15"
	item_state = "plant-15"
	w_class = ITEM_SIZE_LARGE

/obj/item/flora/pottedplantsmall/leaf
	name = "fancy leafy potted desk plant"
	desc = "A tiny waxy leafed plant specimen."
	icon_state = "plant-29"
	item_state = "plant-29"

/obj/item/flora/pottedplantsmall/fern
	name = "fancy ferny potted plant"
	desc = "This leafy desk fern could do with a trim."
	icon_state = "plant-27"
	item_state = "plant-27"
	var/trimmed = FALSE

/obj/item/flora/pottedplantsmall/fern/use_tool(obj/item/S, mob/living/user, list/click_params)
	if (isWirecutter(S))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		visible_message(SPAN_NOTICE("\The [user] starts trimming the [src] with \the [S]."))
		if (do_after(user, (S.toolspeed * 6) SECONDS, src, DO_PUBLIC_UNIQUE))
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
			to_chat (user, SPAN_NOTICE("You trim \the [src] with \the [S]. You probably should've used a pair of scissors."))
			trimmed = TRUE
			addtimer(new Callback(src, .proc/grow), 90 MINUTES, TIMER_UNIQUE|TIMER_OVERRIDE)
			update_icon()
		return TRUE
	return ..()

/obj/item/flora/pottedplantsmall/fern/on_update_icon()
	. = ..()
	if (trimmed)
		name = "fancy trimmed ferny potted plant"
		desc = "This leafy desk fern seems to have been trimmed too much."
		icon_state = "plant-30"
		item_state = "plant-30"
	else
		name = "fancy ferny potted plant"
		desc = "This leafy desk fern could do with a trim."
		icon_state = "plant-27"
		item_state = "plant-27"

/obj/item/flora/pottedplantsmall/fern/proc/grow()
	trimmed = FALSE
	update_icon()
