
/obj/machinery/microwave
	name = "microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = BELOW_OBJ_LAYER
	density = 1
	anchored = 1
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT | ATOM_FLAG_OPEN_CONTAINER
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/list/ingredients = list()


// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/

/obj/machinery/microwave/Initialize()
	. = ..()
	create_reagents(100)

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(src.broken > 0)
		if(src.broken == 2 && isScrewdriver(O)) // If it's broken and they're using a screwdriver
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user, 20, src))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes part of the microwave.</span>", \
					"<span class='notice'>You have fixed part of the microwave.</span>" \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && isWrench(O)) // If it's broken and they're doing the wrench
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user, 20, src))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes the microwave.</span>", \
					"<span class='notice'>You have fixed the microwave.</span>" \
				)
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure
				src.update_icon()
				src.atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
		else
			to_chat(user, "<span class='warning'>It's broken!</span>")
			return 1
	else if((. = component_attackby(O, user)))
		dispose()
		return
	else if(src.dirty==100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/weapon/reagent_containers/spray/cleaner) || istype(O, /obj/item/weapon/reagent_containers/glass/rag)) // If they're trying to clean it then let them
			user.visible_message( \
				"<span class='notice'>\The [user] starts to clean the microwave.</span>", \
				"<span class='notice'>You start to clean the microwave.</span>" \
			)
			if (do_after(user, 20, src))
				user.visible_message( \
					"<span class='notice'>\The [user] has cleaned the microwave.</span>", \
					"<span class='notice'>You have cleaned the microwave.</span>" \
				)
				src.dirty = 0 // It's clean!
				src.broken = 0 // just to be sure
				src.update_icon()
				src.atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
		else //Otherwise bad luck!!
			to_chat(user, "<span class='warning'>It's dirty!</span>")
			return 1
	else if(is_type_in_list(O, SScuisine.microwave_accepts_items))
		if (LAZYLEN(ingredients) >= SScuisine.microwave_maximum_item_storage)
			to_chat(user, "<span class='warning'>This [src] is full of ingredients, you cannot put more.</span>")
			return 1
		if(istype(O, /obj/item/stack)) // This is bad, but I can't think of how to change it
			var/obj/item/stack/S = O
			if(S.use(1))
				var/stack_item = new O.type (src)
				LAZYADD(ingredients, stack_item)
				user.visible_message( \
					"<span class='notice'>\The [user] has added one of [O] to \the [src].</span>", \
					"<span class='notice'>You add one of [O] to \the [src].</span>")
			return
		else
			if (!user.unEquip(O, src))
				return
			LAZYADD(ingredients, O)
			user.visible_message( \
				"<span class='notice'>\The [user] has added \the [O] to \the [src].</span>", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")
			return
	else if(istype(O,/obj/item/weapon/reagent_containers/glass) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.type in SScuisine.microwave_accepts_reagents))
				to_chat(user, "<span class='warning'>Your [O] contains components unsuitable for cookery.</span>")
				return 1
		return
	else if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		to_chat(user, "<span class='warning'>This is ridiculous. You can not fit \the [G.affecting] in this [src].</span>")
		return 1
	else if(isWrench(O))
		user.visible_message( \
			"<span class='notice'>\The [user] begins [src.anchored ? "securing" : "unsecuring"] the microwave.</span>", \
			"<span class='notice'>You attempt to [src.anchored ? "secure" : "unsecure"] the microwave.</span>"
			)
		if (do_after(user,20, src))
			src.anchored = !src.anchored
			user.visible_message( \
			"<span class='notice'>\The [user] [src.anchored ? "secures" : "unsecures"] the microwave.</span>", \
			"<span class='notice'>You [src.anchored ? "secure" : "unsecure"] the microwave.</span>"
			)
		else
			to_chat(user, "<span class='notice'>You decide not to do that.</span>")
	else
		to_chat(user, "<span class='warning'>You have no idea what you can cook with this [O].</span>")
	src.updateUsrDialog()

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
	if(src.broken > 0)
		dat += "<TT>Bzzzzttttt</TT>"
	else if(src.operating)
		dat += "<TT>Microwaving in progress!<BR>Please wait...!</TT>"
	else if(src.dirty==100)
		dat += "<TT>This microwave is dirty!<BR>Please clean it before use!</TT>"
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in InsertedContents())
			var/display_name = O.name
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures[display_name] = "turnover"
				items_measures_p[display_name] = "turnovers"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/fish))
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

		if (items_counts.len==0 && reagents.reagent_list.len==0)
			dat += "<B>The microwave is empty</B>"
		else
			dat += "<b>Ingredients:</b><br>[dat]"
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
	if (reagents.total_volume==0 && !contents.len) //dry run
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(SScuisine.microwave_recipes, src)
	var/obj/cooked
	if (!recipe)
		dirty += 1
		if (prob(max(10,dirty*5)))
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
	for (var/i=1 to seconds)
		if (stat & (NOPOWER|BROKEN))
			return 0
		use_power_oneoff(500)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in ingredients) // do not use src or src.contents unless you want to cook your own components
		if (!istype(O,/obj/item/weapon/reagent_containers/food) && !istype(O, /obj/item/weapon/grown))
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.visible_message("<span class='notice'>The microwave turns on.</span>", "<span class='notice'>You hear a microwave.</span>")
	src.operating = 1
	src.updateUsrDialog()
	src.update_icon()

/obj/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()
	src.update_icon()

/obj/machinery/microwave/proc/stop()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()
	src.update_icon()

/obj/machinery/microwave/proc/dispose()
	if (!LAZYLEN(ingredients) && !reagents.total_volume)
		return
	for (var/obj/O in ingredients)
		O.dropInto(loc)
	LAZYCLEARLIST(ingredients)
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	to_chat(usr, "<span class='notice'>You dispose of the microwave contents.</span>")
	src.updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(src.loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.update_icon()

/obj/machinery/microwave/proc/muck_finish()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.visible_message("<span class='warning'>The microwave gets covered in muck!</span>")
	src.dirty = 100 // Make it dirty so it can't be used util cleaned
	src.obj_flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()
	src.update_icon()

/obj/machinery/microwave/proc/broke()
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	src.visible_message("<span class='warning'>The microwave breaks!</span>") //Let them know they're stupid
	src.broken = 2 // Make it broken so it can't be used util fixed
	src.obj_flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()
	src.update_icon()

/obj/machinery/microwave/on_update_icon()
	if(dirty == 100)
		src.icon_state = "mwbloody[operating]"
	else if(broken)
		src.icon_state = "mwb"
	else
		src.icon_state = "mw[operating]"

/obj/machinery/microwave/proc/fail()
	var/amount = 0

	// Kill + delete mobs in mob holders
	for (var/obj/item/weapon/holder/H in ingredients)
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
	src.reagents.clear_reagents()
	var/obj/item/weapon/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	ffuu.reagents.add_reagent(/datum/reagent/carbon, amount)
	ffuu.reagents.add_reagent(/datum/reagent/toxin, amount/10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	if(src.operating)
		src.updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			cook()

		if ("dispose")
			dispose()
