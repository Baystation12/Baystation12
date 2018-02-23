
/obj/effect/landmark/biome/palm_forest
	name = "palm forest doodad generator"
	skip_chance = 75

/obj/effect/landmark/biome/palm_forest/New()
	. = ..()
	atom_types = list(\
		/obj/structure/tree/palm = 6,\
		/obj/structure/tree/palm_giant = 1\
	)

	//pick two (or so) flora types at random
	var/flora_types = list(\
		/obj/effect/flora,\
		/obj/effect/flora/sparsegrass,\
		/obj/effect/flora/lavendergrass,\
		/obj/effect/flora/ywflowers,\
		/obj/effect/flora/brflowers,\
		/obj/effect/flora/ppflowers,\
		/obj/effect/flora/grassybush,\
		/obj/effect/flora/sunnybush,\
		/obj/effect/flora/stalkybush\
	)
	var/chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 4
	flora_types -= chosen_flora
	if(prob(50))
		chosen_flora = pick(flora_types)
		atom_types[chosen_flora] = 4

/obj/effect/landmark/biome/desert
	name = "desert doodad generator"
	skip_chance = 98

/obj/effect/landmark/biome/desert/New()
	. = ..()
	atom_types = list(\
		/obj/structure/tree/palm = 4,\
		/obj/item/remains/mouse = 2,\
		/obj/item/remains/lizard = 2,\
		/obj/item/remains/xeno = 1,\
		/obj/item/remains/human = 1,\
		/obj/structure/tree/palm_giant = 1\
	)

	//pick two (or so) flora types at random
	var/flora_types = list(\
		/obj/effect/flora,\
		/obj/effect/flora/sparsegrass,\
		/obj/effect/flora/lavendergrass,\
		/obj/effect/flora/ywflowers,\
		/obj/effect/flora/brflowers,\
		/obj/effect/flora/ppflowers,\
		/obj/effect/flora/grassybush,\
		/obj/effect/flora/sunnybush,\
		/obj/effect/flora/stalkybush\
	)
	var/chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 10
	flora_types -= chosen_flora
	chosen_flora = pick(flora_types)
	atom_types[chosen_flora] = 10
	if(prob(50))
		flora_types -= chosen_flora
		chosen_flora = pick(flora_types)
		atom_types[chosen_flora] = 10
		if(prob(50))
			flora_types -= chosen_flora
			chosen_flora = pick(flora_types)
			atom_types[chosen_flora] = 10
