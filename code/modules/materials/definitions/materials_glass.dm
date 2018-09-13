
/material/glass
	name = MATERIAL_GLASS
	lore_text = "A brittle, transparent material made from molten silicates. It is generally not a liquid."
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = "#00e1ff"
	opacity = 0.3
	integrity = 50
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 50
	melting_point = T0C + 100
	weight = 14
	brute_armor = 1
	burn_armor = 2
	door_icon_base = "stone"
	table_icon_base = "solid"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/basic
	rod_product = /obj/item/stack/material/glass/reinforced
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0
	sale_price = 1

/material/glass/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)

	if(!user || !used_stack || !created_window || !window_options.len)
		return 0

	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>This task is too complex for your clumsy hands.</span>")
		return 1

	var/turf/T = user.loc
	if(!istype(T))
		to_chat(user, "<span class='warning'>You must be standing on open flooring to build a window.</span>")
		return 1

	var/title = "Sheet-[used_stack.name] ([used_stack.get_amount()] sheet\s left)"
	var/choice = input(title, "What would you like to construct?") as null|anything in window_options

	if(!choice || !used_stack || QDELETED(user) || used_stack.loc != user || user.incapacitated() || user.loc != T)
		return 1

	// Get data for building windows here.
	var/list/possible_directions = GLOB.cardinal.Copy()
	var/window_count = 0
	for (var/obj/structure/window/check_window in user.loc)
		window_count++
		possible_directions  -= check_window.dir

	// Get the closest available dir to the user's current facing.
	var/build_dir = SOUTHWEST //Default to southwest for fulltile windows.
	var/failed_to_build

	if(window_count >= 4)
		failed_to_build = 1
	else
		if(choice in list("One Direction","Windoor"))
			if(possible_directions.len)
				for(var/direction in list(user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
					if(direction in possible_directions)
						build_dir = direction
						break
			else
				failed_to_build = 1
			if(!failed_to_build && choice == "Windoor")
				if(!is_reinforced())
					to_chat(user, "<span class='warning'>This material is not reinforced enough to use for a door.</span>")
					return
				if((locate(/obj/structure/windoor_assembly) in T.contents) || (locate(/obj/machinery/door/window) in T.contents))
					failed_to_build = 1
	if(failed_to_build)
		to_chat(user, "<span class='warning'>There is no room in this location.</span>")
		return 1

	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options[choice]
	if(choice == "Windoor")
		build_dir = user.dir
	else
		build_path = created_window

	if(used_stack.get_amount() < sheets_needed)
		to_chat(user, "<span class='warning'>You need at least [sheets_needed] sheets to build this.</span>")
		return 1

	// Build the structure and update sheet count etc.
	used_stack.use(sheets_needed)
	new build_path(T, build_dir, 1)
	return 1

/material/glass/proc/is_reinforced()
	return (integrity > 75) //todo

/material/glass/is_brittle()
	return ..() && !is_reinforced()

/material/glass/reinforced
	name = MATERIAL_REINFORCED_GLASS
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags = MATERIAL_BRITTLE
	icon_colour = "#00e1ff"
	opacity = 0.3
	integrity = 100
	melting_point = T0C + 750
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	weight = 17
	brute_armor = 2
	burn_armor = 3
	stack_origin_tech = list(TECH_MATERIAL = 2)
	alloy_materials = list(MATERIAL_STEEL = 1875,MATERIAL_GLASS = 3750)
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 5)
	created_window = /obj/structure/window/reinforced
	wire_product = null
	rod_product = null
	construction_difficulty = 1

/material/glass/phoron
	name = MATERIAL_PHORON_GLASS
	lore_text = "An extremely heat-resistant form of glass."
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = T0C + 2000
	icon_colour = "#fc2bc5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	created_window = /obj/structure/window/phoronbasic
	wire_product = null
	rod_product = /obj/item/stack/material/glass/phoronrglass
	construction_difficulty = 2
	alloy_product = TRUE
	alloy_materials = list(MATERIAL_SAND = 2500, MATERIAL_PLATINUM = 1250)
	sale_price = 2

/material/glass/phoron/reinforced
	name = MATERIAL_REINFORCED_PHORON_GLASS
	brute_armor = 3
	burn_armor = 10
	melting_point = T0C + 4000
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronrglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	created_window = /obj/structure/window/phoronreinforced
	stack_origin_tech = list(TECH_MATERIAL = 2)
	alloy_materials = list() //todo
	rod_product = null
	integrity = 100
