
#define MAX_FOOD_COOK_COUNT 3
#define MAX_FOOD_COMBINE_COUNT 4


#define COOKER_STRIP_RAW FLAG(0)


/obj/item/reagent_containers/food/snacks/var/list/cooked_with
/obj/item/reagent_containers/food/snacks/var/list/combined_names


/obj/machinery/cooker
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/machines/cooking_machines.dmi'
	density = TRUE
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 1000
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	init_flags = EMPTY_BITFIELD

	var/capacity = 1 //how many things the cooker can hold at once
	var/cook_time = 20 SECONDS //how many seconds the cooker takes to cook its contents
	var/burn_time = 0 //food burns after burn_time, or is ejected after cook_time if 0
	var/list/cooking = list() //what the cooker is currently holding
	var/list/cook_modes //How the cooker transforms things when it succeeds
	var/cook_mode //The currently selected cook mode
	var/threshold //Whether (world.time - started) has passed cook_time or burn_time
	var/started //The world.time when cooking started
	var/default_color //The fallback color to assign to cooked things if the mode does not supply one
	var/datum/effect/smoke_spread/bad/smoke


/obj/machinery/cooker/Initialize()
	. = ..()
	if (type == /obj/machinery/cooker)
		return INITIALIZE_HINT_QDEL
	cook_mode = cook_modes[1]
	smoke = new
	smoke.attach(src)
	smoke.set_up(2, 0)


/obj/machinery/cooker/Destroy()
	QDEL_NULL_LIST(cooking)
	. = ..()


/obj/machinery/cooker/examine(mob/user, distance)
	. = ..()
	if (distance < 5)
		if (is_processing)
			to_chat(user, "It is[is_processing ? "" : " not"] running.")
		if (distance < 3)
			if (length(cooking))
				to_chat(user, "You can see \an [english_list(cooking)] inside.")
			else
				to_chat(user, "It is empty.")


/obj/machinery/cooker/components_are_accessible(path)
	return !is_processing && ..()


/obj/machinery/cooker/cannot_transition_to(state_path, mob/user)
	if(is_processing)
		return SPAN_WARNING("Turn off \the [src] first.")
	return ..()


/obj/machinery/cooker/proc/enable()
	update_use_power(active_power_usage)
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	icon_state = "[initial(icon_state)]_on"
	started = world.time
	threshold = 0


/obj/machinery/cooker/proc/disable()
	update_use_power(idle_power_usage)
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	icon_state = initial(icon_state)


/obj/machinery/cooker/proc/empty()
	for (var/obj/item/I in cooking)
		I.dropInto(loc)
	cooking.Cut()


/obj/machinery/cooker/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	if (stat)
		to_chat(user, SPAN_WARNING("\The [src] is in no condition to operate."))
		return
	var/option = alert(user, "", "[src] Options", "Empty", "Turn [is_processing ? "Off" : "On"]", length(cook_modes) > 1 ? "Cook Mode" : null)
	if (!option || QDELETED(src) || stat)
		return
	if (!Adjacent(user) || user.stat)
		to_chat(user, SPAN_WARNING("You're not able to do that to \the [src] right now."))
		return
	switch (option)
		if ("Empty")
			if (is_processing)
				to_chat(user, SPAN_WARNING("Turn off \the [src] first."))
				return
			if (!length(cooking))
				to_chat(user, SPAN_WARNING("\The [src] is already empty."))
				return
			empty()
		if ("Turn Off")
			disable()
			visible_message(SPAN_NOTICE("\The [user] turns off \the [src]."), SPAN_NOTICE("You turn off \the [src]."), range = 5)
		if ("Turn On")
			enable()
			visible_message(SPAN_NOTICE("\The [user] turns on \the [src]."), SPAN_NOTICE("You turn on \the [src]."), range = 5)
		if ("Cook Mode")
			if (is_processing)
				to_chat(user, SPAN_WARNING("Turn off \the [src] first."))
				return
			var/mode = input(user, "", "[src] Cook Modes") as null|anything in cook_modes
			if (!mode || QDELETED(src) || stat)
				return
			if (!Adjacent(user) || user.stat)
				to_chat(user, SPAN_WARNING("You're not able to do that to \the [src] right now."))
				return
			cook_mode = mode
			to_chat(user, "The contents of \the [src] will now be [cook_modes[mode]["desc"]].")


/obj/machinery/cooker/use_tool(obj/item/I, mob/living/user, list/click_params)
	if (is_processing)
		to_chat(user, SPAN_WARNING("Turn off \the [src] first."))
		return TRUE
	if ((. = ..()))
		return
	if (stat)
		to_chat(user, SPAN_WARNING("\The [src] is in no condition to operate."))
		return TRUE
	if (!istype(I, /obj/item/reagent_containers/food/snacks))
		to_chat(user, SPAN_WARNING("Cooking \a [I] wouldn't be very tasty."))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/F = I
	if (!F.can_use_cooker)
		to_chat(user, SPAN_WARNING("Cooking \a [I] wouldn't be very tasty."))
		return TRUE
	if (length(cooking) >= capacity)
		to_chat(user, SPAN_WARNING("\The [src] is already full up."))
		return TRUE
	if (!user.unEquip(I))
		return TRUE
	user.visible_message("\The [user] puts \the [I] into \the [src].")
	I.forceMove(src)
	cooking += I
	return TRUE


/obj/machinery/cooker/Process()
	if (!length(cooking))
		disable()
	var/time = world.time - started
	if (time < cook_time)
		return
	if (!threshold)
		var/list/source = cooking.Copy()
		cooking.Cut()
		var/index = length(source)
		while (index)
			cooking += cook_item(source[index])
			--index
		QDEL_NULL_LIST(source)
		audible_message(SPAN_ITALIC("\The [src] lets out a happy ding."))
		playsound(src, 'sound/machines/ding.ogg', 70, frequency = 0.75)
		threshold = 1
	if (!burn_time)
		empty()
		disable()
		return
	else if (time < burn_time)
		return
	if (threshold < 2)
		var/list/source = cooking.Copy()
		cooking.Cut()
		var/index = length(source)
		while (index)
			cooking += new /obj/item/reagent_containers/food/snacks/badrecipe(src)
			--index
		QDEL_NULL_LIST(source)
		threshold = 2
	if (prob(15))
		visible_message(SPAN_WARNING("\The [src] vomits a gout of rancid smoke!"))
		smoke.start()
	if (threshold < 3 && prob(10))
		visible_message(SPAN_WARNING("\The [src] is on fire!"))
		var/turf/adjacent = get_step(src, dir)
		adjacent.IgniteTurf(20)
		threshold = 3


/obj/machinery/cooker/proc/cook_item(obj/item/reagent_containers/food/snacks/source)
	if (istype(source, /obj/item/reagent_containers/food/snacks/badrecipe))
		return source
	if (LAZYISIN(source.cooked_with, cook_mode) || length(source.cooked_with) > MAX_FOOD_COOK_COUNT)
		return new /obj/item/reagent_containers/food/snacks/badrecipe(src)
	var/obj/item/reagent_containers/food/snacks/result = cook_modes[cook_mode]["type"]
	result = new result (src)
	if (source.reagents && source.reagents.total_volume)
		source.reagents.trans_to(result, source.reagents.total_volume)
	var/flags = cook_modes[cook_mode]["flags"] || 0
	for (var/hint in source.nutriment_desc)
		result.nutriment_desc[hint] = source.nutriment_desc[hint]
	result.combined_names = source.combined_names?.Copy()
	result.cooked_with = source.cooked_with?.Copy()
	LAZYADD(result.cooked_with, cook_mode)
	modify_result_appearance(result, source, flags)
	modify_result_text(result, source, flags)
	return result


/obj/machinery/cooker/proc/modify_result_text(obj/item/reagent_containers/food/snacks/result, obj/item/reagent_containers/food/snacks/source, flags)
	var/prefix = cook_modes[cook_mode]["prefix"]
	var/suffix = cook_modes[cook_mode]["suffix"]
	var/result_name = source.name
	if (flags & COOKER_STRIP_RAW)
		if (text_starts_with(result_name, "raw"))
			result_name = trimtext(copytext(result_name, 4))
	result.SetName("[prefix ? "[prefix] " : ""][result_name][suffix ? " [suffix]" : ""]")
	var/list/combined_names = result.combined_names
	if (combined_names)
		combined_names[1] = result.name
		result.desc = "\A [combined_names[1]] with [english_list(combined_names.Copy(2))]"
	else
		result.desc = "\A [result.name]."


/obj/machinery/cooker/proc/modify_result_appearance(obj/item/reagent_containers/food/snacks/result, obj/item/reagent_containers/food/snacks/source, flags)
	if (!result.icon_state)
		result.icon = source.icon
		result.icon_state = source.icon_state
	var/tint = default_color
	if ("color" in cook_modes[cook_mode])
		tint = cook_modes[cook_mode]["color"]
	if (tint && !istext(tint))
		tint = get_random_colour(1)
	result.color = tint
	if (tint != null)
		result.filling_color = BlendRGB(source.color || "#ffffff", tint, 0.5)
	else
		result.filling_color = (source.color || source.filling_color || "#ffffff")
	if (result.type != /obj/item/reagent_containers/food/snacks/variable)
		var/image/I = image(result.icon, result, "[result.icon_state]_filling")
		I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
		I.color = result.filling_color
		result.AddOverlays(I)


/obj/machinery/cooker/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	default_color = TRUE
	icon_state = "mixer"
	capacity = 2
	cook_modes = list(
		"Candying" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "candied",
			"desc" = "candied"
		),
		"Make Jawbreaker" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/jawbreaker,
			"suffix" = "jawbreaker",
			"desc" = "made into a jawbreaker"
		),
		"Make Candy Bar" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/candybar,
			"suffix" = " candy bar",
			"desc" = "made into a candy bar"
		),
		"Make Sucker" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/sucker,
			"suffix" = "sucker",
			"desc" = "made into a sucker"
		),
		"Make Jelly" = list(
			type = /obj/item/reagent_containers/food/snacks/variable/jelly,
			"suffix" = "jelly",
			"desc" = "made into jelly"
		)
	)

	machine_name = "modular cooker"
	machine_desc = "Can prepare nearly any kind of food a certain way, such as making pies, cookies, or candy bars."


/obj/machinery/cooker/fryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon_state = "fryer"
	default_color = "#ffad33"
	capacity = 4
	burn_time = 40 SECONDS
	cook_modes = list(
		"Deep Frying" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "deep fried",
			"desc" = "deep fried",
			"flags" = COOKER_STRIP_RAW
		)
	)


/obj/machinery/cooker/grill
	name = "griddle"
	desc = "A flat, wide, and smooth cooking surface."
	icon_state = "grill"
	default_color = "#c05b28"
	capacity = 4
	burn_time = 40 SECONDS
	cook_modes = list(
		"Grilling" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "grilled",
			"desc" = "grilled",
			"flags" = COOKER_STRIP_RAW
		),
		"Toasting" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "toasted",
			"desc" = "toasted",
			"flags" = COOKER_STRIP_RAW
		),
		"Frying" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "fried",
			"desc" = "fried",
			"flags" = COOKER_STRIP_RAW
		),
		"Steaming" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "steamed",
			"desc" = "steamed",
			"color" = "#ffffff",
			"flags" = COOKER_STRIP_RAW
		),
		"Boiling" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "boiled",
			"desc" = "boiled",
			"color" = "#ffffff",
			"flags" = COOKER_STRIP_RAW
		),
		"Stewing" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/stew,
			"suffix" = "stew",
			"desc" = "stewed",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Searing" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "seared",
			"desc" = "seared",
			"flags" = COOKER_STRIP_RAW
		)
	)


/obj/machinery/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon_state = "oven"
	default_color = "#99502c"
	capacity = 4
	burn_time = 40 SECONDS
	cook_modes = list(
		"Baking" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "baked",
			"desc" = "baked",
			"flags" = COOKER_STRIP_RAW
		),
		"Roasting" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "roasted",
			"desc" = "roasted",
			"flags" = COOKER_STRIP_RAW
		),
		"Pizza" = list(
			"type" = /obj/item/reagent_containers/food/snacks/sliceable/variable/pizza,
			"suffix" = "pizza",
			"desc" = "made into a pizza",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Bread" = list(
			"type" = /obj/item/reagent_containers/food/snacks/sliceable/variable/bread,
			"suffix" = "bread",
			"desc" = "made into bread",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Pie" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pie,
			"suffix" = "pie",
			"desc" = "made into a pie",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Cake" = list(
			"type" = /obj/item/reagent_containers/food/snacks/sliceable/variable/cake,
			"suffix" = "cake",
			"desc" = "made into a cake",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Turnover" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pocket,
			"suffix" = "turnover",
			"desc" = "made into a turnover",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Kebab" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/kebab,
			"suffix" = "kebab",
			"desc" = "made into a kebab",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Waffles" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/waffles,
			"suffix" = "waffles",
			"desc" = "made into waffles",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Pancakes" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pancakes,
			"suffix" = "pancakes",
			"desc" = "made into pancakes",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Cookie" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/cookie,
			"suffix" = "cookie",
			"desc" = "made into a cookie",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Donut" = list(
			"type" = /obj/item/reagent_containers/food/snacks/donut/variable,
			"suffix" = "donut",
			"desc" = "made into a donut",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		)
	)


/obj/machinery/cooker/cereal
	name = "cereal maker"
	desc = "Now with Dann O's available!"
	icon_state = "cereal"
	capacity = 2
	cook_modes = list(
		"Make Cereal" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "box of",
			"suffix" = "cereal",
			"desc" = "made into cereal"
		),
		"Make Stuffing" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/stuffing,
			"suffix" = "stuffing",
			"desc" = "turned into stuffing"
		),
		"Shred" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/shreds,
			"prefix" = "shredded",
			"desc" = "shredded"
		)
	)


/obj/machinery/cooker/cereal/modify_result_appearance(obj/item/reagent_containers/food/snacks/result, obj/item/reagent_containers/food/snacks/source, flags)
	..(result, source)
	if (cook_mode == "Make Cereal")
		var/image/I = image(source.icon, source.icon_state)
		I.color = source.color
		I.CopyOverlays(source)
		I.SetTransform(scale = 0.5)
		result.icon = 'icons/obj/food/food.dmi'
		result.icon_state = "cereal_box"
		result.color = null
		result.AddOverlays(I)
		result.filling_color = BlendRGB(source.color || source.filling_color , "#fcaf32") //for cereal contents


/obj/item/reagent_containers/food/snacks/variable
	name = "cooked food"
	icon = 'icons/obj/food/food_custom.dmi'
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/variable
	name = "cooked food"
	icon = 'icons/obj/food/food_custom.dmi'
	slice_path = /obj/item/reagent_containers/food/snacks/slice
	slices_num = 5
	bitesize = 2


/obj/item/reagent_containers/food/snacks/slice/variable
	name = "cooked food slice"
	icon = 'icons/obj/food/food_custom.dmi'
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/variable
	bitesize = 2


/obj/item/reagent_containers/food/snacks/sliceable/variable/pizza
	name = "pizza"
	desc = "A tasty oven pizza meant to be shared."
	icon_state = "pizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/variable/pizza
	slices_num = 6
	nutriment_amt = 15
	nutriment_desc = list("pizza crust" = 8, "cheese" = 7)


/obj/item/reagent_containers/food/snacks/slice/variable/pizza
	name = "pizza slice"
	desc = "A tasty slice of pizza."
	icon_state = "pizza_slice"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/variable/pizza


/obj/item/reagent_containers/food/snacks/sliceable/variable/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/variable/bread
	nutriment_amt = 6
	nutriment_desc = list("bread" = 6)

/obj/item/reagent_containers/food/snacks/slice/variable/bread
	name = "bread slice"
	desc = "A tasty slice of bread."
	icon_state = "breadcustom_slice"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/variable/bread


/obj/item/reagent_containers/food/snacks/variable/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"
	nutriment_amt = 4
	nutriment_desc = list("pie" = 4)


/obj/item/reagent_containers/food/snacks/sliceable/variable/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/variable/cake
	nutriment_amt = 15
	nutriment_desc = list("cake" = 8, "sweetness" = 7)


/obj/item/reagent_containers/food/snacks/slice/variable/cake
	name = "cake slice"
	desc = "A tasty slice of cake."
	icon_state = "cakecustom_slice"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/variable/cake
	trash = /obj/item/trash/plate


/obj/item/reagent_containers/food/snacks/variable/pocket
	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"
	nutriment_amt = 2
	nutriment_desc = list("heartiness" = 1,"dough" = 2)


/obj/item/reagent_containers/food/snacks/variable/kebab
	name = "kebab"
	desc = "Remove this!"
	icon_state = "kabob"
	nutriment_amt = 3
	nutriment_desc = list("kebab" = 3)


/obj/item/reagent_containers/food/snacks/variable/waffles
	name = "waffles"
	desc = "Made with love."
	icon_state = "waffles"
	gender = PLURAL
	nutriment_amt = 4
	nutriment_desc = list("waffle" = 4)
	trash = /obj/item/trash/waffles


/obj/item/reagent_containers/food/snacks/variable/pancakes
	name = "pancakes"
	desc = "How does an oven make pancakes?"
	icon_state = "pancakescustom"
	gender = PLURAL
	nutriment_amt = 4
	nutriment_desc = list("pancake" = 4)
	trash = /obj/item/trash/plate


/obj/item/reagent_containers/food/snacks/variable/cookie
	name = "cookie"
	desc = "Sugar snap!"
	icon_state = "cookie"
	nutriment_amt = 3
	nutriment_desc = list("sweetness" = 1, "cookie" = 2)


/obj/item/reagent_containers/food/snacks/donut/variable
	name = "donut"
	desc = "Donut eat this!"
	icon = 'icons/obj/food/food_custom.dmi'
	icon_state = "donut"
	nutriment_amt = 2
	nutriment_desc = list("donut" = 2)


/obj/item/reagent_containers/food/snacks/variable/jawbreaker
	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"
	nutriment_amt = 2
	nutriment_desc = list("a toothache" = 1, "sweetness" = 1)


/obj/item/reagent_containers/food/snacks/variable/candybar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 2)


/obj/item/reagent_containers/food/snacks/variable/sucker
	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"
	nutriment_amt = 2
	nutriment_desc = list("sweetness" = 2)


/obj/item/reagent_containers/food/snacks/variable/jelly
	name = "jelly"
	desc = "All your friends will be jelly."
	icon_state = "jellycustom"
	nutriment_amt = 3
	nutriment_desc = list("sweetness" = 3)
	trash = /obj/item/trash/snack_bowl


/obj/item/reagent_containers/food/snacks/variable/stuffing
	name = "stuffing"
	desc = "Get stuffed."
	icon_state = "stuffing"
	nutriment_amt = 3
	nutriment_desc = list("stuffing" = 3)


/obj/item/reagent_containers/food/snacks/variable/shreds
	name = "shreds"
	desc = "Gnarly."
	icon_state = "shreds" //NB: there is no base icon state and that is intentional

/obj/item/reagent_containers/food/snacks/variable/stew
	name = "stew"
	desc = "A hearty classic."
	icon_state = "stew"
	nutriment_amt = 4
	nutriment_desc = list("stew" = 3)


/obj/item/material/chopping_board
	name = "chopping board"
	desc = "A food preparation surface that allows you to combine food more easily."
	icon = 'icons/obj/food/chopping_board.dmi'
	icon_state = "chopping_board"
	w_class = ITEM_SIZE_NORMAL
	default_material = MATERIAL_MAPLE


/obj/item/material/chopping_board/mahogany/default_material = MATERIAL_MAHOGANY


/obj/item/material/chopping_board/bamboo/default_material = MATERIAL_BAMBOO


/obj/item/material/chopping_board/attackby(obj/item/item, mob/living/user)
	if (istype(item, /obj/item/reagent_containers/food/snacks))
		if (istype(item, /obj/item/reagent_containers/food/snacks/variable))
			to_chat(user, SPAN_WARNING("\The [item] is already combinable."))
			return TRUE
		if (!user.unEquip(item, src))
			return TRUE
		var/obj/item/reagent_containers/food/snacks/source = item
		var/obj/item/reagent_containers/food/snacks/variable/result = new (get_turf(src))
		if (source.reagents?.total_volume)
			source.reagents.trans_to(result, source.reagents.total_volume)
		for (var/hint in source.nutriment_desc)
			result.nutriment_desc[hint] = source.nutriment_desc[hint]
		result.combined_names = source.combined_names?.Copy()
		result.cooked_with = source.cooked_with?.Copy()
		result.icon = source.icon
		result.icon_state = source.icon_state
		result.color = source.color
		result.CopyOverlays(source)
		result.name = source.name
		result.desc = source.desc
		qdel(source)
		return TRUE
	return ..()


/obj/item/reagent_containers/food/snacks/variable/attackby(obj/item/I, mob/living/user)
	if (istype(I, /obj/item/reagent_containers/food/snacks))
		combine(I, user)
		return TRUE
	return ..()


/obj/item/reagent_containers/food/snacks/variable/proc/combine(obj/item/reagent_containers/food/snacks/other, mob/user)
	var/combined_count = length(combined_names)
	var/other_combined_count = length(other.combined_names)
	if (combined_count + other_combined_count > 4)
		to_chat(user, SPAN_WARNING("This food combination is too large."))
	var/response
	if (bitecount || other.bitecount)
		if (user.a_intent == I_HELP)
			to_chat(user, SPAN_WARNING("This food is partially eaten. Combining it would be disgusting."))
			return FALSE
		if (user.a_intent == I_HURT)
			to_chat(user, SPAN_WARNING("This food is partially eaten.") + SPAN_NOTICE(" You combine it anyway."))
		else
			response = alert(user, "Combine Food Scraps?", "Combine Food", "Yes", "No") == "Yes"
			if (!response || !user.use_sanity_check(src, other))
				return FALSE
	if (!response && user.a_intent == I_HELP)
		response = alert(user, "Combine Food?", "Combine Food", "Yes", "No") == "Yes"
		if (!response || !user.use_sanity_check(src, other))
			return FALSE
	if (!user.unEquip(other, src))
		return FALSE
	if (!combined_count)
		combined_names = list(name)
		name = "[name] meal"
	if (other_combined_count)
		combined_names += other.combined_names
	else
		combined_names += other.name
	desc = "\A [combined_names[1]] with [english_list(combined_names.Copy(2))]"
	var/other_volume = other.reagents?.total_volume
	if (other_volume)
		var/volume = reagents.total_volume + other_volume
		if (reagents.maximum_volume < volume)
			reagents.maximum_volume = volume
		other.reagents.trans_to(src, volume)
	for (var/hint in other.nutriment_desc)
		if (!nutriment_desc[hint])
			nutriment_desc[hint] = 0
		nutriment_desc[hint] += other.nutriment_desc[hint]
	bitesize += (other.bitesize - other.bitecount)
	var/image/I = image(other.icon, other.icon_state)
	I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	I.pixel_x = rand(-8, 8)
	I.pixel_y = rand(-8, 8)
	I.color = other.color
	I.CopyOverlays(other)
	I.SetTransform(scale = 0.8)
	AddOverlays(I)
	qdel(other)
	return TRUE


#undef COOKER_STRIP_RAW

#undef MAX_FOOD_COMBINE_COUNT
#undef MAX_FOOD_COOK_COUNT
