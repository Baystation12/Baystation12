/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/carts.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_CLIMBABLE
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/obj/item/mop/mymop = null
	var/obj/item/reagent_containers/spray/myspray = null
	var/obj/item/device/lightreplacer/myreplacer = null
	var/signs = 0	//maximum capacity hardcoded below


/obj/structure/janitorialcart/Initialize()
	. = ..()
	create_reagents(180)


/obj/structure/janitorialcart/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[src] [icon2html(src, viewers(get_turf(src)))] contains [reagents.total_volume] unit\s of liquid!")


/obj/structure/janitorialcart/use_tool(obj/item/tool, mob/user, list/click_params)
	// Caution Sign - Attach
	if (istype(tool, /obj/item/caution))
		if (signs >= 4)
			USE_FEEDBACK_FAILURE("\The [src] can't hold any more signs.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(tool, src)
			return TRUE
		signs++
		update_icon()
		updateUsrDialog()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src].")
		)
		return TRUE

	// Light Replacer - Attach
	if (istype(tool, /obj/item/device/lightreplacer))
		if (myreplacer)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [myreplacer] attached.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(tool, src)
			return TRUE
		myreplacer = tool
		update_icon()
		updateUsrDialog()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src].")
		)
		return TRUE

	// Mop - Wet or store
	if (istype(tool, /obj/item/mop))
		var/input = input(user, "What would you like to do with \the [tool]?", "[src] - [tool]") as null|anything in list("Wet", "Store")
		if (!input || !user.use_sanity_check(src, tool))
			return TRUE
		switch (input)
			// Wet
			if ("Wet")
				if (reagents.total_volume < 1)
					USE_FEEDBACK_FAILURE("\The [src] is out of water.")
					return TRUE
				reagents.trans_to_obj(tool, tool.reagents.maximum_volume)
				playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] wets \a [tool] in \the [src]."),
					SPAN_NOTICE("You wets \the [tool] in \the [src].")
				)
				return TRUE
			// Store
			if ("Store")
				if (mymop)
					USE_FEEDBACK_FAILURE("\The [src] already has \a [mymop] attached.")
					return TRUE
				if (!user.unEquip(tool, src))
					FEEDBACK_UNEQUIP_FAILURE(user, tool)
					return TRUE
				mymop = tool
				update_icon()
				updateUsrDialog()
				user.visible_message(
					SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]."),
					SPAN_NOTICE("You add \the [tool] to \the [src].")
				)
				return TRUE
			else
				return TRUE

	// Spray Bottle - Attach
	if (istype(tool, /obj/item/reagent_containers/spray))
		if (myspray)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [myspray] attached.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		myspray = tool
		update_icon()
		updateUsrDialog()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src].")
		)
		return TRUE

	// Trash Bag - Attach
	if (istype(tool, /obj/item/storage/bag/trash))
		if (mybag)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [mybag] attached.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(tool, src)
			return TRUE
		mybag = tool
		update_icon()
		updateUsrDialog()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] on \the [src]."),
			SPAN_NOTICE("You put \the [tool] on \the [src].")
		)
		return TRUE

	// Everything else - Passthrough to mybag
	// Skip reagent containers as those fill the mop bucket
	if (mybag && !(istype(tool, /obj/item/reagent_containers/glass)))
		return tool.resolve_attackby(mybag, user, click_params)

	return ..()


/obj/structure/janitorialcart/attack_hand(mob/user)
	ui_interact(user)
	return

/obj/structure/janitorialcart/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]
	data["name"] = capitalize(name)
	data["bag"] = mybag ? capitalize(mybag.name) : null
	data["mop"] = mymop ? capitalize(mymop.name) : null
	data["spray"] = myspray ? capitalize(myspray.name) : null
	data["replacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr

	if(href_list["take"])
		switch(href_list["take"])
			if("garbage")
				if(mybag)
					user.put_in_hands(mybag)
					to_chat(user, SPAN_NOTICE("You take [mybag] from [src]."))
					mybag = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					to_chat(user, SPAN_NOTICE("You take [mymop] from [src]."))
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					to_chat(user, SPAN_NOTICE("You take [myspray] from [src]."))
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					to_chat(user, SPAN_NOTICE("You take [myreplacer] from [src]."))
					myreplacer = null
			if("sign")
				if(signs)
					var/obj/item/caution/Sign = locate() in src
					if(Sign)
						user.put_in_hands(Sign)
						to_chat(user, SPAN_NOTICE("You take \a [Sign] from [src]."))
						signs--
					else
						warning("[src] signs ([signs]) didn't match contents")
						signs = 0

	update_icon()
	updateUsrDialog()


/obj/structure/janitorialcart/on_update_icon()
	overlays.Cut()
	if(mybag)
		overlays += "cart_garbage"
	if(mymop)
		overlays += "cart_mop"
	if(myspray)
		overlays += "cart_spray"
	if(myreplacer)
		overlays += "cart_replacer"
	if(signs)
		overlays += "cart_sign[signs]"


//old style cart
/obj/structure/bed/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/callme = "pimpin' ride"	//how do people refer to it?
	buckle_movable = FALSE
	bed_flags = BED_FLAG_CANNOT_BE_DISMANTLED | BED_FLAG_CANNOT_BE_ELECTRIFIED | BED_FLAG_CANNOT_BE_PADDED


/obj/structure/bed/chair/janicart/Initialize()
	. = ..()
	create_reagents(100)

/obj/structure/bed/chair/janicart/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return

	to_chat(user, "[icon2html(src, user)] This [callme] contains [reagents.total_volume] unit\s of water!")
	if(mybag)
		to_chat(user, "\A [mybag] is hanging on the [callme].")


/obj/structure/bed/chair/janicart/use_tool(obj/item/tool, mob/user, list/click_params)
	// Key - Show message
	if (istype(tool, /obj/item/key))
		USE_FEEDBACK_FAILURE("Hold \the [tool] in your hands while you drive \the [callme].")
		return TRUE

	// Mop - Wet mop
	if (istype(tool, /obj/item/mop))
		if (!reagents.total_volume)
			USE_FEEDBACK_FAILURE("\The [callme]'s bucket is out of water.")
			return TRUE
		reagents.trans_to_obj(tool, 2)
		playsound(loc, 'sound/effects/slosh.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] wets \a [tool] in \the [callme]."),
			SPAN_NOTICE("You wet \the [tool] in \the [callme].")
		)
		return TRUE

	// Trash Bag - Hook bag to cart
	if (istype(tool, /obj/item/storage/bag/trash))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		if (mybag)
			USE_FEEDBACK_FAILURE("\The [callme] already has \a [mybag] attached.")
			return TRUE
		mybag = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] hooks \a [tool] onto \the [callme]."),
			SPAN_NOTICE("You hook \the [tool] onto \the [callme].")
		)
		return TRUE

	return ..()


/obj/structure/bed/chair/janicart/attack_hand(mob/user)
	if(mybag)
		user.put_in_hands(mybag)
		mybag = null
	else
		..()


/obj/structure/bed/chair/janicart/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	if (user.IsHolding(/obj/item/key))
		step(src, direction)
		update_mob()
	else
		to_chat(user, SPAN_NOTICE("You'll need the keys in one of your hands to drive this [callme]."))


/obj/structure/bed/chair/janicart/Move()
	..()
	if(buckled_mob && (buckled_mob.buckled == src))
		buckled_mob.dropInto(loc)


/obj/structure/bed/chair/janicart/post_buckle_mob(mob/living/M)
	update_mob()
	return ..()


/obj/structure/bed/chair/janicart/unbuckle_mob()
	var/mob/living/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return M


/obj/structure/bed/chair/janicart/set_dir()
	..()
	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring

	update_mob()


/obj/structure/bed/chair/janicart/proc/update_mob()
	if(buckled_mob)
		buckled_mob.set_dir(dir)
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7


/obj/structure/bed/chair/janicart/bullet_act(obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(85))
			return buckled_mob.bullet_act(Proj)
	visible_message(SPAN_WARNING("[Proj] ricochets off the [callme]!"))


/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
