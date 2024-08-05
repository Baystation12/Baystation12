
/obj/machinery/microwave
	name = "microwave"
	desc = "A possibly occult device capable of perfectly preparing many types of food."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "mw"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT | ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CAN_TABLE | OBJ_FLAG_ANCHORABLE
	construct_state = /singleton/machine_construction/default/panel_closed
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

/obj/machinery/microwave/use_tool(obj/item/O, mob/living/user, list/click_params)
	if (broken > 0)
		// Start repairs by using a screwdriver
		if(broken == 2 && isScrewdriver(O))
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to fix part of the microwave."), \
				SPAN_NOTICE("You start to fix part of the microwave.") \
			)
			if (do_after(user, (O.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
				user.visible_message( \
					SPAN_NOTICE("\The [user] fixes part of the microwave."), \
					SPAN_NOTICE("You have fixed part of the microwave.") \
				)
				broken = 1 // Fix it a bit
			return TRUE

		// Finish repairs using a wrench
		if (broken == 1 && isWrench(O))
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to fix part of the microwave."), \
				SPAN_NOTICE("You start to fix part of the microwave.") \
			)
			if (do_after(user, (O.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
				user.visible_message( \
					SPAN_NOTICE("\The [user] fixes the microwave."), \
					SPAN_NOTICE("You have fixed the microwave.") \
				)
				broken = 0 // Fix it!
				dirtiness = 0 // just to be sure
				update_icon()
				atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
			return TRUE

		// Otherwise, we can't add anything to the micrwoave
		else
			to_chat(user, SPAN_WARNING("It's broken, and this isn't the right way to fix it!"))
			return TRUE

	if(dirtiness == 100) // The microwave is all dirty, so it can't be used!
		var/has_rag = istype(O, /obj/item/reagent_containers/glass/rag)
		var/has_cleaner = O.reagents != null && O.reagents.has_reagent(/datum/reagent/space_cleaner, 5)
		if (has_rag || has_cleaner)
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to clean the microwave."), \
				SPAN_NOTICE("You start to clean the microwave.") \
			)
			if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				user.visible_message( \
					SPAN_NOTICE("\The [user] has cleaned the microwave."), \
					SPAN_NOTICE("You clean out the microwave.") \
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
			to_chat(user, SPAN_WARNING("You need to clean \the [src] before you use it!"))
			return TRUE

	if (is_type_in_list(O, GLOB.microwave_accepts_items))
		if (length(ingredients) >= GLOB.microwave_maximum_item_storage)
			to_chat(user, SPAN_WARNING("This [src] is full of ingredients - you can't fit any more."))
			return TRUE

		if (istype(O, /obj/item/stack)) // This is bad, but I can't think of how to change it
			var/obj/item/stack/S = O
			if(S.use(1))
				var/stack_item = new O.type (src)
				LAZYADD(ingredients, stack_item)
				user.visible_message( \
					SPAN_NOTICE("\The [user] has added one of [O] to \the [src]."), \
					SPAN_NOTICE("You add one of [O] to \the [src]."))
			return TRUE

		else
			if (!user.unEquip(O, src))
				return TRUE
			LAZYADD(ingredients, O)
			user.visible_message( \
				SPAN_NOTICE("\The [user] has added \the [O] to \the [src]."), \
				SPAN_NOTICE("You add \the [O] to \the [src]."))
			return TRUE

	if (istype(O,/obj/item/reagent_containers/glass) || \
	        istype(O,/obj/item/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			to_chat(user, SPAN_WARNING("\The [O] is empty!"))
			return TRUE
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.type in GLOB.microwave_accepts_reagents))
				to_chat(user, SPAN_WARNING("\The [O] contains \the [R] which is unsuitable for cookery."))
				return TRUE
		return FALSE //This will call reagent_container's use_after which handles transferring reagents.

	if (istype(O, /obj/item/storage))
		if (length(ingredients) >= GLOB.microwave_maximum_item_storage)
			to_chat(user, SPAN_WARNING("\The [src] is completely full!"))
			return TRUE

		var/obj/item/storage/bag/P = O
		var/objects_loaded = 0
		for(var/obj/G in P.contents)
			if(length(ingredients) < GLOB.microwave_maximum_item_storage && is_type_in_list(G, GLOB.microwave_accepts_items) && P.remove_from_storage(G, src, 1))
				objects_loaded++
				LAZYADD(ingredients, G)
		P.finish_bulk_removal()

		if (objects_loaded)
			if (!length(P.contents))
				user.visible_message(SPAN_NOTICE("\The [user] empties \the [P] into \the [src]."),
				SPAN_NOTICE("You empty \the [P] into \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [user] empties \the [P] into \the [src]."),
				SPAN_NOTICE("You empty what you can from \the [P] into \the [src]."))
			return TRUE

		else
			to_chat(user, SPAN_WARNING("\The [P] doesn't contain any compatible items to put into \the [src]!"))

		return TRUE

	updateUsrDialog()
	return ..()

/obj/machinery/microwave/use_grab(obj/item/grab/grab, list/click_params)
	to_chat(grab.assailant, SPAN_WARNING("This is ridiculous. You can't fit \the [grab.affecting] in \the [src]."))
	return TRUE

/obj/machinery/microwave/components_are_accessible(path)
	return (broken == 0) && ..()

/obj/machinery/microwave/cannot_transition_to(state_path, mob/user)
	if(broken)
		return SPAN_NOTICE("\The [src] is too broken to do this!")
	. = ..()

/obj/machinery/microwave/state_transition(singleton/machine_construction/new_state)
	..()
	updateUsrDialog()

// need physical proximity for our interface.
/obj/machinery/microwave/DefaultTopicState()
	return GLOB.physical_state

/obj/machinery/microwave/interface_interact(mob/user)
	interact(user)
	return TRUE


/obj/machinery/microwave/interact(mob/user)
	if (isobserver(user))
		if (!isadmin(user))
			return
	else if (!ishuman(user) && !isrobot(user))
		return
	user.set_machine(src)
	var/dat = list()
	if(broken > 0)
		dat += "<tt><b><i>This microwave is very broken. You'll need to fix it before you can use it again.</i></b></tt>"
	else if (operating)
		dat += "<tt>Microwaving in progress!<BR>Please wait...!</tt>"
	else if (dirtiness == 100)
		dat += "<tt><b><i>This microwave is covered in muck. You'll need to wipe it down or clean it out before you can use it again.</i></b></tt>"
	else
		playsound(loc, 'sound/machines/pda_click.ogg', 50, TRUE)
		if (!length(ingredients) && !length(reagents.reagent_list))
			dat += "<B>The microwave is empty.</B>"
		else
			dat += "<b>Ingredients:</b><br>"
			var/list/items_counts = list()
			var/list/items_measures = list()
			var/list/items_measures_p = list()
			for (var/obj/obj in ingredients)
				var/display_name = obj.name
				if (istype(obj,/obj/item/reagent_containers/food/snacks/egg))
					items_measures[display_name] = "egg"
					items_measures_p[display_name] = "eggs"
				if (istype(obj,/obj/item/reagent_containers/food/snacks/tofu))
					items_measures[display_name] = "tofu chunk"
					items_measures_p[display_name] = "tofu chunks"
				if (istype(obj,/obj/item/reagent_containers/food/snacks/meat)) //any meat
					items_measures[display_name] = "slab of meat"
					items_measures_p[display_name] = "slabs of meat"
				if (istype(obj,/obj/item/reagent_containers/food/snacks/donkpocket))
					display_name = "Turnovers"
					items_measures[display_name] = "turnover"
					items_measures_p[display_name] = "turnovers"
				if (istype(obj,/obj/item/reagent_containers/food/snacks/fish))
					items_measures[display_name] = "fillet of fish"
					items_measures_p[display_name] = "fillets of fish"
				items_counts[display_name]++
			for (var/name in items_counts)
				var/count = items_counts[name]
				if (name in items_measures)
					if (count == 1)
						dat += "<b>[capitalize(name)]:</b> [count] [items_measures[name]]"
					else
						dat += "<b>[capitalize(name)]:</b> [count] [items_measures_p[name]]"
				else
					dat += "<b>[capitalize(name)]:</b> [count] [lowertext(name)]\s"
			for (var/datum/reagent/reagent in reagents.reagent_list)
				var/display_name = reagent.name
				if (reagent.type == /datum/reagent/capsaicin)
					display_name = "Hotsauce"
				if (reagent.type == /datum/reagent/frostoil)
					display_name = "Coldsauce"
				dat += "<b>[display_name]:</b> [reagent.volume] unit\s"
		dat += "<hr><br><a href='?src=\ref[src];action=cook'>Turn on!<br><a href='?src=\ref[src];action=dispose'>Eject ingredients!"
	show_browser(user, "<head><title>Microwave Controls</title></head><tt>[jointext(dat,"<br>")]</tt>", "window=microwave")
	onclose(user, "microwave")


/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(inoperable())
		return
	start()
	if (!reagents.total_volume && !length(ingredients)) //dry run
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/current_weight = length(reagents.reagent_list) + length(ingredients)
	var/datum/microwave_recipe/recipe
	for (var/datum/microwave_recipe/candidate as anything in GLOB.microwave_recipes)
		if (current_weight != candidate.weight)
			continue
		if (!candidate.CheckReagents(src))
			continue
		if (!candidate.CheckProduce(src))
			continue
		if (!candidate.CheckItems(src))
			continue
		recipe = candidate
		break

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
		cooked = recipe.CreateResult(src)
		LAZYCLEARLIST(ingredients)
		stop()
		if(cooked)
			cooked.dropInto(loc)
		return

// Behold: the worst proc name in the codebase.
/obj/machinery/microwave/proc/wzhzhzh(seconds)
	for (var/i = 1 to seconds)
		if (inoperable())
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
	visible_message(SPAN_NOTICE("The microwave turns on."), SPAN_NOTICE("You hear a microwave."))
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
	if (length(ingredients))
		for (var/obj/O in ingredients)
			O.dropInto(loc)
		LAZYCLEARLIST(ingredients)
		disposed = TRUE
	if (reagents?.total_volume)
		reagents.clear_reagents()
		++dirtiness
		disposed = TRUE
	if (disposed)
		to_chat(usr, SPAN_NOTICE("You dispose of the microwave contents."))
		updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	update_icon()

/obj/machinery/microwave/proc/muck_finish()
	playsound(loc, 'sound/machines/ding.ogg', 50, 1)
	visible_message(SPAN_WARNING("Muck splatters over the inside of \the [src]!"))
	dirtiness = 100 // Make it dirty so it can't be used util cleaned
	obj_flags = null //So you can't add condiments
	operating = FALSE // Turn it off again aferwards
	updateUsrDialog()
	update_icon()

/obj/machinery/microwave/proc/broke()
	var/datum/effect/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	if (prob(100 * break_multiplier))
		visible_message(SPAN_WARNING("\The [src] breaks!")) //Let them know they're stupid
		broken = 2 // Make it broken so it can't be used util fixed
		obj_flags = null //So you can't add condiments
		updateUsrDialog()
	else
		visible_message(SPAN_WARNING("\The [src] sputters and grinds to a halt!"))
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
		for (var/mob/living/M in H)
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
