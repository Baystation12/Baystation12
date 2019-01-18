
/obj/effect/landmark/biome/rocky_plain
	name = "rocky plain doodad generator"
	skip_chance = 98
	atom_types = list(\
		/obj/effect/rocks/small = 20,\
		/obj/effect/rocks = 5,\
		/obj/effect/flora = 1\
	)

/obj/effect/landmark/biome/rocky_waste
	name = "rocky waste doodad generator"
	skip_chance = 98
	atom_types = list(\
		/obj/effect/rocks/small = 4,\
		/obj/effect/rocks = 1\
	)

/obj/effect/landmark/biome/lava_waste
	name = "lava waste doodad generator"
	skip_chance = 97
	atom_types = list(\
		/obj/effect/rocks/small = 8,\
		/obj/effect/rocks = 2,\
		/obj/structure/geyser/toxic_gas = 1,\
		/obj/structure/geyser/volcanic_gas = 1,\
		/mob/living/simple_animal/hostile/samak = 0.1\
	)
