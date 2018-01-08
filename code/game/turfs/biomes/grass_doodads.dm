
/obj/effect/landmark/biome/grassy_plain
	name = "grassy plain doodad generator"
	skip_chance = 98
	atom_types = list(\
		/obj/effect/rocks/small = 1\
	)

/obj/effect/landmark/biome/grassy_plain/New()
	. = ..()

	//pick a tree type at random
	var/new_type = pick(\
		/obj/structure/tree/bushy,\
		/obj/structure/tree/bushy/two,\
		/obj/structure/tree,\
		/obj/structure/tree/two,\
		/obj/structure/tree/three,\
		/obj/structure/tree/four,\
		/obj/structure/tree/snow_pine_giant,\
	)
	atom_types[new_type] = 2

	//pick two (or so) flora types at random
	var/flora_types = list(\
		/obj/effect/flora,\
		/obj/effect/flora/reedbush,\
		/obj/effect/flora/leafybush,\
		/obj/effect/flora/palebush,\
		/obj/effect/flora/stalkybush,\
		/obj/effect/flora/fernybush,\
		/obj/effect/flora/sunnybush,\
		/obj/effect/flora/genericbush,\
		/obj/effect/flora/pointybush,\
		/obj/effect/flora/lavendergrass,\
		/obj/effect/flora/ywflowers,\
		/obj/effect/flora/brflowers,\
		/obj/effect/flora/ppflowers,\
		/obj/effect/flora/sparsegrass,\
		/obj/effect/flora/fullgrass,\
	)
	var/chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 5
	flora_types -= chosen_flora
	chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 5
	if(prob(50))
		chosen_flora = pick(flora_types)
		atom_types[chosen_flora] = 5
		if(prob(50))
			chosen_flora = pick(flora_types)
			atom_types[chosen_flora] = 5

/obj/effect/landmark/biome/forest
	name = "forest doodad generator"
	skip_chance = 66
	atom_types = list(\
		/obj/effect/rocks/small = 1\
	)

/obj/effect/landmark/biome/forest/New()
	. = ..()
	var/new_type = pick(\
		/obj/structure/tree/bushy,\
		/obj/structure/tree/bushy/two,\
		/obj/structure/tree,\
		/obj/structure/tree/two,\
		/obj/structure/tree/three,\
		/obj/structure/tree/four,\
		/obj/structure/tree/snow_pine_giant,\
	)
	atom_types[new_type] = 3

	//pick two (or so) flora types at random
	var/flora_types = list(\
		/obj/effect/flora,\
		/obj/effect/flora/reedbush,\
		/obj/effect/flora/leafybush,\
		/obj/effect/flora/palebush,\
		/obj/effect/flora/stalkybush,\
		/obj/effect/flora/fernybush,\
		/obj/effect/flora/sunnybush,\
		/obj/effect/flora/genericbush,\
		/obj/effect/flora/pointybush,\
		/obj/effect/flora/lavendergrass,\
		/obj/effect/flora/ywflowers,\
		/obj/effect/flora/brflowers,\
		/obj/effect/flora/ppflowers,\
		/obj/effect/flora/sparsegrass,\
		/obj/effect/flora/fullgrass,\
	)
	var/chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 3
	flora_types -= chosen_flora
	if(prob(50))
		chosen_flora = pick(flora_types)
		atom_types[chosen_flora] = 5
