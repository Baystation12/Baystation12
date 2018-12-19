/obj/item/mech_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/structure/carrying

/obj/item/mech_equipment/clamp/attack()
	return 0

/obj/item/mech_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(. && !carrying)
		if(istype(target, /obj/structure))
			var/obj/structure/S = target
			if(!S.anchored)
				owner.visible_message(SPAN_NOTICE("\The [owner] begins loading \the [S]."))
				if(do_after(owner, 20, S, 0, 1))
					S.forceMove(src)
					carrying = S
					owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [S] into its cargo compartment."))

/obj/item/mech_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!carrying)
			to_chat(user, SPAN_WARNING("You are not carrying anything in \the [src]."))
		else
			owner.visible_message(SPAN_NOTICE("\The [owner] unloads \the [carrying]."))
			carrying.forceMove(get_turf(src))
			carrying = null

/obj/item/mech_equipment/clamp/get_hardpoint_maptext()
	if(carrying)
		return carrying.name
	. = ..()

// A lot of this is copied from floodlights.
/obj/item/mech_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)

	var/on = 0
	var/l_max_bright = 0.8
	var/l_inner_range = 1
	var/l_outer_range = 6

/obj/item/mech_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()

/obj/item/mech_equipment/light/on_update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(l_max_bright, l_inner_range, l_outer_range)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0, 0)
