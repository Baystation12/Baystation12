
/obj/effect/landmark/biome/grassy_plain
	name = "grassy plain doodad generator"
	skip_chance = 97
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

/obj/effect/landmark/biome/grassy_plain/geysers/New()
	. = ..()
	atom_types[/obj/structure/geyser] = 1
	atom_types[/mob/living/simple_animal/hostile/diyaab] = 0.5

/obj/effect/landmark/biome/forest
	name = "forest doodad generator"
	skip_chance = 65
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

/obj/effect/landmark/biome/forest/geysers/New()
	. = ..()
	atom_types[/obj/structure/geyser/noble_gas] = 0.05
	atom_types[/mob/living/simple_animal/hostile/shantak] = 0.01

/obj/effect/landmark/biome/swamp
	name = "swampy doodad generator"
	skip_chance = 89
	atom_types = list(\
		/obj/effect/flora/reedbush = 1,\
		/obj/effect/flora/stalkybush = 1,\
		/obj/effect/flora/fernybush = 1,\
	)

/obj/effect/landmark/biome/swamp/geysers/New()
	. = ..()
	atom_types[/obj/structure/geyser/natural_gas] = 0.1
	atom_types[/obj/structure/geyser/noble_gas] = 0.1
	atom_types[/mob/living/simple_animal/hostile/jelly] = 0.01
