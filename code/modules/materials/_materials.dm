/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation.

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

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return null

//mostly for convenience
/obj/proc/get_material_name()
	var/material/material = get_material()
	if(material)
		return material.name

// Material definition and procs follow.
/material
	var/name	                          // Unique name for use in indexing the list.
	var/display_name                      // Prettier name for display.
	var/adjective_name
	var/use_name
	var/wall_name = "wall"                // Name given to walls of this material
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel
	var/list/chem_products				  //Used with the grinder to produce chemicals.
	var/hidden_from_codex
	var/lore_text
	var/mechanics_text
	var/antag_text

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
	var/table_icon_base = "metal"
	var/table_reinf = "reinf_metal"
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
	var/list/alloy_materials     // If set, material can be produced via alloying these materials in these amounts.
	var/units_per_sheet = SHEET_MATERIAL_AMOUNT

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = MATERIAL_HARD            // Prob of wall destruction by hulk, used for edge damage in weapons.
	var/weight = 20              // Determines blunt damage/throwforce for weapons.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Noise made when you hit structure made of this material.
	var/hitsound = 'sound/weapons/genhit.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type = /obj/item/stack/material/generic
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"
	// Modifies skill checks when constructing with this material.
	var/construction_difficulty = MATERIAL_EASY_DIY

	// Mining behavior.
	var/alloy_product
	var/ore_name
	var/ore_desc
	var/ore_smelts_to
	var/ore_compresses_to
	var/ore_result_amount
	var/ore_spread_chance
	var/ore_scan_icon
	var/ore_icon_overlay
	var/sale_price
	var/value = 1

	// Xenoarch behavior.
	var/list/xarch_ages = list("thousand" = 999, "million" = 999)
	var/xarch_source_mineral = "iron"

// Placeholders for light tiles and rglass.
/material/proc/reinforce(var/mob/user, var/obj/item/stack/material/used_stack, var/obj/item/stack/material/target_stack)
	if(!used_stack.can_use(1))
		to_chat(user, "<span class='warning'>You need need at least one [used_stack.singular_name] to reinforce [target_stack].</span>")
		return

	var/needed_sheets = 2 * used_stack.matter_multiplier
	if(!target_stack.can_use(needed_sheets))
		to_chat(user, "<span class='warning'>You need need at least [needed_sheets] [target_stack.plural_name] for reinforcement with [used_stack].</span>")
		return

	var/material/reinf_mat = used_stack.material
	if(reinf_mat.integrity <= integrity || reinf_mat.is_brittle())
		to_chat(user, "<span class='warning'>The [reinf_mat.display_name] is too structurally weak to reinforce the [display_name].</span>")
		return

	to_chat(user, "<span class='notice'>You reinforce the [target_stack] with the [reinf_mat.display_name].</span>")
	used_stack.use(1)
	var/obj/item/stack/material/S = target_stack.split(needed_sheets)
	S.reinf_material = reinf_mat
	S.update_strings()
	S.update_icon()
	S.dropInto(target_stack.loc)

/material/proc/build_wired_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(!used_stack.can_use(5) || !target_stack.can_use(1))
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

// Return the matter comprising this material.
/material/proc/get_matter()
	var/list/temp_matter = list()
	temp_matter[name] = SHEET_MATERIAL_AMOUNT
	return temp_matter

// Weapons handle applying a divisor for this value locally.
/material/proc/get_blunt_damage()
	return weight //todo

// As above.
/material/proc/get_edge_damage()
	return hardness //todo

/material/proc/get_attack_cooldown()
	if(weight <= MATERIAL_LIGHT)
		return FAST_WEAPON_COOLDOWN
	if(weight >= MATERIAL_HEAVY)
		return SLOW_WEAPON_COOLDOWN
	return DEFAULT_WEAPON_COOLDOWN

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
	place_sheet(target, is_devastated ? 1 : 2)

// Debris product. Used ALL THE TIME.
/material/proc/place_sheet(var/turf/target, var/amount = 1)
	return stack_type ? new stack_type(target, amount, name) : null

// As above.
/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/weapon/material/shard(target, src.name)

// Used by walls and weapons to determine if they break or not.
/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

// Dumb overlay to apply over wall sprite for cheap texture effect
/material/proc/get_wall_texture()
	return