#define BG_READY 0
#define BG_PROCESSING 1
#define BG_NO_BEAKER 2
#define BG_COMPLETE 3
#define BG_EMPTY 4

/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/points = 0
	var/state = BG_READY
	var/denied = 0
	var/build_eff = 1
	var/eat_eff = 1
	var/list/products = list(
		"Food" = list(
			/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton = 30,
			/obj/item/weapon/reagent_containers/food/snacks/meat = 50),
		"Nutrients" = list(
			/obj/item/weapon/reagent_containers/glass/bottle/eznutrient = 60,
			/obj/item/weapon/reagent_containers/glass/bottle/left4zed = 120,
			/obj/item/weapon/reagent_containers/glass/bottle/robustharvest = 120),
		"Leather" = list(
			/obj/item/weapon/storage/wallet/leather = 100,
			/obj/item/clothing/gloves/thick/botany = 250,
			/obj/item/weapon/storage/belt/utility = 300,
			/obj/item/weapon/storage/backpack/satchel = 400,
			/obj/item/weapon/storage/bag/cash = 400,
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
	beaker = new /obj/item/weapon/reagent_containers/glass/bottle(src)

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/biogenerator(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)

	RefreshParts()

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(state == BG_NO_BEAKER)
		icon_state = "biogen-empty"
	else if(state == BG_READY || state == BG_COMPLETE)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='notice'>]The [src] is already loaded.</span>")
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			beaker = O
			state = BG_READY
			updateUsrDialog()
	else if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently processing.</span>")
	else if(istype(O, /obj/item/weapon/storage/plants))
		var/obj/item/weapon/storage/plants/P = O
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, "<span class='notice'>\The [src] is already full! Activate it.</span>")
		else
			var/hadPlants = 0
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in P.contents)
				hadPlants = 1
				P.remove_from_storage(G, src)
				i++
				if(i >= 10)
					to_chat(user, "<span class='notice'>You fill \the [src] to its capacity.</span>")
					break
			if(!hadPlants)
				to_chat(user, "<span class='notice'>\The [P] has no produce inside.</span>")
			else if(i < 10)
				to_chat(user, "<span class='notice'>You empty \the [P] into \the [src].</span>")


	else if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		to_chat(user, "<span class='notice'>You cannot put this in \the [src].</span>")
	else
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, "<span class='notice'>\The [src] is full! Activate it.</span>")
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			to_chat(user, "<span class='notice'>You put \the [O] in \the [src]</span>")
	update_icon()
	return

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/biogenerator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
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
		for(var/c_type =1 to products.len)
			type_name = products[c_type]
			var/list/current_content = products[type_name]
			var/list/listed_products = list()
			for(var/c_product =1 to current_content.len)
				path = current_content[c_product]
				var/atom/A = path
				name = initial(A.name)
				cost = current_content[path]
				listed_products.Add(list(list(
					"path" = path,
					"name" = name,
					"cost" = cost)))
			listed_types.Add(list(list(
				"type_name" = type_name,
				"products" = listed_products)))
		data["types"] = listed_types
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "biogenerator.tmpl", "Biogenerator", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/biogenerator/Topic(href, href_list)
	if(..())
		return 1

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
				return 1
			var/type = href_list["type"]
			var/path = text2path(href_list["path"])
			if (isnull(products[type]))
				return 1
			var/list/sub_products = products[type]
			if (isnull(sub_products[path]))
				return 1
			create_product(type, path)
			return 1
		if("return")
			state = BG_READY
	return 1

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return

	var/S = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount(/datum/reagent/nutriment) < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount(/datum/reagent/nutriment) * 10 * eat_eff
		qdel(I)
	if(S)
		state = BG_PROCESSING
		GLOB.nanomanager.update_uis(src)
		update_icon()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		state = BG_READY
		update_icon()
	else
		state = BG_EMPTY
	return

/obj/machinery/biogenerator/proc/create_product(var/type, var/path)
	state = BG_PROCESSING
	var/cost = products[type][path]
	cost = round(cost/build_eff)
	points -= cost
	GLOB.nanomanager.update_uis(src)
	update_icon()
	sleep(30)
	var/atom/movable/result = new path
	result.dropInto(loc)
	state = BG_COMPLETE
	update_icon()
	return 1


/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
