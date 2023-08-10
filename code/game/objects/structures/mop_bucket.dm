/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor_tools.dmi'
	icon_state = "mopbucket"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite


/obj/structure/mopbucket/New()
	create_reagents(180)
	..()

/obj/structure/mopbucket/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[src] [icon2html(src, user)] contains [reagents.total_volume] unit\s of water!")


/obj/structure/mopbucket/use_tool(obj/item/tool, mob/user, list/click_params)
	// Mop - Wet mop
	if (istype(tool, /obj/item/mop))
		if (reagents.total_volume < 1)
			USE_FEEDBACK_FAILURE("\The [src] is out of water.")
			return TRUE
		reagents.trans_to_obj(tool, 5)
		playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] wets \a [tool] in \the [src]."),
			SPAN_NOTICE("You wet \the [tool] in \the [src].")
		)
		return TRUE

	return ..()
