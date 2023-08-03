/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "closed"
	icon = 'icons/obj/closets/coffin.dmi'
	setup = 0
	closet_appearance = null

	var/screwdriver_time_needed = 7.5 SECONDS

/obj/structure/closet/coffin/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && !opened)
		to_chat(user, "The lid is [locked ? "tightly secured with screws." : "unsecured and can be opened."]")

/obj/structure/closet/coffin/can_open()
	. =  ..()
	if(locked)
		return FALSE


/obj/structure/closet/coffin/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Toggle lock
	if (isScrewdriver(tool))
		if (opened)
			USE_FEEDBACK_FAILURE("\The [src] needs to be closed before you can screw the lid shut.")
			return TRUE
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] begins screwing \the [src]'s lid [locked ? "open" : "shut"] with \a [tool]."),
			SPAN_NOTICE("You begin screwing \the [src]'s lid [locked ? "open" : "shut"] with \the [tool].")
		)
		if (!user.do_skilled(screwdriver_time_needed, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (opened)
			USE_FEEDBACK_FAILURE("\The [src] needs to be closed before you can screw the lid shut.")
			return TRUE
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] screws \the [src]'s lid [locked ? "open" : "shut"] with \a [tool]."),
			SPAN_NOTICE("You screw \the [src]'s lid [locked ? "open" : "shut"] with \the [tool].")
		)
		locked = !locked
		return TRUE

	return ..()


/obj/structure/closet/coffin/toggle(mob/user as mob)
	if(!(opened ? close() : open()))
		to_chat(user, SPAN_NOTICE("It won't budge!"))

/obj/structure/closet/coffin/req_breakout()
	. = ..()
	if(locked)
		return TRUE


/obj/structure/closet/coffin/break_open()
	locked = FALSE
	..()

/obj/structure/closet/coffin/wooden
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon = 'icons/obj/closets/coffin_wood.dmi'
	setup = 0
	closet_appearance = null
