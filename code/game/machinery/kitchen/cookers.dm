
#define MAX_FOOD_COOK_COUNT 3

#define COOKER_STRIP_RAW 0x1

/obj/item/weapon/reagent_containers/food/snacks/var/list/cooked_with

/obj/machinery/cooker
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'
	density = 1
	anchored = 1
	idle_power_usage = 0
	active_power_usage = 1000
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

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
	STOP_PROCESSING(SSmachines, src)
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
	START_PROCESSING(SSmachines, src)
	icon_state = "[initial(icon_state)]_on"
	started = world.time
	threshold = 0

/obj/machinery/cooker/proc/disable()
	update_use_power(idle_power_usage)
	STOP_PROCESSING(SSmachines, src)
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
	if (!istype(I, /obj/item/weapon/reagent_containers/food/snacks))
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
			cooking += new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(src)
			--index
		QDEL_NULL_LIST(source)
		threshold = 2
	if (prob(10))
		visible_message(SPAN_WARNING("\The [src] vomits a gout of rancid smoke!"))
		smoke.start()

/obj/machinery/cooker/proc/cook_item(obj/item/weapon/reagent_containers/food/snacks/S)
	if (istype(S, /obj/item/weapon/reagent_containers/food/snacks/badrecipe))
		return S
	if (LAZYISIN(S.cooked_with, cook_mode) || length(S.cooked_with) > MAX_FOOD_COOK_COUNT)
		return new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(src)
	var/obj/item/weapon/reagent_containers/food/snacks/result = cook_modes[cook_mode]["type"]
	result = new result(src)
	if (S.reagents && S.reagents.total_volume)
		S.reagents.trans_to(result, S.reagents.total_volume)
	var/flags = cook_modes[cook_mode]["flags"] || 0
	modify_result_appearance(result, S, flags)
	modify_result_text(result, S, flags)
	result.cooked_with = S.cooked_with?.Copy()
	LAZYADD(result.cooked_with, cook_mode)
	return result

/obj/machinery/cooker/proc/modify_result_text(obj/item/weapon/reagent_containers/food/snacks/result, obj/item/weapon/reagent_containers/food/snacks/source, flags)
	var/prefix = cook_modes[cook_mode]["prefix"]
	var/suffix = cook_modes[cook_mode]["suffix"]
	var/result_desc = source.desc
	var/result_name = source.name
	if (flags & COOKER_STRIP_RAW)
		if (text_starts_with(result_name, "raw"))
			result_name = trim(copytext(result_name, 4))
	result.SetName("[prefix ? "[prefix] " : ""][result_name][suffix ? " [suffix]" : ""]")
	result.desc = "[result_desc] It has been [cook_modes[cook_mode]["desc"] || cook_mode]."

/obj/machinery/cooker/proc/modify_result_appearance(obj/item/weapon/reagent_containers/food/snacks/result, obj/item/weapon/reagent_containers/food/snacks/source, flags)
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
	if (result.type != /obj/item/weapon/reagent_containers/food/snacks/variable && istype(result, /obj/item/weapon/reagent_containers/food/snacks/variable))
		var/image/I = image(result.icon, result, "[result.icon_state]_filling")
		I.appearance_flags = RESET_COLOR
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
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "candied",
			"desc" = "candied"
		),
		"Make Jawbreaker" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/jawbreaker,
			"suffix" = "jawbreaker",
			"desc" = "made into a jawbreaker"
		),
		"Make Candy Bar" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/candybar,
			"suffix" = " candy bar",
			"desc" = "made into a candy bar"
		),
		"Make Sucker" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/sucker,
			"suffix" = "sucker",
			"desc" = "made into a sucker"
		),
		"Make Jelly" = list(
			type = /obj/item/weapon/reagent_containers/food/snacks/variable/jelly,
			"suffix" = "jelly",
			"desc" = "made into jelly"
		)
	)


/obj/machinery/cooker/fryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon_state = "fryer"
	default_color = "#ffad33"
	capacity = 4
	burn_time = 40 SECONDS
	cook_modes = list(
		"Deep Frying" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "deep fried",
			"desc" = "deep fried",
			"flags" = COOKER_STRIP_RAW
		)
	)


/obj/machinery/cooker/grill
	name = "griddle"
	desc = "A flat, wide, and smooth cooking surface."
	icon_state = "grill"
	default_color = "#a34719"
	capacity = 4
	burn_time = 40 SECONDS
	cook_modes = list(
		"Grilling" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "grilled",
			"desc" = "grilled",
			"flags" = COOKER_STRIP_RAW
		),
		"Frying" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "fried",
			"desc" = "fried",
			"flags" = COOKER_STRIP_RAW
		),
		"Steaming" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "steamed",
			"desc" = "steamed",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		),
		"Boiling" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "boiled",
			"desc" = "boiled",
			"color" = null,
			"flags" = COOKER_STRIP_RAW
		)
	)


/obj/machinery/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon_state = "oven"
	default_color = "#a34719"
	capacity = 4
	burn_time = 40 SECONDS
	cook_modes = list(
		"Baking" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "baked",
			"desc" = "baked",
			"flags" = COOKER_STRIP_RAW
		),
		"Personal Pizza" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/pizza,
			"suffix" = "pizza",
			"desc" = "made into a pizza",
			"flags" = COOKER_STRIP_RAW
		),
		"Bread" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/bread,
			"suffix" = "bread",
			"desc" = "made into bread",
			"flags" = COOKER_STRIP_RAW
		),
		"Pie" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/pie,
			"suffix" = "pie",
			"desc" = "made into a pie",
			"flags" = COOKER_STRIP_RAW
		),
		"Small Cake" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/cake,
			"suffix" = "cake",
			"desc" = "made into a cake",
			"flags" = COOKER_STRIP_RAW
		),
		"Turnover" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/pocket,
			"suffix" = "turnover",
			"desc" = "made into a turnover",
			"flags" = COOKER_STRIP_RAW
		),
		"Kebab" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/kebab,
			"suffix" = "kebab",
			"desc" = "made into a kebab",
			"flags" = COOKER_STRIP_RAW
		),
		"Waffles" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/waffles,
			"suffix" = "waffles",
			"desc" = "made into waffles",
			"flags" = COOKER_STRIP_RAW
		),
		"Pancakes" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/pancakes,
			"suffix" = "pancakes",
			"desc" = "made into pancakes",
			"flags" = COOKER_STRIP_RAW
		),
		"Cookie" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/cookie,
			"suffix" = "cookie",
			"desc" = "made into a cookie",
			"flags" = COOKER_STRIP_RAW
		),
		"Donut" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable/donut,
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
		"Cerealizing" = list(
			"type" = /obj/item/weapon/reagent_containers/food/snacks/variable,
			"prefix" = "box of",
			"suffix" = "cereal",
			"desc" = "made into cereal"
		)
	)

/obj/machinery/cooker/cereal/modify_result_appearance(obj/item/weapon/reagent_containers/food/snacks/result, obj/item/weapon/reagent_containers/food/snacks/source, flags)
	..(result, source)
	var/image/I = image(source.icon, source.icon_state)
	I.color = source.color
	I.overlays += source.overlays
	I.transform *= 0.5
	result.icon = 'icons/obj/food.dmi'
	result.icon_state = "cereal_box"
	result.color = null
	result.overlays += I


/obj/item/weapon/reagent_containers/food/snacks/variable
	name = "cooked food"
	icon = 'icons/obj/food_custom.dmi'
	nutriment_amt = 5
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/variable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"


/obj/item/weapon/reagent_containers/food/snacks/variable/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"


/obj/item/weapon/reagent_containers/food/snacks/variable/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"


/obj/item/weapon/reagent_containers/food/snacks/variable/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"


/obj/item/weapon/reagent_containers/food/snacks/variable/pocket
	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"


/obj/item/weapon/reagent_containers/food/snacks/variable/kebab
	name = "kebab"
	desc = "Remove this!"
	icon_state = "kabob"


/obj/item/weapon/reagent_containers/food/snacks/variable/waffles
	name = "waffles"
	desc = "Made with love."
	icon_state = "waffles"
	gender = PLURAL


/obj/item/weapon/reagent_containers/food/snacks/variable/pancakes
	name = "pancakes"
	desc = "How does an oven make pancakes?"
	icon_state = "pancakescustom"
	gender = PLURAL


/obj/item/weapon/reagent_containers/food/snacks/variable/cookie
	name = "cookie"
	desc = "Sugar snap!"
	icon_state = "cookie"


/obj/item/weapon/reagent_containers/food/snacks/variable/donut
	name = "filled donut"
	desc = "Donut eat this!"
	icon_state = "donut"


/obj/item/weapon/reagent_containers/food/snacks/variable/jawbreaker
	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"


/obj/item/weapon/reagent_containers/food/snacks/variable/candybar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"


/obj/item/weapon/reagent_containers/food/snacks/variable/sucker
	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"


/obj/item/weapon/reagent_containers/food/snacks/variable/jelly
	name = "jelly"
	desc = "All your friends will be jelly."
	icon_state = "jellycustom"


#undef MAX_FOOD_COOK_COUNT
#undef COOKER_STRIP_RAW
