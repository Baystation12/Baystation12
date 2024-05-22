// Cheap, shitty, hacky means of draining water without a proper pipe system.
// TODO: water pipes.
/obj/structure/hygiene/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/structures/drain.dmi'
	icon_state = "drain"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER+0.1
	can_drain = 1
	var/welded


/obj/structure/hygiene/drain/use_tool(obj/item/tool, mob/user, list/click_params)
	// Welding Tool - Weld the drain closed
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.remove_fuel(1, user))
			return TRUE
		welded = !welded
		user.visible_message(
			SPAN_NOTICE("\The [user] [welded ? "un" : "welds"] \the [src] with \a [tool]."),
			SPAN_NOTICE("You [welded ? "un" : "weld"] \the [src] with \the [tool].")
		)
		update_icon()
		return TRUE

	// Wrench - Dismantle drain
	if (isWrench(tool))
		var/obj/item/drain/drain_item = new(loc)
		transfer_fingerprints_to(drain_item)
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] unwrenches \the [src] from the floor with \a [tool]."),
			SPAN_NOTICE("You unwrench \the [src] from the floor with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/hygiene/drain/on_update_icon()
	icon_state = "[initial(icon_state)][welded ? "-welded" : ""]"

/obj/structure/hygiene/drain/Process()
	if(welded)
		return
	..()

/obj/structure/hygiene/drain/examine(mob/user)
	. = ..()
	if(welded)
		to_chat(user, "It is welded shut.")

//for construction.
/obj/item/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/structures/drain.dmi'
	icon_state = "drain"
	var/constructed_type = /obj/structure/hygiene/drain

/obj/item/drain/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(isWrench(thing))
		if (!isturf(loc))
			USE_FEEDBACK_FAILURE("\The [src] needs to be placed on the floor before you can secure it.")
			return TRUE
		new constructed_type(src.loc)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, SPAN_WARNING("[user] wrenches the [src] down."))
		qdel(src)
		return TRUE
	return ..()

/obj/structure/hygiene/drain/bath
	name = "sealable drain"
	desc = "You probably can't get sucked down the plughole. Specially not when it's closed!"
	icon_state = "drain_bath"
	var/closed = FALSE

/obj/structure/hygiene/drain/bath/attack_hand(mob/user)
	. = ..()
	if(!welded)
		closed = !closed
		user.visible_message(SPAN_NOTICE("\The [user] has [closed ? "closed" : "opened"] the drain."))
	update_icon()

/obj/structure/hygiene/drain/bath/on_update_icon()
	if(welded)
		icon_state = "[initial(icon_state)]-welded"
	else
		icon_state = "[initial(icon_state)][closed ? "-closed" : ""]"

/obj/structure/hygiene/drain/bath/examine(mob/user)
	. = ..()
	to_chat(user, "It is [closed ? "closed" : "open"]")

/obj/structure/hygiene/drain/bath/Process()
	if(closed)
		return
	..()
/obj/item/drain/bath
	name = "sealable drain"
	desc = "You probably can't get sucked down the plughole. Specially not when it's closed!"
	icon_state = "drain_bath"
	constructed_type = /obj/structure/hygiene/drain/bath
