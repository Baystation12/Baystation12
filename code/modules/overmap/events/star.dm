#define STAR_DWARF 0
#define STAR_GIANT 1
#define STAR_SUPERGIANT 2

/obj/effect/overmap_event/star
	name = "star"
//	events = list()
	icon_states = list("star")
	difficulty = EVENT_LEVEL_MAJOR
	auto_spawn = FALSE
	var/startype

/obj/effect/overmap_event/star/Initialize()
	. = ..()
	init_size()
	init_color()

/obj/effect/overmap_event/star/proc/init_size()
	startype = pick(STAR_DWARF, STAR_GIANT, STAR_SUPERGIANT)
	switch(startype)
		if(STAR_DWARF)
			name = "dwarf"
		if(STAR_GIANT)
			name = "giant"
			icon = 'icons/obj/overmap64.dmi'
			extra_width = extra_height = 2
		if(STAR_SUPERGIANT)
			name = "supergiant"
			icon = 'icons/obj/overmap96.dmi'
			extra_width = extra_height = 4

/obj/effect/overmap_event/star/proc/init_color()
	color = pick(COLOR_YELLOW, COLOR_ORANGE, COLOR_RED)
	switch(color)
		if(COLOR_YELLOW)
			name = "yellow [name]"
		if(COLOR_ORANGE)
			name = "orange [name]"
		if(COLOR_RED)
			name = "red [name]"

/obj/effect/overmap_event/star/pulsar
	name = "pulsar"
	icon_state = "pulsar"
	icon_states = list("pulsar")

/obj/effect/overmap_event/star/pulsar/init_color()
	color = pick(COLOR_BLUE, COLOR_NAVY_BLUE, COLOR_BLUE_GRAY, COLOR_BLUE_LIGHT, COLOR_DEEP_SKY_BLUE)
	name = "[name] pulsar"

/obj/effect/overmap_event/star/blackhole
	name = "blackhole"

/obj/effect/overmap_event/star/blackhole/init_size()
	..()
	switch(startype)
		if(STAR_DWARF)
			name = ""
		if(STAR_GIANT)
			name = "massive "
		if(STAR_SUPERGIANT)
			name = "supermassive "

/obj/effect/overmap_event/star/blackhole/init_color()
	color = COLOR_BLACK
	name = "[name]blackhole"

#undef STAR_DWARF
#undef STAR_GIANT
#undef STAR_SUPERGIANT