// Submap specific atom definitions.

MANTIDIFY(/obj/item/storage/bag/trash/purple,   "sample collection carrier", "material storage")
MANTIDIFY(/obj/structure/bed/chair/padded/purple,      "mantid nest",               "resting place")
MANTIDIFY(/obj/item/pickaxe/diamonddrill,       "lithobliterator",           "drilling")
MANTIDIFY(/obj/item/tank/jetpack/carbondioxide, "maneuvering pack",          "propulsion")

/obj/structure/bed/chair/padded/purple/ascent
	icon_state = "nest_chair"
	base_icon = "nest_chair"
	pixel_z = 0

/obj/structure/bed/chair/padded/purple/ascent/gyne
	name = "mantid throne"
	icon_state = "nest_chair_large"
	base_icon = "nest_chair_large"

/obj/item/light/tube/ascent
	name = "mantid light filament"
	color = COLOR_CYAN
	b_colour = COLOR_CYAN
	desc = "Some kind of strange alien lightbulb technology."
	random_tone = FALSE
