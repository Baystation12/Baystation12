// Cheap, shitty, hacky means of draining water without a proper pipe system.
// TODO: water pipes.
/obj/structure/hygiene/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/drain.dmi'
	icon_state = "drain"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER+0.1
	can_drain = 1
	var/welded

/obj/structure/hygiene/drain/attackby(var/obj/item/thing, var/mob/user)
	..()
	if(isWelder(thing))
		var/obj/item/weldingtool/WT = thing
		if(WT.isOn())
			welded = !welded
			to_chat(user, "<span class='notice'>You weld \the [src] [welded ? "closed" : "open"].</span>")
		else
			to_chat(user, "<span class='warning'>Turn \the [thing] on, first.</span>")
		update_icon()
		return
	if(isWrench(thing))
		new /obj/item/drain(src.loc)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='warning'>[user] unwrenches the [src].</span>")
		qdel(src)
		return
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
	icon = 'icons/obj/drain.dmi'
	icon_state = "drain"
	var/constructed_type = /obj/structure/hygiene/drain

/obj/item/drain/attackby(var/obj/item/thing, var/mob/user)
	if(isWrench(thing))
		new constructed_type(src.loc)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='warning'>[user] wrenches the [src] down.</span>")
		qdel(src)
		return
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
