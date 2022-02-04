
#define MAX_FOOD_COOK_COUNT 3
#define MAX_FOOD_COMBINE_COUNT 4


#define COOKER_STRIP_RAW FLAG(0)


/obj/item/reagent_containers/food/snacks/var/list/cooked_with
/obj/item/reagent_containers/food/snacks/var/list/combined_names


/obj/machinery/cooker
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'
	density = TRUE
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 1000
	construct_state = /decl/machine_construction/default/panel_closed
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
	var/datum/effect/effect/system/smoke_spread/bad/smoke


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
			if (cooking.len)
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
	var/option = alert(user, "", "[src] Options", "Empty", "Turn [is_processing ? "Off" : "On"]", cook_modes.len > 1 ? "Cook Mode" : null)
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


/obj/machinery/cooker/attackby(obj/item/I, mob/user)
	if (is_processing)
		to_chat(user, SPAN_WARNING("Turn off \the [src] first."))
		return
	. = component_attackby(I, user)
	if (.)
		return
	if (stat)
		to_chat(user, SPAN_WARNING("\The [src] is in no condition to operate."))
		return
	if (!istype(I, /obj/item/reagent_containers/food/snacks))
		to_chat(user, SPAN_WARNING("Cooking \a [I] wouldn't be very tasty."))
		return
	if (cooking.len >= capacity)
		to_chat(user, SPAN_WARNING("\The [src] is already full up."))
		return
	if (!user.unEquip(I))
		return
	user.visible_message("\The [user] puts \the [I] into \the [src].")
	I.forceMove(src)
	cooking += I


/obj/machinery/cooker/Process()
	if (!cooking.len)
		disable()
	var/time = world.time - started
	if (time < cook_time)
		return
	if (!threshold)
		var/list/source = cooking.Copy()
		cooking.Cut()
		var/index = source.len
		while (index)
			cooking += cook_item(source[index])
			--index
		QDEL_NULL_LIST(source)
		audible_message(SPAN_ITALIC("\The [src] lets out a happy ding."))
		playsound(src, 'sound/machines/ding.ogg', 0.5)
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
		var/index = source.len
		while (index)
			cooking += new /obj/item/reagent_containers/food/snacks/badrecipe(src)
			--index
		QDEL_NULL_LIST(source)
		threshold = 2
	if (prob(10))
		visible_message(SPAN_WARNING("\The [src] vomits a gout of rancid smoke!"))
		smoke.start()


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
			result_name = trim(copytext_char(result_name, 4))
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
	result.filling_color = BlendRGB(source.color || "#ffffff", result.color || "#ffffff", 0.5)
	if (result.type != /obj/item/reagent_containers/food/snacks/variable && istype(result, /obj/item/reagent_containers/food/snacks/variable))
		var/image/I = image(result.icon, result, "[result.icon_state]_filling")
		I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
		I.color = result.filling_color
		result.overlays += I


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
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Boiling" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"prefix" = "boiled",
			"desc" = "boiled",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Stewing" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable,
			"suffix" = "stew",
			"desc" = "stewed",
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
		"Personal Pizza" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pizza,
			"suffix" = "pizza",
			"desc" = "made into a pizza",
			"flags" = COOKER_STRIP_RAW
		),
		"Bread" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/bread,
			"suffix" = "bread",
			"desc" = "made into bread",
			"flags" = COOKER_STRIP_RAW
		),
		"Pie" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pie,
			"suffix" = "pie",
			"desc" = "made into a pie",
			"flags" = COOKER_STRIP_RAW
		),
		"Small Cake" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/cake,
			"suffix" = "cake",
			"desc" = "made into a cake",
			"flags" = COOKER_STRIP_RAW
		),
		"Turnover" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pocket,
			"suffix" = "turnover",
			"desc" = "made into a turnover",
			"flags" = COOKER_STRIP_RAW
		),
		"Kebab" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/kebab,
			"suffix" = "kebab",
			"desc" = "made into a kebab",
			"flags" = COOKER_STRIP_RAW
		),
		"Waffles" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/waffles,
			"suffix" = "waffles",
			"desc" = "made into waffles",
			"flags" = COOKER_STRIP_RAW
		),
		"Pancakes" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/pancakes,
			"suffix" = "pancakes",
			"desc" = "made into pancakes",
			"flags" = COOKER_STRIP_RAW
		),
		"Cookie" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/cookie,
			"suffix" = "cookie",
			"desc" = "made into a cookie",
			"flags" = COOKER_STRIP_RAW
		),
		"Donut" = list(
			"type" = /obj/item/reagent_containers/food/snacks/variable/donut,
			"suffix" = "donut",
			"desc" = "made into a donut",
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
		I.overlays += source.overlays
		I.transform *= 0.5
		result.icon = 'icons/obj/food.dmi'
		result.icon_state = "cereal_box"
		result.color = null
		result.overlays += I


/obj/item/reagent_containers/food/snacks/variable
	name = "cooked food"
	icon = 'icons/obj/food_custom.dmi'
	bitesize = 2


/obj/item/reagent_containers/food/snacks/variable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"


/obj/item/reagent_containers/food/snacks/variable/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"


/obj/item/reagent_containers/food/snacks/variable/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"


/obj/item/reagent_containers/food/snacks/variable/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"


/obj/item/reagent_containers/food/snacks/variable/pocket
	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"


/obj/item/reagent_containers/food/snacks/variable/kebab
	name = "kebab"
	desc = "Remove this!"
	icon_state = "kabob"


/obj/item/reagent_containers/food/snacks/variable/waffles
	name = "waffles"
	desc = "Made with love."
	icon_state = "waffles"
	gender = PLURAL


/obj/item/reagent_containers/food/snacks/variable/pancakes
	name = "pancakes"
	desc = "How does an oven make pancakes?"
	icon_state = "pancakescustom"
	gender = PLURAL


/obj/item/reagent_containers/food/snacks/variable/cookie
	name = "cookie"
	desc = "Sugar snap!"
	icon_state = "cookie"


/obj/item/reagent_containers/food/snacks/variable/donut
	name = "filled donut"
	desc = "Donut eat this!"
	icon_state = "donut"


/obj/item/reagent_containers/food/snacks/variable/jawbreaker
	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"


/obj/item/reagent_containers/food/snacks/variable/candybar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"


/obj/item/reagent_containers/food/snacks/variable/sucker
	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"


/obj/item/reagent_containers/food/snacks/variable/jelly
	name = "jelly"
	desc = "All your friends will be jelly."
	icon_state = "jellycustom"


/obj/item/reagent_containers/food/snacks/variable/stuffing
	name = "stuffing"
	desc = "Get stuffed."
	icon_state = "stuffing"


/obj/item/reagent_containers/food/snacks/variable/shreds
	name = "shreds"
	desc = "Gnarly."
	icon_state = "shreds" //NB: there is no base icon state and that is intentional


/obj/item/material/chopping_board
	name = "chopping board"
	desc = "A food preparation surface that allows you to combine food more easily."
	icon = 'icons/obj/chopping_board.dmi'
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
		result.overlays += source.overlays
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
			if (!response)
				return FALSE
	if (!response && user.a_intent == I_HELP)
		response = alert(user, "Combine Food?", "Combine Food", "Yes", "No") == "Yes"
		if (!response)
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
	I.overlays += other.overlays
	I.transform *= 0.8
	overlays += I
	qdel(other)
	return TRUE


#undef COOKER_STRIP_RAW

#undef MAX_FOOD_COMBINE_COUNT
#undef MAX_FOOD_COOK_COUNT
