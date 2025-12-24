/obj/item/organ/internal/augment/active/polytool/engineer
	name = "engineering toolset"
	action_button_name = "Deploy Engineering Tool"
	desc = "A lightweight augmentation for the engineer on-the-go. This one comes with a series of common tools."
	paths = list(
		/obj/item/screwdriver/finger,
		/obj/item/wrench/finger,
		/obj/item/weldingtool/finger,
		/obj/item/crowbar/finger,
		/obj/item/wirecutters/finger,
		/obj/item/device/multitool/finger
	)


/obj/item/weldingtool/finger
	name = "digital welder"
	desc = "A precise, high quality welding tool."
	icon_state = "welder_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/weldingtool/finger/on_update_icon()
	if(welding)
		icon_state = "welder_finger_on"
		set_light(2.5, 0.6, l_color =COLOR_PALE_ORANGE)
	else
		icon_state = "welder_finger"
		set_light(0)


/obj/item/wirecutters/finger
	name = "digital splicer"
	desc = "A small embedded cutter in your finger."
	icon_state = "wirecutter_finger"
	icon = 'icons/obj/augment_tools.dmi'
	build_from_parts = FALSE
	canremove = FALSE


/obj/item/wirecutters/finger/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)


/obj/item/screwdriver/finger
	name = "digital screwdriver"
	desc = "A nifty powertool at your literal fingertips."
	icon_state = "screwdriver_finger"
	icon = 'icons/obj/augment_tools.dmi'
	build_from_parts = FALSE
	canremove = FALSE


/obj/item/screwdriver/finger/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)


/obj/item/crowbar/finger
	name = "digital prybar"
	desc = "A somewhat awkward to use prybar. It doubles as bottle opener."
	icon_state = "prybar_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/crowbar/finger/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)


/obj/item/wrench/finger
	name = "digital wrench"
	desc = "A rotating wrench. Don't get your hair caught in it."
	icon_state = "wrench_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/wrench/finger/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)


/obj/item/device/multitool/finger
	name = "digital multitool"
	desc = "A multitool inside of a multitool. Doubletool?"
	icon_state = "multitool_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/organ/internal/augment/active/polytool/engineer/advanced
	name = "advanced engineering toolset"
	action_button_name = "Deploy Engineering Tool"
	desc = "A lightweight augmentation for the engineer on-the-go. This one comes with a series of upgraded tools."
	paths = list(
		/obj/item/swapper/power_drill/finger,
		/obj/item/weldingtool/electric/finger,
		/obj/item/swapper/jaws_of_life/finger,
		/obj/item/device/multitool/finger
	)


/obj/item/swapper/power_drill/finger
	name = "digital drill"
	desc = "A nifty powertool at your literal fingertips."
	icon_state = "screwdriver_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/swapper/power_drill/finger/on_update_icon()
	icon_state = (active_tool == BOLT_HEAD) ? "wrench_finger" : "screwdriver_finger"


/obj/item/swapper/jaws_of_life/finger
	name = "digital prytool"
	desc = "A hydraulic prying/cutting tool. Much less awkward."
	icon_state = "prybar_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/swapper/jaws_of_life/finger/on_update_icon()
	icon_state = (active_tool == CUTTER_HEAD) ? "wirecutter_finger" : "prybar_finger"


/obj/item/weldingtool/electric/finger
	name = "digital arc welder"
	desc = "A precise, high quality welding tool. No fuel tank required!"
	icon_state = "welder_finger"
	icon = 'icons/obj/augment_tools.dmi'
	canremove = FALSE


/obj/item/weldingtool/electric/finger/on_update_icon()
	if(welding)
		icon_state = "welder_finger_on"
		set_light(0.6, 0.5, 2.5, l_color = COLOR_LIGHT_CYAN)
	else
		icon_state = "welder_finger"
		set_light(0)


/obj/item/weldingtool/electric/finger/attack_hand(mob/living/user)
	if (!cell || user.get_inactive_hand() != src)
		return ..()

	if (!welding)
		user.visible_message(
			SPAN_ITALIC("\The [user] removes \a [cell] from \a [src]."),
			SPAN_ITALIC("You remove \the [cell] from \the [src].")
		)
		user.put_in_hands(cell)
		cell = null
		w_class = initial(w_class)
		force = initial(force)
		update_icon()
	else
		to_chat(user, SPAN_WARNING("Turn off the welder first!"))
