var/list/name_to_material

/proc/populate_material_list()
	name_to_material = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

/*
	Valid sprite masks:
	stone
	metal
	solid
	cult
*/

/material
	var/name	          // Tag for use in overlay generation/list population	.
	var/display_name
	var/icon_base = "metal"
	var/icon_colour
	var/icon_reinf = "reinf_metal"
	var/stack_type
	var/unmeltable
	var/cut_delay = 0
	var/radioactivity
	var/ignition_point
	var/melting_point = 1800 // K, walls will take damage if they're next to a fire hotter than this
	var/integrity = 150      // Damage before wall falls apart, essentially.
	var/hardness = 60        // Used to determine if a hulk can punch through this wall.
	var/rotting_touch_message = "crumbles under your touch"
	var/opacity = 1
	var/explosion_resistance = 5

/material/New()
	..()
	if(!display_name)
		display_name = name

/material/placeholder
	name = "placeholder"

/material/proc/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()

/material/proc/place_dismantled_product(var/turf/target,var/is_devastated)
	for(var/x=1;x<(is_devastated?2:3);x++)
		place_sheet(target)

/material/proc/place_sheet(var/turf/target)
	if(stack_type)
		new stack_type(target)

/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/sheet/mineral/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"

/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/sheet/mineral/diamond
	unmeltable = 1
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4

/material/gold
	name = "gold"
	stack_type = /obj/item/stack/sheet/mineral/gold
	icon_colour = "#EDD12F"

/material/silver
	name = "silver"
	stack_type = /obj/item/stack/sheet/mineral/silver
	icon_colour = "#D1E6E3"

/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/sheet/mineral/phoron
	ignition_point = 300
	icon_base = "stone"
	icon_colour = "#FC2BC5"

/material/sandstone
	name = "sandstone"
	stack_type = /obj/item/stack/sheet/mineral/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"

/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/sheet/metal
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"

/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/sheet/plasteel
	integrity = 800
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25

/material/glass
	name = "glass"
	stack_type = /obj/item/stack/sheet/glass
	icon_colour = "#00E1FF"
	opacity = 0.3

/material/plastic
	name = "plastic"
	stack_type = /obj/item/stack/sheet/mineral/plastic
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"

/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/sheet/mineral/osmium
	icon_colour = "#9999FF"

/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/sheet/mineral/tritium
	icon_colour = "#777777"

/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/sheet/mineral/mhydrogen
	icon_colour = "#E6C5DE"

/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/sheet/mineral/platinum
	icon_colour = "#9999FF"

/material/iron
	name = "iron"
	stack_type = /obj/item/stack/sheet/mineral/iron
	icon_colour = "#5C5454"

/material/cult
	name = "cult"
	display_name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"

/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target)

/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/material/cult/reinf
	name = "cult2"
	display_name = "human remains"

/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)
