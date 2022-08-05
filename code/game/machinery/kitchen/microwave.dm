
/obj/machinery/microwave
	name = "microwave"
	desc = "A possibly occult device capable of perfectly preparing many types of food."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT | ATOM_FLAG_OPEN_CONTAINER
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "microwave"
	machine_desc = "Required for preparing any dish more complicated than a slice of bread. In the future, <i>everything</i> is microwaved."

	var/operating = FALSE // Is it on?
	var/dirtiness = 0 // Ranges from 0 to 100, increasing a little with failed recipes and emptying reagents
	var/broken = 0 // If above 0, the microwave is broken and can't be used

	var/power_efficiency = 1.0 // Divider for the microwave's power use
	var/speed_multiplier = 1.0 // Divider for the microwave's cooking delay
	var/break_multiplier = 1.0 // Multiplier for break chance

	var/list/ingredients = list()


// see code/modules/food/recipes_microwave.dm for recipes

/*********************************
*   Initialization, part logic
**********************************/

/obj/machinery/microwave/Initialize()
	. = ..()
	create_reagents(100)

/obj/machinery/microwave/RefreshParts()
	// Microwaves use a manipulator, micro lasers, and matter bin.
	// The used manipulator determines the power use.
	// Micro lasers speed cooking up at higher tiers.
	// Matter bins decrease the chance of breaking or getting dirty.
	..()
	var/laser_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/micro_laser), 1, 5)

	speed_multiplier = (laser_rating * 0.5)
	power_efficiency = total_component_rating_of_type(/obj/item/stock_parts/manipulator)
	break_multiplier = 1 / clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 1, 3)

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(broken > 0)
		// Start repairs by using a screwdriver
		if(broken == 2 && isScrewdriver(O))
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes part of the microwave.</span>", \
					"<span class='notice'>You have fixed part of the microwave.</span>" \
				)
				broken = 1 // Fix it a bit

		// Finish repairs using a wrench
		else if(broken == 1 && isWrench(O))
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes the microwave.</span>", \
					"<span class='notice'>You have fixed the microwave.</span>" \
				)
				broken = 0 // Fix it!
				dirtiness = 0 // just to be sure
				update_icon()
				atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER

		// Otherwise, we can't add anything to the micrwoave
		else
			to_chat(user, "<span class='warning'>It's broken, and this isn't the right way to fix it!</span>")
		return

	else if((. = component_attackby(O, user)))
		dispose()
		return

	else if(dirtiness == 100) // The microwave is all dirty, so it can't be used!
		var/has_rag = istype(O, /obj/item/reagent_containers/glass/rag)
		var/has_cleaner = O.reagents != null && O.reagents.has_reagent(/datum/reagent/space_cleaner, 5)

		// If they're trying to clean it, let them
		if (has_rag || has_cleaner)

			user.visible_message( \
				"<span class='notice'>\The [user] starts to clean the microwave.</span>", \
				"<span class='notice'>You start to clean the microwave.</span>" \
			)
			if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				user.visible_message( \
					"<span class='notice'>\The [user] has cleaned the microwave.</span>", \
					"<span class='notice'>You clean out the microwave.</span>" \
				)

				// You can use a rag to wipe down the inside of the microwave
				// Otherwise, you'll need some space cleaner
				if (!has_rag)
					O.reagents.remove_reagent(/datum/reagent/space_cleaner, 5)

				dirtiness = 0 // It's clean!
				broken = 0 // just to be sure
				update_icon()
				atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
			return TRUE

		// Otherwise, bad luck!
		else
			to_chat(user, "<span class='warning'>You need to clean [src] before you use it!</span>")
			return

	else if(is_type_in_list(O, GLOB.microwave_accepts_items))

		if (LAZYLEN(ingredients) >= GLOB.microwave_maximum_item_storage)
			to_chat(user, "<span class='warning'>This [src] is full of ingredients - you can't fit any more.</span>")

		else if(istype(O, /obj/item/stack)) // This is bad, but I can't think of how to change it
			var/obj/item/stack/S = O
			if(S.use(1))
				var/stack_item = new O.type (src)
				LAZYADD(ingredients, stack_item)
				user.visible_message( \
					"<span class='notice'>\The [user] has added one of [O] to \the [src].</span>", \
					"<span class='notice'>You add one of [O] to \the [src].</span>")
			return TRUE

		else
			if (!user.unEquip(O, src))
				return
			LAZYADD(ingredients, O)
			user.visible_message( \
				"<span class='notice'>\The [user] has added \the [O] to \the [src].</span>", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")
			return TRUE

		return

	else if(istype(O,/obj/item/reagent_containers/glass) || \
	        istype(O,/obj/item/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			return
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.type in GLOB.microwave_accepts_reagents))
				to_chat(user, SPAN_WARNING("Your [O] contains components unsuitable for cookery."))
		return

	else if(istype(O, /obj/item/storage))
		if (LAZYLEN(ingredients) >= GLOB.microwave_maximum_item_storage)
			to_chat(user, SPAN_WARNING("[src] is completely full!"))
			return

		var/obj/item/storage/bag/P = O
		var/objects_loaded = 0
		for(var/obj/G in P.contents)
			if(length(ingredients) < GLOB.microwave_maximum_item_storage && is_type_in_list(G, GLOB.microwave_accepts_items) && P.remove_from_storage(G, src, 1))
				objects_loaded++
				LAZYADD(ingredients, G)
		P.finish_bulk_removal()

		if (objects_loaded)
			if (!P.contents.len)
				user.visible_message(SPAN_NOTICE("\The [user] empties \the [P] into \the [src]."),
				SPAN_NOTICE("You empty \the [P] into \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [user] empties \the [P] into \the [src]."),
				SPAN_NOTICE("You empty what you can from \the [P] into \the [src]."))
			return TRUE

		else
			to_chat(user, SPAN_WARNING("\The [P] doesn't contain any compatible items to put into \the [src]!"))

		return

	else if(istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		to_chat(user, "<span class='warning'>This is ridiculous. You can't fit \the [G.affecting] in \the [src].</span>")
		return

	else if(isWrench(O))
		user.visible_message( \
			"<span class='notice'>\The [user] begins [anchored ? "securing" : "unsecuring"] the microwave.</span>", \
			"<span class='notice'>You attempt to [anchored ? "secure" : "unsecure"] the microwave.</span>"
			)
		if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			anchored = !anchored
			user.visible_message( \
			"<span class='notice'>\The [user] [anchored ? "secures" : "unsecures"] the microwave.</span>", \
			"<span class='notice'>You [anchored ? "secure" : "unsecure"] the microwave.</span>"
			)

	else
		to_chat(user, "<span class='warning'>You have no idea what you can cook with this [O].</span>")

	updateUsrDialog()

/obj/machinery/microwave/components_are_accessible(path)
	return (broken == 0) && ..()

/obj/machinery/microwave/cannot_transition_to(state_path, mob/user)
	if(broken)
		return SPAN_NOTICE("\The [src] is too broken to do this!")
	. = ..()

/obj/machinery/microwave/state_transition(decl/machine_construction/new_state)
	..()
	updateUsrDialog()

// need physical proximity for our interface.
/obj/machinery/microwave/DefaultTopicState()
	return GLOB.physical_state

/obj/machinery/microwave/interface_interact(mob/user)
	interact(user)
	return TRUE

/*******************
*   Microwave Menu
********************/

/obj/machinery/microwave/InsertedContents()
	return ingredients

/obj/machinery/microwave/interact(mob/user as mob) // The microwave Menu
	user.set_machine(src)
	var/dat = list()
	if(broken > 0)
		dat += "<TT><b><i>This microwave is very broken. You'll need to fix it before you can use it again.</i></b></TT>"
	else if(operating)
		dat += "<TT>Microwaving in progress!<BR>Please wait...!</TT>"
	else if(dirtiness == 100)
		dat += "<TT><b><i>This microwave is covered in muck. You'll need to wipe it down or clean it out before you can use it again.</i></b></TT>"
	else
		playsound(loc, 'sound/machines/pda_click.ogg', 50, 1)
		if (!LAZYLEN(ingredients) && !reagents.reagent_list.len)
			dat += "<B>The microwave is empty.</B>"
		else
			dat += "<b>Ingredients:</b><br>"
			var/list/items_counts = new
			var/list/items_measures = new
			var/list/items_measures_p = new
			for (var/obj/O in InsertedContents())
				var/display_name = O.name
				if (istype(O,/obj/item/reagent_containers/food/snacks/egg))
					items_measures[display_name] = "egg"
					items_measures_p[display_name] = "eggs"
				if (istype(O,/obj/item/reagent_containers/food/snacks/tofu))
					items_measures[display_name] = "tofu chunk"
					items_measures_p[display_name] = "tofu chunks"
				if (istype(O,/obj/item/reagent_containers/food/snacks/meat)) //any meat
					items_measures[display_name] = "slab of meat"
					items_measures_p[display_name] = "slabs of meat"
				if (istype(O,/obj/item/reagent_containers/food/snacks/donkpocket))
					display_name = "Turnovers"
					items_measures[display_name] = "turnover"
					items_measures_p[display_name] = "turnovers"
				if (istype(O,/obj/item/reagent_containers/food/snacks/fish))
					items_measures[display_name] = "fillet of fish"
					items_measures_p[display_name] = "fillets of fish"
				items_counts[display_name]++
			for (var/O in items_counts)
				var/N = items_counts[O]
				if (!(O in items_measures))
					dat += "<B>[capitalize(O)]:</B> [N] [lowertext(O)]\s"
				else
					if (N==1)
						dat += "<B>[capitalize(O)]:</B> [N] [items_measures[O]]"
					else
						dat += "<B>[capitalize(O)]:</B> [N] [items_measures_p[O]]"

			for (var/datum/reagent/R in reagents.reagent_list)
				var/display_name = R.name
				if (R.type == /datum/reagent/capsaicin)
					display_name = "Hotsauce"
				if (R.type == /datum/reagent/frostoil)
					display_name = "Coldsauce"
				dat += "<B>[display_name]:</B> [R.volume] unit\s"

		dat += "<HR><BR><A href='?src=\ref[src];action=cook'>Turn on!<BR><A href='?src=\ref[src];action=dispose'>Eject ingredients!"

	show_browser(user, "<HEAD><TITLE>Microwave Controls</TITLE></HEAD><TT>[jointext(dat,"<br>")]</TT>", "window=microwave")
	onclose(user, "microwave")
	return



/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return
	start()
	if (reagents.total_volume == 0 && !LAZYLEN(ingredients)) //dry run
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(GLOB.microwave_recipes, src)
	var/obj/cooked
	if (!recipe)
		dirtiness += 1
		if (prob(max(10, dirtiness * 5) / break_multiplier))
			if (!wzhzhzh(4))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			cooked = fail()
			cooked.dropInto(loc)
			return
		else if (has_extra_item())
			if (!wzhzhzh(4))
				abort()
				return
			broke()
			cooked = fail()
			cooked.dropInto(loc)
			return
		else
			if (!wzhzhzh(10))
				abort()
				return
			stop()
			cooked = fail()
			cooked.dropInto(loc)
			return
	else
		var/halftime = round(recipe.time/10/2)
		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.dropInto(loc)
			return
		cooked = recipe.make_food(src)
		LAZYCLEARLIST(ingredients)
		stop()
		if(cooked)
			cooked.dropInto(loc)
		return

// Behold: the worst proc name in the codebase.
/obj/machinery/microwave/proc/wzhzhzh(var/seconds)
	for (var/i = 1 to seconds)
		if (stat & (NOPOWER|BROKEN))
			return FALSE
		use_power_oneoff(500 / power_efficiency)
		sleep(10 / speed_multiplier)
	return TRUE

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in ingredients) // do not use src or contents unless you want to cook your own components
		if (!istype(O, /obj/item/reagent_containers/food))
			return TRUE
	return FALSE

/obj/machinery/microwave/proc/start()
	visible_message("<span class='notice'>The microwave turns on.</span>", "<span class='notice'>You hear a microwave.</span>")
	operating = TRUE
	updateUsrDialog()
	update_icon()

/obj/machinery/microwave/proc/abort()
	operating = FALSE // Turn it off again aferwards
	updateUsrDialog()
	update_icon()

/obj/machinery/microwave/proc/stop()
	playsound(loc, 'sound/machines/ding.ogg', 50, 1)
	operating = FALSE // Turn it off again aferwards
	updateUsrDialog()
	update_icon()

/obj/machinery/microwave/proc/dispose()
	var/disposed = FALSE
	if (LAZYLEN(ingredients))
		for (var/obj/O in ingredients)
			O.dropInto(loc)
		LAZYCLEARLIST(ingredients)
		disposed = TRUE
	if (reagents?.total_volume)
		reagents.clear_reagents()
		++dirtiness
		disposed = TRUE
	if (disposed)
		to_chat(usr, "<span class='notice'>You dispose of the microwave contents.</span>")
		updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	update_icon()

/obj/machinery/microwave/proc/muck_finish()
	playsound(loc, 'sound/machines/ding.ogg', 50, 1)
	visible_message("<span class='warning'>Muck splatters over the inside of \the [src]!</span>")
	dirtiness = 100 // Make it dirty so it can't be used util cleaned
	obj_flags = null //So you can't add condiments
	operating = FALSE // Turn it off again aferwards
	updateUsrDialog()
	update_icon()

/obj/machinery/microwave/proc/broke()
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	if (prob(100 * break_multiplier))
		visible_message("<span class='warning'>\The [src] breaks!</span>") //Let them know they're stupid
		broken = 2 // Make it broken so it can't be used util fixed
		obj_flags = null //So you can't add condiments
		updateUsrDialog()
	else
		visible_message("<span class='warning'>\The [src] sputters and grinds to a halt!</span>")
	operating = FALSE // Turn it off again aferwards
	update_icon()

/obj/machinery/microwave/on_update_icon()
	if(dirtiness == 100)
		icon_state = "mwbloody[operating]"
	else if(broken)
		icon_state = "mwb"
	else
		icon_state = "mw[operating]"

/obj/machinery/microwave/proc/fail()
	var/amount = 0

	// Kill + delete mobs in mob holders
	for (var/obj/item/holder/H in ingredients)
		for (var/mob/living/M in H.contents)
			M.death()
			qdel(M)

	for (var/obj/O in ingredients)
		amount++
		if (O.reagents)
			var/reagent_type = O.reagents.get_master_reagent_type()
			if (reagent_type)
				amount+=O.reagents.get_reagent_amount(reagent_type)
		qdel(O)

	LAZYCLEARLIST(ingredients)
	reagents.clear_reagents()
	var/obj/item/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	ffuu.reagents.add_reagent(/datum/reagent/carbon, amount)
	ffuu.reagents.add_reagent(/datum/reagent/toxin, amount / 10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	if(operating)
		updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			playsound(loc, 'sound/machines/quiet_beep.ogg', 50, 1)
			cook()

		if ("dispose")
			dispose()
