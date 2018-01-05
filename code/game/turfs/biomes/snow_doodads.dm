
/obj/effect/landmark/biome/snow_forest
	name = "Snowy forest doodad generator"
	skip_chance = 66
	atom_types = list(\
		/obj/effect/rocks/small = 1\
	)

/obj/effect/landmark/biome/snow_forest/New()
	. = ..()

	//pick a tree type at random
	var/tree_type = pick(\
		/obj/structure/tree/snow_pine,\
		/obj/structure/tree/snow_pine_giant,\
		/obj/structure/tree/snow_dead\
	)
	atom_types[tree_type] = 3

	//pick a flora type at random
	var/flora_types = list(\
		/obj/effect/flora/snow,\
		/obj/effect/flora/snow/snowygrass,\
		/obj/effect/flora/snow/snowbush\
	)
	var/chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 3

/obj/effect/landmark/biome/snow_plain
	name = "Snowy plain doodad generator"
	skip_chance = 98
	atom_types = list(\
		/obj/effect/rocks/small = 2,\
		/obj/effect/rocks = 1\
	)

/obj/effect/landmark/biome/snow_plain/New()
	. = ..()

	//pick a tree type at random
	var/new_type = pick(\
		/obj/structure/tree/snow_pine,\
		/obj/structure/tree/snow_pine_giant,\
		/obj/structure/tree/bushy,\
		/obj/structure/tree/bushy/two,\
		/obj/structure/tree/snow_dead\
	)
	atom_types[new_type] = 2

	//pick two flora types at random
	var/flora_types = list(\
		/obj/effect/flora/snow,\
		/obj/effect/flora/snow/snowygrass,\
		/obj/effect/flora/snow/snowbush\
	)
	var/chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 5
	flora_types -= chosen_flora
	chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 5
