/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation. ~Z

	PATHS THAT USE DATUMS
		turf/simulated/wall
		obj/item/weapon/material
		obj/structure/barricade
		obj/item/stack/material
		obj/structure/table

	VALID ICONS
		WALLS
			stone
			metal
			solid
			cult
		DOORS
			stone
			metal
			resin
			wood
*/

// Assoc list containing all material datums indexed by name.
var/list/name_to_material

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return null

//mostly for convenience
/obj/proc/get_material_name()
	var/material/material = get_material()
	if(material)
		return material.name

// Builds the datum list above.
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

// Safety proc to make sure the material list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	. = name_to_material[name]
	if(!.)
		log_error("Unable to acquire material by name '[name]'")

/proc/material_display_name(name)
	var/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null

// Material definition and procs follow.
/material
	var/name	                          // Unique name for use in indexing the list.
	var/display_name                      // Prettier name for display.
	var/adjective_name
	var/use_name
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this material.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.

	// Icons
	var/icon_colour                                      // Colour applied to products of this material.
	var/icon_base = "metal"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/icon_reinf = "reinf_metal"                       // Overlay used
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1) // Research level for stacks.

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation var. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the material catches on fire.
	var/melting_point = 1800     // K, walls will take damage if they're next to a fire hotter than this
	var/brute_armor = 2	 		 // Brute damage to a wall is divided by this value if the wall is reinforced by this material.
	var/burn_armor				 // Same as above, but for Burn damage type. If blank brute_armor's value is used.
	var/integrity = 150          // General-use HP value for products.
	var/opacity = 1              // Is the material transparent? 0.5< makes transparent walls/doors.
	var/explosion_resistance = 5 // Only used by walls currently.
	var/conductive = 1           // Objects with this var add CONDUCTS to flags on spawn.
	var/luminescence
	var/list/composite_material  // If set, object matter var will be a list containing these values.

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = 60            // Prob of wall destruction by hulk, used for edge damage in weapons.
	var/weight = 20              // Determines blunt damage/throwforce for weapons.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Noise made when you hit structure made of this material.
	var/hitsound = 'sound/weapons/genhit.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"

// Placeholders for light tiles and rglass.
/material/proc/build_rod_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need one rod and one sheet of [display_name] to make anything useful.</span>")
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/material/proc/build_wired_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need five wires and one sheet of [display_name] to make anything useful.</span>")
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, "<span class='notice'>You attach wire to the [name].</span>")
	var/obj/item/product = new wire_product(get_turf(user))
	if(!(user.l_hand && user.r_hand))
		user.put_in_hands(product)

// Make sure we have a display name and shard icon even if they aren't explicitly set.
/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!adjective_name)
		adjective_name = display_name
	if(!shard_icon)
		shard_icon = shard_type
	if(!burn_armor)
		burn_armor = brute_armor

// This is a placeholder for proper integration of windows/windoors into the system.
/material/proc/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)
	return 0

// Weapons handle applying a divisor for this value locally.
/material/proc/get_blunt_damage()
	return weight //todo

// Return the matter comprising this material.
/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	else if(SHEET_MATERIAL_AMOUNT)
		temp_matter[name] = SHEET_MATERIAL_AMOUNT
	return temp_matter

// As above.
/material/proc/get_edge_damage()
	return hardness //todo

// Snowflakey, only checked for alien doors at the moment.
/material/proc/can_open_material_door(var/mob/living/user)
	return 1

// Currently used for weapons and objects made of uranium to irradiate things.
/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls when qdel()ing to avoid neighbor merging.
/material/placeholder
	name = "placeholder"

// Places a girder object when a wall is dismantled, also applies reinforced material.
/material/proc/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()

// General wall debris product placement.
// Not particularly necessary aside from snowflakey cult girders.
/material/proc/place_dismantled_product(var/turf/target,var/is_devastated)
	for(var/x=1;x<(is_devastated?2:3);x++)
		place_sheet(target)

// Debris product. Used ALL THE TIME.
/material/proc/place_sheet(var/turf/target)
	if(stack_type)
		return new stack_type(target)

// As above.
/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/weapon/material/shard(target, src.name)

// Used by walls and weapons to determine if they break or not.
/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

// Datum definitions follow.
/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"

/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	brute_armor = 10
	burn_armor = 50		// Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech = list(TECH_MATERIAL = 6)
	conductive = 0

/material/gold
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 25
	hardness = 25
	integrity = 100
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	icon_colour = "#EDD12F"

/material/silver
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = "#E37108"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1

/material/phoron/supermatter
	name = "supermatter"
	icon_colour = "#FFFF00"
	radioactivity = 20
	stack_origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_PHORON = 4)
	stack_type = null
	luminescence = 3


//Controls phoron and phoron based objects reaction to being in a turf over 200c -- Phoron's flashpoint.
/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas("phoron", phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)


/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	brute_armor = 3
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0

/material/stone/marble
	name = "marble"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 60
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	brute_armor = 5
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"
	hitsound = 'sound/weapons/smash.ogg'

/material/diona
	name = "biomass"
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = "diona"
	icon_reinf = "noreinf"
	hitsound = 'sound/effects/attackblob.ogg'
	conductive = 0

/material/diona/place_dismantled_product()
	return

/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)

/material/steel/holographic
	name = "holo" + DEFAULT_WALL_MATERIAL
	display_name = DEFAULT_WALL_MATERIAL
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0

/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	brute_armor = 6
	burn_armor = 10
	hardness = 80
	weight = 23
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = 3750, "platinum" = 3750) //todo

/material/plasteel/titanium
	name = "titanium"
	brute_armor = 10
	burn_armor = 8
	integrity = 200
	melting_point = 3000
	stack_type = null
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"

/material/plasteel/ocp
	name = "osmium-carbide plasteel"
	stack_type = /obj/item/stack/material/ocp
	integrity = 200
	melting_point = 12000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 3)
	composite_material = list("plasteel" = 7500, "osmium" = 3750)


/material/glass
	name = "glass"
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
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
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/basic
	rod_product = /obj/item/stack/material/glass/reinforced
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0

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

	if(!choice || !used_stack || !user || used_stack.loc != user || user.stat || user.loc != T)
		return 1

	// Get data for building windows here.
	var/list/possible_directions = cardinal.Copy()
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
	name = "rglass"
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	melting_point = T0C + 750
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	weight = 17
	brute_armor = 2
	burn_armor = 3
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = 1875,"glass" = 3750)
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 5)
	created_window = /obj/structure/window/reinforced
	wire_product = null
	rod_product = null

/material/glass/phoron
	name = "phglass"
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = T0C + 2000
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	created_window = /obj/structure/window/phoronbasic
	wire_product = null
	rod_product = /obj/item/stack/material/glass/phoronrglass

/material/glass/phoron/reinforced
	name = "rphglass"
	brute_armor = 3
	burn_armor = 10
	melting_point = T0C + 4000
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronrglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list() //todo
	created_window = /obj/structure/window/phoronreinforced
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list() //todo
	rod_product = null
	integrity = 100


/material/plastic
	name = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 5
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	conductive = 0

/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1

/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = "voxalloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500

// Likewise.
/material/voxalloy/elevatorium
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

/material/wood
	name = "wood"
	adjective_name = "wooden"
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#824B28"
	integrity = 50
	icon_base = "solid"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	brute_armor = 1
	weight = 18
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	hitsound = 'sound/effects/woodhit.ogg'
	conductive = 0

/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/material/cardboard
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	brute_armor = 1
	weight = 1
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	conductive = 0

/material/cloth //todo
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING
	brute_armor = 1
	conductive = 0

/material/cult
	name = "cult"
	display_name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0

/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target)

/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/material/cult/reinf
	name = "cult2"
	display_name = "human remains"

/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/item/remains/human(target)

/material/resin
	name = "resin"
	icon_colour = "#E85DD8"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0

/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

/material/aliumium
	name = "alien alloy"
	stack_type = null
	icon_base = "jaggy"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	hitsound = 'sound/weapons/smash.ogg'
	sheet_singular_name = "chunk"
	sheet_plural_name = "chunks"

/material/aliumium/New()
	icon_base = pick("jaggy","curvy")
	icon_colour = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,10000)
	..()

/material/aliumium/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	return

//TODO PLACEHOLDERS:
/material/leather
	name = "leather"
	icon_colour = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0

/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	conductive = 0

/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0

/material/cloth_lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
