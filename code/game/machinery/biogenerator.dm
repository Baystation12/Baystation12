#define BG_READY 0
#define BG_PROCESSING 1
#define BG_NO_BEAKER 2
#define BG_COMPLETE 3
#define BG_EMPTY 4

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = ""
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "biogen"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 40
	base_type = /obj/machinery/biogenerator
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	machine_name = "biogenerator"
	machine_desc = "Processes fruits, veggies, and other produce into raw biomatter that can be converted into food products and leather items."
	var/processing = 0
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/state = BG_READY
	var/denied = 0
	var/build_eff = 1
	var/eat_eff = 1
	var/ingredients = 0 //How many processable ingredients are stored inside.
	var/capacity = 10   //How many ingredients can we store?
	var/list/products = list(
		"Food" = list(
			/obj/item/reagent_containers/food/drinks/small_milk = 30,
			/obj/item/reagent_containers/food/drinks/milk = 50,
			/obj/item/reagent_containers/food/snacks/meat/syntiflesh = 50,
			/obj/item/storage/fancy/egg_box/full = 300),
		"Nutrients" = list(
			/obj/item/reagent_containers/glass/bottle/eznutrient = 60,
			/obj/item/reagent_containers/glass/bottle/left4zed = 120,
			/obj/item/reagent_containers/glass/bottle/robustharvest = 120),
		"Leather" = list(
			/obj/item/storage/wallet = 100,
			/obj/item/stack/material/leather = 100,
			/obj/item/clothing/gloves/thick/botany = 250,
			/obj/item/storage/belt/utility = 300,
			/obj/item/storage/backpack/satchel = 400,
			/obj/item/storage/bag/cash = 400,
			/obj/item/clothing/shoes/workboots = 400,
			/obj/item/clothing/shoes/leather = 400,
			/obj/item/clothing/shoes/dress = 400,
			/obj/item/clothing/suit/leathercoat = 500,
			/obj/item/clothing/suit/storage/toggle/brown_jacket = 500,
			/obj/item/clothing/suit/storage/toggle/bomber = 500,
			/obj/item/clothing/suit/storage/hooded/wintercoat = 500))

/obj/machinery/biogenerator/New()
	..()
	create_reagents(1000)
	beaker = new /obj/item/reagent_containers/glass/bottle(src)

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(state == BG_READY || state == BG_COMPLETE)
		AddOverlays("biogen_stand")
	else if (state == BG_PROCESSING)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")
		AddOverlays("biogen_stand")
	return

/obj/machinery/biogenerator/components_are_accessible(path)
	return !processing && ..()

/obj/machinery/biogenerator/cannot_transition_to(state_path)
	if(processing)
		return SPAN_NOTICE("You must turn \the [src] off first.")
	return ..()

/obj/machinery/biogenerator/examine(mob/user)
	. = ..()
	if (processing)
		to_chat(user, SPAN_NOTICE("\The [src] is currently processing."))
	if (ingredients >= capacity)
		to_chat(user, SPAN_NOTICE("\The [src] is full!"))

/obj/machinery/biogenerator/use_tool(obj/item/O, mob/living/user, list/click_params)
	if((. = ..()))
		return
	if (istype(O, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_NOTICE("The [src] is already loaded."))
			return TRUE
		else if(user.unEquip(O, src))
			beaker = O
			state = BG_READY
			updateUsrDialog()
			return TRUE

	if (istype(O, /obj/item/storage/plants))
		var/obj/item/storage/plants/P = O
		var/hadPlants = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in P.contents)
			hadPlants = 1
			P.remove_from_storage(G, src, 1) //No UI updates until we are all done.
			ingredients++
			if(ingredients >= capacity)
				to_chat(user, SPAN_NOTICE("You fill \the [src] to its capacity."))
				break
		P.finish_bulk_removal() //Now do the UI stuff once.
		if(!hadPlants)
			to_chat(user, SPAN_NOTICE("\The [P] has no produce inside."))
		if (ingredients < capacity)
			to_chat(user, SPAN_NOTICE("You empty \the [P] into \the [src]."))
		return TRUE

	if (!istype(O, /obj/item/reagent_containers/food/snacks/grown))
		to_chat(user, SPAN_NOTICE("You cannot put this in \the [src]."))
		return TRUE

	if(user.unEquip(O, src))
		ingredients++
		to_chat(user, SPAN_NOTICE("You put \the [O] in \the [src]"))
	update_icon()
	return TRUE

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/biogenerator/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	user.set_machine(src)
	var/list/data = list()
	data["state"] = state
	var/name
	var/cost
	var/type_name
	var/path
	if (state == BG_READY)
		data["points"] = points
		var/list/listed_types = list()
		for(var/c_type =1 to length(products))
			type_name = products[c_type]
			var/list/current_content = products[type_name]
			var/list/listed_products = list()
			for(var/c_product =1 to length(current_content))
				path = current_content[c_product]
				var/atom/A = path
				name = initial(A.name)
				cost = current_content[path]
				listed_products.Add(list(list(
					"product_index" = c_product,
					"name" = name,
					"cost" = cost)))
			listed_types.Add(list(list(
				"type_name" = type_name,
				"products" = listed_products)))
		data["types"] = listed_types
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "biogenerator.tmpl", "Biogenerator", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/biogenerator/OnTopic(user, href_list)
	switch (href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.dropInto(src.loc)
				beaker = null
				state = BG_NO_BEAKER
				update_icon()
		if("create")
			if (state == BG_PROCESSING)
				return TOPIC_REFRESH
			var/type = href_list["type"]
			var/product_index = text2num(href_list["product_index"])
			if (isnull(products[type]))
				return TOPIC_REFRESH
			var/list/sub_products = products[type]
			if (product_index < 1 || product_index > length(sub_products))
				return TOPIC_REFRESH
			create_product(type, sub_products[product_index])
		if("return")
			state = BG_READY
	return TOPIC_REFRESH

/obj/machinery/biogenerator/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //MACHINE_STAT_NOPOWER etc
		return

	var/S = 0
	for(var/obj/item/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		ingredients--
		if(I.reagents.get_reagent_amount(/datum/reagent/nutriment) < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount(/datum/reagent/nutriment) * 10 * eat_eff
		qdel(I)
	if(S)
		state = BG_PROCESSING
		SSnano.update_uis(src)
		update_icon()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power_oneoff(S * 30)
		sleep((S + 15) / eat_eff)
		state = BG_READY
		update_icon()
	else
		state = BG_EMPTY
	return

/obj/machinery/biogenerator/proc/create_product(type, path)
	state = BG_PROCESSING
	var/cost = products[type][path]
	cost = round(cost/build_eff)
	points -= cost
	SSnano.update_uis(src)
	update_icon()
	sleep(30)
	var/atom/movable/result = new path
	result.dropInto(loc)
	state = BG_COMPLETE
	update_icon()
	return 1


/obj/machinery/biogenerator/RefreshParts()
	..()
	build_eff = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 1, 10)
	eat_eff = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 1, 10)
