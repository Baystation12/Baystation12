var/list/name_to_material

/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	return name_to_material[name]

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
	var/flags = 0
	var/rotting_touch_message = "crumbles under your touch"

	// Shards/tables/structures
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	var/shard_type = SHARD_SHRAPNEL
	var/shard_icon
	var/shard_can_repair = 1

	// Icons
	var/icon_colour
	var/icon_base = "metal"
	var/icon_reinf = "reinf_metal"
	var/stack_type

	// Attributes
	var/cut_delay = 0
	var/radioactivity
	var/ignition_point
	var/melting_point = 1800 // K, walls will take damage if they're next to a fire hotter than this
	var/integrity = 150      // Damage before wall falls apart, essentially.
	var/hardness = 60        // Used to determine if a hulk can punch through this wall.
	var/opacity = 1
	var/explosion_resistance = 5
	var/weight = 20

/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!shard_icon)
		shard_icon = shard_type

/material/proc/get_blunt_damage()
	return weight //todo

/material/proc/get_edge_damage()
	return round(hardness/4) //todo

/material/proc/products_need_process()
	return (radioactivity>0) //todo

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
		return new stack_type(target)

/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/weapon/material/shard(target, src.name)

/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/sheet/mineral/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22

/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/sheet/mineral/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100

/material/gold
	name = "gold"
	stack_type = /obj/item/stack/sheet/mineral/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40

/material/silver
	name = "silver"
	stack_type = /obj/item/stack/sheet/mineral/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50

/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/sheet/mineral/phoron
	ignition_point = 300
	icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30

/material/sandstone
	name = "sandstone"
	stack_type = /obj/item/stack/sheet/mineral/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55

/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/sheet/metal
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"

/material/steel/holographic
	name = "holographic " + DEFAULT_WALL_MATERIAL
	display_name = DEFAULT_WALL_MATERIAL
	stack_type = null
	shard_type = SHARD_NONE

/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/sheet/plasteel
	integrity = 800
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23

/material/glass
	name = "glass"
	stack_type = /obj/item/stack/sheet/glass
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 15
	weight = 15

/material/glass/phoron
	name = "phoron glass"
	stack_type = /obj/item/stack/sheet/glass/phoronglass
	flags = MATERIAL_BRITTLE
	ignition_point = 300
	integrity = 200 // idk why but phoron windows are strong, so.
	icon_colour = "#FC2BC5"
	hardness = 10
	weight = 10

/material/plastic
	name = "plastic"
	stack_type = /obj/item/stack/sheet/mineral/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12

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
	weight = 27

/material/iron
	name = "iron"
	stack_type = /obj/item/stack/sheet/mineral/iron
	icon_colour = "#5C5454"
	weight = 22

/material/wood
	name = "wood"
	stack_type = /obj/item/stack/sheet/wood
	icon_colour = "#824B28"
	integrity = 25
	icon_base = "solid"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18

/material/wood/holographic
	name = "holographic wood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/material/cult
	name = "cult"
	display_name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE

/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target)

/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/material/cult/reinf
	name = "cult2"
	display_name = "human remains"

/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)
